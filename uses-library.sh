
#source build/envsetup.sh
IsManifest=false
find out/target/product/qssi/  out/target/product/trinket/ -iname "*.apk" 2>&1 | tee apk.log

function mgrep1()
        {
            find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o \( -regextype posix-egrep -iregex '(.*Android\.mk|.*Android\.bp)' -o -regextype posix-extended -regex '(.*/)?(build|soong)/.*[^/]*\.go' \) -type f \
                -exec grep --color -n -E $@ {} +
        }

APK_PATH=`cat apk.log | grep -v '/obj/' | awk '{print $0}' | sort | uniq`
echo -e "out path\tapk path\tAndroidManifest" >> apk.txt
for apk in ${APK_PATH[@]};do
	echo "the apk is: $apk"
	apk_file=`out/host/linux-x86/bin/aapt dump badging $apk | grep -o 'uses-library'`
    	if [[ -z $apk_file ]];then
		echo $apk >> no_uses-library.log
	else
		echo $apk >> uses-library.log
	fi
done

APK_PATH_user=`cat uses-library.log | grep -v '/obj/' | awk '{print $0}' | sort | uniq`
for apk in ${APK_PATH_user[@]};do 
	local_name=${apk##*/}
	local_name1=${local_name%.*}
	path1=`mgrep1 "name:\s*\"${local_name1}\"|LOCAL_MODULE\s*:=\s*${local_name1}$|LOCAL_PACKAGE_NAME\s*:=\s*${local_name1}$" | sort -u`
	path2=`echo $path1 | awk -F":" '{print $1}'| sort -u`
	echo "1111111122222 ${path2[@]}"
	for path in ${path2[@]};do
		path3=`echo $path | awk -F"Android.bp|Android.mk" '{print $1}'| sort -u`
		ManifestXml=`find $path3 -name "AndroidManifest.xml"`
		if [[ -n $ManifestXml ]];then
			IsManifest=true
		fi 
		echo -e "$apk\t$path\t$IsManifest" >> apk.txt
	done
done

declare -a list1=("Android.bp true" "Android.bp flase" "Android.mk true" "Android.mk false")
for((i=0;i<${#list1[@]};i++));do
        count=`cat apk.txt | awk -F"\t" '{print $2,$3}' | grep "${list1[$i]}" | wc -l`
        echo "[${list1[$i]}] numbers:$count" >> apk.txt
done
