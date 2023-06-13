System
		systeminfo
		wmic bios get biosversion
		set for env settings
		ipconfig

Processes
		tasklist
		wmic process where processid=x
		wmic process get caption,commandline /format:list | findstr powershell.exe
		tasklist /m <x.dll>
		*might want to see dlls loaded by processes
		
Services
		net start to list running services
		sc qc <service name> to get binary path and name, display name
		
Network
		netstat -anob
		arp
		
Firewall
		netsh advfirewall firewall show allprofiles
		netsh advfirewall firewall show rule name=all profile=domain
		Show enabled rules (PS):
		netsh advfirewall firewall show rule name=all profile=any | select-string -pattern "Yes" -exclude "Edge traversal" -context 2,11
		
Registry
		reg query
		User SID (logged in only) Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\
		or use wmic useraccount get name,sid
		wmic where name="xx" get sid
	
Event logs
		wevtutil
		wevtutil qe Security "/q:*[System [(EventID=4624)]]" /c:10 /f:text 
		wevtutil qe Security "/q:*[System [(EventID=4624)] and EventData[Data[@Name='TargetUserName']='ralph']]" /f:text /c:5
		User creation logs = ID 4720
		
Scheduled tasks
		schtasks
	
AV
		use tasklist to find processes
		find directories related to AVs
		powershell "gwmi -namespace 'root\securitycenter2' -class antivirusproduct"
		wmic /namespace:\\root\securitycenter2 path antivirusproduct
	
Shares
		net use \\192.168.11.46\c$ /u:monty "IT&burns " to mount share as admin user monty
			To do this on non-domain machine requires registry
			reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f
		net use H: \\127.0.0.1\Users\Todd\Appdata\hmmm to mount drive. 
			If drive letter is included, will appear on computer.
		net use <remote path> /delete to delete
		wmic share

User
		whoami /all		
		query user (win server only)
		net user [/domain]
		net group 
		net group "domain admins" on DC
		net localgroup Administrators
		reg query hku
			HKEY_USERS contains all actively loaded user profiles
		wmic netlogin
		wmic netlogin list full /format:list to see user account last login, passwd age, expiry
		dir /a/s c:\$Recycle.bin
			dir \\192.168.11.46\c$\$Recycle.bin /a/s 
		PS gwmi win32_useraccount 
		get-acl 

User Activity
	Hashdumping and mimikatz require admin access (high integrity or SYSTEM)
	Keylogging must be done in the target users session. 
	If u have system, u can reach any user session and see filesystem

Dumping password and hashes
		Memory dump: procdump.exe
		Backup stuff: ntdsutil.exe, vssadmin.exe (volume shadow copy)
			ntdsutil
			snapshot
			activate instance ntds
		
		Plaintext password will appear when 2 conditions
		1. user logged in and creds in memory
		2. windows cred guard not active
	
	Check if Windows CredentialGuard is running
	powershell iex "(get-ciminstance -classname Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard).SecurityServicesRunning"


Search

	find "flag" c:\users\mrpeanutbutter\desktop\*.txt	
	findstr /c:"hello there" /s /m /i *.*
	findstr /c:"flag" /s /m /i *.txt

Remote enum

	Look for DC in internal network
		Use portscan/tcp
		set ports 53,88,139,135,389,445,464
		
	NBTSCAN (Mostly Win, or linux with samba)
		Get NetBIOS name, MAC Add
		nbtscan 10.200.1.28


SMB
		Listing shares	

		smbmap -H <IP> -P <PORT> //null user
		smbmap -u 'training28' -p 'password' -H 10.200.1.28 
			-R to recursive list
	
		crackmapexec smb 10.200.1.28 -u 'user' -p 'password' --shares
			
		smbclient -L 10.200.1.28 --no-pass
		
			Sharename       Type      Comment
			---------       ----      -------
			ADMIN$          Disk      Remote Admin
			C$              Disk      Default share
			IPC$            IPC       Remote IPC
			test            Disk      
		
		Connect to share via smb
		smbclient \\\\10.200.1.28\\test will enter smb> 
		OR smbclient //10.200.1.28/test 
			Note: need extra \ to escape \ 

		nmap --script smb-os-discovery.nse -p445 10.200.1.28 

RPC (Windows)
		Can try --user='' --no-pass <target>
		rpcclient --user='training28' 10.200.1.28 
		srvinfo
		other commands useful for domain enum
 	
Search for nmap script
		locate -r nse$ | grep telnet


