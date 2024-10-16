#/bin/sh
socks_port="1080" #端口可修改
socks_user="313"  #账号
socks_pass="313"  #密码
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables-save

ips=(
$(hostname -I)
)

# Xray Installation
wget -O /usr/local/bin/xray  http://841893392.sxmir.com/xray
chmod +x /usr/local/bin/xray
cat <<EOF > /etc/systemd/system/xray.service
[Unit]
Description=The Xray Proxy Serve
After=network-online.target
[Service]
ExecStart=/usr/local/bin/xray -c /etc/xray/serve.toml
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
RestartSec=15s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable xray

# Xray Configuration
mkdir -p /etc/xray
echo -n "" > /etc/xray/serve.toml
for ((i = 0; i < ${#ips[@]}; i++)); do
cat <<EOF >> /etc/xray/serve.toml

[[inbounds]]
listen = "${ips[i]}"
port = $socks_port
protocol = "socks"
tag = "$((i+1))"

[inbounds.settings]
auth = "password"
udp = true
ip = "${ips[i]}"

[[inbounds.settings.accounts]]
user = "$socks_user"
pass = "$socks_pass"
[[routing.rules]]
type = "field"
inboundTag = "$((i+1))"
outboundTag = "$((i+1))"
[[outbounds]]
sendThrough = "${ips[i]}"
protocol = "freedom"
tag = "$((i+1))"
EOF
done
systemctl stop xray
systemctl start xray

    echo "###############################################################"
    echo "#        支持系统:  CentOS 6+ / Debian 7+ / Ubuntu 12+          #"
    echo "#        详细说明: L2TP VPN 自动安装程序 有问题添加下方             #"
    echo "#                  微信:lO_OI-KLp                              #"
    echo "#                  QQ群:519969773                              #"
    echo "###############################################################"
