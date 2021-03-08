# RAPGAP

# Install RAPGAP on lxplus

## 1) Install HepMC

use https://gitlab.cern.ch/hepmc/HepMC/-/tree/HEPMC_02_06_05  
This version and this version only
```./installHepMC.sh```

## 2) Install Rapgap

```./installRapgap.sh```  
This will install RAPGAP using LHAPDF and pythia6 libraries from lxplus.

## 3) Check that Rapgap installation worked

```
cd $WORKDIR/rapgap-install
./bin/rapgap33 < steer_test
```

if it does not work
```export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$WORKDIR/HepMC/install/lib```
and try again
```./bin/rapgap33 < steer_test```

