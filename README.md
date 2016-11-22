Nessus in a Container
=====================

## Motivation

Operate the famous Nessus Scanner in a Docker container leveraging the overhead of an extra VM.

## Prerequisites

* Docker environment
* Activation code from tenable

## User Manual

### Build and Run manually

The following instructions may illustrate on behalf of sample commands how to build and run the Nessus container locally.

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

## Appendix

### References

* [Ansible role for the Nessus Agent deployment](https://github.com/polster/ansible-nessus-agent)

### Known Issues

* No known issues so far
