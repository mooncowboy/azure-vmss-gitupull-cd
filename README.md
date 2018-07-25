# Continuous Deployment for Azure VM Scale Sets
An example of CD into Scale Sets using update scripts and Visual Studio Team Services (VSTS). The provided script updates the running application by doing a `git pull` on the VMSS virtual machines. 

This allows for an easy set-up of continuous deployment of web apps while leveraging Azure VMSS.

There are other ways of implementing continuous deployment for Scale Sets. [Here's an example](https://docs.microsoft.com/en-us/vsts/pipelines/apps/cd/azure/deploy-azure-scaleset?view=vsts) using [Packer](https://www.packer.io/) and [more examples in the official docs](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-deploy-app).

# Requirements

* An Azure subcription
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) installed

Make sure you're logged in to the Azure CLI console. Run `az login` if not.

# Getting Started
To keep it simple, this repo contains the Scale Sets creation scripts and the nodejs web app used as example. It can be used to deploy other applications by changing the git repo in `cloud-init.txt`.

Run the following script and wait a couple of minutes:

`sh create-vmss.sh <resource_group_name>` 

This creates a resource group and the scale set and returns the public IP of the scale set and inbound NAT rules: 

```
Getting public IP vmss-cd2LBPublicIp
23.97.210.147

Getting inbout NAT rules
22      50000
22      50003
```

You can check that the website is running by browsing to the public IP. 

Also, if you need to ssh to the VMs, you can specify the port from the NAT rules above. E.g.:

`ssh <user>@23.97.210.147 -p 50000`

# Setting up Continuous Deployment







