use, intrinsic :: iso_fortran_env, only : real32
use, intrinsic :: iso_fortran_env, only : real64

use fma_test, only : do_fma
use fma_test, only : do_prod
use fma_test, only : do_prod2
use fma_test, only : do_prod3
use fma_test, only : do_prod4

character(:), allocatable :: fmt_flt
    ! Value component of format string

! From the Nvidia CUDA documentation (x**2 - 1)
!   Noncommutative in both single and double precision
! NOTE: Example in docs round to 4 digits; we use SP float rounding (~1.2e-7)
!a = 1.0008
!b = a
!c = 1.
!d = -1.

! An extreme but more illustrative example
a = 1. + epsilon(a)
b = 1. - epsilon(a)
c = 1.
d = -1.

! TODO: run/compile time selection
if (kind(1.0) == real32) then
  fmt_flt = 'es14.7, " (", z8.8, ")"'
else
  fmt_flt = 'es23.16, " (", z16.16, ")"'
endif


! NOTE: output assumes single precision
f = do_prod(a,b,c,d)
print '(" a*b  +  c*d : ", ' // fmt_flt // ')', f, f

f = do_prod(c,d,a,b)
print '(" c*d  +  a*b : ", ' // fmt_flt // ')', f, f

f = do_prod2(a,b,c,d)
print '("(a*b) + (c*d): ", ' // fmt_flt // ')', f, f

f = do_prod2(c,d,a,b)
print '("(c*d) + (a*b): ", ' // fmt_flt // ')', f, f

f = do_prod3(a,b,c,d)
print '(" a*b  + (c*d): ", ' // fmt_flt // ')', f, f

f = do_prod3(c,d,a,b)
print '(" c*d  + (a*b): ", ' // fmt_flt // ')', f, f

f = do_prod4(a,b,c,d)
print '("(a*b) +  c*d : ", ' // fmt_flt // ')', f, f

f = do_prod4(c,d,a,b)
print '("(c*d) +  a*b : ", ' // fmt_flt // ')', f, f

end
