# Raspberry Pi Cluster Salt Provisioner

This repo contains instructions and salt scripts that you can use in order to maintain the Raspberry Pi cluster. Follow the instructions below to install Salt and start the Docker Swarm.

## Setting up the Raspberry Pis

Setting up the Raspberry Pi nodes is pretty straightforward. Follow the instructions on [Raspberry Pi's Website](https://www.raspberrypi.org/documentation/) to download and install the latest version of Raspbian.

After you flash the SD card, you will need to perform three steps to get the Raspberry Pi ready for use.

### 1. Enable SSH

To enable SSH, you will need to open up a terminal and navigate to the SD Card directory. For Mac, it is usually located at `/Volumes/boot`. Once there, run the command `touch ssh`. This will create a blank file on the SD Card that tells the Pi to enable SSH the next time it boots.

```
$ cd /Volumes/boot
$ touch ssh
```

### 2. Configure WiFi

If you are going to connect your Raspberry Pi via ethernet, you can skip this step. To set up WiFi, you will need to create a file on the SD Card called `wpa_supplicant.conf`.

First, you will need to generate a secure passphrase so that you don't use your actual WiFi password in your configuration files. You can do this using a tool such as `wpa_passphrase`. Be sure to change <my_ssid> to the SSID of your network. If you use `wpa_passphrase`, you can copy and paste the output directly into the `wpa_supplicant.conf` file. More thorough instructions can be found [here](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md).

To edit the `wpa_supplicant.conf` file, we can use nano, a built-in editor that comes standard on most machines.

```
$ wpa_passphrase <my_ssid> <password>
$ sudo nano wpa_supplicant.conf
```

To exit the editor, press 'Ctrl-X' and be sure to select 'yes' to save your changes.

Your `wpa_supplicant.conf` file should look something like this:

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="<my_ssid>"
  psk=131e1e221f6e06e3911a2d11ff2fac9182665c004de85300f9cac208a6a80531
}
```

### 3. Change the Hostname

Lastly, we need to change the host name of the device. Insert the SD Card into the Raspberry Pi and boot it up. This can take up to 90 seconds. Once you have done so, SSH into the node using the hostname of the Raspberry Pi. Usually, this is going to be `raspberrypi`. If you have multiple Raspberry Pis connected to your network at the same time, you may have to connect to them using their IP address.

```
$ ssh pi@raspberrypi.local
```

The default password is `raspberry`.

Now, we need to change the hostname of the Pi. The easiest way to achieve this is using raspi-config and following the on-screen instructions to change it.

```
$ sudo raspi-config
```

For the 'master', use `rpi-master`, and for each 'node', use `rpi-node-<#>`, where the '<#>' is replaced by a unique number for each node.

From this point on, each subsequent node can be set up entirely using Salt. However, you will need to manually set up the Master using the instructions below.

---

## Setting up the Cluster

Now that we have Raspbian installed on our Raspberry Pis and they are configured to connect to the network, we can start to do the configuration work on the cluster itself.

The Raspberry Pi Cluster uses SaltStack (Salt) to provision all of the nodes in the cluster. This allows us to manage software and configuration settings across the entire cluster, making sure that all nodes have the same software versions and configuration files. Think of it like copy/paste for an entire device's 'state'.

The first step in setting up our cluster is to install Salt on our Master and get it ready for more nodes.

---

### Setting up the Master

First and foremost in our cluster, we need to set up the Master. The Master is the only node that needs to be set up manually, every other node can be set up automatically using salt-ssh.

#### 1. Run the Salt Bootstrap Script

To install the latest version of Salt, we can take advantage of the Salt bootstrap script available to us from the wonderful developers at SaltStack.

The process is pretty straightforward, and requires only two commands. On the Master, run the commands below to download the install script into the `tmp` directory and install the latest version of salt-minion and salt-master for Raspbian.

```
$ curl -o /tmp/bootstrap-salt.sh -L https://bootstrap.saltstack.com
$ sudo sh /tmp/bootstrap-salt.sh -M
```

The bootstrap script will install salt-minion automatically, and by adding the `-M` tag, we elect to install salt-master as well.

More instructions for setting up Salt on the Master can be found at [Salt Bootstrap](https://docs.saltstack.com/en/latest/topics/tutorials/salt_bootstrap.html#debian-and-derivatives) and the [Raspbian Installation Instructions](https://docs.saltstack.com/en/latest/topics/installation/debian.html).

You will also want to install salt-ssh after completing this step so that we can use it in later steps. Use the following command to install it.

`$ sudo apt-get install salt-ssh`

Now that we have Salt installed on the Master, we need to change the configuration. You can do this manually, or by running the bootstrap script in the `bootstrap` folder. If you choose to use the bootstrap script, you can skip steps two and three below.

```
$ sudo salt-run state.apply bootstrap.bootstrap
```

That's it! Once you are finished, you have successfully installed Salt on the RPi Master.

#### 2. Configure the Master Manually

Now we need to configure the Master and enable GitFS. The easiest way to maintain the latest configuration for the Salt Master is to use GitFS in place of the regular filesystem for Salt. This allows you to keep your Salt configuration in a Git repo, as opposed to on your local Salt Master.

To start, you will need a python library for interacting with Git, such as *pygit2*, *GitPython*, or *Dulwich*.

As of 3/14/17, pygit2 is not packaged for Raspbian, though you can install it from source. GitPython and Dulwich have an updated source for Raspbian, and can be installed using pip or via apt.

Next, you will need to configure the Master to use Git as the fileserver. To do this, you will modify `/etc/salt/master`, and update the file with the following configuration changes:

```
file_roots:
  base:
    - /srv/salt

fileserver_backend:
  - git
  - roots

gitfs_remotes:
  - https://github.com/ajthor/rpi-cluster-salt.git

pillar_roots:
  base:
    - /srv/pillar
```

If you create your own configuration for the cluster, either by forking this repository or by creating your own git repo to hold your cluster configuration, be sure to change the remote repo. If you only want to change a small portion of the configuration, you can add your own git repo in place of (or above) the first repo in the configuration file. Salt will pull from the list in order, so if there are two files with the same name, the file from the first repo in the list takes precedence.

Take a look at [Git Fileserver Backend Walkthrough](https://docs.saltstack.com/en/latest/topics/tutorials/gitfs.html#gitfs-per-remote-config) for more info.

If you want to have a local configuration, that's fine, too! Take a look at the [Salt Documentation](https://docs.saltstack.com/en/latest/topics/tutorials/states_pt1.html) for more information on configuring Salt.

#### 3. Configure the Minion Manually

Even the Master, in most cases, will be managed by salt. However, the Master can't configure itself if you don't configure salt-minion on the device. The Master should have salt-minion installed, but in order to provision the node using Salt, we need to modify `/etc/salt/minion`, and add just a single line to the file:

```
master: 127.0.0.1
```

This tells the minion to attempt to reach the Master at the local loopback address, which is the current device.

---

### Bootstrapping Nodes

Next, we need to install salt-minion on each node. This can be done a number of ways:

- (Recommended) Install salt-minion using salt-ssh.
- Install salt-minion manually.

#### Install salt-minion via salt-ssh

If you choose to install salt-minion using salt-ssh, you can install salt-minion via the bootstrap script in the `bootstrap` folder, directly from the master node.

To do this, we first need to edit the roster file on `rpi-master` located at `/etc/salt/roster`. Edit the file to include the Raspberry Pi nodes by adding each node as shown below:

```
rpi-node-1:
  host: rpi-node-<#>.local
  user: pi
  passwd: raspberry
  sudo: True
```

Once you have added the node to the roster file, you can bootstrap it and update the configuration using the commands:

```
$ sudo salt-ssh -i 'rpi-node-<#>' state.apply bootstrap.bootstrap
```

Be sure to change '<#>' in the above commands to the unique number you assigned to the node earlier.

#### Install salt-minon manually

If you choose to install salt-minon manually, you should follow the instructions on the [Salt Website](https://docs.saltstack.com/en/latest/topics/installation/debian.html) or use the [bootstrap script](#using-the-salt-bootstrap-script), just like you did for the Master.

---

## Provision the Cluster

Now that Salt is installed on all of the nodes in the cluster, we can provision the cluster and apply the latest state to the nodes.

First, we need to accept the keys on the Master by using `salt-key`, and then we need to apply the default state to our nodes.

```
$ sudo salt-key -A
$ sudo salt 'rpi-node-<#>' state.apply
```

You may run into some errors while provisioning the nodes. If you do, you can try to apply the state again, or you can SSH into the nodes with the errors and try to fix the problems individually. You may also try increasing the timeout for Salt to ensure that the states run all the way through.

---

## Start the Swarm

Once your nodes are properly provisioned, you can start the swarm by following the instructions in the [Swarm README](https://github.com/ajthor/rpi-cluster-salt/swarm).
