#!/bin/bash

export WORKDIR=$(pwd)

git clone https://gitlab.cern.ch/hepmc/HepMC.git
cd HepMC
mkdir build
mkdir install
cd build
cmake -DCMAKE_INSTALL_PREFIX=$WORKDIR/HepMC/install -Dmomentum=GEV -Dlength=CM ..
make
make install

