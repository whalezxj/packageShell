# 变量参数配置
$package_name = $args[0]
$tomcat_name = "Tomcat8-02"
$service_name = $tomcat_name
$local_path = "C:\Users\admin\Desktop\packages"
$temp_path = "E:\temp"
$tomcat_home = "D:\" + $tomcat_name
# 远程登录信息
$serverId = '192.168.1.135'
$username = 'administrator'
$password = 'Gz*#yd#*87356212'
$password = ConvertTo-SecureString -AsPlainText $password -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $password
# 创建远程会话
$session = New-PSSession -ComputerName $serverId  -Credential $credential
# 上传部署文件
Copy-Item -Path $local_path\$package_name.war -Destination $temp_path\ -ToSession $session
# 执行远程命令
Invoke-Command -Session $session {
    param($service_name, $package_name, $tomcat_home, $temp_path)
    Stop-Service $service_name
    rm $tomcat_home\webapps\$package_name\ -Recurse -Force
    copy $temp_path\$package_name.war $tomcat_home\webapps\$package_name.war
    Start-Service $service_name
} -ArgumentList $service_name, $package_name, $tomcat_home, $temp_path
