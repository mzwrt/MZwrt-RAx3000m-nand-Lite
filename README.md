# MZwrt RAX3000m 云编译

这个是应该是你们所说的闭源驱动定版本，还有一个开源驱动版本（WIFI高功率驱动版）：[MZwrt-RAx3000m-nand-Lite-lede](https://github.com/mzwrt/MZwrt-RAx3000m-nand-Lite-lede.git)

上面两个固件一致，刷哪一个看个人需求把

【建议所有人更新2024-11-04以后的版本，修复许多错误】

此版本为精简版，自用版本，极限精简如果安装插件可能会出现缺少内核等情况

纯原版安装后剩余空间85.6M足够使用

截至2024年8月14日经过六个月的严格测试，未发现bug，高负载情况下运行良好，有问题请提交issues。每天都会查看修复

# 插件兼容性

兼容openclash

兼容adguardhome--默认安装

兼容passwall

# 如何兼容第三方插件

首先安装我编译的openwrt，在后台安装插件会出现类似以下错误就说明系统不兼容此插件

下面以：`luci-app-docker`插件为例：


依赖的软件包 kmod-fs-btrfs 在所有仓库都未提供。

依赖的软件包 kmod-dm 在所有仓库都未提供。

依赖的软件包 kmod-br-netfilter 在所有仓库都未提供。

依赖的软件包 kmod-ikconfig 在所有仓库都未提供。

依赖的软件包 kmod-nf-ipvs 在所有仓库都未提供。

依赖的软件包 kmod-veth 在所有仓库都未提供。

出现这个错误是因为编译时候未编译进去这几个软件包

云源仓库也未提供此软件包

第一种方法：修改config文件

查找所有报错的软件包在编译时候编译进去就可以了

例如 kmod-fs-btrfs 软件包

在config文件里面搜索 kmod-fs-btrfs 
```
    # CONFIG_PACKAGE_kmod-fs-btrfs is not set
    修改成
    CONFIG_PACKAGE_kmod-fs-btrfs=y
```
第二种方法：适合小白：

在编译的时候直接将 docker 编译进去


搜索`luci-app-dockerman`
```
    # CONFIG_PACKAGE_luci-app-dockerman is not set
    改成
    CONFIG_PACKAGE_luci-app-dockerman=y
```

第一种方法适合只做兼容不安装插件

第二种方法直接安装所需插件

# 2024-7-27日更新

增加一些安全性参数

添加针对armv8-a特性的一些优化和编译器优化

2.添加对passwall的支持这样就可以满足所有主流vpn协议的支持

添加一下四个模块

`CONFIG_PACKAGE_libatomic=y`

`CONFIG_PACKAGE_iptables-mod-conntrack-extra=y`

`CONFIG_PACKAGE_libstdcpp=y`

`CONFIG_PACKAGE_iptables-mod-iprange=y`

# 2024-8-14更新内和参数优化

添加diy3脚本来添加内核优化参数，优化rx 和 tx 队列大小由1000改为1024,tx最大2048最小512 和 开启irqbalance小程序cpu自动平衡中断请求

添加了一个china_dns.sh脚本。我使用的是自建dns服务器在海外，解决国内域名解析慢，速度慢问题，针对国内域名和苹果域名解析的bash脚本默认全部指定`114.114.114.114`

`china_dns.sh`解析使用方法，复制以下命令在ssh里面运行一下就可以了
```
    curl -s https://raw.githubusercontent.com/mzwrt/MZwrt-RAx3000m-nand-Lite/main/china_dns.sh -o /tmp/china_dns.sh && bash /tmp/china_dns.sh && rm /tmp/china_dns.sh
```
# 2024-9-27更新，针对不能拨号连接问题添加以下软件包
```
CONFIG_PACKAGE_shellsync=y
CONFIG_PACKAGE_kmod-ppp=y
CONFIG_PACKAGE_kmod-mppe=y
```
如果后台找不到pppoe协议可以修改`/etc/config/network`文件将里面的`config interface 'wan'`下面的`option proto 'dhcp'`这一行删除然后添加以下几行，运行`/etc/init.d/network restart`或者重启路由器就可以了
```
    option proto 'pppoe'
    option username 'your-username'
    option password 'your-password'
```
说明：
option proto 'pppoe'：将 wan 接口的协议从 dhcp 改为 pppoe。

option username 'your-username'：填入你的宽带账号。

option password 'your-password'：填入你的宽带密码。

# 2024-11-4更新，
修复WIFI固件错误，wifi 6GHz接口报错
```
CONFIG_MTK_MT_WIFI_MT7981_20240823=y
CONFIG_MTK_MT_WIFI_FIRMWARE_PATH_MT7981="mt7981-fw-20240823"
CONFIG_MTK_MT_WIFI_DRIVER_VERSION_7672=y
```
修复加密模块，
```
CONFIG_PACKAGE_kmod-crypto-sha512=y
CONFIG_PACKAGE_kmod-crypto-sha256=y
CONFIG_PACKAGE_kmod-crypto-seqiv=y
CONFIG_PACKAGE_kmod-crypto-rng=y
CONFIG_PACKAGE_kmod-crypto-md5=y
CONFIG_PACKAGE_kmod-crypto-md4=y
CONFIG_PACKAGE_kmod-crypto-hmac=y
CONFIG_PACKAGE_kmod-crypto-ghash=y
CONFIG_PACKAGE_kmod-crypto-gf128=y
CONFIG_PACKAGE_kmod-crypto-gcm=y
CONFIG_PACKAGE_kmod-crypto-des=y
CONFIG_PACKAGE_kmod-crypto-des=y
CONFIG_PACKAGE_kmod-crypto-ctr=y
CONFIG_PACKAGE_kmod-crypto-cmac=y
```
修复luci-app-turboacc-mtk
```
# CONFIG_PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING is not set
# CONFIG_PACKAGE_TURBOACC_INCLUDE_FAST_CLASSIFIER is not set
CONFIG_PACKAGE_TURBOACC_INCLUDE_SHORTCUT_FE_CM=y
```
改为
```
# CONFIG_PACKAGE_TURBOACC_INCLUDE_FLOW_OFFLOADING is not set
CONFIG_PACKAGE_TURBOACC_INCLUDE_FAST_CLASSIFIER=y
# CONFIG_PACKAGE_TURBOACC_INCLUDE_SHORTCUT_FE_CM is not set
```
添加wifi管理工具iw
```
CONFIG_PACKAGE_iw=y

```
修复 802.11n 协议
```
CONFIG_MTK_DOT11_N_SUPPORT=y
```

# 默认安装的插件
luci-app-adguardhome  （官方库未提供后台界面安装会不显示）

