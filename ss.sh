#!/bin/bash

# 一键搭建 Shadowsocks 服务脚本，使用 aes-256-gcm 加密方式

# 更新系统软件包
apt update -y
apt upgrade -y

# 安装 Shadowsocks 服务端
apt install -y shadowsocks-libev

# 配置 Shadowsocks
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "local_port": 1080,
    "password": "your_password",
    "timeout": 300,
    "method": "aes-256-gcm"
}
EOF

# 启动并启用 Shadowsocks 服务
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# 显示配置信息
echo "Shadowsocks 已成功搭建!"
echo "服务器地址: $(curl -s ifconfig.me)"
echo "服务器端口: 8388"
echo "密码: your_password"
echo "加密方式: aes-256-gcm"
