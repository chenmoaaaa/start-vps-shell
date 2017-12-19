#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Version: 8.3.5
#	Blog: blog.lvcshu.club
#	Author: johnpoint
#=================================================

sh_ver="8.3.5"
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"
check_root(){
	[[ $EUID != 0 ]] && echo -e "${Error} 当前账号非ROOT(或没有ROOT权限)，无法继续操作，请使用${Green_background_prefix} sudo su ${Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。" && exit 1
}
#check OS
if [ -f /etc/redhat-release ]; then
    release="centos"
    PM='yum'
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    PM='apt-get'
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    PM='yum'
fi

Update_shell

#check_bbr
check_bbr_status_on=`sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}'`
	if [[ "${check_bbr_status_on}" = "bbr" ]]; then
		# 检查是否启动BBR
		  check_bbr_status_off=`lsmod | grep bbr`
		  if [[ "${check_bbr_status_off}" = "" ]]; then
			  bbr="BBR 已开启但未正常启动"
		  else
			  bbr="BBR 已开启并已正常启动"
		  fi
		else
		   bbr="BBR 未安装"
	fi

#check_IP_address
check_IP_address(){
curl http://members.3322.org/dyndns/getip 
}

get_opsy() {
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
ip=$(check_IP_address)

#Install_screen
 Install_screen(){
 echo -e "${Info} 正在安装screen..."
 ${PM} update
 ${PM} install screen -y
 echo -e "${Tip} 安装完成！"
 }
#Install_lrzsz
 Install_lrzsz(){
 echo -e "${Info} 正在安装lrzsz..."
 ${PM} update
 ${PM} install lrzsz -y
 echo -e "${Tip} 安装完成！"
 }
 #Install_git
 Install_git(){
 echo -e "${Info} 正在安装git..."
 ${PM} update
 ${PM} install git -y
 echo -e "${Tip} 安装完成！"
 }
 #Install_ssr
 Install_ssr(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh && chmod +x ssrmu.sh && bash ssrmu.sh
 }

 #Install_status
 Install_status(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/status.sh && chmod +x status.sh
 bash status.sh s
 }
 
 #Install_sync
 Install_sync(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/sync.sh && chmod +x sync.sh && ./sync.sh
 }
 
 #Install_ytb_dl
 Install_ytb_dl(){
 cd ~
 wget https://yt-dl.org/downloads/2017.10.01/youtube-dl -O /usr/local/bin/youtube-dl
 chmod a+rx /usr/local/bin/youtube-dl
 youtube-dl -U
 echo && stty erase '^H' && read -p "请输入保存路径：" save
 cd $save
 echo && stty erase '^H' && read -p "请输入视频地址：" address
 youtube-dl $address
 }
 
 #Install_EFB
 Install_EFB(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/EFB.sh && chmod +x EFB.sh && ./EFB.sh
 }
 
 #Install_wordpress
 Install_wordpress(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/wordpress.sh && chmod +x wordpress.sh && ./wordpress.sh
 }
 
 #Install_GoFlyway
 Install_GoFlyway(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/goflyway.sh && chmod +x goflyway.sh && bash goflyway.sh
 }
 
 #Install_ExpressBot
 Install_ExpressBot(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/BennyThink/ExpressBot/master/install.sh && chmod +x install.sh && ./install.sh
 }
 
 #Install_bbr
 Install_bbr(){
 echo && echo -e "  安装bbr需要更换内核，可能会造成vps启动失败，请勿在生产环境中使用！
 " && echo
 stty erase '^H' && read -p "是否继续？（Y/N）（默认：取消）" YON
 [[ -z "${install_num}" ]] && echo "已取消..." && exit 1
	if [[ ${YON} == "Y" ]]; then
		 wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
	elif [[ ${YON} == "N" ]]; then
		exit 1
		else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi
 }
 
 #Install_something
Install_something(){
echo && echo -e "  你要做什么？

  ${Green_font_prefix}1.${Font_color_suffix} 安装 screen
  ${Green_font_prefix}2.${Font_color_suffix} 安装 lrzsz
  ${Green_font_prefix}3.${Font_color_suffix} 安装 git
  ————————————————
  ${Green_font_prefix}A.${Font_color_suffix} 以上全部安装
  ————————————————
  ${Green_font_prefix}4.${Font_color_suffix} 安装/管理 ssr
  ${Green_font_prefix}5.${Font_color_suffix} 安装/管理 逗逼监控
  ${Green_font_prefix}6.${Font_color_suffix} ~ 【 暂时不能安装 V2ray 】 ~
  ${Green_font_prefix}7.${Font_color_suffix} 安装 Sync
  ${Green_font_prefix}8.${Font_color_suffix} 安装/使用 youtube-dl
  ${Green_font_prefix}9.${Font_color_suffix} 安装微信互联系统（限Ubuntu）
  ${Green_font_prefix}10.${Font_color_suffix} 安装 wordpress博客
  ${Green_font_prefix}11.${Font_color_suffix} 安装/管理 GoFlyway
  ${Green_font_prefix}12.${Font_color_suffix} 安装/管理 ExpressBot
  ${Green_font_prefix}13.${Font_color_suffix} 安装 bbr (慎重)
  ————————————————" && echo
	stty erase '^H' && read -p "(默认: 取消):" install_num
	[[ -z "${install_num}" ]] && echo "已取消..." && exit 1
	if [[ ${install_num} == "1" ]]; then
		Install_screen
	elif [[ ${install_num} == "2" ]]; then
		Install_lrzsz
	elif [[ ${install_num} == "3" ]]; then
		Install_git
	elif [[ ${install_num} == "4" ]]; then
		Install_ssr
	elif [[ ${install_num} == "5" ]]; then
		Install_status
	elif [[ ${install_num} == "6" ]]; then
		Install_v2ray
	elif [[ ${install_num} == "7" ]]; then
		Install_sync
	elif [[ ${install_num} == "8" ]]; then
		Install_ytb_dl
	elif [[ ${install_num} == "9" ]]; then
		Install_EFB
	elif [[ ${install_num} == "10" ]]; then
		Install_wordpress
	elif [[ ${install_num} == "11" ]]; then
		Install_GoFlyway
	elif [[ ${install_num} == "A" ]]; then
		Install_screen
		Install_lrzsz
		Install_git
	elif [[ ${install_num} == "12" ]]; then
	Install_ExpressBot
	elif [[ ${install_num} == "13" ]]; then
	Install_bbr
	else
		echo -e "${Error} 请输入正确的选项" && exit 1
	fi
}

#CG_passwd
CG_passwd(){
passwd
}

#Bash_bench
Bash_bench(){
 wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/shell/superbench.sh && chmod +x superbench.sh && ./superbench.sh
 rm -rf superbench.sh
 echo -e "${Info} done"
}

#install openssl
 Install_openssl(){
 echo -e "${Info} 正在安装openssl..."
 ${PM} update
 ${PM} install openssl -y
 echo -e "${Tip} 安装完成！"
 }
 
 #Generate_key
 Generate_key(){
 echo -e "${Info} 正在生成key..."
 ssh-keygen
 echo -e "${Info} 生成成功，保存于 /root/.ssh"
 cd .ssh
 mv id_rsa.pub authorized_keys
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }
 
 #modify_sshd_config
 modify_sshd_config(){
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 echo '警告！此步骤如果出现异常请在 /root/sshd_config 目录处使用 mv 指令恢复配置文件'
 mkdir ~/sshd_config
 cp /etc/ssh/sshd_config /root/sshd_config
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 echo '请寻找RSAAuthentication yes PubkeyAuthentication yes 如不为yes 则改为yes'
 vi /etc/ssh/sshd_config
 echo '正在重启ssh服务'
 echo '请使用key登陆测试是否成功'
 }
 
 #Download_key
 Download_key(){
 cd ~/.ssh
 cat id_rsa
 echo '把屏幕上面的密匙复制出来写入文件内，文件取名为 id_rsa （这个名称随意，但这个密匙文件一定要保存好！）。'
 }
 
 #Upload_key
 Upload_key(){
 mkdir ~/.ssh
 Install_lrzsz
 cd ~/.ssh
 rz -y
 ls -a
 chmod 600 authorized_keys
 chmod 700 ~/.ssh
 }
 
 #restart_sshd
 restart_sshd(){
 echo '正在重启ssh服务'
 service ssh restart
 service sshd restart
 }
 
 #close_passwd
 close_passwd(){
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 echo '将PasswordAuthentication 改为no 并去掉#号'
 vi /etc/ssh/sshd_config
 echo '记得重启'
 }
 
#Login_key
Login_key(){
echo && echo -e "  你要做什么？

  ${Green_font_prefix}1.${Font_color_suffix} 安装 openssl
  ${Green_font_prefix}2.${Font_color_suffix} 生成 key
  ${Green_font_prefix}3.${Font_color_suffix} 取回 私钥
  ${Green_font_prefix}4.${Font_color_suffix} 上传 key（多服务端单key选此项）
  ${Green_font_prefix}5.${Font_color_suffix} 修改 sshd_config文件
  ${Green_font_prefix}6.${Font_color_suffix} 重启 ssh服务
  ${Green_font_prefix}7.${Font_color_suffix} 关闭 密码登陆
  ——" && echo
	stty erase '^H' && read -p "(默认: 取消):" Login_key_num
	[[ -z "${Login_key_num}" ]] && echo "已取消..." && exit 1
	if [[ ${Login_key_num} == "1" ]]; then
		Install_openssl
	elif [[ ${Login_key_num} == "2" ]]; then
		Generate_key
	elif [[ ${Login_key_num} == "3" ]]; then
		Download_key
	elif [[ ${Login_key_num} == "4" ]]; then
		Upload_key
	elif [[ ${Login_key_num} == "5" ]]; then
		modify_sshd_config
	elif [[ ${Login_key_num} == "6" ]]; then
		restart_sshd
	elif [[ ${Login_key_num} == "7" ]]; then
		close_passwd
	else
		echo -e "${Error} 请输入正确的数字 [1-7]" && exit 1
	fi
}

#look ssh log
Look_sshlog(){
cat /var/log/secure
}

#Update_shell
Update_shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="yun"
	[[ -z ${sh_new_ver} ]] && sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1) && sh_new_type="github"
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		stty erase '^H' && read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			cd "${file}"
			if [[ $sh_new_type == "yun" ]]; then
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			else
				wget -N --no-check-certificate https://raw.githubusercontent.com/johnpoint/start-vps-shell/master/start.sh && chmod +x start.sh
			fi
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
			chmod +x start.sh
			./start.sh
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
	fi
	exit 0
}

	echo -e "  VPS一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  ---- johnpoint ----
  
  =============== System Information ===================
  =${Green_font_prefix}IP${Font_color_suffix} :  $ip
  =${Green_font_prefix}OS${Font_color_suffix} : $opsy
  =${Green_font_prefix}Arch${Font_color_suffix} : $arch ($lbit Bit)
  =${Green_font_prefix}Kernel${Font_color_suffix} : $kern
  =${Green_font_prefix}BBR${Font_color_suffix} : $bbr
  =============== System Information ===================
  ${Green_font_prefix}1.${Font_color_suffix} 安装 软件
  ${Green_font_prefix}2.${Font_color_suffix} 修改 密码
  ${Green_font_prefix}3.${Font_color_suffix} 查看 vps详细参数
  ${Green_font_prefix}4.${Font_color_suffix} 更改 系统为密钥登陆
  ${Green_font_prefix}5.${Font_color_suffix} 查看 SSH登录日志
  ——————————————————————
  ${Green_font_prefix}0.${Font_color_suffix} 更新 脚本
 "
	echo && stty erase '^H' && read -p "请输入数字 [1-15]：" num
case "$num" in
	1)
	Install_something
	;;
	2)
	CG_passwd
	;;
	3)
	Bash_bench
	;;
	4)
	Login_key
	;;
	5)
	Look_sshlog
	;;
    0)
	Update_shell
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-15]"
	;;
esac
fi

