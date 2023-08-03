use fma_test, only : do_fma
use fma_test, only : do_prod
use fma_test, only : do_prod2
use fma_test, only : do_prod3
use fma_test, only : do_prod4

a = 1.1
b = 2.2
c = 3.3
d = do_fma(a,b,c)
print *, "FMA:", d

f = do_prod(a,b,c,d)
print '(" a*b  +  c*d : ", f19.16, " (", z16, ")")', f, f

f = do_prod(c,d,a,b)
print '(" c*d  +  a*b : ", f19.16, " (", z16, ")")', f, f

f = do_prod2(a,b,c,d)
print '("(a*b) + (c*d): ", f19.16, " (", z16, ")")', f, f

f = do_prod2(c,d,a,b)
print '("(c*d) + (a*b): ", f19.16, " (", z16, ")")', f, f

f = do_prod3(a,b,c,d)
print '(" a*b  + (c*d): ", f19.16, " (", z16, ")")', f, f

f = do_prod3(c,d,a,b)
print '(" c*d  + (a*b): ", f19.16, " (", z16, ")")', f, f

f = do_prod4(a,b,c,d)
print '("(a*b) +  c*d : ", f19.16, " (", z16, ")")', f, f

f = do_prod4(c,d,a,b)
print '("(c*d) +  a*b : ", f19.16, " (", z16, ")")', f, f

end
