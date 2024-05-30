# MZwrt RAX3000m 云编译
此版本为精简版，自用版本，极限精简如果安装插件可能会出现缺少内核等情况
因为我常用openclash和adguardhome默认兼容此插件
纯原版安装剩余空间88.7M足够使用

如果不需要ipv6可以在config文件里面的7294行和7295行将以下代码替换掉

CONFIG_PACKAGE_odhcp6c=y

CONFIG_PACKAGE_odhcp6c_ext_cer_id=0


替换成

    # CONFIG_PACKAGE_odhcp6c is not set
    # CONFIG_PACKAGE_odhcp6c_ext_cer_id is not set

后期想开启ipv6可以在后台安装odhcp6即可恢复ipv6


# 兼容的插件
因为精简许多模块导致很多第三方插件无法安装，

兼容所有官方插件

已测试兼容的插件
luci-app-openclash

luci-app-adguardhome

luci-app-smartdns

luci-app-gowebdav

# 默认安装的插件
luci-app-adguardhome  （官方库未提供后台界面安装会不显示）



# 微信赞赏码
如果您觉得还不错请支持我持续更好的创作

![Image text](https://github.com/mzwrt/RAx3000m/blob/1f1223de54bcf87e85471ad04cc8814a6cdee4d9/zanshang.png)
