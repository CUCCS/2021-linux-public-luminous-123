#!/usr/bin/env bash
# function : 统计访问来源主机TOP 100和分别对应出现的总次数
# Parmas：访问日志
function source_host_top100 {
    awk '{print"访问来源主机TOP 100和分别对应出现的总次数:\n"}{print $1}' $1 | sort | uniq -c|sort -nr|head -n 100
}

# function:统计访问来源主机Top100IP和分别对应出现的总次数，IP所有值均为数字
# Parmas：访问日志
function source_ip_top100 {
    awk '{print "访问来源主机TOP 100IP和分别对对应出现的总次数：\n"}{if($1~/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/){print $1}}' $1 | sort | uniq -c | sort -nr | head -n 100
}

#function: 统计最频繁被访问的URL TOP 100
# Parmas: 访问日志
function Url_top_100 {
    awk '{print "统计最频繁被访问的URL TOP 100:\n"}{print $5 "\n\n"}' $1 |sort | uniq -c|sort -nr|head -n 100
}
# function: 统计不同响应状态码的出现次数和对应百分比
# Parmas: 访问日志
function static_respone {
    awk 'BEGIN{sum=0}{if(NR>1){a[$6]++};sum++}END{for(i in a){printf "%s: %d %.4f\n",i,a[i],a[i]*100/sum}}' $1
}
# function ：分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
# Parmas：日志文件
function static_4xx_top10 {
    awk '{print "403"}{if($6==403){print $5,"\n\n"}}' $1| sort | uniq -c| sort -nr|head -n 12
    awk '{print "404"}{if($6==404){print $5,"\n\n"}}' $1| sort | uniq -c| sort -nr|head -n 12
}
#function :输出给定URL访问Top100的来源主机
#Parmas：URL 日志文件
function static_resource {
    awk -v url=$2 '{if($5==url){print $1 "\n\n"}}' $1|sort|uniq -c|sort -nr|head -n 100
}
# function:帮助文档
function help {
        echo "PARAMETERS HELP INFO:"
        echo ":=======================================================================================:"
        echo "-n [filename]         统计访问来源主机TOP 100和分别对应出现的总次数"
        echo "-i [filename]         统计访问来源主机Top 100 IP和分别对应出现的总次数"
        echo "-u [filename]         统计最频繁被访问的URL TOP 100"
        echo "-r [filename]         统计不同响应状态码的出现次数和对应百分比"
        echo "-s [filename]         分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数"
        echo "-p [filename] [url]   输出给定URL访问Top100的来源主机"
        echo "-h                    帮助文档"
}

if [[ $# -lt 1 ]];then
    help
else 
    array=($@) #将所有参数放入到array数组中
    i=0
    while [[ $i -lt $# ]]
    do
        #echo "${array[$i]}"
        case ${array[$i]} in
            -n)
                source_host_top100 "${array[$i+1]}";;
            -i)
                source_ip_top100 "${array[$i+1]}";;
            -u)
                Url_top_100 "${array[$i+1]}";;
            -r)
                static_respone "${array[$i+1]}";;
            -s)
                static_4xx_top10 "${array[$i+1]}";;
            -p)
                static_resource "${array[$i+1]}" "${array[$i+2]}";;
            -h)
                help
        esac
        i=$((i+1))
    done
fi