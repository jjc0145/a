#!/bin/bash

# 一键安装 Shadowsocks-libev，并启用 TCP 和 UDP

# 更新系统软件包
apt update -y && apt upgrade -y

# 安装 Shadowsocks-libev
apt install -y shadowsocks-libev

# 设置 Shadowsocks 服务器配置
server_port=8388  # 修改此处设置端口
password="your_password"  # 设置你的密码
method="aes-256-gcm"  # 设置加密方式

# 创建 Shadowsocks 配置文件，启用 TCP 和 UDP 支持
cat > /etc/shadowsocks-libev/config.json <<EOF
{
    "server": "0.0.0.0",
    "server_port": $server_port,
    "password": "$password",
    "timeout": 300,
    "method": "$method",
    "mode": "tcp_and_udp",  # 启用 TCP 和 UDP 支持
    "fast_open": false,  # 禁用 TCP Fast Open 避免兼容性问题
    "no_delay": true,  # 禁用 Nagle 算法减少延迟
    "reuse_port": true  # 启用端口复用
}
EOF

# 重启并启用 Shadowsocks 服务
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev

# 验证 Shadowsocks 是否启动成功
if systemctl is-active --quiet shadowsocks-libev; then
    echo "Shadowsocks 启动成功"
else
    echo "Shadowsocks 启动失败，请检查日志"
    journalctl -u shadowsocks-libev --no-pager
    exit 1
fi

# 获取服务器IP
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
