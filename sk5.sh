#!/bin/bash

# SOCKS5 代理服务器一键安装脚本 (基于 Dante)
# 请以root权限运行此脚本

# 更新系统并安装必要的软件包
apt update -y && apt upgrade -y
apt install -y dante-server

# 配置 Dante (SOCKS5) 服务器
cat > /etc/danted.conf <<EOF
logoutput: syslog
H80
external: eth0
method: username
user.notprivileged: proxyuser
client pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  log: connect disconnect
}
client pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  log: connect disconnect
  method: username
}
socks pass {
  from: 0.0.0.0/0 to: 0.0.0.0/0
  command: bind connect udpassociate
  log: connect disconnect
}
EOF

# 创建一个系统服务以运行 Dante

# 添加用户和密码
useradd 313 -s /usr/sbin/nologin
echo '313:313' | chpasswd
cat > /etc/systemd/system/danted.service <<EOF
[Unit]
Description=Dante SOCKS5 Server
After=network.target

[Service]
ExecStart=/usr/sbin/danted -f /etc/danted.conf
User=root
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# 启动并使 SOCKS5 服务在系统启动时自动运行
systemctl daemon-reload
systemctl enable danted
systemctl start danted

# 提示用户 SOCKS5 代理服务器安装完成
cat << EOF
SOCKS5 代理服务器已成功安装并启动。
默认监听端口: 1080
请根据需要修改 /etc/danted.conf 以满足特定的访问控制和认证需求。
EOF
