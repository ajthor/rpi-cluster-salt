Raspberry Pi Omega Salt Provisioner
===================================

This repository is a provisioner for my Raspberry Pi Cluster. I have chosen to provision the cluster with [Salt](https://saltstack.com), and due to the complex nature of setting up a current version of Salt on a Raspberry Pi and configuring it properly, I have decided to bootstrap each node with Ansible. See the rpiomega-bootstrap repo for details.

To use this repository, clone the repo into your Salt `file_roots` directory, specified in `/etc/salt/master` on the master node. The default is `/srv/salt`.
In the master configuration file, specify an alternate `base` directory if you wish to change where the files are stored.

    file_roots:
      base:
      - /srv/salt

Applying the salt states is straightforward. Run `salt '*' state.apply` to apply the state across all nodes. This will:

* Install Common Packages, including Git, Python, PIP, etc.
* Install & Configure Docker
* Start Docker Swarm

What is Raspberry Pi Omega?
---------------------------

In set notation, Omega is the greek letter used to represent the Universal Set, and is also used to represent the first number after infinity. Raspberry Pi Omega is a cluster computing platform using the credit-card sized SBC, Raspberry Pi. It is designed as an educational and personal tool for software development, and is designed to work as a set, hence the name.

Raspberry Pi Omega is developed as a platform for performing development and computing tasks on a self-hosted cluster of Raspberry Pi's. It is designed to be an inexpensive, educational entry-point into cluster computing, utilizing technologies such as Configuration Management, Container-Based Virtualization, and Continuous Integration.

Though the system can run with a single node, it is better to use at least 3 nodes With enough Raspberry Pi's, the system can become quite powerful.

See more in the rpiomega repository.
