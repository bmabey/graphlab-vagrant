#!/bin/bash
set -x
set -e

# based on https://github.com/smarttypes/SmartTypes/blob/master/smarttypes/graphlab/install_instructions.txt
# Updated by Ben Mabey to rely on eigen instead of itpp.

sudo apt-get update
sudo apt-get install --yes wget

echo "Installing compilers, and other dependences..."
sudo apt-get install --yes gcc g++ libboost-all-dev cmake mercurial zlib1g-dev

echo "Installing graphlabapi via hg..."
sudo su vagrant
cd /home/vagrant
hg clone https://graphlabapi.googlecode.com/hg/ graphlabapi

cd graphlabapi
./configure --bootstrap --eigen

echo "Running the tests..."
(cd release/demoapps && make)
(cd release/tests && make && ./runtests.sh)

 # build pmf and test it
 echo "Building PMF and running smalltest..."
 pushd release/demoapps/pmf
   make
   ./pmf smalltest 0 --float=true --scheduler="round_robin(max_iterations=15)"
 popd
