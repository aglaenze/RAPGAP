## PYTHIA 6

```
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

Trial with version 6
```
wget --no-verbose --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.3.0.tar.gz
tar xvfz index.html\?f\=LHAPDF-6.3.0.tar.gz
rm index.html\?f\=LHAPDF-6.3.0.tar.gz
cd $WORKDIR/LHAPDF-6.3.0
mkdir install
./configure --prefix=$WORKDIR/lhapdf-6.3.0/install
```

It has to be version 5?
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
