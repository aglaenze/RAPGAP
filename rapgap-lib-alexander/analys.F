      SUBROUTINE ANALYS
      Implicit none
      DOUBLE PRECISION SSS,CM,DBCMSS
      COMMON /PARTON/ SSS,CM(4),DBCMSS(4)
#include "rgluco.inc"
#include "rgrapgki.inc"

      INTEGER N,NPAD,K
      Double Precision P,V
      COMMON/PYJETS/N,NPAD,K(4000,5),P(4000,5),V(4000,5)

#include "rgludat1.inc"

*KEEP, RGPARA1. change q2--> q2r
      DOUBLE PRECISION SHAT,YMAX,YMIN,Q2R,Q2MAX,Q2MIN
      DOUBLE PRECISION XMAX,XMIN,Q2Q,AM,PCM
      COMMON /PARAT/AM(18),SHAT,YMAX,YMIN,Q2MAX,Q2MIN,XMAX,XMIN
      COMMON /PARAE/Q2R,Q2Q,PCM(4,18)

#include "rgparam.inc"

*KEEP, RGPARAS. change IPRO --> IPROR
      DOUBLE PRECISION Q2START,W_Q2,OMEG2
      INTEGER IRUNA,IQ2,IRUNAEM
      INTEGER IPROR
      COMMON/RAPA /IPROR,IRUNA,IQ2,IRUNAEM,Q2START,W_Q2,OMEG2
      DOUBLE PRECISION SCALFA
      COMMON/SCALF/ SCALFA

*KEEP, RGDISDIF. change IDIR --> IDIRR
      INTEGER IDIRR,IDIRINT,IDISDIF
      COMMON/DISDIF/ IDIRR,IDIRINT,IDISDIF

*KEEP, RGEFFIC. change NOUT --> NOUTT
      DOUBLE PRECISION AVGI,SD
      INTEGER NIN,NOUTT
      COMMON/EFFIC/AVGI,SD,NIN,NOUTT
C     SAVE

      DOUBLE PRECISION DBCMS(4)
      DOUBLE PRECISION XMX
      COMMON/TEST/XMX
      Integer NOUT,NOU110,NOU210,NOU1100
      COMMON/MYOUT/NOUT,NOU110,NOU210,NOU1100
      DOUBLE PRECISION PT2GEN,PHIGEN
      COMMON/HARDPOM/PT2GEN,PHIGEN

      DOUBLE PRECISION  DOT
      real pt2_gen,phi_gen
      Double Precision PYP,pyangl
      Double Precision sphi,stheta,phit1,phit2
      Integer ncall,nevent,naf1,naf2,l,ll
c  ntuple gluon
      Real x_bj,y,xgam,Q2,x_pom,t,sigm
      Integer ipro,idir
      Real s_h,p_t,p_t1,p_t2,p_t3,phi1,phi2,phi3,eta1,eta2,
     + eta3,xg_p,xm2_tot
      common/cwnco1/x_bj,y,xgam,Q2,x_pom,t,ipro,idir,sigm
      common/cwnco2/s_h,p_t,p_t1,p_t2,p_t3,phi1,phi2,phi3,eta1,eta2,
     + eta3,xg_p,xm2_tot

      real phi_e,phi_p
      Integer isprot,i,ipom
      double precision bochck

      LOGICAL FIRST
      EXTERNAL DOT
      DATA FIRST/.TRUE./
      DATA NEVENT/0/
      IF(FIRST) THEN
         NOUT = 0
         FIRST = .FALSE.
      ENDIF
      x_bj = SNGL(Q2R/DBLE(YY)/SSS)
      y = yy
      xgam = xel/yy
      Q2 = SNGL(Q2R)
      x_pom = XFGKI
      t = T2GKI
      ipro = ipror
      idir = idirr
      sigm = sngl(avgi)
      s_h = shh
      if(ipror.eq.12) shh = 0.
      p_t = sqrt(pt2h)
      phi_e = pyangl(P(4,1),P(4,2))
      do I=1,n
         if(k(i,2).eq.2212.and.k(i,1).eq.1) isprot =i
      enddo
      phi_p=pyangl(P(isprot,1),P(isprot,2))
c     write(6,*) ' analys: phi_e/p ',phi_e,phi_p
c looking for phi asymmetries
C boost in gamma proton system
C and rotate
      IF(IDIRR.EQ.1) THEN

         DBCMS(1)= DBLE(P(NIA1,1) + P(2,1))
         DBCMS(2)= DBLE(P(NIA1,2) + P(2,2))
         DBCMS(3)= DBLE(P(NIA1,3) + P(2,3))
         DBCMS(4)= DBLE(P(NIA1,4) + P(2,4))
         xfgki=1.
      ELSE
c find pomeron
         ipom = 2
         do i=1,n
            if(k(i,2).eq.100) ipom=i
         enddo
c boost to gamma pomeron system
         DBCMS(1)= DBLE(P(NIA1,1) + P(ipom,1))
         DBCMS(2)= DBLE(P(NIA1,2) + P(ipom,2))
         DBCMS(3)= DBLE(P(NIA1,3) + P(ipom,3))
         DBCMS(4)= DBLE(P(NIA1,4) + P(ipom,4))
      ENDIF
c      write(6,*) ' analys nia1 ',nia1
      BOCHCK = (DBCMS(1)/DBCMS(4))**2 + (DBCMS(2)/DBCMS(4))**2
     +              + (DBCMS(3)/DBCMS(4))**2
      BOCHCK = DSQRT(BOCHCK)
      IF(BOCHCK.GT.0.99999999D0) then
         write(6,*) BOCHCK,nia1,ipom
         call pylist(1)
      endif
      CALL PYROBO(0,N,0.d0,0.d0,-DBCMS(1)/DBCMS(4),-DBCMS(2)/DBCMS(4),
     +-DBCMS(3)/DBCMS(4))
      SPHI = pyangl(P(nia1,1),P(nia1,2))
      CALL PYROBO(0,0,0.d0,-sphi,0.d0,0.d0,0.d0)
      STHETA = pyangl(P(nia1,3),P(nia1,1))
      CALL PYROBO(0,0,-STHETA,0.d0,0.d0,0.d0,0.d0)
      IF(P(NF1,4).GT.P(NF2,4)) THEN
         phit1 = pyangl(P(NF1,1),P(NF1,2))
         phit2 = pyangl(P(NF2,1),P(NF2,2))
      ELSE
         phit2 = pyangl(P(NF1,1),P(NF1,2))
         phit1 = pyangl(P(NF2,1),P(NF2,2))

      ENDIF
      if(phit1.lt.0.) phit1 = 2.*sngl(pi) + phit1
      if(phit2.lt.0.) phit2 = 2.*sngl(pi) + phit2


      if(nf1.ne.nf2) then
         naf1=nf1
         naf2=nf2
      else
         do 20  l=nf1+1,n-1
            if(k(l,1).eq.12.or.k(l,1).eq.2) THEN
               do 10 ll = l,n
                  IF(k(ll,1).eq.11.or.k(ll,1).eq.1) then
                     naf1=l
                     naf2=ll
                     goto 30
                  endif
   10          continue
            endif
   20    continue
   30    continue
      endif
      call pylist(1)
      write(6,*) ' nf1,nf2,naf1,naf2 ',nf1,nf2,naf1,naf2

      p_t1 = PYP(naf1,10)
      p_t2 = PYP(naf2,10)
      p_t3 = PYP(naf1+1,10)
      phi1 = pyangl(P(NaF1,1),P(NaF1,2))
      phi2 = pyangl(P(NaF2,1),P(NaF2,2))
      phi3 = pyangl(P(NaF1+1,1),P(NaF1+1,2))
      eta1 = PYP(naf1,19)
      eta2 = PYP(naf2,19)
      eta3 = PYP(naf1+1,19)
      xg_p = (shh+ sngl(Q2R))/yy/sngl(sss)
      xg_p = xpr
      xm2_tot = -sngl(Q2R) + yy*xfgki*sngl(sss) + t2gki

      CALL PYROBO(0,0,STHETA,0.d0,0.d0,0.d0,0.d0)
      CALL PYROBO(0,0,0.d0,sphi,0.d0,0.d0,0.d0)
      CALL PYROBO(0,N,0.d0,0.d0,DBCMS(1)/DBCMS(4),DBCMS(2)/DBCMS(4),
     + DBCMS(3)/DBCMS(4))


      if(pt2gen.ne.0.0) then
         pt2_gen = sngl(pt2gen)
         phi_gen = sngl(phigen)
      else
         pt2_gen=PT2H
         phi_gen=phitgki
      endif
      ncall = ncall + 1
C      CALL HFNT(100)

      NEVENT = NEVENT + 1
      NOUT=NEVENT
C      WRITE(*,*) "Integrated cross section: ", AVGI
C      WRITE(*,*) "Total center of mass energy: ", SSS

C      WRITE(20,1001)"E ",NEVENT,-1,-1,-1,20," ",NEVENT,1,0,0
C 1001 FORMAT(a,i6,i4,i4,i4,i7,a,i4,i4,i4,i4)
C      WRITE(20,1002)"V ",NEVENT,0,0,0,0,0,0,N,0
C 1002 FORMAT(a,i6,i4,i4,i4,i7,i4,i4,i4,i4)
C      DO 100 I=1, N
C           WRITE(20,1003)"P",I,K(I,2),P(I,1),P(I,2),P(I,3),P(I,4),K(I,1),0,0,0,0
C 1003      FORMAT(a,i6,i8,f14.7,f14.7,f14.7,f14.7,i6,i2,i2,i2,i2)
C 100  ENDDO

C      WRITE(21,1004)sss,Q2R,yy,xel,xpr
C 1004 FORMAT(d10.2,f14.7,f14.7,f14.7,f14.7)
C      WRITE(*,*) "SSS IS HERE ",sss

      WRITE(21,1004)"E ",NEVENT,-1,-1,-1,20," ",NEVENT,1,0,0
 1004 FORMAT(a,i6,i4,i4,i4,i4,a,i4,i4,i4,i4)
      WRITE(21,1005)"V ",NEVENT,0,0,0,0,0,0,N,0
 1005 FORMAT(a,i6,i4,i4,i4,i4,i4,i4,i4,i4)
      DO 200 I=1, N
           WRITE(21,1006)"P",I,K(I,2),P(I,1),P(I,2),P(I,3),P(I,4),K(I,1),sss,Q2R,yy,xel,xpr,K(I,3),XFGKI
 1006      FORMAT(a,i6,i8,f14.7,f14.7,f14.7,f14.7,i6,d10.2,f14.7,f14.7,f14.7,f14.7,i6,f14.7)
 200  ENDDO



      RETURN
      END
