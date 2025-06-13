# Guide on working with GCP VM
Original video: https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=15

## Content
- [Guide on working with GCP VM](#guide-on-working-with-gcp-vm)
  - [Content](#content)
  - [Generate ssh key](#generate-ssh-key)
  - [Upload public key to GCP](#upload-public-key-to-gcp)
  - [VM is then created](#vm-is-then-created)
  - [ssh into VM](#ssh-into-vm)
  - [Configure VM and setup local ~/.ssh/config](#configure-vm-and-setup-local-sshconfig)
  - [setup port forwarding to local machine](#setup-port-forwarding-to-local-machine)
  - [Run Jupyter to run upload-data notebook](#run-jupyter-to-run-upload-data-notebook)
  - [install terraform](#install-terraform)
  - [sftp Google credentials to vm](#sftp-google-credentials-to-vm)
  - [shut down VM](#shut-down-vm)


## Generate ssh key
A .ssh folder was created in the home directory. In the .ssh directory:
```bash
# https://cloud.google.com/compute/docs/connect/create-ssh-keys
# ssh-keygen -t rsa -f C:\Users\WINDOWS_USER\.ssh\KEY_FILENAME -C USERNAME
# -C = USERNAME on VM
ssh-keygen -t rsa -f gcp -C ASUS
```
Enter your own password. 
Two key file will be created in the .ssh folder, a public key (gcp.pub) and a private key (gcp).


## Upload public key to GCP
Compute Engine >> Settings >> Metadata >> create ssh key
```bash
# print the content of the public key
cat gcp.pub
```
Copied and pasted


## VM is then created


## ssh into VM
At home directory
```bash
# -i {private key file} {USERNAME of VM when generate ssh key}@{external ip of vm}
ssh -i  ~/.ssh/gcp ASUS@34.143.211.4
```
Enter password created when generate ssh key, then logged into gcp vm (Ubuntu) at local pc terminal
```bash
# linux task manager
htop
```
```bash
# gcloud sdk is included with the vm
gcloud --version
```


## Configure VM and setup local ~/.ssh/config
install anaconda by copy link from website
```bash
# download
wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
# install
bash Anaconda3-2024.10-1-Linux-x86_64.sh
```
at .ssh directory
```bash
touch config
code config
```
```text
Host de-zoomcamp
    HostName 34.143.211.4
    User ASUS
    IdentityFile C:/Users/ASUS/.ssh/gcp
Host {name of VM}
    HostName {VM external IP}
    User {username when creating ssh key}
    IdentityFile {private ssh key path}
```
with the file, can directly login at home directory with
```bash
# login
ssh de-zoomcamp
# logout
logout
```
install docker
```bash
sudo apt-get install docker.io
```
install remote ssh extension on vs code. There is a green button at the bottom left of vs code. Click on it and choose remote-ssh. Because we ady have the config file at .ssh folder, we can directly connect

install docker but docker is owned by root, current user is ASUS.
Need add user to docker group, follow instruction: 
https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md

```bash
# dk why he run this
docker run -it ubuntu bash
```

install docker-compose
```bash
mkdir bin
cd bin
wget {find the repo and get latest version for linux 86 64} -O docker-compose
# make the file executable
chmod +x docker-compose
ls
# file turn green
```
add docker-compose to PATH
```bash
cd
nano .bashrc
export PATH="${HOME}/bin:${PATH}"
# reload .bashrc
source .bashrc
```

clone course repo and run docker-compose.yml
```bash
cd
git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git
# cd into the folder 2_docker_sql that contain the yml file of previous video (pgadmin, pgdatabase)
docker-compose up -d
cd
# install pgcli
pip install pgcli
pgcli -h localhost -U root -d ny_taxi
pip uninstall pgcli
conda install -c conda-forge pgcli
pip install -U mycli
```


## setup port forwarding to local machine
In the vs code of vm, find ports beside terminal tab.
Add 5432 to port.
Open a new terminal that never connected to vm , now can connect pgsql in vm directly from pc.
```bash
pgcli -h localhost -U root -d ny_taxi
```
Add 8080 to port.
Now can open pgadmin of vm directly from pc.



## Run Jupyter to run upload-data notebook
In vm terminal, cd into the directory that contain the notebook.
```bash
jupyter notebook
```
Terminal print out jupyter notebook start on port 8888.
Add port 8888.
Now can run jupyter notebook of vm directly from pc browser.


## install terraform
Follow the method mentioned before, install the binary into the bin folder


## sftp Google credentials to vm
cd into the folder where is json file is located
```bash
sftp de-zoomcamp
mkdir .gc
cd .gc
put {name of the json file}
```
```bash
# in another vm terminal
export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/ny-rides.json
```

Now authenticate: 

```bash
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

## shut down VM
can do it in UI or
```bash
# stop vm
sudo shutdown now
```
