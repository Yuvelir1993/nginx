1. Generate the ssh to the .keys folder: `ssh-keygen -t rsa -b 4096 -f .keys/ec2 -N ""`
2. View the public key's content with `cat .keys/ec2.pub` and add it to the key pair in the main.tf.
3. Set right permissions with `chmod 400 .keys/ec2`.
4. Create instance: `terraform init`, `terraform apply`
5. Connect with `ssh -i .keys/ec2 ubuntu@ec2-35-156-146-76.eu-central-1.compute.amazonaws.com`

