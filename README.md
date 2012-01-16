
# PopHealth Automation with Chef

The project developers Chef recipes to manage automated installation and deployment of [PopHealth](http://projectpophealth.org/) for clinical quality measurement reporting. It is specifically designed to help IT administrators that are unfamiliar with Ruby, GEMs, MongoDB etc to get PopHealth up and running quickly.

By executing a single shell script on a stock [Ubuntu 10.04](http://releases.ubuntu.com/lucid/) (TLS) Linux install, you should be able to install and deploy a PopHealth server.

## Instructions for a fresh Ubuntu 10.04 box

1. Copy the ubuntu-10.04-startup.sh file to the box, and change its permission to executable. (e.g., <code>chmod 777 ubuntu-10.04-startup.sh</code>)

2. Run <code>sudo ubuntu-10.04-startup.sh</code> It might take 30 minutes to an hour to finish. So, get a cup of coffee!

3. Verify your install at <code>http://ip-address:3000</code> and login as "pophealth / pophealth"

On Amazon EC2, things can be further simplified. You do not even need to log into the server. The installation and deployment can be "headless".

## Instructions for Amazon EC2

1. Startup an EC2 instance using the official Ubuntu 10.04 image (e.g., <code>ami-55dc0b3c</code> for US East region. See a complete list of different EC2 regions at [Ubuntu support site](http://cloud-images.ubuntu.com/releases/10.04/release/)).

2. Copy and paste the content of the <code>sudo ubuntu-10.04-startup.sh</code> file into the "user data" box when starting up the EC2 server.

3. Make sure that you use an open security group to expose port 3000 for access.

4. Verify your install at <code>http://ip-address:3000</code> and login as "pophealth / pophealth"

With EC2, we can create on-demand PopHealth instances outside of our firewalls. But for developers, it is sometimes easier to experiment with PopHealth on a virtual machine on their own PC. For this, we support [VirtualBox](https://www.virtualbox.org/) instances managed by vagrant.

## Instructions for VirtualBox

1. Install [VirtualBox](https://www.virtualbox.org/). It is a very lightweight install.

2. Install [vagrant](http://vagrantup.com/). Assuming that you have Ruby installed on your PC, it is a simple command <code>gem install vagrant</code>.

3. Then use vagrant to install Ubuntu 10.04 onto an VirtualBox instance: <code>vagrant box add lucid32 http://files.vagrantup.com/lucid32.box</code>

4. Download this GitHub repository, and type <code>vagrant up</code> in the exploded directory.

5. Wait for some time until it finishes. And access PopHealth at http://localhost:8300/

6. You can use <code>vagrant ssh</code> to SSH into the instance, <code>vagrant suspend</code> stop the virtual machine, and <code>vagrant destroy</code> to get rid of the virtual machine when you no longer need it.

## What's Next?

To import data into the PopHealth server for analysis and visualization, you could do one of the following:

* Configure your EHR to upload CCR / CCD content to URL http://pophealth.ip-address:3000/records The default authentication username and password are "pophealth / pophealth". This is the option if you deployed PopHealth servers outside of your firewall.

OR

* If the PopHealth server is deployed inside your EHR's firewall, you could configure it to retrieve CCR / CCD files containing patient information from a shared file directories, where the EHR exports those files.

Enjoy!