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
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[*]} \t\t�ɹ�\n" >>./shell_log
		fi
	else
		echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[*]} \t\tʧ��\n" >>./shell_log
		continue 
	fi
done
date_end=`date +"%T"`
	clear 
	echo -e "\e[34;1m===========================================================================================================================\e[;m"
	echo -e "\e[34;1m����IP			�˿�		����						״̬	\e[;m\n"
	cat ./shell_log
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
	echo -e "\e[34;1m ��ʼʱ�䣺$date_start \t\t\t ����ʱ�䣺$date_end  \t\t\t\t  \e[;m\n"
	echo -e "\e[34;1m ִ����������$shell_row \t\t\t �ɹ�������`cat ./shell_log |grep "�ɹ�" |wc -l`  \t\t\t ʧ��������`cat ./shell_log |grep "ʧ��" |wc -l`\t\t\t\e[;m\n"
	echo -e "\e[34;1m ʧ��������¼ ��\e[;m\n"
	cat ./shell_log |grep "ʧ��"
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
			echo -e "\e[34;1m$Ip_Addr\t\t �������....\e[;m\n"
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[1]}\t\t${comad[2]}\t\t\t\t�ɹ�\n" >>./shell_log
		fi
	else
			echo -e "\e[34;1m$Ip_Addr\t\t ����ʧ��....\e[;m\n"
			echo -e "$Ip_Addr\t\t$shell_port\t\t${comad[1]}\t\t${comad[2]}\t\t\t\tʧ��\n" >>./shell_log
			continue
	fi

done

	date_end=`date +"%T"`
	clear 
	echo -e "\e[34;1m===========================================================================================================================\e[;m"
	echo -e "\e[34;1m����IP			�˿�		����Դ			���䵽			״̬	\e[;m\n"
	cat ./shell_log
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
	echo -e "\e[34;1m ��ʼʱ�䣺$date_start \t\t\t ����ʱ�䣺$date_end  \t\t\t\t  \e[;m\n"
	echo -e "\e[34;1m ִ����������$shell_row \t\t\t �ɹ�������`cat ./shell_log |grep "�ɹ�" |wc -l`  \t\t\t ʧ��������`cat ./shell_log |grep "ʧ��" |wc -l`\t\t\t\e[;m\n"
	echo -e "\e[34;1m ʧ��������¼ ��\e[;m\n"
	cat ./shell_log |grep "ʧ��"
	echo -e "\e[34;1m===========================================================================================================================\e[;m\n"
}


function shell_meminfo(){

        echo -e "\e[34;1m===========================================================================================================================\e[;m"
        echo -e "\e[34;1m IP��ַ\t\t\t����\t\t��ʹ��\t\tʣ��\t\t����\t\t����\t\t����\t\t\n \e[;m"
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


#==============================================�����ַ�SSH��Կ������-��ʼ=======================================================================
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
#==============================================�����ַ�SSH��Կ������-����=======================================================================


function shell_add_ip(){

        [ -e $shell_list ] || touch $shell_list
        echo "${comad[1]}" >>$shell_list
        if [ $? -ne 0 ]
        then
                echo -e "\e[34;1m ���IP:${comad[1]}ʧ�� \e[;m\n\n"
		exit 1
	fi
}

function shell_show_ip(){

        [ -e $shell_list ] || touch $shell_list
	echo -e "\e[34;1m====================================================================\n\n\e[;m"
	echo -e "\e[34;1m`cat $shell_list` \n\n\e[;m"
	echo -e "\e[34;1m�ܼ�:`cat $shell_list |wc -l `\t\t\t �����б�:$shell_list\n\n\e[;m"
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
	echo -e "\e[34;1m ��ʼ���ɹ�... \e[m"
	
}

function shell_help(){

        echo -e "\e[34;1m====================================================================\n"

#        echo -e "ע:����Ҫ���߳�ִ��,��������for����¼���{} ��д�롡wait������֧�ֶ��̣߳��ӿ촫���ٶ�\n\n"

#	echo -e "\t\t\t[ʹ��ʱ��������/root/Ŀ¼�´���ip_list�ļ���д����Ҫ���Ƶ�����]\n\n"

        echo -e "\t-shell [��������]			����Զ��ִ������\n"
	
	echo -e "\t-init					��ʼ��\n"

        echo -e "\t-show					��ʾ�����б�\n"

        echo -e "\t-add					���һ������������\n"
        
	echo -e "\t-del					ɾ��һ������������\n"
	
	echo -e "\t-drop					���һ�������б�\n"

        echo -e "\t-keys					����������Կ��\n"

        echo -e "\t-scpkeys				�����ַ���Կ��\n"

        echo -e "\t-upload [�����ļ�]  [���䵽]		���������ļ�\n"

        echo -e "\t-mem					����ͳ�������ڴ�ʹ��\n"


        echo -e "====================================================================\n\n"
	echo -e " Powered by LyShark		������������Ȩ��\n"
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
