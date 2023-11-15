### **Ansible-1: Installing Ansible & Basic Operations**

## Outline

- Part 1 - Install Ansible
- Part 2 - Ansible Ad-hoc Commands

## Part 1 - Install Ansible

- Spin-up 3 Amazon Linux 2 instances and name them as:

  1. master node
  2. node1 ----> (SSH PORT 22, HTTP PORT 80)
  3. node2 ----> (SSH PORT 22, HTTP PORT 80)

- Connect to the master node via SSH and run the following commands.

```bash
sudo yum update -y
sudo amazon-linux-extras install ansible2 -y
```

### Confirm Installation

- To confirm the successful installation of Ansible, run the following command.

```bash
ansible --version

ansible 2.9.23
```

### Ansible command options

```bash
-o, --one-line
condense output

-a <MODULE_ARGS>, --args <MODULE_ARGS>
The action’s options in space separated k=v format: -a ‘opt1=val1 opt2=val2’

-m <MODULE_NAME>, --module-name <MODULE_NAME>
Name of the action to execute (default=command)

--become-method <BECOME_METHOD>
privilege escalation method to use (default=sudo), use ansible-doc -t become -l to list valid choices.
```

### Configure Ansible on the Master Node

### Using Your Own Inventory

- Create a file named `inventory`.
- Edit the file as shown below:

```bash
$ vim inventory

[webservers]
node1 ansible_host=<node1_ip> ansible_user=ec2-user

[webservers:vars]
ansible_ssh_private_key_file=/home/ec2-user/<YOUR-PEM-FILE-NAME>.pem

```

---

- Actual file example, just remember EC2 instance IP address will change when restarted and to use this command in shell "export ANSIBLE_HOST_KEY_CHECKING=False" to avoid host key checking when trying to ssh/ping more than one host at a time.

---

````bash

```bash
[webservers]
node_amz1 ansible_host=13.40.106.75 ansible_user=ec2-user

[webservers]
node_ubuntu ansible_host=18.133.245.112 ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/cpdevopsew-eu-west-2.pem


````

- Test ping to only node1

```bash
ansible all -m ping  -i inventory
```

NOTE: Now, like this use `-i inventory` with every ansible command to tell the node about inventory, group etc.

### Understanding basics of inventory

- Explain what `ansible_host`, `ansible_user` and `ansible_ssh_key_file` parameters are. For this reason visit the Ansible's [inventory parameters web site](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#connecting-to-hosts-behavioral-inventory-parameters).
- Explain what an `alias` (node1 and node2) is and where we use it.
  It is useful to address one server and its values at once. For example `ansible node1 -m ping` it will access host IP and ping using key.
- Explain what `[webservers] and [all:vars]` expressions are. Elaborate the concepts of [group name](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#inventory-basics-formats-hosts-and-groups), [group variables](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#assigning-a-variable-to-many-machines-group-variables) and [default groups](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#default-groups).

#### Ansible groups

The headings in brackets are group names, which are used in classifying hosts and deciding what hosts you are controlling at what times and for what purpose.

```bash
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
three.example.com
```

Or in yaml

```yaml
all:
  hosts:
    mail.example.com:
  children:
    webservers:
      hosts:
        foo.example.com:
        bar.example.com:
    dbservers:
      hosts:
        one.example.com:
        two.example.com:
        three.example.com:
```

### Testing nodes

- To make sure that all our nodes are reachable, we will run various ad-hoc commands that use the ping module.

```
ansible all -m ping
ansible webservers -m ping
ansible node1 -m ping

# Check doc
ansible-doc ping

# single line output
ansible all -m ping -o

# removing warning
sudo vim /etc/ansible/ansible.cfg

```

Add the following lines to `/etc/ansible/ansible.cfg` file.

```
[defaults]
interpreter_python=auto_silent

```

### Hosts uptime

```
ansible webservers -a "uptime"
web_server1 | CHANGED | rc=0 >>
 13:00:59 up 42 min,  1 user,  load average: 0.08, 0.02, 0.01

```

### Running commands on hosts

```bash
ansible webservers -m shell -a "systemctl status sshd"

ansible webservers -m command -a 'df -h'

ansible webservers -a 'df -h'

vi testfile    # Create a text file name "testfile"
  "This is a test file."

ansible webservers -m copy -a "src=/home/ec2-user/testfile dest=/home/ec2-user/testfile"

# Verify if the file got copied in node1
$ ansible node1 -m shell -a "ls | cat *"

$ ansible node1 -m shell -a "echo Hello DevOps > /home/ec2-user/testfile2 ; cat testfile2"

```

### Using Shell

```bash

$ ansible webservers -b -m shell -a "yum -y update ; yum -y install nginx ; service nginx start; systemctl enable nginx"

# If the above command gives an error complaining about the existance of the package, try the command below.

ansible webservers -b -m shell -a "amazon-linux-extras install -y nginx1 ; systemctl start nginx ; systemctl enable nginx"

# Create one more ubuntu node to test. Uncomment the Node3 in CF and add Node3 in /etc/ansible/hosts
ansible node3 -b -m shell -a "apt update -y ; apt-get install -y nginx ; systemctl start nginx; systemctl enable nginx"

$ ansible webservers -b -m shell -a "yum -y remove nginx"

```

### Using Yum and Package Module

````bash
ansible-doc yum

# Bring back nginx
ansible webservers -b -m yum -a "name=nginx state=present"

# Start back nginx
$ ansible webservers -b -m shell -a "systemctl start nginx ; systemctl enable nginx"

# Remove nginx in node3
ansible node3 -b -m shell -a "apt-get remove nginx -y"

# difference of ```yum``` and ```package``` modules. Package automatically detects underlying OS and uses yum or apt.
$ ansible -b -m package -a "name=nginx state=present" all

````
