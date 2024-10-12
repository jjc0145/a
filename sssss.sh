#!/bin/bash

# 一键安装 Shadowsocks 服务，启用 TCP 和 UDP 支持

# 更新系统软件包
apt update -y && apt upgrade -y

# 安装 Shadowsocks-libev
apt install -y shadowsocks-libev

# 配置 Shadowsocks
server_port=8388  # 你可以更改此端口
password="your_password"  # 你可以更改此密码
method="aes-256-gcm"  # 加密方式

# 创建 Shadowsocks 配置文件，并启用 UDP 支持
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": $server_port,
    "password": "$password",
    "timeout": 300,
    "method": "$method",
    "mode": "tcp_and_udp"  # 启用 TCP 和 UDP
}
EOF

# 启动并启用 Shadowsocks 服务
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# 获取服务器IP
server_ip=$(curl -s ifconfig.me)

# 生成并输出 Shadowsocks 分享 URL (SUR)
sur="ss://$(echo -n "$method:$password@$server_ip:$server_port" | base64)#Shadowsocks"
echo "Shadowsocks 已成功搭建!"
echo "服务器地址: $server_ip"
echo "服务器端口: $server_port"
echo "密码: $password"
echo "加密方式: $method"
echo "Shadowsocks 分享 URL (SUR): $sur"
