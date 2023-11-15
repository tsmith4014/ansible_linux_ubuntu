## Ansible Playbooks Hands-on

- Check Ansible connectivity using commands.

```bash
# Test connectivity
ansible all -m ping  -i inventory

```

- Create a yaml file named "pb1.yml" and make sure all our hosts are up and running.

```yaml
---
- name: Test Connectivity
  hosts: all
  tasks:
    - name: Ping test
      ping:
```

- Run the yaml file.

```
ansible-playbook pb1.yml -i inventory

```

### Ansible module “Copy”

- Create a text file named "testfile1.txt" and write "Hello Ansible" with using vim. Then create a yaml file name "pb2.yml" and send the "testfile1.txt" to the hosts.

```yaml
---
- name: Copy for linux
  hosts: webservers
  tasks:
    - name: Copy your file to the webservers
      copy:
        src: /home/ec2-user/testfile1
        dest: /home/ec2-user/testfile1

- name: Copy for ubuntu
  hosts: ubuntuservers
  tasks:
    - name: Copy your file to the ubuntuservers
      copy:
        src: /home/ec2-user/testfile1
        dest: /home/ubuntu/testfile1
```

- Run the yaml file.

```
ansible-playbook pb2.yml -i inventory
```

- Check file presence in nodes

```yaml
ansible all -m shell -a "cat *" -i inventory
```

### Ansible module “Package” management

```
$ ansible-doc yum
$ ansible-doc apt

$ vim pb3.yml

---
- name: Apache installation for webservers
  hosts: webservers
  tasks:
   - name: install the latest version of Apache
     yum:
       name: httpd
       state: latest

   - name: start Apache
     shell: "service httpd start"

- name: Apache installation for ubuntuservers
  hosts: ubuntuservers
  tasks:
   - name: install the latest version of Apache
     apt:
       name: apache2
       state: latest
```

- Run the yaml file.

```
$ ansible-playbook -b pb3.yml -i inventory
$ ansible-playbook -b pb3.yml   # Run the command again and show the changing parts of the output.
```

- Create pb4.yml and remove the Apache server from the hosts.

```yaml
$ vim pb4.yml
---
- name: Remove Apache from webservers
  hosts: webservers
  tasks:
    - name: Remove Apache
      yum:
        name: httpd
        state: absent

- name: Remove Apache from ubuntuservers
  hosts: ubuntuservers
  tasks:
    - name: Remove Apache
      apt:
        name: apache2
        state: absent
    - name: Remove unwanted Apache2 packages from the system
      apt:
        autoremove: yes
        purge: yes
```

- Run the yaml file.

```
$ ansible-playbook -b pb4.yml -i inventory

```

- This time, install Apache and wget together with pb5.yml. After the installation, enter the IP-address of node2 to the browser and show the Apache server. Then, connect node1 with SSH and check if "wget and apache server" are running.

```yaml
vim pb5.yml
---
- name: Apache installation for ubuntuservers
  hosts: ubuntuservers
  tasks:
    - name: installing apache
      apt:
        name: apache2
        state: latest

    - name: index.html
      copy:
        content: "<h1>Hello Ansible</h1>"
        dest: /var/www/html/index.html

    - name: restart apache2
      service:
        name: apache2
        state: restarted
        enabled: yes

- name: Apache wget installation for webservers
  hosts: webservers
  tasks:
    - name: installing httpd and wget
      yum:
        pkg: ["httpd", "wget"]
        state: present
```

- Run the yaml file.

```
ansible-playbook -b pb5.yml -i inventory

```

- Remove Apache and wget from the hosts with pb6.yml.

```
vim pb6.yml

---
- name: Apache wget removal for webservers
  hosts: ubuntuservers
  tasks:
   - name: Uninstalling Apache
     apt:
       name: apache2
       state: absent
       update_cache: yes
   - name: Remove unwanted Apache2 packages
     apt:
       autoremove: yes
       purge: yes

- name: Apache wget removal for ubuntuserver
  hosts: webservers
  tasks:
   - name: removing apache and wget
     yum:
       pkg: ['httpd', 'wget']
       state: absent
```

- Run the yaml file.

```
ansible-playbook -b pb6.yml -i inventory

```
