#! /bin/bash

#apt update
#安装NFS服务器
#apt install -y nfs-kernel-server

#if [[ $? -ne 0 ]];then
#	echo "failed to install nfs-kernel-server!"
#	exit
#fi
#创建文件系统
srv_pr="/var/nfs/gen_r" #只读文件夹
srv_prw="/var/nfs/gen_rw" #读写文件夹
srv_no_rsquash="/home/no_rsquash"
srv_rsquash="/home/rsquash" 


mkdir -p "$srv_pr"
chown nobody:nogroup "$srv_pr"

mkdir -p "$srv_prw"
chown nobody:nogroup "$srv_prw"

mkdir -p "$srv_no_rsquash"
mkdir -p "$srv_rsquash"

client_ip="192.168.56.114"
cl_prw_op="rw,sync,no_subtree_check" #rw读写访问
cl_pr_op="ro,sync,no_subtree_check" #只读访问
cl_prw_nors="rw,sync,no_subtree_check,no_root_squash"
cl_prw_rs="rw,sync,no_subtree_check"
conf="/etc/exports"


grep -q "$srv_pr" "$conf" && sed -i -e "#${srv_pr}#s#^[#]##g;#${srv_pr}#s#\ .*#${client_ip}($cl_pr_op)" "$conf" || echo "${srv_pr} ${client_ip}($cl_pr_op)" >> "$conf"

grep -q "$srv_prw" "$conf" && sed -i -e "#${srv_prw}#s#^[#]##g;#${srv_prw}#s#\ .*#${client_ip}($cl_prw_op)" "$conf" || echo "${srv_prw} ${client_ip}($cl_prw_op)" >> "$conf"

grep -q "$srv_no_rsquash" "$conf" && sed -i -e "#${srv_no_rsquash}#s#^[#]##g;#${srv_no_rsquash}#s#\ .*#${client_ip}  ($cl_prw_nors)" "$conf" || echo "${srv_no_rsquash} ${client_ip}($cl_prw_nors)" >> "$conf"

grep -q "$srv_rsquash" "$conf" && sed -i -e "#${srv_rsquash}#s#^[#]##g;#${srv_rsquash}#s#\ .*#${client_ip}  ($cl_prw_rs)" "$conf" || echo "${srv_rsquash} ${client_ip}($cl_prw_rs)" >> "$conf"

sed '$a{$srv_prw} {$client_ip}(rw,no_root_squash)' "$conf"

exportfs -v #查看当前活动的导出状态

systemctl restart nfs-kernel-server