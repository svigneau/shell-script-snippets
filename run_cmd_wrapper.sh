#!/bin/bash

# Wrapper to run a command on all files from a set of directories, and output to directories with matching names.
# Parameters need to be edited according to your data structure.
# The parameters here assume a project directory containing:
# - a "src" directory, from which are run this script and the executable used in the command.
# - a "data" directory, containing input directories that can be called using regular expressions. The input directories are named with an underscore-separated suffix indicating file format.
# - a "munge" directory, where output directories will be created with names matching those of the input directories, using a different underscore-separated suffix to indicate the output file format.

src_path=../src # Directory of the executable used in command -- edit with yours.
in_path=../data # Data directory, where the input directories lie -- edit with yours.
in_dir=*_bedgraph # Input directories; use regular expressions to select multiple directories at once -- edit with yours.
out_path=../munge # Munge directoy, where the output directories lie -- edit with yours.
out_dir_suffix=fixedstepwig # Suffix of output directories; the root name is the same as for matching input directories -- edit with yours. 

for dir in $in_path/$in_dir # Cycle through input directories.
do
  dir_name=${dir##*/} # Extract directory name without path.
  dir_base=${dir_name%_*} # Extract directory name root witout suffix.
  out_dir=${dir_base}_${out_dir_suffix} # Compose output directory name by adding the output directory suffix to the input directory name root.
  [ -d $out_path/$out_dir ] || mkdir -p $out_path/$out_dir # Create output directory if it does not already exist.
  for file in $dir/* # Cycle through files in each input directory.
  do
    file_name=${file##*/} # Extract file name without path.
    file_base=${file_name%.*} # Extract file name root without the extension, defined as anything after the first "." character.
    out_file=${out_path}/${out_dir}/${file_base}.wig # Compose the output file name by adding a new extension to the input file name root.
    cmd="perl ${src_path}/bedgraph_to_wig.pl --bedgraph $file --wig $out_file --step 100 --compact" # Define command.
    [ -e $out_file ] || $cmd # Execute command if the output file does not already exist.
  done
done
