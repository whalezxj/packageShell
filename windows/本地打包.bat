@echo off
:: 变量参数配置
set java_project_path=D:\zhuang\svn\irrigated-parent
set java_module_path=package\pack-yd-busi-normal-hnsw
set vue_project_path=D:\ydsoft\web-vue-hn-swyc
set current_path=%cd%
set package_name=hnsw
set profile_name=dev
:: 前端项目打包
cd %vue_project_path%
git pull
call npm install --registry=https://registry.npm.taobao.org
call npm run build
:: 前端->webapp
rd /S/Q "%java_project_path%\%java_module_path%\src\main\webapp\"
xcopy /S/Y "%vue_project_path%\dist"  "%java_project_path%\%java_module_path%\src\main\webapp\"
:: 后端打包
cd %java_project_path%
git pull
call mvn install -Dmaven.test.skip=true
cd %java_project_path%\%java_module_path%
call mvn clean package -P %profile_name%
:: 打包到package目录
copy "%java_project_path%\%java_module_path%\target\%package_name%.war" "C:\Users\admin\Desktop\packages\"
cd %current_path%
:: 远程部署
powershell .\%package_name%.ps1 %package_name%

:: pause
