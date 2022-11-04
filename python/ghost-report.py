import numpy as np
import pandas as pd
import subprocess
import datetime

def ghosts_old(loc="/mnt/rowley", months=1):
    _c = f"/home/prod/duc-mount-range/bash/ghost-scan.sh {loc} {months}"
    _p = subprocess.Popen(_c.split(), stdout=subprocess.PIPE)
    return _p.communicate()

def ghosts_big(loc="/mnt/rowley", 
               db="/home/prod/duc-mount-range/nightly.db"):
    _c = f"duc ls -b --dirs-only {loc} -d {db}"
    _p = subprocess.Popen(_c.split(), stdout=subprocess.PIPE)
    return _p.communicate()                               

def catch_ghosts(loc = "/mnt/rowley", 
                 months = 1,
                 size_thresh = 0.1,
                 size_prec = 1,
                 db = "/home/prod/duc-mount-range/nightly.db"):
    
    staff = ['AIPTadmin',
             'patch','patch.KI-SONIC', 
             'vspan',
             'huangw', 
             'hhmak', 
             'miltoncb',
             'nhenning',
             'howard',
             'jingzhi',
             'virginiaspanoudaki',
             'howardmak',
             'elmiligy',
             'jrkuhn', 
             'Adam_Patch', 
             'Doug_Beeson', 
             'HHMAK', 
             'virginia']

    shared = ['Default', 
              'Default User', 
              'imaging user',
              'Osirix',
              'Shared',
              'CFT',
              'Ultrasound',
              'Public',
              'IVIS',
              'PET',
              'microCT', 
              'UserMRI', 
              'OldMRIUsersData', 
              'workstation usage', 
              'IVIS user data',
              'vivoquant', 
              'aiptcore', 
              'Guest',
              'Imaging User', 
              'remote user',
              'ApowerREC', 
              'DCM', 
              'Synlogic', 
              'Visual Sonics PDF manuals', 
              'vct', 
              'machine-images', 
              'angiogensis  3-27-17']

    _ddf = {}
    _depth = len(loc.split('/'))
    # some ghosts are too old
    _old = ghosts_old(loc=loc, months=months)[0].decode("utf-8").split('\n') 
    _fp = pd.Series([_ifp for _ifp in _old if len(_ifp.split('/')) > _depth])
    _arr = np.array([np.array(_ifp) for _ifp in _fp.str.split('/')])[:,-1]
    _ddf['old'] = pd.DataFrame(_arr, columns=['User'])
    _ddf['old']['Filepath'] = pd.DataFrame(_fp)
    # some ghosts are too big
    _big = ghosts_big(loc=loc, db=db)[0].decode("utf-8").split('\n')
    _fp = pd.DataFrame(_big)[0].str.strip()
    _arr = np.array([np.array(_l) for _l in _fp.str.split(' ',1) if len(_l) == 2])
    _ddf['big'] = pd.DataFrame(_arr, columns=['Size (Bytes)', 'User'])
    _ddf['big']['Size (Bytes)'] = _ddf['big']['Size (Bytes)'].astype('float')
    _ddf['big']['Size (GB)'] = _ddf['big']['Size (Bytes)'] * 1e-9
    _ddf['big']['Size (GB)'] = _ddf['big']['Size (GB)'].round(size_prec)
    _ddf['big']['Size (GB)'] = _ddf['big']['Size (GB)'][_ddf['big']['Size (GB)'] > size_thresh]
    
    # JOIN them together and choose a subset of columns
    # Note: Choosing OUTER join for now, so all files are captured 
    _gh = pd.merge(_ddf['old'], _ddf['big'], how="left", on='User')
    _gh = _gh[['Size (GB)','User','Filepath']]
    # store in a dictionary with meaningful labels
    _ghosts = {}
    _ghosts['user'] = _gh[[_name not in (staff+shared) for _name in _gh['User']]]
    _ghosts['staff'] = _gh[[_name in (staff) for _name in _gh['User']]]
    _ghosts['shared'] = _gh[[_name in (shared) for _name in _gh['User']]]
    # just a little bit of cleanup, then deliver
    for _k in _ghosts.keys():
        _ghosts[_k].reset_index(inplace=True, drop=True)
        _ghosts[_k].index += 1
    return _ghosts

def unique_ghosts(ghosts, gtype='user'):
    ## Options are 'user', 'staff', 'shared'
    unique_users = []
    for _k in ghosts.keys():
        unique_users = unique_users + list(ghosts[_k][gtype]['User'].unique())
    unique_users.sort()
    unique_users = list(np.unique(np.array(unique_users)))
    return unique_users

def show_unique_ghosts(ghosts):
    print()
    print(f"Unique Names\n")
    print(f"\t{len(unique_ghosts(ghosts, gtype='user')):3d} user")
    print(f"\t{len(unique_ghosts(ghosts, gtype='staff')):3d} staff")
    print(f"\t{len(unique_ghosts(ghosts, gtype='shared')):3d} shared")
    print()

def catch_all_ghosts(mntpt):
    _ghosts = {}
    for _k in mntpt:
        _ghosts[_k] = catch_ghosts(loc=mntpt[_k])
    return _ghosts

def ghosts_to_excel(ghosts):
    now = datetime.datetime.now()
    print()
    print(f"Printing Ghost Reports to Excel files\n")
    for _mtpt in ghosts.keys():
        print(f"\t- {_mtpt}")
        _of = f"/root/ghost-reports/Ghosts_{now:%Y-%m-%d}_{_mtpt}.xlsx"
        print(f"\t  @ {_of}")
        with pd.ExcelWriter(_of) as writer:
            for _cat in ghosts[_mtpt].keys():
                ghosts[_mtpt][_cat].to_excel(writer, sheet_name=_cat, index=False)
    print()
                
mntpt = {'Rowley': '/mnt/rowley',
         'Magneto': '/mnt/magneto/Users',
         'Positron': '/mnt/positron/Users',
         'Sonic': '/mnt/sonic/C:/Users',
         'Photon': '/mnt/photon/C:/Users'}

ghosts = catch_all_ghosts(mntpt)
show_unique_ghosts(ghosts)
ghosts_to_excel(ghosts)
