#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
PLAIN='\033[0m'

red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}

green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}

yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}

clear
echo "#############################################################"
echo -e "#               ${RED} Deepnote xray 一键安装脚本${PLAIN}                 #"
echo -e "# ${GREEN}作者${PLAIN}: MisakaNo の 小破站                                  #"
echo -e "# ${GREEN}博客${PLAIN}: https://blog.misaka.rest                            #"
echo -e "# ${GREEN}GitHub 项目${PLAIN}: https://github.com/Misaka-blog               #"
echo -e "# ${GREEN}Telegram 频道${PLAIN}: https://t.me/misakablogchannel             #"
echo -e "# ${GREEN}Telegram 群组${PLAIN}: https://t.me/misakanoxpz                   #"
echo -e "# ${GREEN}YouTube 频道${PLAIN}: https://www.youtube.com/@misaka-blog        #"
echo "#############################################################"
echo ""

yellow "使用前请注意："
red "1. 我已知悉本项目有可能触发 Deepnote 封号机制"
red "2. 我不保证脚本其搭建节点的稳定性"
read -rp "是否安装脚本？ [Y/N]：" yesno

if [[ $yesno =~ "Y"|"y" ]]; then
    kill -9 $(ps -ef | grep web | grep -v grep | awk '{print $2}') >/dev/null 2>&1
    rm -f web config.json
    yellow "开始安装..."
    wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
    unzip temp.zip xray
    RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
    mv xray web
    read -rp "请设置UUID（如无设置则使用脚本默认的）：" uuid
    if [[ -z $uuid ]]; then
        uuid="8d4a8f5e-c2f7-4c1b-b8c0-f8f5a9b6c384"
    fi
    cat <<EOF > config.json
{
  "log": {
    "loglevel": "info"
  },
  "dns": {
    "servers": ["https+local://dns.oszx.co/dns-query"]
  },
  "inbounds": [
    {
      "port": 8080,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "$uuid"
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "/579ccd?ed=2048"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": ["http", "tls", "quic"]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
        "domainStrategy": "UseIPv4"
      }
    }
  ]
}
EOF
    nohup ./web -config=config.json &>/dev/null &
    green "Deepnote xray 已安装完成！"
    yellow "请认真阅读项目博客说明文档，配置出站链接！"
    yellow "别忘记给项目点一个免费的Star！"
    echo ""
    yellow "更多项目，请关注：小御坂的破站"
else
    red "已取消安装，脚本退出！"
    exit 1
fi