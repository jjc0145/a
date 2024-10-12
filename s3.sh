#!/bin/bash

# Shadowsocks-libev 一键安装脚本，支持 TCP 和 UDP

# 更新并升级系统
apt update -y && apt upgrade -y

# 安装 Shadowsocks-libev
apt install -y shadowsocks-libev

# 配置 Shadowsocks
server_port=8388  # 设置服务器端口号
password="your_password"  # 设置Shadowsocks连接密码
method="aes-256-gcm"  # 加密方式，推荐 aes-256-gcm

# 创建 Shadowsocks 配置文件，启用 TCP 和 UDP 支持
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": $server_port,
    "password": "$password",
    "timeout": 300,
    "method": "$method",
    "mode": "tcp_and_udp",  # 同时启用 TCP 和 UDP 支持
    "fast_open": false,  # 如果需要启用 TCP Fast Open，可以设置为 true
    "no_delay": true,  # 禁用 Nagle 算法减少延迟
    "reuse_port": true  # 启用端口复用
}
EOF

# 重启 Shadowsocks 服务并设置开机自启动
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# 检查 Shadowsocks 服务状态
if systemctl is-active --quiet shadowsocks-libev; then
    echo "Shadowsocks 启动成功"
else
    echo "Shadowsocks 启动失败，请检查日志"
    journalctl -u shadowsocks-libev --no-pager
    exit 1
fi

# 获取服务器 IP 地址
server_ip=$(curl -s ifconfig.me)

# 生成 Shadowsocks 分享 URL
sur="ss://$(echo -n "$method:$password@$server_ip:$server_port" | base64 | tr -d '\n')"

# 输出配置信息
echo "Shadowsocks 已成功搭建!"
echo "服务器地址: $server_ip"
echo "服务器端口: $server_port"
echo "密码: $password"
echo "加密方式: $method"
echo "Shadowsocks 分享 URL: $sur"

# 提示用户检查防火墙
echo "确保防火墙允许端口 $server_port 的 TCP 和 UDP 流量"
