module fma_test

contains

function do_fma(a,b,c) result(f)
  real, intent(in) :: a, b, c
  real :: f

  f = a + b*c
end function do_fma

function do_prod(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = a*b + c*d
end function do_prod

function do_prod2(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = (a*b) + (c*d)
end function do_prod2

function do_prod3(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = a*b + (c*d)
end function do_prod3

function do_prod4(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = (a*b) + c*d
end function do_prod4

end module fma_test
