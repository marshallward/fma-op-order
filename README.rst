===============================
Fused multiply-add compile test
===============================

This is a small program which attempts to detect the usage of FMA in a simple
mathematical operation.


Summary
-------

This program is intended to demonstrate the ambiguous order of operations of
the following expression when FMAs are enabled::

   a*b + c*d

and the ways in which various compilers handle parentheses inside of such
expressions.

The GNU and Intel compilers appear to both respect parentheses and utilize FMAs
when the appropriate flags are provided.  Other compilers are being
investigated.


Example
-------

We compute the expression above using the following values::

   a = 1.0008
   b = 1.0008
   c = 1.0
   d = -1.0
   
which is equivalent to :math:`x^2 - 1` for :math:`x = 1.0008`.  This is taken
from the FMA section of the Nvidia CUDA documentation.  This example is
sensitive to rounding in both traditional and FMA computation.  Another
advantage is that it is sensitive at both single and double precision.

Four functions are created to compute the following expressions::

    a * b  +  c * d

   (a * b) + (c * d)

    a * b  + (c * d)

   (a * b) +  c * d 

What we expect:

1. FMA, either ``a*b + (c*d)`` or ``(a*b) + c*d``

2. No FMA

3. FMA, only ``a*b + (c*d)``

4. FMA, only ``c*d + (a*b)``


Platforms
---------

======== ======== ====================================
Compiler Version  Flags
======== ======== ====================================
GFortran 13.1.1   ``-O2 -mfma``
Intel    2021.9.0 ``-O2 -mfma -assume protect_parens``
Nvidia   22.7     ``-O0`` (``-Mfma`` is default)
Cray     15.0.1   (``-O2 -fma``, failed to use FMA)
======== ======== ====================================

CPU: AMD EPYC 7662


Results
-------

GNU::

    a*b  +  c*d :  0.0016006399999998237 (3F5A39921CF88611)
    c*d  +  a*b :  0.0016006399999999310 (3F5A39921CF88800)
   (a*b) + (c*d):  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) + (a*b):  0.0016006399999999310 (3F5A39921CF88800)
    a*b  + (c*d):  0.0016006399999998237 (3F5A39921CF88611)
    c*d  + (a*b):  0.0016006399999999310 (3F5A39921CF88800)
   (a*b) +  c*d :  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) +  a*b :  0.0016006399999998237 (3F5A39921CF88611)


Intel::

    a*b  +  c*d :  0.0016006399999998237 (3F5A39921CF88611)
    c*d  +  a*b :  0.0016006399999999310 (3F5A39921CF88800)
   (a*b) + (c*d):  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) + (a*b):  0.0016006399999999310 (3F5A39921CF88800)
    a*b  + (c*d):  0.0016006399999998237 (3F5A39921CF88611)
    c*d  + (a*b):  0.0016006399999999310 (3F5A39921CF88800)
   (a*b) +  c*d :  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) +  a*b :  0.0016006399999998237 (3F5A39921CF88611)

GNU and Intel are in agreement.


Nvidia::

    a*b  +  c*d :  0.0016006399999999310 (3F5A39921CF88800)
    c*d  +  a*b :  0.0016006399999998237 (3F5A39921CF88611)
   (a*b) + (c*d):  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) + (a*b):  0.0016006399999998237 (3F5A39921CF88611)
    a*b  + (c*d):  0.0016006399999999310 (3F5A39921CF88800)
    c*d  + (a*b):  0.0016006399999998237 (3F5A39921CF88611)
   (a*b) +  c*d :  0.0016006399999999310 (3F5A39921CF88800)
   (c*d) +  a*b :  0.0016006399999998237 (3F5A39921CF88611)

Nvidia results use FMA (via ``@llvm.fma.f64``) regardless of parentheses.


Cray

I have not yet been able to get this compiler to generate FMA bytecode.


Discussion
----------

Fused multiply-add operations (FMAs) combine the addition and multiplication of
an expression like ``a*b + c`` into a single instruction.  If the calculation
is sufficiently pipelined, they can be computed in a single CPU cycle.  Like
most numerical operations, FMAs can be vectorized, computing multiple values
per cycle.  In many devices, the FMA is used as the unit of computation when
measuring peak numerical performance.

FMAs present challenges for numerical models which require floating point
operations to be bit-reproducible.  Floating point operations are well-known to
be non-associative; for example, the computation of ``s`` ::

   s = a + b + c

is understood to be ambiguous, and could represent either ::

   t = a + b
   s = t + c

or ::

   t = b + c
   s = a + t

The values of ``s`` are equivalent in algebraic arithmetic, but not necessarily
in floating point arithmetic, where an increase in the magnitude of the sum may
cause trailing bits to be lost, if not ignored entirely.

As in algebraic arithmetic, the order of operations in many programming
languages is typically imposed by requiring the integrity of parentheses.  For
example::

   s = (a + b) + c

requires that ``a + b`` be computed before adding the value of ``c``.  For
summation, this eliminates any ambiguity in the result.

Mixed-operator expressions typically introduce an order of operations.  In the
following expression::

   s = a*b + c*d

multiplication is understood to precede addition, and the expression is
evaluated as::

   t1 = a * b
   t2 = c * d
   s = t1 + t2

The order of operations is not ambiguous with floating point addition and
multiplication.  But this is not the case with FMAs, which present two
solutions::

   t = a * b
   s = t + c * d

::

   t = c * d
   s = a * b + t

Each solution follows different rules, and produces different results.

In principle, this could be resolved with parentheses; that is,::

   s = a*b + (c*d)

should unambiguously compute ``c*d`` before applying the FMA.  However, this is
not the case in some of the tested compilers, which appear to aggressively
apply FMAs where possible.

This is still under investigation, and produces different results.

In principle, this could be resolved with parentheses; that is,::

   s = a*b + (c*d)

should unambiguously compute ``c*d`` before applying the FMA.  However, not all
compilers appear to respect this.

This is still under investigation.


Contact
-------

Marshall Ward <marshall.ward@noaa.gov>
