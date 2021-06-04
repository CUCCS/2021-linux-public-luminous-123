#!/usr/bin/env bash

#安装dhcp服务器
apt install -y isc-dhcp-server

if [[ $? -ne 0 ]];then
		echo "install isc-dhcp-server failed"
		exit
fi

conf="/etc/dhcp/dhcpd.conf"
conf_def="/etc/default/isc-dhcp-server"
conf_inter="/etc/netplan/01-netcfg.yaml"

if [[ ! -f "${conf}.bak" ]];then
		cp "$conf" "$conf".bak
else
		echo "${conf}.bak already exits!"
fi


min_time=600
max_time=7200
inter="enp0s9" #采用的接口
subnet="192.168.10.0"
netmask="255.255.255.0"
range_ip_l="192.168.10.20" #分配地址的范围
range_ip_r="192.168.10.200"

#修改配置文件/etc/dhcp/dhcpd.conf
cat<<EOT >>"$conf"
subnet 192.168.10.0 netmask 255.255.255.0 {
	# client's ip address range
	range ${range_ip_l} ${range_ip_r};
	default-lease-time ${min_time};
	max-lease-time ${max_time};
}
EOT

#修改配置文件/etc/netplan/01-netcfg.yaml
cat<<EOF > "$conf_inter"
network:
  ethernets:
    enp0s9:
      dhcp4:no
      addresses: [192.168.10.2/24]
  version: 2
EOF


#设置接口卡interfaces,在配置文件/etc/default/isc-dhcp-server中
sed -i -e "/INTERFACESv4=/s/^[#]//g;/INTERFACESv4=/s/\=.*/=\"${inter}\"/g" "$conf_def"

#重启服务
systemctl restart isc-dhcp-server

netplan apply