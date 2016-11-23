Nessus in a Container
=====================

## Motivation

Operate the famous Nessus Scanner in a Docker container leveraging the overhead of an extra VM.

## Prerequisites

* Docker environment (tested with Docker for Mac and CentOS VM as Docker host)
* Activation code from tenable

## User Manual

The following instructions may illustrate on behalf of sample commands how to build, run and operate the Nessus container locally.

### Building and running manually

* Clone this project locally and cd into the same
* Download the latest Nessus Manager (needs login to the tenable support portal) or Nessus Scanner
* Build the Nessus Manager image:
```
docker build --build-arg NESSUS_INSTALLER=Nessus-6.9.1-es7.x86_64.rpm --tag nessus-manager .
```
* Create a named volume where Docker will automatically copy the source image's data under /opt/nessus to the volume:
```
docker create -v /opt/nessus --name nessus-manager-datastore nessus-manager:latest
```
* Start the Nessus Container
```
docker run -d --name nessus-manager -p 443:8834 --volumes-from nessus-manager-datastore nessus-manager
```
* Check if the container is up and running (nessus-manager should be up, nessus-manager-datastore should be created):
```
docker ps -a
```
* Try to access the Nessus configuration wizard by entering https://localhost into your browser
* Follow the wizard's instructions

### Creating backups

* Execute the following command in order to create a backup:
```
docker run --rm --volumes-from nessus-manager-datastore -v $(pwd):/backup centos tar cvf /backup/nessus-backup-$(date +%Y%m%d-%H%M%S).tar /opt/nessus
```
* Please note, if running on OSX the local backup folder location will be on the VM in between. Run the following command if you would like to store the backup files locally:
```
docker run --rm -it --volumes-from nessus-manager-datastore -v $HOME/Temp/docker-backups:/backup -v /var/lib/docker:/docker centos tar cvf /backup/nessus-backup-$(date +%Y%m%d-%H%M%S).tar /opt/nessus
```

### Performing restores

* Execute the following commands in order to restore from backup, assuming to override the existing data volume (another approach here would be to first create a new named volume and then start a new Nessus container linked to the new volume):
```
# Stop the Nessus container
docker stop nessus-manager

# Restore from docker host
docker run --rm --volumes-from nessus-manager-datastore -v $(pwd):/backup centos bash -c "cd /opt/nessus && rm -rf * && tar xvf /backup/nessus-backup-20161123-082521.tar --strip 2"
# or if on OSX
docker run --rm -it --volumes-from nessus-manager-datastore -v $HOME/Temp/docker-backups:/backup -v /var/lib/docker:/docker centos bash -c "cd /opt/nessus && rm -rf * && tar xvf /backup/nessus-backup-20161123-082521.tar --strip 2"

# Check if restore was successful
docker run --rm -it --volumes-from nessus-manager-datastore centos ls -l /opt/nessus

# Start container
docker start nessus-manager
```

## Appendix

### References

* [Ansible role for the Nessus Agent deployment](https://github.com/polster/ansible-nessus-agent)

### Known Issues

* No known issues so far
