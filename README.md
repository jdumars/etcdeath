# etcdeath
The etcdeath repo is a series of scripts and code that punishes etcd clusters into failure.  These can be automated and instrumented.  The downside is you'll probably have to regularly rebuild your etcd cluster after running several of the tests.

All scripts read the VICTIM environment variable which can either be a single IP or fully-qualified host name.  Alternately, you can pass a comma-delimited array of IPs or hosts into the command:
```
memkill 10.0.1.3, 10.0.1.4, 10.0.1.5
```
This command would sequentially run each etcd server out of memory by flooding the keyspace with data.  Many scripts will have specific variables that you need to tweak like data directory.  Everything should be well-commented and you will find all variable declarations at the top of the script.

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

# To-do 
- parralel death scenarios (aka apply changes to all servers simultaneously)
- Scripts for rapidly spinning up etcd clusters in AWS
- More sophistication
