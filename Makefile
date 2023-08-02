FC=gfortran
#FCFLAGS=-O2 -mfma -fdefault-real-8
FCFLAGS=-O2 -mfma
#FCFLAGS=-O0

a.out: main.o fma.o
	$(FC) $^

main.o: fma.o

%.o: %.f90
	$(FC) -c $(FCFLAGS) -o $@ $<

fma.s: fma.f90
	$(FC) -c $(FCFLAGS) -S -o $@ $<

clean:
	$(RM) a.out *.o *.mod
