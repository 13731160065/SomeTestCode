# WZZBaseProject

基础项目

<br/>

## 文件介绍

**addhead_wzz.sh**：给本文件夹内文件批量添加前缀，用法./addhead_wzz.sh xxx，本文件夹内的所有文件都会加xxx前缀

**addend_wzz.sh**：给本文件夹内文件批量添加前缀，用法./addend_wzz.sh @3x png，本文件夹内所有png文件都会加上@3x后缀

**changeBaseProName_wzz.sh**：修改基础项目名，包括项目内文件夹，依赖于changeFileContent_wzz文件

**changeFileContent_wzz**：修改内容

## 功能简介

通过该项目，可以快速创建一个空的项目，包括已集成好的各类基础框架及基本项目结构

## 使用说明

1. **修改项目名称**

 只需调用`changeBaseProName_wzz.sh`脚本即可快速修改该基础项目名为你想创建的项目名

 例如，要创建一个名为`WZZAbcProject`的项目，在终端输入

 `cd xxx/xxx/xxx/WZZBaseProject` *(进入基础项目文件夹，由于改名脚本使用的是./相对路径，所以一定要进入该项目文件夹再操作)*

 `./changeBaseProName_wzz.sh WZZAbcProject` *(执行改名脚本)*

 不出意外应该修改成功了

 如果提示`-bash: ./changeBaseProName_wzz.sh: Permission denied`，说明该用户没有执行该脚本权限，使用`chmod u+x ./changeBaseProName_wzz.sh`给用户加该文件的执行权限即可

2. **pod加载类库`(可选)`**

 如果要使用cocoapod加载类库，Podfile文件已经创建好，直接pod即可，如果不使用cocoapod也建议看看Podfile，里边已经放好常用的类库，和一些方便的工具

🍺😄
