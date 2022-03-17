#!/bin/bash
# Author : ufec
# Copyright (c) https://github.com/ufec

# 注意：不要在没连接任何网络的情况下运行本脚本

# 飞young账号
username=""
# 31天密码
passwords=(
)


# 请求头
cty="Content-Type:application/x-www-form-urlencoded"
ua="User-Agent:CDMA+WLAN(Maod)"
con="Connection:Keep-Alive"
encoding="Accept-Encoding:gzip"

# 自动获取登录链接
getLoginUrl() {
    trueUrl=`curl -I -s www.baidu.com | grep -Pao '[a-zA-z]+://[^\s]*'`
    curl -s -X POST $trueUrl -H $cty -H $ua -H $con -H $encoding > young.xml
    
    loginUrl=`awk '/<\/*LoginURL\/*>/{gsub(/<LoginURL><!\[CDATA\[/,"");gsub(/\]\]><\/LoginURL>/,"");print $0}' young.xml`
    if [ "$loginUrl" != "" ]; then
        echo -e "\033[49;32;1m[ 1 ] 获取登录链接 [ ✓ ]\n\033[0m"
    else
        echo -e "\033[49;31;1m[ 1 ] 获取登录链接 [ ✕ ]\n\033[0m"
    fi
    AidcAuthAttr1=`awk '/<\/*AidcAuthAttr1\/*>/{gsub(/[[:space:]]*<\/*AidcAuthAttr1\/*>/,"");print $0}' young.xml`
    if [ "$AidcAuthAttr1" != "" ]; then
        echo -e "\033[49;32;1m[ 2 ] 获取飞Young认证服务器时间 [ ✓ ]\n\033[0m"
    else
        echo -e "\033[49;31;1m[ 2 ] 获取飞Young认证服务器时间 [ ✕ ]\n\033[0m"
    fi
    rm -f young.xml
}

online() {
    echo -e "\033[49;32;1m[ 3 ] 获取今天日期 [ ✓ ]\n\033[0m"
    nowdate=${AidcAuthAttr1: 6: 2}
    UserName="!^Adcm0$username"
    Password=${passwords[$nowdate - 1]}
    createAuthorFlag="0"
    AidcAuthAttr3="b5DtUJx1"
    AidcAuthAttr4="LNu8EsIhaVf/JdxatEuOF+4="
    AidcAuthAttr5="MPqjGmDvAZDvlUipl07x+5LxD5M8VYs7GGjbKvFjs5MK"
    AidcAuthAttr6="NfC5UmHsBtjzzR20xFjq+to="
    AidcAuthAttr8="coztTJxofzSeE4IXpxfUUrxMnYRKtArSiRprVVP7GTQ5AN1oVSBw2mzXzvKjzJWQqhaSE42CZU8gD+/MDjTiGaMb0AuNsxxDA0vFo5Mtzt4TcJRJtEg="
    AidcAuthAttr15="b4nuSJw="
    AidcAuthAttr22="bg=="
    AidcAuthAttr23="Lcu+Hco3IQ=="
    echo -e "\033[49;32;5m========服务器认证中========\n\033[0m"
    curl -s -X POST $loginUrl -H $cty -H $ua -H $con -H $encoding \
    --data-urlencode "UserName=$UserName" \
    --data-urlencode "Password=$Password" \
    --data-urlencode "createAuthorFlag=$createAuthorFlag" \
    --data-urlencode "AidcAuthAttr1=$AidcAuthAttr1" \
    --data-urlencode "AidcAuthAttr3=${AidcAuthAttr3}" \
    --data-urlencode "AidcAuthAttr4=$AidcAuthAttr4" \
    --data-urlencode "AidcAuthAttr5=$AidcAuthAttr5" \
    --data-urlencode "AidcAuthAttr6=$AidcAuthAttr6" \
    --data-urlencode "AidcAuthAttr7=" \
    --data-urlencode "AidcAuthAttr8=$AidcAuthAttr8" \
    --data-urlencode "AidcAuthAttr15=$AidcAuthAttr15" \
    --data-urlencode "AidcAuthAttr22=$AidcAuthAttr22" \
    --data-urlencode "AidcAuthAttr23=$AidcAuthAttr23" > offline_young.xml
    checkLogin
}

offline(){
    LogoffURL=`awk '/<\/*LogoffURL\/*>/{gsub(/<LogoffURL><!\[CDATA\[/,"");gsub(/\]\]><\/LogoffURL>/,"");print $0}' offline_young.xml`
    if [ "$LogoffURL" != "" ]; then
        echo -e "\033[49;32;1m[ 2 ] 取下线链接 [ ✓ ]\n\033[0m"
    else
        echo -e "\033[49;31;1m[ 2 ] 取下线链接 [ ✕ ]\n\033[0m"
    fi
    rm -f offline_young.xml
    curl -s -X GET $LogoffURL -H $cty -H $ua -H $con -H $encoding > out.xml
    offlineResponseCode=`awk '/<\/*ResponseCode\/*>/{gsub(/[[:space:]]*<\/*ResponseCode\/*>/, ""); print $0}' out.xml`
    if [ "$offlineResponseCode" == "150" ]; then
        echo -e "\033[49;32;1m[ 3 ]✌️ 下线成功！ [ ✓ ]\n\033[0m"
    else
        echo -e "\033[49;31;1m[ 3 ]😭 下线失败！ [ ✕ ]\n\033[0m"
    fi
    rm -f out.xml
}

checkLogin(){
    loginMsg=`awk '/<\/*ReplyMessage\/*>/{gsub(/[[:space:]]*<\/*ReplyMessage\/*>/, ""); print $0}' offline_young.xml`;
    responseCode=`awk '/<\/*ResponseCode\/*>/{gsub(/[[:space:]]*<\/*ResponseCode\/*>/, ""); print $0}' offline_young.xml`
    if [ "$responseCode" != 50 ]; then
        echo -e "\033[49;31;1m[ 4 ] 😭 $loginMsg [ ✕ ]\n\033[0m"
        return 0;
    else
        echo -e "\033[49;32;1m[ 4 ] ✌️ $loginMsg [ ✓ ]\n\033[0m"
        echo -e "\033[49;34;1m 写码不易 尊重版权 欢迎Start: https://github.com/ufec/CampusNet\n\033[0m"
        return 1;
    fi
}

main() {
    if [ "$1" == "offline" ]; then
        if [ -f "offline_young.xml" ]; then
            echo -e "\033[49;32;1m[ 1 ] 执行下线操作 [ ✓ ]\n\033[0m"
            offline
        else
            echo -e "\033[49;31;1m [ ✕ ] 😭 文件不存在, 请先上线之后再进行操作！\n\033[0m"
        fi
    else
        statusCode=`curl -s -I www.baidu.com | awk 'NR==1{print $2}'`
        if [ "$statusCode" == "200" ]; then
            echo -e "\033[49;31;1m [ ✕ ] 😭 你已经连上网了\n\033[0m"
        else
            getLoginUrl
            online
        fi
    fi
}

echo -e "\033[49;31;1m注意: \n[1] 不要在没连接任何网络的情况下运行本脚本, 本脚本没有判断是否连接网络, 这是没有必要的\n \033[0m"

main $1