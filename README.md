# CampusNet
联通沃派、天翼飞Young 一体化登录器，绕过限制热点分享，路由器可直接上网

**注：`Fyoung` 已经更新，后浪们加油，永不屈服，永远斗争**

注意：本仓库只给出可执行文件，不包含源代码（由于种种原因）

[博客](https://www.ufec.cn)给出了分析过程

Windows、Linux、mipsle 三个版本

## 关于脚本
由于我的路由器 `upx` 无法运行，不能进一步压缩路由器打包的程序，导致很多朋友无法使用，最终还是决定写一个 `shell` 脚本，Windows端也可以通过 `WSL` 运行 (本脚本就是在 `WSL` 中写出来的)

### 运行截图
![运行截图](https://s1.ax1x.com/2022/03/17/qPpWTA.png)

### 需要准备什么
 * **请确保你的终端设备支持** `curl` `grep` `awk`
 * **一个飞Young账号**
   * 注意：一旦使用本脚本登录，手机端将无法登录，请确认你的需求
 * **对应账号的31天密码**
   使用仓库中的 `fyoung.js` 生成即可
 * **使用前一定要连接飞young AP**

### 如何使用
```shell
chmod +x ./young.sh
./young.sh   # 上线操作
./young offline
```

你也可以这样
```shell
wget https://ghproxy.com/https://raw.githubusercontent.com/ufec/CampusNet/main/young.sh -O young.sh && bash young.sh
```

### 其他注意事项
  * 模拟手机端登陆，任何设备联网之后均可以分享热点，无视飞young限制
  * 手机端没有心跳包，连接飞young的设备无网络活动一段时间后会自动断开连接，解决方法有：
    - 路由器认证后，通过定时任务 `curl` `ping` 一个网址 均可
    - 始终保持路由器有网络活动，这个就有很多办法了

### 支持仓库
![赞赏码](https://ghproxy.com/https://raw.githubusercontent.com/ufec/picGoImg/main/blog/sponsor_qrcode.webp)