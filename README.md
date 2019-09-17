## HA Installer

Some basic scripts to:
  1) bring up boxes with docker installed
  2) install Kubernetes
  3) install Rancher

Really this should all be done with terraform, but it's necessary sometimes to modify these like scripts to run custom installs.


#### Bring up boxes and install docker

Fill out terraform.tfvars with linode token and your info

```
terraform init
terraform plan
terraform apply
```

#### Install kubernetes

Add IP's and ssh key in cluster.yml

```
rke up
```

Run command with `--config rke-config.yml` to specify a different file.

#### Installing Rancher

There are options in helm script for deploying local (custom) chart and image.

```
./helm.sh
```
