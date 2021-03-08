# RAPGAP

# Install RAPGAP

```
export WORKDIR=$(pwd)
```


## 1) Install HepMC

use https://gitlab.cern.ch/hepmc/HepMC/-/tree/HEPMC_02_06_05
This version and this version only
```./installHepMC.sh```

## 2) Install LHAPDF

??
Or don't

## 3) Install Rapgap

```./installRapgap.sh```

## 4) Check that Rapgap installation worked

```
cd $WORKDIR/rapgap-install
./bin/rapgap33 < steer_test
```

if it does not work
```export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORKDIR/HepMC/install/lib```
and try again
```./bin/rapgap33 < steer_test```

## PYTHIA 6

```
wget --no-verbose --no-check-certificate https://rapgap.hepforge.org/downloads/?f=pythia6428.tgz
wget --no-verbose --no-check-certificate https://rapgap.hepforge.org/downloads/?f=pythia6428.tgz

tar xvfz index.html?f=pythia6428.tgz
rm index.html?f=pythia6428.tgz
mv pythia6428 pythia6
cd pythia6
make lib
```

```
cd $WORKDIR/rapgap-3.301
./configure --disable-shared --prefix=$WORKDIR/rapgap-install --with-pythia6=$WORKDIR/pythia6 --with-lhapdf="/afs/cern.ch/work/a/abylinki/public/lhapdf_build" --with-hepmc=$WORKDIR/HepMC/install
```




## Warning about LHAPDF

Essai avec la version 6
```
wget --no-verbose --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.3.0.tar.gz
tar xvfz index.html\?f\=LHAPDF-6.3.0.tar.gz
rm index.html\?f\=LHAPDF-6.3.0.tar.gz
cd $WORKDIR/LHAPDF-6.3.0
mkdir install
./configure --prefix=$WORKDIR/lhapdf-6.3.0/install
```

has to be version 5
```
wget --no-verbose --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=old/lhapdf-5.9.1.tar.gz
tar xvfz index.html?f=old%2Flhapdf-5.9.1.tar.gz
rm index.html?f=old%2Flhapdf-5.9.1.tar.gz

cd $WORKDIR/lhapdf-5.9.1
mkdir install
./configure --prefix=$WORKDIR/lhapdf-5.9.1/install --enable-low-memory CC=gcc-7 CXX=g++-7
make
make install
```


```
wget https://lhapdf.hepforge.org/downloads/?f=old/lhapdf-5.9.0.tar.gz
tar xvfz index.html?f=old%2Flhapdf-5.9.0.tar.gz
rm index.html?f=old%2Flhapdf-5.9.0.tar.gz

cd $WORKDIR/lhapdf-5.9.0
mkdir install
./configure --prefix=$WORKDIR/lhapdf-5.9.0/install
make
make install
```

```
export GFORTRAN=/cvmfs/sft.cern.ch/lcg/releases/gcc/7.3.0-cb1ee/x86_64-slc6/bin/gfortran
/cvmfs/sft.cern.ch/lcg/releases/gcc/8.3.0.1-0a5ad/x86_64-slc6/bin/gfortran


