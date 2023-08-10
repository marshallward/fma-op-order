FC=gfortran
#FCFLAGS=-fdefault-real-8 -O3
FCFLAGS=-O2 -mfma -fdefault-real-8
#FCFLAGS=-O2 -mfma

#FC=ifort
#FCFLAGS=-O2 -r8
#FCFLAGS=-O0 -mfma -r8

#FC=nvfortran
#FCFLAGS=-O0 -r8
#FCFLAGS=-O0 -Mnofma -r8
#FCFLAGS=-O0 -Mfma -r8

a.out: main.o fma.o
	$(FC) $^

main.o: fma.o

%.o: %.f90
	$(FC) -c $(FCFLAGS) -o $@ $<

fma.s: fma.f90
	$(FC) -c $(FCFLAGS) -S -o $@ $<

clean:
	$(RM) a.out *.o *.mod fma.s
