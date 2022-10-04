#/usr/local/bin/julia
using CSV
using DataFrames
using Dates
using TerminalPager
using ArgParse

s = ArgParseSettings()
@add_arg_table s begin
    "--duc-mount-ls-sh", "-s"
        arg_type = String
        help = "Path to duc-mount-ls.sh"
        default = "/home/prod/duc-mount-range/bash/duc-mount-ls.sh"
    "--base-dir", "-b"
        arg_type = String
        help = "Path to scan folder, please specify"
        required = true
    "--print", "-p"
        action = :store_true 
        help = "Print output"
end

parsed_args = parse_args(ARGS, s)
pbash = parsed_args["duc-mount-ls-sh"]
bdir = parsed_args["base-dir"]
printflag = parsed_args["print"]

df = DataFrame(CSV.File(IOBuffer(readchomp(`$pbash $bdir csv`))))
dff = filter(row -> !(row.User == "AIPTadmin" || 
                      row.User == "Default" || 
                      row.User == "Public" || 
                      row.User == "Default User"),  df)
first_of_last_month = firstdayofmonth(today() - Month(1))
ghost = dff[(dff.LastMod .< first_of_last_month), :]
sort!(ghost, [:Size], rev=true)
if printflag
  CSV.write(stdout, ghost)
else
  pager(ghost)
end
