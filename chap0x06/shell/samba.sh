#! /bin/bash
#更新
apt-get update

# 安装samba
apt-get install samba* -y

conf="/etc/samba/smb.conf"
# 判断文件是否已有备份
if [[ ! -f "${conf}.bak" ]];then
		# 没有已存在的备份，创建备份
		cp "$conf" "$conf".bak
elsee
		echo "${conf}.bak already exits!"
fi

shareFolder="/home/shareFolder"
#创建samba的用户和用户组
useradd -M -s /sbin/nologin demoUser
groupadd demoGroup
usermod -a -G demoGroup demoUser
echo "demoUser:demo" | chpasswd

#设置samba登录用户（必须为已有账户）
(echo song123;echo song123) | smbpasswd -a song

#创建共享文件夹
mkdir -p "$shareFolder"
#对文件夹设置权限
chown -R demoUser:demoGroup "$shareFolder"
#追加配置文件
cat >>/etc/samba/smb.conf<<EOF
[sambashare]
   comment = Samba on Ubuntu
   path = /home/sharefolder
   read only = no #非只读
   Writable = yes #可以写入
   browsable = yes
   force user = demoUser
   force group = demoGroup
EOF
#重启
sudo service smbd restart
#设置防火墙过滤
sudo ufw allow samba




