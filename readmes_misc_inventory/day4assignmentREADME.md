# Assignment

## Overview

### Introduction

You have learnt that Ansible helps to automate tasks and manage large numbers of servers efficiently. In this assignment you will test your knowledge on how to create an inventory file and use various Ansible commands to manage web servers.

### Task

In this assignment, you are given a list of two web servers, along with their usernames and passwords. You need to write an inventory file and use various Ansible commands to perform tasks on these servers.

## Checkpoints

1. Add two web servers and one db server to the inventory file. All servers are Linux so users can be different than root for all practical purposes. Include additional parameters to specify the alias, connection type, username, and password for each server. Use the table below for the credentials information:

   | Alias | Connection | User |
   | ----- | ---------- | ---- |
   | Web1  | SSH        | root |
   | Web2  | SSH        | root |
   | Db1   | SSH        | root |

2. Group all the web servers under "[web_servers]" and the db server under "[db_servers]".
3. Create another group named "[all_servers]" that includes both web_servers and db_servers.

---

## inventory file

```bash

[web_servers]
web1 ansible_host=18.170.32.206 ansible_user=ec2-user ansible_become=yes ansible_connection=ssh
web2 ansible_host=35.177.187.121 ansible_user=ec2-user ansible_become=yes ansible_connection=ssh

[db_servers]
db1 ansible_host=18.170.221.152 ansible_user=ubuntu ansible_become=yes ansible_connection=ssh

[all_servers:children]
web_servers
db_servers

[all:vars]
ansible_ssh_private_key_file=/home/ec2-user/cpdevopsew-eu-west-2.pem

```

---

## Tasks

1. Submit the written commands for following actions.
   1. list all the hosts - ansible all_servers --list-hosts -i inventory
   2. list only the web servers - ansible web_servers --list-hosts -i inventory
   3. list only the db servers - ansible db_servers --list-hosts -i inventory

# Assignment-2 Installation using ansible

1. Create one ubuntu and amazon linux servers each.
2. Create inventory.
3. Install apache in all the web server.
4. Copy a local index.html file and server them on installed apache web servers

```

```
