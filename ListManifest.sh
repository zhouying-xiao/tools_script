
revision_module=`cat .repo/manifest.xml |grep -E "<\s*project name\s*=\s*.*revision\s*="| sed -e 's/<project name=\"\(.*\)\"\s*path=\"\(.*\)\"\s*revision\s*=\"\(.*\)\"\s*.*/\1 \2 \3/' | sed "s/\"//g" | awk -F" " '{print $2,$3}' 2>&1 | tee revision_module.txt`

no_revision_module=`cat .repo/manifest.xml |grep -E "<\s*project name\s*=\s*.*" | grep -v "revision\s*=" | sed -e 's/<project name\s*=\s*\"\(.*\)\"\s*path\s*=\s*\"\(.*\)\".*/\1 \2/' |  sed 's/\"//g' | awk -F" " '{print $1,$2}' 2>&1 | tee no_revision_module.txt`

default_branch_list=`cat .repo/manifest.xml | grep -E "<default\s*remote" | sed -e 's/<default\s*remote\s*=\s*\"\(.*\)\"\s*revision\s*=\s*\"\(.*\)"/\1 \2/'| sed 's/\"//g' | awk -F" " '{print $1,$2}'`
default_branch_list=($default_branch_list)
echo "default_branch_list: ${default_branch_list[@]} ${#default_branch_list[@]}"
remote=${default_branch_list[0]}
default_branch=${default_branch_list[1]}
echo "remote:$remote ##########default_branch:$default_branch"

rom_branch='A'
rom_mtk_branch='B'
new_rom_branch='C'
new_default_branch='D'
new_mtk_rom_branch='E'
local_branch='F'

while read line
do
	flag=true
	path=`echo $line | cut -d" " -f1`
	branch=`echo $line | cut -d" " -f2`
	if [[ $branch == $rom_branch  ]];then
		branch_new=$new_rom_branch
	elif [[ $branch == $rom_mtk_branch ]];then
		branch_new=$new_mtk_rom_branch
	else
		branch_new=$new_default_branch
	fi
	echo "revision_module path: $path ############ $branch_new"
	pushd $path
	git push $remote $local_branch:$branch_new
	popd
	
done < revision_module.txt

while read line
do
	path=`echo $line | cut -d" " -f2`
	echo "path: $path"
	pushd $path
	git push $remote $local_branch:$new_default_branch
	popd
	
		
done < no_revision_module.txt
