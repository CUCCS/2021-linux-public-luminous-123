#!/usr/bin/env bash

# function1: jpeg格式图片进行图片质量压缩
# Parma：改变图片质量的参数
function image_quality_compress {
    for img in $(ls *.jpeg); do
        convert "$img" -quality "$1" "$img"
        echo "$img is successfully compressed of quality $1"
    done
}
# function : 对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
# Parma: 调整参数
function image_size_compress {
    for img in $(ls *.jpeg *.png *.svg); do
        convert "$img" -resize "$1" "$img"
        echo "$img resize $1 successfully"
    done 
}
# function: 对图片批量添加自定义文本水印
# Parma：自定义文本
function add_watermark {
    for img in $(ls); do
        mogrify -pointsize 16 -fill black -weight bolder -gravity southeast -annotate +5+5 "$1" $img
        echo "$img successfully add watermark"
    done
}
# function: 批量添加文件名前缀
# Parma：添加的前缀
function add_prefix {
    for img in $(ls); do
        mv $img $1$img
        echo "$img add perfix"
    done
}
# function: 批量添加文件后缀
# Parma：添加的后缀
function add_suffix {
    for img in $(ls);do
        mv $img $img$1
        echo "$img add suffix"
    done
}
# function:将png/svg图片统一转换为jpg格式图片
function transform_to_jpg {
    for img in $(ls *.png *.svg); do
        convert $img $(img%.*).jpg
        echo "convert $img to jpg"
    done
}
# 帮助文档
function help {
        echo "PARAMETERS HELP INFO:"
        echo ":=======================================================================================:"
        echo "[image dir] -q [quality_args]                 对jpeg格式图片进行图片质量压缩"
        echo "[image dir] -r [resolution_args]              对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率"
        echo "[image dir] -m [watermark_text]               批量添加自定义文本水印"
        echo "[image dir] -p [prefix_info]          统一添加文件名前缀"
        echo "[image dir] -s [suffix__info]         统一添加文件名后缀"
        echo "[image dir] -t                     将png/svg图片统一转换为jpg格式图片"
        echo "-h                                帮助文档"
}
# 主函数
if [[ $# -lt 1 ]]; then
    help # 输入参数小于一个自动输出帮助文档
else
    array=($@) #将所有参数放入到array数组中
    i=1
    echo $#
    if [[ ${array[0]}==$1&&${array[0]}!="-h" ]];then # 如果第一个参数为路径，则进入
        cd $1 || exit 1
    fi
    while [[ $i -lt $# ]]
    do
        echo "${array[$i]}"
        if [[ ${array[$i]} == $1 ]];then
            i=$((i+1)) # 如果后面有参数与第一个路径参数相同，则令i+1，但不重复进入，避免错误
            continue
        else
            case ${array[$i]} in
                -q) 
                    image_quality_compress "${array[$((i+1))]}";;
                -r)
                    image_size_compress "${array[$((i+1))]}";;
                -m)
                    add_watermark "${array[$((i+1))]}";;
                -p)
                    add_prefix "${array[$((i+1))]}";;
                -s)
                    add_suffix "${array[$((i+1))]}";;
                -t)
                    transform_to_jpg;;
            esac
        fi
        i=$((i+1))
    done
fi
