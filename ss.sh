#!/bin/bash

# 检查是否安装了 Git
if ! command -v git &> /dev/null; then
    echo "Git 未安装，正在安装 Git..."
    
    # 检测操作系统类型
    if [ -f /etc/redhat-release ]; then
        # CentOS/RHEL 系统
        sudo yum -y install git
    elif [ -f /etc/debian_version ]; then
        # Debian/Ubuntu 系统
        sudo apt-get update && sudo apt-get -y install git
    elif [ -f /etc/os-release ]; then
        # 一些其他 Linux 发行版（如 Arch、Fedora 等）
        . /etc/os-release
        if [[ "$ID" == "fedora" ]]; then
            sudo dnf install -y git
        elif [[ "$ID" == "arch" ]]; then
            sudo pacman -S --noconfirm git
        else
            echo "未检测到支持的 Linux 发行版，无法自动安装 Git。请手动安装 Git。"
            exit 1
        fi
    else
        echo "未检测到已知的 Linux 发行版，无法自动安装 Git。请手动安装 Git。"
        exit 1
    fi
fi

# 下载 Shadowsocks 一键搭建脚本
echo "下载 Shadowsocks 一键搭建脚本..."
git clone -b master https://github.com/flyzy2005/ss-fly

# 运行 Shadowsocks 安装脚本
echo "运行 Shadowsocks 安装脚本..."
bash ss-fly/ss-fly.sh -i flyzy2005.com 1024

# 启用 BBR 加速
echo "启用 BBR 加速..."
bash ss-fly/ss-fly.sh -bbr

# 验证 BBR 是否成功开启
echo "验证 BBR 加速是否成功开启..."
bbr_status=$(sysctl net.ipv4.tcp_available_congestion_control | grep 'bbr')
if [[ $bbr_status == *"bbr"* ]]; then
    echo "BBR 加速已成功开启。"
else
    echo "BBR 加速未成功开启，请检查配置。"
fi

echo "Shadowsocks 安装及 BBR 配置脚本执行完成。"
