#!/bin/bash
# 如果目录下有一个podspec文件，直接询问版本号，然后打包验证、发布
# 如果目录下有多个podspec文件，遍历每一个podspec文件，询问版本号，然后打包验证、发布

PARAM1=$1

function cmd_push(){
	# 输入版本号
	while :
	do
		if [ "$PARAM1" == "" ];then
			read -p "请输入${FILENAME}版本号: " PARAM1
		else
			break
		fi
	done

	# 更新podspec
	sed -i "" "s/s.version\([ ]\{1,\}\)=\([ ]\{1,\}\)\([\'|\"]\)\([^\"]\{1,\}\([\'|\"]\)\)/s.version = \"${PARAM1}\"/g" ${FILENAME}

	# 打包验证
	git add --all
	git commit -am "update podspec"
	git push origin
	git tag ${PARAM1}
	git push --tags
	pod lib lint

	# 发布
	read -p "现在要发布${FILENAME}吗？ y/n: " pushnow
	if [ "$pushnow" == "y" ];then
		echo "> pod trunk push ${FILENAME}"
		pod trunk push ${FILENAME}
	fi


}

function cmd_checkfile(){
	count=$(ls *.podspec | wc -l)

	# 遍历每一个podspec文件
	for FILENAME in *.podspec
	do
		if [ $count -gt 1 ]; then
			read -p "检测到了${FILENAME}，是否是您要发布的podspec？ y/n: " yn
			if [ "$yn" == "y" ];then
				cmd_push
			fi
		elif [ $count == 1 ]; then
				cmd_push
		else
				echo -e "> \\033[0;31m没有找到podspec。\\033[0;39m"
		fi
	done
}

case $PARAM1 in
	'docs'|'help') open https://xaoxuu.com/wiki/podspec.sh/ ;;
	*) cmd_checkfile ;;
esac
