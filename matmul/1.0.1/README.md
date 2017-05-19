This package provides floating-point matrix multiplication.  It runs
on Forth-94 and Forth-2012 systems with the floating-point wordset.

    include matmul.4th

to get the word

    matmul ( a b c ncols nrows -- )

MATMUL computs C=AxB, where A, B, and C are matrixes: A has nrows rows
and ncols columns, B has ncols rows and nrows columns, and C has nrows
rows and columns.  Matrixes are stored in row-major order, i.e., the
elements of one row are adjacent, whereas the items of a column are
separated by all the items in the first row.

# Testing

To test whether this works as intended with your Forth system, type

    create matmul-verbose include matmul.4th include test.4th


# Details (irrelevant for most usage)

MATMUL calls a word FAXPY-NOSTRIDE, and the library contains several
implementations of this word, and automatically selects the one
expected to give the best performance.  If you want to know which
implementation is used, you can CREATE MATMUL-VERBOSE before including
matmul.4th.  You can also determine which implementation is used by
defining a constant FAXPY-NOSTRIDE-VARIANT.  The values for this
constant are as follows:

    unrolling
    no yes
     1     use FAXPY (a primitive in Gforth)
     4  2  separate-stack (Forth-2012) implementation
     5  3  Forth-94 implementation by Joel Rees and Anton Ertl
    15 13  Forth-94 implementation by pahihu

The Forth-94 implementations work on systems with separate FP stacks
as well as on systems with a combined FP and data stack with any
number of cells per FP item.

# Use as Benchmark

For use as benchmark, there is benchmark.4th, which performs one
500x500 matrix multiplication.  There is also the script runbenchs; by
default, runbenchs will run the benchmark on gforth-fast, vfxlin (with
various FP packages), and sf if available (and for VFX, if %vfxpath%
works), and it will use `perf` (with a fallback to `time`) for timing.
You can influence these choices and more by setting environment
variables before calling runbenchs.  E.g., if you want to benchmark
iforth only, you can do (on a bourne-compatible shell):

    SF=iforth GFORTH=xx VFXLIN=xx ./runbenchs

The environment variables used are:

TIMING  command used for measuring, e.g., `time`
RUN     file used for running benchmark (RUN=test.4th for testing)
GFORTH  how to invoke Gforth (default: gforth-fast)
SF      how to invoke SwiftForth (default: sf)
VFXLIN  How to invoke VFX (default: vfxlin)
VFXHOME where the VfxLin directory is (default: %vfxpath%)
VFXLIB  where the FP packages can be found (default: $VFXHOME/Lib)
VFXX86  where the x86-specific FP packages can be found

The defaults are reasonable, but you may need to define VFXHOME yourself.

You can also use this script to test all the different variants on
several systems with

    TIMING=command RUN=test.4th ./runbenchs

# Performance

This may not be the best-performing matrix multiplication written in
Forth and certainly not outside of Forth, but it has the advantage of
just working (at least that's the intention).  It's also not too badly
performing: Gforth performs 0.8 FLOP/cycle on a Core i5-6600K using
the faxpy primitive, and ideally Forth compilers will generate as good
code for FAXPY-NOSTRIDE as that for the FAXPY primitive.

Here are some results (using unrolled versions):

    cycles Core i5-6600K
    Forth-2012 Forth-94 Forth-94 primitive
              Rees/Ertl   pahihu     faxpy
     *1044M       1170M    1515M           vfxlin Ndp387.fth
      2222M       2949M    2763M     *319M gforth-fast
     *4978M       4859M    4936M           SwiftForth HW stack, no WAIT

The default variants are marked with "*".
