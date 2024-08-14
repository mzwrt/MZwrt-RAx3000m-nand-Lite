#!/bin/bash

# 配置文件保存目录
CONFIG_DIR="/etc/dnsmasq.d"
# 配置文件 URL
URL1="https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf"
URL2="https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"
# 配置文件路径
DNSMASQ_CONF="/etc/dnsmasq.conf"
# 引入配置的内容
CONFIG_ENTRY="conf-dir=/etc/dnsmasq.d"

# 检查并创建配置目录
if [ ! -d "$CONFIG_DIR" ]; then
    echo "配置目录不存在，正在创建目录..."
    mkdir -p "$CONFIG_DIR"
fi

# 下载配置文件
echo "正在下载 $URL1 ..."
curl -s -o "$CONFIG_DIR/apple.china.conf" "$URL1"

echo "正在下载 $URL2 ..."
curl -s -o "$CONFIG_DIR/accelerated-domains.china.conf" "$URL2"

# 检查下载情况
if [ -f "$CONFIG_DIR/apple.china.conf" ] && [ -f "$CONFIG_DIR/accelerated-domains.china.conf" ]; then
    echo "配置文件成功下载并保存到 $CONFIG_DIR."
else
    echo "配置文件下载失败."
    exit 1
fi

# 检查是否已经包含了引入配置
if grep -q "^$CONFIG_ENTRY" "$DNSMASQ_CONF"; then
    echo "引入配置已存在于 $DNSMASQ_CONF 中."
else
    echo "在 $DNSMASQ_CONF 中添加引入配置..."
    echo "$CONFIG_ENTRY" >> "$DNSMASQ_CONF"
    echo "引入配置已添加到 $DNSMASQ_CONF."
fi

# 重启 dnsmasq 服务以使配置生效
echo "重启 dnsmasq 服务以使配置生效..."
service dnsmasq restart
echo "dnsmasq 服务已重启."
