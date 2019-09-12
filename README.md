
Some basic scripts to:
  1) bring up boxes with docker installed
  2) install Kubernetes
  3) install Rancher

Really this should all be done with terraform, but it's necessary sometimes to modify these like scripts to run custom installs.


#### Bring up boxes and install docker

Fill out terraform.tfvars, then:

```
terraform init
terraform plan
terraform apply
```

#### Install kubernetes

Add IP's and ssh key in cluster.yml and run:

`rke up`

Add `--config rke-config.yml` to specify a different config file. 


#### Installing Rancher

There are options in helm script for deploying local chart and image vs official chart.

```
./helm.sh
```
