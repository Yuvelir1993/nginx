1. Generate the ssh to the ~/.ssh folder: `ssh-keygen -t rsa -b 4096 -f ~/.ssh/ec2 -N ""`
2. Set right permissions with `chmod 400 ~/.ssh/ec2`
3. Create instance: `terraform init`, `terraform apply`
4. Connect with `ssh -i ~/.ssh/ec2 ubuntu@ec2-3-121-153-135.eu-central-1.compute.amazonaws.com`