#!/bin/bash

# 更新包列表
apt-get update

# 安装 shadowsocks-libev
sudo apt install -y shadowsocks-libev

# 启动 shadowsocks-libev 服务
/etc/init.d/shadowsocks-libev start
systemctl start shadowsocks-libev

# 创建配置文件
echo '{
    "server":["::0", "0.0.0.0"],
    "mode":"tcp_and_udp",
    "server_port":51888,
    "local_port":10810,
    "password":"996996ZZ",
    "timeout":86400,
    "method":"chacha20-ietf-poly1305"
}' > /etc/shadowsocks-libev/config.json

# 重启 shadowsocks-libev 服务
systemctl restart shadowsocks-libev