#!/bin/bash

# 红色 \033[31m \033[0m 
# 绿色 \033[32m \033[0m 
# 黄色 \033[33m \033[0m 

if [ ! -n "$1" ]; then
	echo -e "\033[32m修改项目名脚本\033[0m"
	echo "使用方法:将需要修改成的项目名放在该文件后面"
	echo "例如:$0 xxx"
	echo "主要功能:将该项目换名"
	exit
fi

# 待修改项目名
projectName=$1

# 修改项目文件中的项目名
# 相关配置
changeFileContent="./changeFileContent_wzz"

for line in $(cat $changeFileContent); do

	sed -i "" "s/WZZBaseProject/${projectName}/g" $line
	echo -e "修改 \033[32m ${line} \033[0m 文件，讲该文件中的\033[33mWZZBaseProject\033[0m修改为\033[33m${projectName}\033[0m"

done

# 修改路径中的文件和文件夹名
mv ./WZZBaseProject/WZZBaseProjectUITests/WZZBaseProjectUITests.m ./WZZBaseProject/WZZBaseProjectUITests/${projectName}UITests.m
mv ./WZZBaseProject/WZZBaseProjectUITests ./WZZBaseProject/${projectName}UITests
mv ./WZZBaseProject/WZZBaseProject.xcodeproj ./WZZBaseProject/${projectName}.xcodeproj
mv ./WZZBaseProject/WZZBaseProjectTests/WZZBaseProjectTests.m ./WZZBaseProject/WZZBaseProjectTests/${projectName}Tests.m
mv ./WZZBaseProject/WZZBaseProjectTests ./WZZBaseProject/${projectName}Tests
mv ./WZZBaseProject/WZZBaseProject ./WZZBaseProject/${projectName}
mv WZZBaseProject ${projectName}
echo -e "修改包含\033[33mWZZBaseProject\033[0m的文件及文件夹名为\033[32m${projectName}\033[0m"

