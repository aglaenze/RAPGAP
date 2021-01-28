      PROGRAM RGMAIN
	Implicit None
#include "rgfull.inc"
#include "rgdisdif.inc"
#include "rgluco.inc"
#include "rgludat1.inc"
#include "rgpara.inc"
#include "rgpypars.inc"
#include "rgdiffr.inc"
#include "rgscq2.inc"
#include "rglq2.inc"
#include "rghsunts.inc"
#include "rghsoptn.inc"
#include "rghscuts.inc"
#include "rghsvglp.inc"
#include "rgeffic.inc"

	Integer Nevent
	Common/steer1/Nevent
	Integer K1,K2,LUX

	real timeleft
      Integer Minuts
      External Minuts
	External pydata

      Integer I,ISEED
      character*255 raseed
      character*255 test
      
      call dummysub(pydata)
      
C---initialise ARIADNE parameters, now done via block data
C---initialise PYTHIA 6 parameters, via pythia block data 
C     initialize random number generator
C      ISEED = 213123 
C^This was batch8
C      ISEED = 213124
C      ISEED = 213125 This is batch 10
C      ISEED = 213126 
C      ISEED = 213127
C      ISEED = 213128 
C      This is batch 13
C      ISEED = 213129
C      ISEED = 213130
C      ISEED = 213131
C      ISEED = 213135
C      ISEED = 213136
C      ISEED = 213137
C      ISEED = 213138
C      ISEED = 213139       
C      ISEED = 213140
C      ISEED = 213141
      ISEED = 213146
c      ISEED = Iabs(MINUTS())
c      ISEED = 44788029
cc      CALL GETENV("RASEED", raseed)
c note RASEED can have only 10 digits
c i.e   export RASEED='1234567890
cc      read(raseed,'(I30)') iseed
cc      WRITE (6,*) ' test raseed:',Iseed
      LUX = 4
      K1=0
      K2=0
      CALL RLUXGO(LUX,ISEED,K1,K2)
C---initialise RAPGAP parameters
      CALL GRAINI
C-- read in parameters from file 
      Call Steer
C-- change standard parameters of RAPGAP 	
	Call rapcha
C-- change standard parameters of HERACLES	
	Call hercha
C-- change standard parameters of JETSET
	Call pytcha
	IF(IFPS.EQ.10) then
C Initialize ARIADNE
         CALL ARINIT('RAPGAP')
C-- change standard parameters of ARIADNE
	   Call aricha
      endif
C--- CALCULATE X SECTION
      CALL PTIME(' rapgap  ',1,0)
      CALL RAPGAP
C--- print x section
      CALL RAEND(1)
C--- event generation

C--- Samuel starts a new output     
c      OPEN(UNIT=20, FILE="/eos/user/a/abylinki/hepmc.dat", STATUS='NEW')
c      OPEN(UNIT=21, FILE="/eos/user/a/abylinki/jpsie.dat",STATUS='NEW')
c      OPEN(UNIT=20, FILE="/eos/user/a/abylinki/hepmc.dat", STATUS='NEW')
      OPEN(UNIT=21, FILE="hepmcgk.dat",STATUS='NEW')
C--- Samuel is putting the opening line of the HEPMC Ascii File.
      WRITE(20,1005)"HepMC::IO_Ascii-START_EVENT_LISTING"
 1005 FORMAT(a)
      DO 10 I=1,Nevent
         CALL PTIME(' event  ',1,0)
c	   call timel(timeleft)
c	   if(timeleft.le.10.) then
c	      write(6,*) ' *** time limit reached. time left = ',timeleft
c            goto 123
c	   endif
         CALL EVENT
C--- user analysis routine
         WRITE(*,*) "Event: ", I
         CALL ANALYS
C--- user analysis routine (hztool)
cc         CALL hzraana
cc         iev = I
cc         isub = ipro
ccc hepmc xsec in pb        
cc         xsec = avgi *1000.
cc         xsece = sd * 1000.
cc         call convhepmc(iev, isub, xsec, xsece)
         CALL PTIME(' event  ',2,0)
C---
   10 CONTINUE
123   Continue
C--- Samuel is putting the ending line of the HEPMC Ascii File.
      WRITE(20,1005)"HepMC::IO_Ascii-END_EVENT_LISTING"

C---PRINT NR OF GENERATED EVENTS
      CALL RAEND(20)	
C--- user terminate routine (hztool)
cc	CALL hzraend
	
      CALL PTIME(' rapgap  ',2,0)
      CALL PTIME('        ',2,99)
      STOP
      END
      subroutine dummysub(a)
      return
      end
