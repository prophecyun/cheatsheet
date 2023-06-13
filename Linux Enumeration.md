System

    uname -a;
		cat /etc/*-release;
		dmesg | grep Linux to read kernel. Need sudo

Network	
 
    ifconfig -a
		netstat -antup
		cat /etc/resolv
		arp -a
	
Env

		set, env

Processes

		ps auxfww

Firewall

    iptables -l

Scheduled tasks

    crontab -l

Users

		cat /etc/passwd;
		cat /etc/shadow;
		ssh private keys in /etc/ssh
		history
		~/.bash_history
		to clear: cat /dev/null > ~/.bash_history
		
Logs

		/var/log/*
		/var/log/secure
    
Search 

    grep -R "flag" /etc/flag/

Enum4linux

		enum4linux -a <IP> //do all simple enum
