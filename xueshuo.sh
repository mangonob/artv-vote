#!/bin/bash

TOKEN_PATH=~/.xueshuo_token
PYTHON_ENV="null=None;undefined=None;true=True;false=False;"

if [ -f $TOKEN_PATH ]; then
  TOKEN=$(cat $TOKEN_PATH)

  echo "Checking you login status..."

  RESPONSE=$(curl -s 'https://finance-api.51xueshuo.com/financial-search/api/web/isLogin' \
    -H 'Connection: keep-alive' \
    -H 'deviceMod: iOS10.31' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'source: 2' \
    -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' \
    -H 'token: '$TOKEN'' \
    -H 'deviceBrand: iPhone' \
    -H 'Origin: https://www.55xueshuo.com' \
    -H 'Sec-Fetch-Site: cross-site' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Sec-Fetch-Dest: empty' \
    -H 'Referer: https://www.55xueshuo.com/' \
    -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8' \
    --compressed)

  echo $RESPONSE

  LOGINED=true
else
  LOGINED=false
fi

if [ $LOGINED == false ]; then
  printf "Please input your phone number: " && read MOBILE

  curl -s "https://finance-api.51xueshuo.com/financial-search/api/web/sendMessage?userName=$MOBILE&prefix=86" \
    -H 'deviceMod: iOS10.31' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Referer: https://www.55xueshuo.com/' \
    -H 'source: 2' \
    -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' \
    -H 'token: ' \
    -H 'deviceBrand: iPhone' \
    --compressed > /dev/null && echo "Pin code send success!" || echo "Pin code send failed!"

  printf "Please input your 6 digits pin code: " && read PINCODE

  RESULT=$(curl -s 'https://finance-api.51xueshuo.com/financial-search/api/web/loginMessage' \
    -H 'source: 2' \
    -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' \
    -H 'Content-Type: application/json' \
    -H 'deviceMod: iOS10.31' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Referer: https://www.55xueshuo.com/' \
    -H 'token: ' \
    -H 'deviceBrand: iPhone' \
    --data-raw '{"userName":'$MOBILE',"mobilePrefix":"86","smsVerifyCode":"'$PINCODE'"}' \
    --compressed)

  TOKEN=$(python -c $PYTHON_ENV'print '$RESULT'["data"]["token"]')

  echo $TOKEN > $TOKEN_PATH
fi

for i in {1..6}
do
  curl 'https://finance-api.51xueshuo.com/financial-search/api/voteVideo/vote' \
    -H 'source: 2' \
    -H 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_1 like Mac OS X) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.0 Mobile/14E304 Safari/602.1' \
    -H 'Content-Type: application/json' \
    -H 'deviceMod: iOS10.31' \
    -H 'Accept: application/json, text/plain, */*' \
    -H 'Referer: https://www.55xueshuo.com/' \
    -H "token: $TOKEN" \
    -H 'deviceBrand: iPhone' \
    --data-raw '{"videoId":"3facf92bc10b3b1cef28b11cee8647cb"}' \
    --compressed
done
