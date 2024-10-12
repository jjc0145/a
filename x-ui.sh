﻿#!/bin/bash
# 一键安装 X-UI 并设置登录端口、账号和密码

# 安装 X-UI
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)

# 设置登录端口为147
x-ui setting -port 147

# 设置登录账号为 jjc0145，密码为 caonima313
x-ui setting -username jjc0145 -password caonima313

# 重启 X-UI 以应用设置
x-ui restart

echo "X-UI 已安装并配置成功！"
echo "登录地址: http://your_server_ip:147"
echo "账号: jjc0145"
echo "密码: caonima313"
