#!/usr/bin/expect

# 自动安装 X-UI 并设置登录端口、账号和密码

# 设置变量
set timeout 300
set username "jjc0145"
set password "caonima313"
set port "147"

# 启动安装脚本并自动确认安装
spawn bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

# 模拟输入 "y" 确认继续安装
expect "确认是否继续?*"
send "y\r"

# 输入账户名
expect "请设置您的账户名*"
send "$username\r"

# 输入密码
expect "请设置您的密码*"
send "$password\r"

# 确认密码
expect "请确认您的密码*"
send "$password\r"

# 设置登录端口
expect "请设置面板访问端口*"
send "$port\r"

# 结束 expect 脚本
expect eof

# 重启 X-UI 以应用设置
spawn x-ui restart
expect eof

puts "X-UI 已安装并配置成功！"
puts "登录地址: http://your_server_ip:$port"
puts "账号: $username"
puts "密码: $password"
