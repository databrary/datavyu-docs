#!/usr/bin/env bash
# Script to copy over Datavyu_API.rb from datavyu src folder, generate html file, and remove the src file

# in_path="../datavyu/src/main/resources/Datavyu_API.rb"
api_file_loc="https://raw.githubusercontent.com/databrary/datavyu/dev/src/main/resources/Datavyu_API.rb"
out_folder="./docs"
copy_name="Datavyu_API.rb"
copy_path="${out_folder}/${copy_name}"

mkdir -p "$out_folder"
curl -fsSL --output "$copy_name" "$api_file_loc"
yard --output-dir "$out_folder" "$copy_name"
rm "$copy_name"
