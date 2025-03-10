#!/bin/bash

# 单条搭建 Shadowsocks 服务脚本，启用 TCP 和 UDP 支持

# 更新系统软件包
apt update -y
apt upgrade -y

# 安装 Shadowsocks 服务端
apt install -y shadowsocks-libev

# 配置 Shadowsocks
server_port=8388  # Shadowsocks 端口号
password="your_password"  # Shadowsocks 密码
method="aes-256-gcm"  # 加密方式

# 获取服务器IP
server_ip=$(curl -s ifconfig.me)

# 创建 Shadowsocks 配置文件
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": $server_port,
    "local_port": 1080,
    "password": "$password",
    "timeout": 300,
    "method": "$method",
    "mode": "tcp_and_udp"  # 启用 TCP 和 UDP 支持
}
EOF

# 启动并启用 Shadowsocks 服务
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# 生成并输出 Shadowsocks URL (SUR)
sur="ss://$(echo -n "$method:$password@$server_ip:$server_port" | base64)#Shadowsocks"

echo "Shadowsocks 已成功搭建!"
echo "服务器地址: $server_ip"
echo "服务器端口: $server_port"
echo "密码: $password"
echo "加密方式: $method"
echo "Shadowsocks 分享 URL (SUR):"
echo "$sur"
