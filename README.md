# etcdeath
The etcdeath repo is a series of scripts and code that punishes etcd clusters into failure.  These can be automated and instrumented.  The downside is you'll probably have to regularly rebuild your etcd cluster after running several of the tests.

All scripts read the VICTIM environment variable which can either be a single IP or fully-qualified host name.  Alternately, you can pass an IP or host name into the script: 
```
flakynet.sh 10.0.1.3
```
This command would sequentially run each etcd server out of memory by flooding the keyspace with data.  Many scripts will have specific variables that you need to tweak like data directory.  Everything should be well-commented and you will find all variable declarations at the top of the script.

Another environment variable you can set is *UNATTENDED*, which allows a script to be run with no human intervention if *UNATTENDED=1*

Be sure and look at the scripts because they have different options.  For example, keyflood has a dynamic payload variable so you can bring etcd to an ignominious end more quickly.  

# Structure
The scripts are divided into directories that describe the primary failure modes.  For example, *network* scripts will do things like drop interfaces or saturate links.  The directories are:
* colo
  - mishaps that occur in AWS and GCP
* data
  - data corruption, missing files
* misc
  - random failure scenarios
* network
  - interface mayhem, saturation, latency
* security
  - fun with iptables, patches and other security topics
* stress
  - io usage, connection bombardment, busy systems
* system
  - reboots, version changes, unstable systems
* user
  - killed processes, mangled restarts, junior sysadmin stuff

# Building your etcd cluster in AWS for testing

I realized early on in this process that the bulk of the time testing will be destroying and recreating etcd clusters.  Therefore I created terraform files for spinning up either a 3-node, 5-node, or N-node autoscaling etcd cluster fronted by a bastion host in its own VPC.  The terraform directories are in either etcdeath/build/terraform.3node or etcdeath/build/terraform.5node etcdeath/build/terraform.autoscale and you'll need to do a 'brew install terraform' on Mac or visit https://www.terraform.io/ to get the binaries for your OS of choice.   While Terraform can be run directly on the 3 and 5 node configurations with no editing or alterations, the autoscaling configuration requires you to generate a new discovery token:

```
curl https://discovery.etcd.io/new?size=3
```
This will return the string that you need to put in cloud-init:
```
https://discovery.etcd.io/12699f8f033ac0c72fd9512abceced91
```
That is the only change necessary, unless you want to change the autoscaling cluster geometry which lives in autoscaling.tf

From that point forward, you can follow these instructions in any of the terraform.* directories:
```
terraform plan
```
That will run you through what it will intend to do, but first, it will ask you for a bunch of variables.  Any of these variables can be bypassed in the future by exporting them in the format TF_VAR_instance_size or TF_VAR_domain.  This allows you to run this via automation.  You also need to make sure your AWS credentials are set in the running environment in order for it to work.  Lastly, you need a domain in route53 (it asks you for the zone code that looks like: Z2VCIMPG0M9T91 and you'll need the CoreOS ami for your intended region (https://coreos.com/os/docs/latest/booting-on-ec2.html) If you've got all that, you're ready to build your etcd cluster!  Build time in AWS on a good day is around 1:30 with another 5 minutes spent waiting for AWS to actually pass all the checks.  Once that's done, you can ssh into the bastion (ssh core@etcdbastion.yourdomain.com) and manage your cluster which is 10.0.1.4, 10.0.1.5, 10.0.1.6 for 3 nodes (add 10.0.1.7 and 10.0.1.8 for 5 nodes).  Don't forget you need that ssh key you specified in the config earlier.  You can pass it with -i keyname.pem in ssh, or if you're using ssh-agent, add it to your keyring.
```
terraform apply
```
Sorry you have to re-enter all of those variables again.  Did I mention setting environment variables?  So one big caveat if you're not familiar with terraform.  It will put 2 files in your directory: terraform.tfstate and terraform.tfstate.backup and this is where it keeps the information about the cluster you just built.  Lost these files and you'll have to manage all of the infrastructure manually in the console.  Yuck. When you're done torturing this poor etcd cluster, you just run:
```
terraform destroy
```
And, once again enter all those variables (or not... envars FTW!). Make sure you use the same variable entries as before.  This should effectively remove all traces of your cluster.  

# To-do 
- parallel death scenarios (aka apply changes to all servers simultaneously)
- More sophistication
