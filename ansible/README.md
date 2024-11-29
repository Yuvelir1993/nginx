# General
Provision configs with Ansible.

# Helper links
- [Automating Installation with Ansible](https://docs.nginx.com/nginx/deployment-guides/amazon-web-services/ec2-instances-for-nginx/#automating-installation-with-ansible)
  - [Ansible Galaxy nginx](https://galaxy.ansible.com/ui/standalone/roles/nginxinc/nginx/documentation/)
- [amazon.aws.ec2_instance module – Create & manage EC2 instances](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_instance_module.html#ansible-collections-amazon-aws-ec2-instance-module)
- [amazon.aws.aws_ec2 inventory – EC2 inventory source](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html)

# Commands
## Hints
Use `--check` for validation.
Use `--step` flag to execute with prompts.
Use `--tags <tag>` to execute only tagged.
Use `-e <variable>` to pass variable value.
Use `--ask-become-pass` to explicitly provide sudo password when `become: true`.

Ping hosts with `ANSIBLE_CONFIG=ansible.cfg ansible all -m ping`

## List inventories
Will call AWS API to return available hosts.
`ANSIBLE_CONFIG=ansible.cfg ansible-inventory --list`
`ANSIBLE_CONFIG=ansible.cfg ansible-inventory --graph`

## Play playbooks
Do not use `sudo` since `become: true` automatically elevates needed permissions.
⚠️ But probably you need to use `sudo su` before, depends on how you generated the key!
1. `ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./playbooks/prepare_instance.yml`
2. `ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./playbooks/configure_nginx.yml`
3. `ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./playbooks/deploy_website.yml` (access 'Public DNS' of elastic IP to test endpoints)

# Troubleshooting

## UNREACHABLE

In case of error like below log in with `sudo su`:
```bash
ec2-3-71-181-6.eu-central-1.compute.amazonaws.com | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: ubuntu@ec2-3-71-181-6.eu-central-1.compute.amazonaws.com: Permission denied (publickey).",
    "unreachable": true
}
```
