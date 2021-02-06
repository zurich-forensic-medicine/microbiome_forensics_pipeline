# R wrapper for cut_adupters

# Input
print(raw_path)
print(no_primers_path)

# run bash script
# https://stackoverflow.com/questions/11395217/run-a-bash-script-from-an-r-script
# form a bash string (make sure it has execution permissions)
x1 <- file.path(project_path, 'src/pipeline_building_blocks/1_cut_adapters.sh')   # script to run
x <- paste(x1, raw_path, no_primers_path)
cat(x)  # sanity check

# run bash command
system(x)
