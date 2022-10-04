#/usr/local/bin/julia
using CSV
using DataFrames
using Dates
using TerminalPager

# NOTE: CURRENTLY REQUIRES PRIOR CALL FROM FISH
# ~> duc-list-sonic-users csv > /your/local/path/sonic-user.dat
# TODO: Make the fish duc script into a shell script to call from Julia
df = DataFrame(CSV.File("sonic-user.csv"))
dff = filter(row -> !(row.User == "AIPTadmin" || 
                      row.User == "Default" || 
                      row.User == "Public" || 
                      row.User == "Default User"),  df)
sort(dff)
first_of_last_month = firstdayofmonth(today() - Month(1))
ghost = dff[(dff.LastMod .< first_of_last_month), :]
sort!(ghost, [:Size], rev=true)
print
pager(ghost)  
