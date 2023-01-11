#!/bin/bash

user=$1
domain=$2
ip=$3
home=$4
docroot=$5

nodeDir="$home/$user/web/$domain/nodeapp"

mkdir $nodeDir
chown -R $user:$user $nodeDir