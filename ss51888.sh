apt-get update;
sudo apt install -y shadowsocks-libev;

/etc/init.d/shadowsocks-libev start;
systemctl start shadowsocks-libev;   

echo '{
    "server":["::0", "0.0.0.0"],
    "mode":"tcp_and_udp",
    "server_port":51888,
    "local_port":10810,
    "password":"996996ZZ",
    "timeout":86400,
    "method":"chacha20-ietf-poly1305"
}' > /etc/shadowsocks-libev/config.json;

systemctl restart shadowsocks-libev;