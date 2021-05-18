#general linux commands

su root
sudo systemctl status #get a list of all services
sudo systemctl enable [service name]#enable a service

#usersetup https://www.cyberciti.biz/faq/add-create-a-sudo-user-on-centos-linux-8/
adduser -G wheel wendy #create new user called marlena add to wheel group
passwd marlena #set pw
id marlena #check user account
sudo -i # test sudo


#OS version and software updates
lsb_release -d #check OS version
sudo yum check-update #check for software updates #check for software updates
sudo yum update -y #update all packages

#networking
hostnamectl #check hostname
hostnamectl set-hostname my.new-hostname.server #set system hostname
sudo vim /etc/hosts
ip a | grep ens #get the interface identifier usually ens192
sudo nmcli connection modify ens192 Ipv4.address 10.2.6.204/24 #change IP
sudo nmcli connection modify ens192 IPv4.gateway 192.168.122.1 #set interface gateway
sudo nmcli connection modify ens192 IPv4.dns 192.168.122.1 #set interface DNS
sudo nmcli connection modify ens192 IPv4.method manual #remove dhcp
vi /etc/resolv.conf #dns

#firewall
#https://linuxconfig.org/redhat-8-open-and-close-ports
firewall-cmd --zone=public --permanent --add-port 8080/tcp #allow 8080
firewall-cmd --reload #reload firewall
firewall-cmd --list-all #check firewall

#ssh

mkdir -p ~/.ssh  #https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-centos-8
touch ~/.ssh/authorized_keys
chmod -R go= ~/.ssh
vi ~/.ssh/authorized_keys
eval `ssh-agent` #start ssh agent
ssh-add ~/.ssh/id_rsa_ergadmin #add ssh key to agent 
# add below script to : .bash_profile
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
ssh-add ~/.ssh/id_rsa_ergadmin

#nfs https://www.linuxtechi.com/setup-nfs-server-on-centos-8-rhel-8/
#https://linuxize.com/post/how-to-mount-an-nfs-share-in-linux/

sudo dnf install nfs-utils nfs4-acl-tools -y #install nfs utils
sudo mkdir /mnt/client_share #make mount folder on file system
sudo mount -t nfs 192.168.2.102:/mnt/nfs_shares/docs /mnt/client_share#mount nfs share
df -h #view mounts
/etc/fstab #file that is read for mounts on boot
