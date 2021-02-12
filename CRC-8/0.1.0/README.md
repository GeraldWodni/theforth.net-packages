\ *****************************************************************************
\ CRC-8.4th V0.1.0 2020 Sep 04  ANS Forth 
\ CRC-8 calculation using a table loaded at run time
\ *****************************************************************************

From : https://en.wikipedia.org/wiki/Cyclic_redundancy_check
"A cyclic redundancy check (CRC) is an error-detecting code commonly used in digital networks and storage devices to detect accidental changes to raw data."

Note : the Polynomial is often specified in reverse bit order, e.g. $F1 is shown as $07 .
The CRC calculation can either be in normal order, following the Big Endian description of the polynomial,
or in "reverse" order where the bits are reversed (which can be calculated more efficiently on Little Endian processors).
There is some confusion online about which of these is "reverse".

Usage
=====

Define your CRC8 parameters and create a definition line like :
\      Name                  Poly Init  Xor Rev   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16   Name
create CRC-8/_         lineC,  07   00   00  FF  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 " CRC-8/_"

Run
   0 v_Silent !            \ do not show test details
   CRC-8/_ CRC8table_Init  Show_CRC8_test
To show the results of the test, which will mostly fail :

\      Name                  Poly Init  Xor Rev   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16   Name
create CRC-8/_         lineC,  07   00   00  FF  00 F4 6C 34 90 6E 68 42 ED 83 B1 CA A0 BD D7 00 30 " CRC-8/_"

Copy the results of the test back into the CRC-8/_ definition line and repeat the test.

The test results should be checked using an external reference :
e.g. https://crccalc.com/ or http://www.sunshine2k.de/coding/javascript/crc/crc_js.html

To display all test results :
   empty include crc8  Show_CRC8tests_all
the output is the CRC8 definitions lines used to create the tests.

CRC tables can be generated for use in systems with limited RAM, for Forth :
   CRC-8/_  CRC8table_Init  Show_CRC8table
or for C code :
   CRC-8/_  CRC8table_Init  Show_CRC8table_C

The word  lineC,  is defined to parse the text following it and add hex numbers, strings
and counted strings to the table. This makes the source code easier to read.