#!/bin/bash

shell_user="root"
shell_pass="1233"
shell_port="22"
shell_list="/root/ip_list"
shell_row=`cat $shell_list |wc -l`

comad[0]=$1
comad[1]=$2
comad[2]=$3
comad[3]=$4
comad[4]=$5
comad[5]=$6
comad[6]=$7
comad[7]=$8
comad[8]=$9
comad[9]=${10}
comad[10]=${11}
comad[11]=${12}
comad[12]=${13}
comad[13]=${14}
comad[14]=${15}
comad[15]=${16}
comad[16]=${17}
comad[17]=${18}
comad[18]=${19}
comad[19]=${20}
comad[20]=${21}

function shell_exp(){

date_start=`date +"%T"`
rm -fr ./shell_log
for temp in `seq 1 $shell_row`
do
        Ip_Addr=`cat $shell_list |head -n $temp |tail -n 1`
	
	ping -c 1 $Ip_Addr &>/dev/null
	if [ $? -eq 0 ]
	then
		echo -e "\e[34;1m====================================================>$Ip_Addr<=======================================================\e[;m\n"
        	ssh -p $shell_port $shell_user@$Ip_Addr ${comad[*]}
		if [ $? -eq 0 ]
		then
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[*]} \t\t成功\n" >>./shell_log
		fi
	else
		echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[*]} \t\t失败\n" >>./shell_log
		continue 
	fi
done
date_end=`date +"%T"`
	clear 
	echo -e "\e[34;1m===========================================================================================================================\e[;m"
	echo -e "\e[34;1m主机IP			端口		命令						状态	\e[;m\n"
	cat ./shell_log
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
	echo -e "\e[34;1m 开始时间：$date_start \t\t\t 结束时间：$date_end  \t\t\t\t  \e[;m\n"
	echo -e "\e[34;1m 执行主机数：$shell_row \t\t\t 成功主机：`cat ./shell_log |grep "成功" |wc -l`  \t\t\t 失败主机：`cat ./shell_log |grep "失败" |wc -l`\t\t\t\e[;m\n"
	echo -e "\e[34;1m 失败主机记录 ↓\e[;m\n"
	cat ./shell_log |grep "失败"
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"

}

function shell_upload(){

date_start=`date +"%T"`
rm -fr ./shell_log

for temp in `seq 1 $shell_row`
do

        take_ip=`cat $shell_list |head -n $temp |tail -n 1`
        Ip_Addr="$take_ip"
	ping -c 1 $Ip_Addr &>/dev/null
	if [ $? -eq 0 ]
	then
		scp ${comad[1]} $shell_user@$Ip_Addr:${comad[2]} &>/dev/null
		if [ $? -eq 0 ]
		then
			echo -e "\e[34;1m$Ip_Addr\t\t 传输完成....\e[;m\n"
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[1]}\t\t${comad[2]}\t\t\t\t成功\n" >>./shell_log
		fi
	else
			echo -e "\e[34;1m$Ip_Addr\t\t 传输失败....\e[;m\n"
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[1]}\t\t${comad[2]}\t\t\t\t失败\n" >>./shell_log
			continue
	fi

done

	date_end=`date +"%T"`
	clear 
	echo -e "\e[34;1m===========================================================================================================================\e[;m"
	echo -e "\e[34;1m主机IP			端口		传输源			传输到			状态	\e[;m\n"
	cat ./shell_log
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
	echo -e "\e[34;1m 开始时间：$date_start \t\t\t 结束时间：$date_end  \t\t\t\t  \e[;m\n"
	echo -e "\e[34;1m 执行主机数：$shell_row \t\t\t 成功主机：`cat ./shell_log |grep "成功" |wc -l`  \t\t\t 失败主机：`cat ./shell_log |grep "失败" |wc -l`\t\t\t\e[;m\n"
	echo -e "\e[34;1m 失败主机记录 ↓\e[;m\n"
	cat ./shell_log |grep "失败"
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
}


function shell_meminfo(){

        echo -e "\e[34;1m===========================================================================================================================\e[;m"
        echo -e "\e[34;1m IP地址\t\t\t总量\t\t已使用\t\t剩余\t\t共享\t\t缓冲\t\t缓存\t\t\n \e[;m"
for temp in `seq 1 $shell_row`
do
        take_ip=`cat $shell_list |head -n $temp |tail -n 1`
        Ip_Addr="$take_ip"
        echo -ne "\e[34;1m $take_ip\t\t \e[;m"
#       sleep 0.5
        ping -c 1 $Ip_Addr &>/dev/null
        if [ $? -eq 0 ]
        then
                ssh $shell_user@$take_ip free -h |grep "Mem:" |awk '{print $2 "\t\t" $3 "\t\t" $4 "\t\t" $5 "\t\t" $6 "\t\t" $7}'
        else
                echo -e "0M\t\t0M\t\t0M\t\t0M\t\t0M\t\t0M"
        fi
done
        echo -e "\e[34;1m===========================================================================================================================\e[;m"

}


#==============================================批量分发SSH密钥函数体-开始=======================================================================
function shell_ssh_keygen(){
      /usr/bin/expect << EOF
set timeout 5
spawn ssh-keygen -t rsa
expect {
"*save the key*" {send "\n";exp_continue}
"Enter passphrase*" {send "\n";exp_continue}
"*passphrase again:" {send "\n"}
}
expect eof
EOF
}

function shell_push_sshkey(){
local ssh_user=$1
local ssh_host=$2
local ssh_pass=$3
/usr/bin/expect << EOF
set timeout 10
spawn ssh-copy-id $ssh_user@$ssh_host
expect {
"(yes/no)" {send "yes\n"; exp_continue}
"password:" {send "$ssh_pass\n"}
"id_rsa.pub" {puts "(^_^)\n";exit 2\n}
}
expect eof 
EOF
}



function shell_expect(){

for temp in `seq 1 $shell_row`
do
        Ip_Addr=`cat $shell_list |head -n $temp |tail -n 1`
        shell_push_sshkey $shell_user $Ip_Addr $shell_pass
done
}
#==============================================批量分发SSH密钥函数体-结束=======================================================================


function shell_add_ip(){

        [ -e $shell_list ] || touch $shell_list
        echo "${comad[1]}" >>$shell_list
        if [ $? -ne 0 ]
        then
                echo -e "\e[34;1m 添加IP:${comad[1]}失败 \e[;m\n\n"
		exit 1
	fi
}

function shell_show_ip(){

        [ -e $shell_list ] || touch $shell_list
	echo -e "\e[34;1m====================================================================\n\n\e[;m"
	echo -e "\e[34;1m`cat $shell_list` \n\n\e[;m"
	echo -e "\e[34;1m总计:`cat $shell_list |wc -l `\t\t\t 操作列表:$shell_list\n\n\e[;m"
	echo -e "\e[34;1m====================================================================\n\n\e[;m"
}


function shell_drop_ip(){
	
#sed -i '/echo "${comad[1]}"/d' $shell_list
#	for i in `seq 1 $shell_row`
#	do
#		Ip_Addr=`cat $shell_list |head -n $temp |tail -n 1`
#		if [ "$Ip_Addr" == "$del_ip" ]
#		then
#	donei
#	cat $shell_list |grep -v ${comad[1]}  >/root/ip_list.tmp
#	rm -fr /root/ip_list
#	mv /root/ip_list.tmp /root/ip_list

	rm -fr $shell_list
	touch $shell_list

}


function shell_init(){

	touch $shell_list
	yum install -y expect
	[ $? -eq 0 ]
	echo -e "\e[34;1m 初始化成功... \e[m"
	
}

function shell_help(){

        echo -e "\e[34;1m====================================================================\n"

#        echo -e "注:如需要多线程执行,请自行在for语句下加入{} 并写入　wait　即可支持多线程，加快传输速度\n\n"

#	echo -e "\t\t\t[使用时请自行在/root/目录下创建ip_list文件并写入你要控制的主机]\n\n"

        echo -e "\t-shell [任意命令]			批量远程执行命令\n"
	
	echo -e "\t-init					初始化\n"

        echo -e "\t-show					显示控制列表\n"

        echo -e "\t-add					添加一个被管理主机\n"
        
	echo -e "\t-del					删除一个被管理主机\n"
	
	echo -e "\t-drop					清空一个主机列表\n"

        echo -e "\t-keys					本地生成密钥对\n"

        echo -e "\t-scpkeys				批量分发密钥对\n"

        echo -e "\t-upload [本地文件]  [传输到]		批量传输文件\n"

        echo -e "\t-mem					批量统计主机内存使用\n"


        echo -e "====================================================================\n\n"
	echo -e " Powered by LyShark		瑞王保留所有权利\n"
        echo -e "====================================================================\e[;m"


}





case ${comad[0]} in

	"")
		shell_help
		exit 1
		;;
	"-upload")	
		shell_upload
		exit 1
		;;
	"-mem")
		shell_meminfo
		exit 1
		;;
	"-keys")
		shell_ssh_keygen
		exit 1
		;;
	"-scpkeys")
		shell_expect
		exit 1
		;;
	"-add")
		shell_add_ip
		exit 1
		;;
	"-show")
		shell_show_ip
		exit 1
		;;
	"-drop")
		shell_drop_ip
		exit 1
		;;
	"-init")
		shell_init
		exit 1
		;;
	*)	shell_exp
		exit 1
		;;

esac
