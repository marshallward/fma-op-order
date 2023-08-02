use fma_test, only : do_fma
use fma_test, only : do_prod, do_prod2, do_prod3

a = 1.1
b = 2.2
c = 3.3
d = do_fma(a,b,c)

print *, "FMA:", d

!print *, "p1(a,b,c,d):", do_prod(a,b,c,d)
!print *, "p1(c,d,a,b):", do_prod(c,d,a,b)

f = do_prod(a,b,c,d)
print *, "p1(a,b,c,d):", f
print '(z16)', f

f = do_prod(c,d,a,b)
print *, "p1(c,d,a,b):", f
print '(z16)', f

f = do_prod2(a,b,c,d)
print *, "p2(a,b,c,d):", f
print '(z16)', f

f = do_prod2(c,d,a,b)
print *, "p2(c,d,a,b):", f
print '(z16)', f

f = do_prod3(a,b,c,d)
print *, "p2(a,b,c,d):", f
print '(z16)', f

f = do_prod3(c,d,a,b)
print *, "p2(c,d,a,b):", f
print '(z16)', f

end
