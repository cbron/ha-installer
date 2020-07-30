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

Troubleshooting:

* If you get an error message about etcd saying ` Failed to reconcile`, try `rke remove` and `rke up` again
* If ssh key gets stuck, try logging in manually with `ssh root@ip -i /my/key` and then trying again

#### Installing Rancher

There are options in helm script for deploying local (custom) chart and image. Currently setup for helm 3 using a binary names `helm3`.

Either run commands by hand or configure and do:

```
./helm.sh
```
