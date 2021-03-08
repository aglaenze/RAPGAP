#!/bin/bash

export WORKDIR=$(pwd)

#version=3.301
version=3.303
#wget --no-verbose --no-check-certificate http://www.hepforge.org/archive/rapgap/rapgap-3.301.tar.gz
wget --no-verbose --no-check-certificate http://www.hepforge.org/downloads/?f=rapgap-3.303.tar.gz
mkdir rapgap-install
cp steer_test rapgap-install/
tar xvfz rapgap-$version.tar.gz
rm rapgap-$version.tar.gz

cp rapgap-lib-alexander/* $WORKDIR/rapgap-$version/src/rapgap/

cd $WORKDIR/rapgap-$version

#./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6=$WORKDIR/pythia6 --with-lhapdf="/afs/cern.ch/work/a/abylinki/public/lhapdf_build" --with-hepmc=$WORKDIR/HepMC/install CC=gcc-7 CXX=g++-7

#./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6=$WORKDIR/pythia6  --with-lhapdf=$WORKDIR/lhapdf-6.3.0/install --with-hepmc=$WORKDIR/HepMC/install

#./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6="/cvmfs/sft.cern.ch/lcg/external/MCGenerators/pythia6/427/x86_64-slc5-gcc46-opt"  --with-lhapdf=$WORKDIR/lhapdf-6.3.0/install --with-hepmc=$WORKDIR/HepMC/install

#./configure --disable-shared --prefix=$WORKDIR/rapgap3-install --with-pythia6=$WORKDIR/pythia6  --with-lhapdf=/usr/local/opt/lhapdf --with-hepmc=/usr/local/opt/hepmc

./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6="/cvmfs/sft.cern.ch/lcg/external/MCGenerators/pythia6/427/x86_64-slc5-gcc46-opt" --with-lhapdf="/afs/cern.ch/work/a/abylinki/public/lhapdf_build" --with-hepmc=$WORKDIR/HepMC/install


#--with-hepmc="/afs/cern.ch/work/a/abylinki/public/hepmc/slc4_amd64_gcc34/"


make
wait
make install
