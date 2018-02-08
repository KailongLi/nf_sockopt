#!/bin/bash
yum install -y kernel-headers kernel-devel
yum update -y kernel
shutdown -r now
