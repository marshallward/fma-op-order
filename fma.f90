module fma_test

contains

elemental function do_fma(a,b,c) result(f)
  real, intent(in) :: a, b, c
  real :: f

  f = a + b*c
end function do_fma

elemental function do_prod(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = a*b + c*d
end function do_prod

elemental function do_prod2(a,b,c,d) result(f)
  real, intent(in) :: a, b, c, d
  real :: f

  f = (a*b) + (c*d)
end function do_prod2

end module fma_test
