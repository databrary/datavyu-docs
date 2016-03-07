# Script to copy over Datavyu_API.rb from datavyu src folder, generate html file, and remove the src file

in_path=../datavyu/src/main/resources/Datavyu_API.rb
out_folder=source/_static/yard
copy_name=Datavyu_API.rb
copy_path="${out_folder}/${copy_name}"

mkdir -p $out_folder
cp $in_path $copy_path
cd $out_folder && yard --no-save --output-dir . $copy_name
rm $copy_name
