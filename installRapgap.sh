#!/bin/bash

export WORKDIR=$(pwd)

#version=3.301
version=3.303
#wget --no-verbose --no-check-certificate http://www.hepforge.org/archive/rapgap/rapgap-3.301.tar.gz
wget --no-verbose --no-check-certificate https://rapgap.hepforge.org/downloads/?f=rapgap-3.303.tar.gz
mkdir rapgap-install
cp steer_test rapgap-install/
#tar xvfz rapgap-$version.tar.gz
#rm rapgap-$version.tar.gz
tar xvfz index.html\?f\=rapgap-3.303.tar.gz
rm index.html\?f\=rapgap-3.303.tar.gz

#cp rapgap-lib-alexander/* $WORKDIR/rapgap-$version/src/rapgap/     # only for version 3.301

cd $WORKDIR/rapgap-$version

./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6="/cvmfs/sft.cern.ch/lcg/external/MCGenerators/pythia6/427/x86_64-slc5-gcc46-opt" --with-lhapdf="/afs/cern.ch/work/a/abylinki/public/lhapdf_build" --with-hepmc=$WORKDIR/HepMC/install

make
wait
make install
