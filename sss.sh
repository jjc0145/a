#!/bin/bash

# 批量搭建 30 条 Shadowsocks 账户并导出 URL 的脚本（启用 UDP）

# 更新系统软件包
apt update -y
apt upgrade -y

# 安装 Shadowsocks 服务端
apt install -y shadowsocks-libev

# 创建目录保存 Shadowsocks 配置
mkdir -p /etc/shadowsocks-libev

# 配置 Shadowsocks
base_port=8388  # 基础端口号
method="aes-256-gcm"  # 加密方式
base_password="your_password"  # 基础密码前缀

# 获取服务器IP
server_ip=$(curl -s ifconfig.me)

# 创建并导出 Shadowsocks 配置和 URL
for i in $(seq 1 30); do
    port=$((base_port + i))
    password="${base_password}_$i"

    # 生成配置文件，启用 UDP 支持
    config_file="/etc/shadowsocks-libev/config_$i.json"
    cat > $config_file <<EOF
{
    "server": "0.0.0.0",
    "server_port": $port,
    "local_port": 1080,
    "password": "$password",
    "timeout": 300,
    "method": "$method",
    "mode": "tcp_and_udp"  # 启用 TCP 和 UDP 支持
}
EOF

    # 启动 Shadowsocks 服务
    ss-server -c $config_file -u -d start  # 使用 -u 启用 UDP 支持

    # 生成并输出 SUR
    sur="ss://$(echo -n "$method:$password@$server_ip:$port" | base64)#Shadowsocks_$i"
    echo "$sur" >> /etc/shadowsocks-libev/shadowsocks_urls.txt
done

# 显示所有 URL
echo "Shadowsocks 已批量搭建 30 条并成功导出 URL！"
echo "URL 已保存至 /etc/shadowsocks-libev/shadowsocks_urls.txt"
cat /etc/shadowsocks-libev/shadowsocks_urls.txt
