#~ #!/bin/bash
##get user to specify nipe file location as part of first argument
nipe_folder="$1"



#check nipe location and run nipe
function check_nipe(){
	
if [ ! -d "$nipe_folder" ]; 
then
    echo "Error: nipe folder not found at '$nipe_folder'"
exit
else

	sudo perl nipe.pl start 
	echo "nipe found in folder, loading nipe"

fi

	sleep 1 

}

check_nipe


#~ #check if nipe is connected to TOR
function check_status() {
    status=$(sudo perl nipe.pl status)
    sleep 4s
if echo "$status" | grep -q "true"; 
then
        echo "Connected to TOR."
else
        echo "NOT connected to TOR."
        sudo perl nipe.pl restart
        sleep 4
        sudo perl nipe.pl status
fi
}
check_status

#~ #perform whois on the IP address that is returned by nipe
function check_spoofed_country() {
	
	spoofed_IP=$(sudo perl nipe.pl status | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | awk -F: '{print $2}')
	echo "and your spoofed IP address is $spoofed_IP"
	sleep 2
	spoof_country=$(whois "$spoofed_IP" | grep -i country)
	sleep 2
    echo "and your country is $spoof_country"
	
	
	}
	
check_spoofed_country

#collect more information on remote server to launch the scan from, and automatically launch nmap scan
echo "Please key in the IP address of your ubuntu remote server"
read IP_for_remote_server

#~ nmap $IP_for_remote_server -F -Pn

#~ store domain name that we want to search into a variable 
echo "Type in the domain which you like to perform Whois on:"
read domain_name


function ssh_remote_server_details_whois(){
	
	sshpass -p tc ssh tc@$IP_for_remote_server "whois $domain_name >> audit.txt "
	
	
	}
ssh_remote_server_details_whois



function ssh_remote_server_details_uptime(){
	
	sshpass -p tc ssh tc@$IP_for_remote_server "uptime -p >> audit.txt "
	
	
	}
ssh_remote_server_details_uptime



function ssh_remote_server_details_ipadd(){
	
	sshpass -p tc ssh tc@$IP_for_remote_server "ifconfig | grep -i broadcast | grep inet | awk '{print $2}' >> audit.txt"
	
	
	}
ssh_remote_server_details_ipadd 



function ssh_remote_server_details_ipinfo(){
	
	sshpass -p tc ssh tc@$IP_for_remote_server "whois $IP_for_remote_server | grep -i country >> audit.txt"
	
	
	}
ssh_remote_server_details_ipinfo




function ftp_auditfile_from_remote_server(){
	echo "Type FTP username"
	read ftpusername
	echo "Type FTP password"
	read ftppassword
	wget ftp://$ftpusername:$ftppassword@$IP_for_remote_server/audit.txt
	
}

ftp_auditfile_from_remote_server



#~ function ssh_remote_server_details() {
	#~ echo "Type in remote server password"
	#~ read remote_server_pw
	
    #~ sshpass -p "$remote_server_pw" ssh -T -o  StrictHostKeyChecking=no tc@"$IP_for_remote_server" << EOF
        #~ how_long_up="This is the uptime value: \$(uptime -p)"
        #~ ip_add="This is the remote server's IP address: \$(ifconfig | grep -i broadcast | grep inet | awk '{print \$2}')"
        #~ ip_info="This is the remote server's country: \$(whois $IP_for_remote_server | grep -i country)"
        
       
    
        #~ echo \$how_long_up >> audit.txt
        #~ echo \$ip_add >> audit.txt
        #~ echo \$ip_info >> audit.txt
    
       
#~ EOF
#~ }

#~ ssh_remote_server_details







#~ use another bash script to maintain persistence and perform commands on remote server
#~ function ssh_remote_server_details(){
	
	#~ ssh -T tc@$IP_for_remote_server 'bash -s' < run.sh $domain_name $IP_for_remote_server
	
	#~ }
#~ ssh_remote_server_details




















#~ function ssh_remote_server_details() {
	#~ echo "Type in remote server password"
	#~ read remote_server_pw
	
    #~ sshpass -p "$remote_server_pw" ssh -T -o  StrictHostKeyChecking=no tc@"$IP_for_remote_server" << EOF
        #~ how_long_up="This is the uptime value: \$(uptime -p)"
        #~ ip_add="This is the remote server's IP address: \$(ifconfig | grep -i broadcast | grep inet | awk '{print \$2}')"
        #~ ip_info="This is the remote server's country: \$(whois $IP_for_remote_server | grep -i country)"
        
       
    
        #~ echo \$how_long_up >> audit.txt
        #~ echo \$ip_add >> audit.txt
        #~ echo \$ip_info >> audit.txt
    
       
#~ EOF
#~ }

#~ ssh_remote_server_details






#~ function ssh_whois() {
	
	
    #~ sshpass -p "$remote_server_pw" ssh -T -o  StrictHostKeyChecking=no tc@"$IP_for_remote_server" << EOF
    #~ echo "Type in the domain which you like to perform Whois on:"
	#~ read domain_name 
        
    #~ target_domain="The following is the whois data for $domain_name: "
    
 
    
    #~ sleep 1
    #~ echo $target_domain >> audit.txt
#~ EOF
#~ }

#~ ssh_whois

#~ # use ftp protocol to get audit.txt file from remote server














