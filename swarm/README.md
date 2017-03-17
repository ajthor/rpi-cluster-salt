# Using Docker Swarm

Once your cluster is provisioned properly, we can turn the group of Raspberry Pis, which aren't connected yet, into a cluster using Docker Swarm.

In Rasperry Pi Omega, you have two options for starting the swarm:
1. (Recommended) Use the Salt orchestration script.
2. Set up the swarm manually.

## Using the Salt Orchestration Script

For convenience, there is a script in the `swarm` folder that allows you to start the swarm automatically. It will make `raspiomega-master` a manager and initialize the swarm, and add the remaining nodes to the cluster, attempting to make three of the nodes managers and add the rest of the nodes as workers.

The script can be run using:

```
$ sudo salt-run state.orchestrate swarm.up
```

There is a preliminary script in the same folder, `swarm.down`, that will try to force all of the nodes in the cluster to leave the swarm in case you want to spin up a cluster for testing and then stop the swarm for whatever reason. The script isn't recommended for use, and you should use caution if you choose to run it.

## Setting up the Swarm manually

If you choose to set up the swarm manually, you will wind up doing a lot of SSHing into the nodes to configure them individually. You should follow the tutorials at [Getting Started With Swarm Mode](https://docs.docker.com/engine/swarm/swarm-tutorial/) on the Docker website to set up the swarm.

There are a few guidelines for the Raspberry Pi Omega cluster that you should follow:
- Initialize the swarm on the Master, so that you have a consistent entry-point into your cluster. This means this is the only node that you will need to interact with for provisioning with Salt and for managing your swarm.
- It is a good idea to have multiple managers in your swarm for redundancy. This means that if one manager goes down, it has others it can rely upon to keep the swarm running.
