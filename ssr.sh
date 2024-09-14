#!/bin/bash

# 设定默认的配置参数
DEFAULT_PORT=8388
DEFAULT_PASSWORD="your_default_password"
DEFAULT_METHOD="aes-256-gcm"  # SSR支持的加密方式之一
DEFAULT_PROTOCOL="origin"     # SSR协议
DEFAULT_OBFS="plain"          # SSR混淆方式
OBFS_PARAM=""
PROTOCOL_PARAM=""
REMARKS="MySSRServer"         # 服务器的备注名称
GROUP=""                      # SSR组名

# 获取服务器 IP 地址
SERVER_IP=$(curl -s https://api.ipify.org)

# 安装 ShadowsocksR 依赖
apt update
apt install -y wget curl

# 下载并执行 ShadowsocksR 安装脚本
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
chmod +x shadowsocksR.sh

# 自动输入默认参数并安装
./shadowsocksR.sh <<EOF
$DEFAULT_PORT
$DEFAULT_PASSWORD
$DEFAULT_METHOD
$DEFAULT_PROTOCOL
$DEFAULT_OBFS
EOF

# 输出 ShadowsocksR 配置信息
echo "ShadowsocksR 安装完成"
echo "端口号: $DEFAULT_PORT"
echo "密码: $DEFAULT_PASSWORD"
echo "加密方式: $DEFAULT_METHOD"
echo "协议: $DEFAULT_PROTOCOL"
echo "混淆方式: $DEFAULT_OBFS"

# Base64 编码函数
base64_encode() {
    echo -n "$1" | base64 | tr -d '\n' | tr '/+' '_-' | tr -d '='
}

# 生成 SSR URI 格式
SSR_URI="ssr://$(base64_encode "$SERVER_IP:$DEFAULT_PORT:$DEFAULT_PROTOCOL:$DEFAULT_METHOD:$DEFAULT_OBFS:$(base64_encode $DEFAULT_PASSWORD)/?obfsparam=$OBFS_PARAM&protoparam=$PROTOCOL_PARAM&remarks=$(base64_encode $REMARKS)&group=$(base64_encode $GROUP)")"

# 输出 SSR URI 导入链接
echo "ShadowsocksR URI 导入链接: $SSR_URI"
