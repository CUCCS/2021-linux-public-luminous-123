#!/usr/bin/env bash
# function: 统计不同年龄区间的区间范围（20岁以下、20-30岁，30岁以上）的球员数量、百分比
# parmas：统计文件
function static_age {
    awk -F "\t" 'BEGIN{a=0;b=0;c=0;sum=-1}{sum++;if($6<20){a++}else if($6>=20&&$6<=30){b++}else{c++}}END{printf "age under 20 player number:%d\tpercentage: %.2f\nage between 20 to 30 player number:%d\tpercentage:%.2f\nage over 30 player number:%d\tpercentage:%.2f\n",a,a*100/sum,b,b*100/sum,c,c*100/sum}' $1
}

# function ：统计不同场上位置的球员数量百分比
# Parmas: 统计文件
function static_position {
    awk -F "\t" 'BEGIN{a=0;b=0;c=0;d=0;sum=-1}{sum++;if($5=="Goalie"){a++} else if($5=="Defender"){b++} else if($5=="Midfielder"){c++} else{d++}}END{printf "Goalie: %d %.2f\nDefender: %d %.2f\nMidfielder: %d %.2f\nForward: %d %.2f\n",a,a*100/sum,b,b*100/sum,c,c*100/sum,d,d*100/sum}' $1
}

# function: 统计名字最长的球员和名字最短的球员
# Parmas：统计文件
function static_name {
    awk -F "\t" 'BEGIN{max_length=0;max_nam="";min_length=100;min_name=""}{if(length($9)>max_length){max_length=length($9);max_name=$9} else if(length($9)<min_length){min_length=length($9);min_name=$9}}END{printf"The longest name: %s\nThe shortest name: %s\n",max_name,min_name}' $1
}

# function:统计年龄最大和最小的球员
# Parmas: 统计文件
function max_min_age {
    awk -F "\t" 'BEGIN{max=0;max_name="";min=100;min_name=""}{if(NR>=2&&$6<=min){min=$6;min_name=$9} else if(NR>=2&&$6>max){max=$6;max_name=$9}}END{printf "The oldest player:%s age: %d\nThe youngest player:%s age: %d\n",max_name,max,min_name,min}' $1
}

#function:帮助文档
function help {
        echo "PARAMETERS HELP INFO:"
        echo ":=======================================================================================:"
        echo "-a [filename]         统计不同年龄区间的区间范围（20岁以下、20-30岁，30岁以上）的球员数量、百分比"
        echo "-p [filename]         统计不同场上位置的球员数量、百分比"
        echo "-n [filename]         统计名字最长的球员和名字最短的球员(字符数统计)"
        echo "-m [filename]         统计年龄最大和最小的球员"
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
            -a) 
                    static_age "${array[$((i+1))]}";;
            -p)
                    static_position "${array[$((i+1))]}";;
            -n)
                    static_name "${array[$((i+1))]}";;
            -m)
                    max_min_age "${array[$((i+1))]}";;
            -h)
                    help
        esac
        i=$((i+1))
    done
fi