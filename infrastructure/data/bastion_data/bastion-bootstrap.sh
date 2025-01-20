sudo apt-get update -y
sudo apt-get ugrade -y

sudo apt-get install -y mysql-client

sudo snap install aws-cli --classic


# Update all packages
sudo apt update -y

# Download the latest stable release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install bash-completion
sudo apt install -y bash-completion

# Enable kubectl bash completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
sudo chmod a+r /etc/bash_completion.d/kubectl

# Add alias and enable completion in user's bashrc
sudo echo 'alias k=kubectl' >> /home/ubuntu/.bashrc
sudo echo 'complete -o default -F __start_kubectl k' >> /home/ubuntu/.bashrc
sudo echo 'source <(kubectl completion bash)' >> /home/ubuntu/.bashrc

# Source bash completion scripts
sudo chmod +x /usr/share/bash-completion/bash_completion
sudo echo "source /usr/share/bash-completion/bash_completion" >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc