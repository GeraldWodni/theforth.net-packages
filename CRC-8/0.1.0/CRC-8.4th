\ *****************************************************************************
\ CRC-8.4th V0.1.0 2020 Sep 04  ANS Forth 
\ CRC-8 calculation using a table loaded at run time
\ *****************************************************************************

0 [IF]

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

[THEN]

\ *****************************************************************************
\ Create CRC8 parameter definitions
\ *****************************************************************************

[UNDEFINED] 2.hex [IF]
: 2.hex ( c -- )   base @ >r  hex  0 <#  # #  #> type  r> base ! ;
[THEN]

[UNDEFINED] 4.hex [IF]
: 4.hex ( c -- )   base @ >r  hex  0 <#  # # # #  #> type  r> base ! ;
[THEN]

[UNDEFINED] ToColumn [IF]
: ToColumn ( u -- )   get-xy drop - 1 max 200 min  spaces ;    \ move to the given column number
[THEN]

[UNDEFINED] dumpL [IF]
\ dump on the same line
: dumpL ( a n -- )   0 max  $100 min  space  dup 2.hex ."  |  " over + swap ?do  i c@  2.hex space  loop ;
[THEN]

[UNDEFINED] lineC, [IF]
\ Add up to 128 bytes to a structure, using the 128 hex ASCII words following, then ignore the rest of the line.
: lineC, ( -- )
   base @ >r  hex                                     \ save the current number base on the return stack and change to hexadecimal
   $80 0 do                                           \ loop up to 128 times, or until something makes us "leave"
      bl word  count
      dup 0= if  2drop  leave  then                   \ there are no more words on the line, so leave the loop
      2dup s" \" compare 0= if  2drop  leave  then    \ we have found a "comment until end of line" character, so leave the loop
      2dup NUMBER? case      \ NUMBER? returns 0, 1 or 2 plus 0, 1 or 2 cells on the stack
         0 of
            dup 1 = if
               over c@ [char] " = if  [CHAR] " STRING  then \  " AAAA" will be added as a counted string AAAA with null terminator
               over c@ [char] % = if  [CHAR] % STRING  then \  % BBBB% will be added as a counted string BBBB with null terminator
               2drop
            else
               \ "AAAA" will be added as the string AAAA , %BBBB% will be added as the string BBBB
               over c@ [CHAR] " = if  1 /string  over + swap ?do  i c@ dup [CHAR] " = if  drop  leave  else  c,  then  loop  then
               over c@ [CHAR] % = if  1 /string  over + swap ?do  i c@ dup [CHAR] % = if  drop  leave  else  c,  then  loop  then
            then
         endof
         1 of  c,  2drop  endof
         2 of  ,   2drop  endof
      endcase
   loop
   r> base !                                          \ restore the number base from the return stack
   postpone \                                         \ perform the action of "\", ignore everything until the end of the line
                                                      \ "postpone"  means don't do this now, but when  lineC,  is called
;
[THEN]

\                                               |                 ... Test results ...             |
\      Name                  Poly Init  Xor Rev   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16   Name
create CRC-8/_         lineC,  07   00   00  FF  00 F4 6C 34 90 6E 68 42 ED 83 B1 CA A0 BD D7 00 30 " CRC-8/_"
create CRC-8/CDMA2000  lineC,  9B   FF   00  FF  FF DA B7 BC 2D EA 58 06 7D D9 99 77 C9 39 87 AC F6 " CRC-8/CDMA2000"
create CRC-8/DARC      lineC,  39   00   00  00  00 15 A3 6F A8 BA 5C 4A F3 81 73 84 AE F9 D3 00 8F " CRC-8/DARC"
create CRC-8/DVB-S2    lineC,  D5   00   00  FF  00 BC B8 EF F6 26 BA 06 AF E6 E4 F0 D2 06 24 00 2E " CRC-8/DVB-S2"
create CRC-8/EBU       lineC,  1D   FF   00  00  FF 97 04 34 1A 31 C5 A7 7D FB 16 1E FE D7 37 A1 94 " CRC-8/EBU"
create CRC-8/I-CODE    lineC,  1D   FD   00  FF  FD 7E 87 E7 B4 4F 5B E8 B3 9C 5E 63 4A 8F A6 27 BC " CRC-8/I-CODE"
create CRC-8/ITU       lineC,  07   00   55  FF  55 A1 39 61 C5 3B 3D 17 B8 D6 E4 9F F5 E8 82 55 65 " CRC-8/ITU"
create CRC-8/MAXIM     lineC,  31   00   00  00  00 A1 E8 85 BE CD 9E 55 2B 83 12 90 41 18 C9 00 06 " CRC-8/MAXIM"
create CRC-8/ROHC      lineC,  07   FF   00  00  FF D0 50 80 EB 61 73 C9 3C 0E E8 4D B1 39 C5 5A BB " CRC-8/ROHC"
create CRC-8/WCDMA     lineC,  9B   00   00  00  00 25 BD F1 1B DC 02 56 88 13 E8 22 CC D4 3A 00 BE " CRC-8/WCDMA"

$04 constant o_OFFSET_TESTS   \ fixed offset in bytes to the Test Results
$15 constant o_OFFSET_NAME    \ fixed offset in bytes to the counted name string at the end

\ *****************************************************************************
\ Calculate the CRC8 using a table
\ *****************************************************************************

$100 constant |CRC8table|
|CRC8table| Buffer: CRC8table[] ( -- a )

variable p_CRC8:        \ pointer to the current CRC8:x definition

\ The CRC8table[] must be initialised using CRC8table_Init . C-code \ crc = table[crc ^ data[i]];
: CRC8 ( a n -- c )   \ calculates the CRC8 of the given string using the parameters in the CRC8: definition string stored in p_CRC8:
   ( Init ) p_CRC8: @ 1 + c@  -rot  \ v_CRC8 c!      \ initialises the output CRC value in the required way
   over + swap ?do
      i c@
      xor CRC8table[] + c@
   loop
   ( Xor ) p_CRC8: @ 2 + c@ xor 
;

\ 12 PAD !  PAD 1 CRC8 PAD 1+ c!  PAD 2 CRC8 constant CRC_VALID

\ *****************************************************************************
\ Create the CRC8table
\ *****************************************************************************

variable BRin
variable BRout

: BitReverse8 ( c -- c )   \ slow version, used to constuct the table
   BRin !
   0 BRout !
   #08 0 do
      BRout @ 2* BRout !
      BRin @ 1 and if  BRout @ 1 or  BRout !  then
      BRin @ U2/ BRin !
   loop
   BRout @
;

variable v_polynomial

: CRC8calculateRev ( c -- c )   \ calculates the CRC value for table element n , slow method, Reversed
   p_CRC8: @ c@ BitReverse8 v_polynomial !
   8 0 do
      dup $01 and if
         1 rshift
         v_polynomial @ xor
      else
         1 rshift
      then
      $FF and
   loop
;

: CRC8calculateForward ( c -- c )   \ calculates the CRC value for table element n , slow method
   p_CRC8: @ c@ v_polynomial !
   8 0 do
      dup $80 and if
         1 lshift
         v_polynomial @ xor
      else
         1 lshift
      then
      $FF and
   loop
;

: CRC8calculate ( c -- c )   \ calculates the CRC value for table element n , slow method
   p_CRC8: @ 3 + c@ if        \ check to see if the bit order should be reversed
      CRC8calculateForward    \ "Normal" bit order
   else
      CRC8calculateRev        \ Reversed bit order - is more efficient on Little Endian processors
   then
;

: CRC8table_Init ( CRC8: -- )   \ Initialises the CRC8 table using the given CRC8 definition
   p_CRC8: !                     \ save the CRC8: definition line's address
   |CRC8table| 0 do
      i CRC8calculate CRC8table[] i  + c!
   loop
;

\ *****************************************************************************
\ Export a CRC8 table as compilable source code
\ *****************************************************************************

$20 constant c_LINE_LENGTH    \ how many bytes to display on each line

: Show_CRC8table ( -- )    \ show the current table as Forth source code
   cr  ." create CRC8table_" p_CRC8: @ o_OFFSET_NAME + count type  ."  ( -- a )   "
   ." \ Poly = $" p_CRC8: @ c@ 2.hex  ."  (rev $"  p_CRC8: @ c@ BitReverse8 2.hex ." )"
   ."   Init = $" p_CRC8: @ 1 + c@ 2.hex  ."   Xor = $" p_CRC8: @ 2 + c@ 2.hex   ."   Rev = $" p_CRC8: @ 3 + c@ 2.hex
   |CRC8table| 0 do
      i c_LINE_LENGTH 1- and 0= if  cr  ."    lineC, "  then  \ the text at the start of each line
      i CRC8table[] + c@ 2.hex space
      i c_LINE_LENGTH 1- and c_LINE_LENGTH 1- = if  ."  \ " i c_LINE_LENGTH 1- - 2.hex  then \ the text at the end of each line
   loop
   cr
;

: Show_CRCtables_all ( -- )
   CRC-8/_         CRC8table_Init  Show_CRC8table
   CRC-8/CDMA2000  CRC8table_Init  Show_CRC8table
   CRC-8/DARC      CRC8table_Init  Show_CRC8table
   CRC-8/DVB-S2    CRC8table_Init  Show_CRC8table
   CRC-8/EBU       CRC8table_Init  Show_CRC8table
   CRC-8/I-CODE    CRC8table_Init  Show_CRC8table
   CRC-8/ITU       CRC8table_Init  Show_CRC8table
   CRC-8/MAXIM     CRC8table_Init  Show_CRC8table
   CRC-8/ROHC      CRC8table_Init  Show_CRC8table
   CRC-8/WCDMA     CRC8table_Init  Show_CRC8table
   cr
;

: Show_CRC8table_C ( CRC8:x -- )    \ show the current table as C source code
   cr  ." create CRC8table_" p_CRC8: @ o_OFFSET_NAME + count type  ."  ( -- a )   "
   ." // Poly = 0x" p_CRC8: @ c@ 2.hex
   ."  (rev 0x"  p_CRC8: @ c@ BitReverse8 2.hex ." )"
   ."   Init = 0x" p_CRC8: @ 1 + c@ 2.hex  ."   Xor = 0x" p_CRC8: @ 2 + c@ 2.hex   ."   Rev = 0x" p_CRC8: @ 3 + c@ 2.hex
   ."   Please remove the final ',' before the '}' .
   cr ." { "
   |CRC8table| 0 do
      i c_LINE_LENGTH 1- and 0= if  cr  ."    "  then  \ the text at the start of each line
      i CRC8table[] + c@  0 <# [char] , hold # #  [char] x hold  [char] 0 hold  bl hold #> type  \ C format - please remove the final ,
      i c_LINE_LENGTH 1- and c_LINE_LENGTH 1- = if  ."  // " i c_LINE_LENGTH 1- - 2.hex  then \ the text at the end of each line
   loop
   cr ." } "
   cr
;

: Show_CRCtables_all_C ( -- )
   CRC-8/_         CRC8table_Init  Show_CRC8table_C
   CRC-8/CDMA2000  CRC8table_Init  Show_CRC8table_C
   CRC-8/DARC      CRC8table_Init  Show_CRC8table_C
   CRC-8/DVB-S2    CRC8table_Init  Show_CRC8table_C
   CRC-8/EBU       CRC8table_Init  Show_CRC8table_C
   CRC-8/I-CODE    CRC8table_Init  Show_CRC8table_C
   CRC-8/ITU       CRC8table_Init  Show_CRC8table_C
   CRC-8/MAXIM     CRC8table_Init  Show_CRC8table_C
   CRC-8/ROHC      CRC8table_Init  Show_CRC8table_C
   CRC-8/WCDMA     CRC8table_Init  Show_CRC8table_C
   cr
;

0 [IF]

Show_CRCtables_all

create CRC8table_CRC-8/_ ( -- a )   \ Poly = $07 (rev $E0)  Init = $00  Xor = $00  Rev = $FF
   lineC, 00 07 0E 09 1C 1B 12 15 38 3F 36 31 24 23 2A 2D 70 77 7E 79 6C 6B 62 65 48 4F 46 41 54 53 5A 5D  \ 00
   lineC, E0 E7 EE E9 FC FB F2 F5 D8 DF D6 D1 C4 C3 CA CD 90 97 9E 99 8C 8B 82 85 A8 AF A6 A1 B4 B3 BA BD  \ 20
   lineC, C7 C0 C9 CE DB DC D5 D2 FF F8 F1 F6 E3 E4 ED EA B7 B0 B9 BE AB AC A5 A2 8F 88 81 86 93 94 9D 9A  \ 40
   lineC, 27 20 29 2E 3B 3C 35 32 1F 18 11 16 03 04 0D 0A 57 50 59 5E 4B 4C 45 42 6F 68 61 66 73 74 7D 7A  \ 60
   lineC, 89 8E 87 80 95 92 9B 9C B1 B6 BF B8 AD AA A3 A4 F9 FE F7 F0 E5 E2 EB EC C1 C6 CF C8 DD DA D3 D4  \ 80
   lineC, 69 6E 67 60 75 72 7B 7C 51 56 5F 58 4D 4A 43 44 19 1E 17 10 05 02 0B 0C 21 26 2F 28 3D 3A 33 34  \ A0
   lineC, 4E 49 40 47 52 55 5C 5B 76 71 78 7F 6A 6D 64 63 3E 39 30 37 22 25 2C 2B 06 01 08 0F 1A 1D 14 13  \ C0
   lineC, AE A9 A0 A7 B2 B5 BC BB 96 91 98 9F 8A 8D 84 83 DE D9 D0 D7 C2 C5 CC CB E6 E1 E8 EF FA FD F4 F3  \ E0

create CRC8table_CRC-8/CDMA2000 ( -- a )   \ Poly = $9B (rev $D9)  Init = $FF  Xor = $00  Rev = $FF
   lineC, 00 9B AD 36 C1 5A 6C F7 19 82 B4 2F D8 43 75 EE 32 A9 9F 04 F3 68 5E C5 2B B0 86 1D EA 71 47 DC  \ 00
   lineC, 64 FF C9 52 A5 3E 08 93 7D E6 D0 4B BC 27 11 8A 56 CD FB 60 97 0C 3A A1 4F D4 E2 79 8E 15 23 B8  \ 20
   lineC, C8 53 65 FE 09 92 A4 3F D1 4A 7C E7 10 8B BD 26 FA 61 57 CC 3B A0 96 0D E3 78 4E D5 22 B9 8F 14  \ 40
   lineC, AC 37 01 9A 6D F6 C0 5B B5 2E 18 83 74 EF D9 42 9E 05 33 A8 5F C4 F2 69 87 1C 2A B1 46 DD EB 70  \ 60
   lineC, 0B 90 A6 3D CA 51 67 FC 12 89 BF 24 D3 48 7E E5 39 A2 94 0F F8 63 55 CE 20 BB 8D 16 E1 7A 4C D7  \ 80
   lineC, 6F F4 C2 59 AE 35 03 98 76 ED DB 40 B7 2C 1A 81 5D C6 F0 6B 9C 07 31 AA 44 DF E9 72 85 1E 28 B3  \ A0
   lineC, C3 58 6E F5 02 99 AF 34 DA 41 77 EC 1B 80 B6 2D F1 6A 5C C7 30 AB 9D 06 E8 73 45 DE 29 B2 84 1F  \ C0
   lineC, A7 3C 0A 91 66 FD CB 50 BE 25 13 88 7F E4 D2 49 95 0E 38 A3 54 CF F9 62 8C 17 21 BA 4D D6 E0 7B  \ E0

create CRC8table_CRC-8/DARC ( -- a )   \ Poly = $39 (rev $9C)  Init = $00  Xor = $00  Rev = $00
   lineC, 00 72 E4 96 F1 83 15 67 DB A9 3F 4D 2A 58 CE BC 8F FD 6B 19 7E 0C 9A E8 54 26 B0 C2 A5 D7 41 33  \ 00
   lineC, 27 55 C3 B1 D6 A4 32 40 FC 8E 18 6A 0D 7F E9 9B A8 DA 4C 3E 59 2B BD CF 73 01 97 E5 82 F0 66 14  \ 20
   lineC, 4E 3C AA D8 BF CD 5B 29 95 E7 71 03 64 16 80 F2 C1 B3 25 57 30 42 D4 A6 1A 68 FE 8C EB 99 0F 7D  \ 40
   lineC, 69 1B 8D FF 98 EA 7C 0E B2 C0 56 24 43 31 A7 D5 E6 94 02 70 17 65 F3 81 3D 4F D9 AB CC BE 28 5A  \ 60
   lineC, 9C EE 78 0A 6D 1F 89 FB 47 35 A3 D1 B6 C4 52 20 13 61 F7 85 E2 90 06 74 C8 BA 2C 5E 39 4B DD AF  \ 80
   lineC, BB C9 5F 2D 4A 38 AE DC 60 12 84 F6 91 E3 75 07 34 46 D0 A2 C5 B7 21 53 EF 9D 0B 79 1E 6C FA 88  \ A0
   lineC, D2 A0 36 44 23 51 C7 B5 09 7B ED 9F F8 8A 1C 6E 5D 2F B9 CB AC DE 48 3A 86 F4 62 10 77 05 93 E1  \ C0
   lineC, F5 87 11 63 04 76 E0 92 2E 5C CA B8 DF AD 3B 49 7A 08 9E EC 8B F9 6F 1D A1 D3 45 37 50 22 B4 C6  \ E0

create CRC8table_CRC-8/DVB-S2 ( -- a )   \ Poly = $D5 (rev $AB)  Init = $00  Xor = $00  Rev = $FF
   lineC, 00 D5 7F AA FE 2B 81 54 29 FC 56 83 D7 02 A8 7D 52 87 2D F8 AC 79 D3 06 7B AE 04 D1 85 50 FA 2F  \ 00
   lineC, A4 71 DB 0E 5A 8F 25 F0 8D 58 F2 27 73 A6 0C D9 F6 23 89 5C 08 DD 77 A2 DF 0A A0 75 21 F4 5E 8B  \ 20
   lineC, 9D 48 E2 37 63 B6 1C C9 B4 61 CB 1E 4A 9F 35 E0 CF 1A B0 65 31 E4 4E 9B E6 33 99 4C 18 CD 67 B2  \ 40
   lineC, 39 EC 46 93 C7 12 B8 6D 10 C5 6F BA EE 3B 91 44 6B BE 14 C1 95 40 EA 3F 42 97 3D E8 BC 69 C3 16  \ 60
   lineC, EF 3A 90 45 11 C4 6E BB C6 13 B9 6C 38 ED 47 92 BD 68 C2 17 43 96 3C E9 94 41 EB 3E 6A BF 15 C0  \ 80
   lineC, 4B 9E 34 E1 B5 60 CA 1F 62 B7 1D C8 9C 49 E3 36 19 CC 66 B3 E7 32 98 4D 30 E5 4F 9A CE 1B B1 64  \ A0
   lineC, 72 A7 0D D8 8C 59 F3 26 5B 8E 24 F1 A5 70 DA 0F 20 F5 5F 8A DE 0B A1 74 09 DC 76 A3 F7 22 88 5D  \ C0
   lineC, D6 03 A9 7C 28 FD 57 82 FF 2A 80 55 01 D4 7E AB 84 51 FB 2E 7A AF 05 D0 AD 78 D2 07 53 86 2C F9  \ E0

create CRC8table_CRC-8/EBU ( -- a )   \ Poly = $1D (rev $B8)  Init = $FF  Xor = $00  Rev = $00
   lineC, 00 64 C8 AC E1 85 29 4D B3 D7 7B 1F 52 36 9A FE 17 73 DF BB F6 92 3E 5A A4 C0 6C 08 45 21 8D E9  \ 00
   lineC, 2E 4A E6 82 CF AB 07 63 9D F9 55 31 7C 18 B4 D0 39 5D F1 95 D8 BC 10 74 8A EE 42 26 6B 0F A3 C7  \ 20
   lineC, 5C 38 94 F0 BD D9 75 11 EF 8B 27 43 0E 6A C6 A2 4B 2F 83 E7 AA CE 62 06 F8 9C 30 54 19 7D D1 B5  \ 40
   lineC, 72 16 BA DE 93 F7 5B 3F C1 A5 09 6D 20 44 E8 8C 65 01 AD C9 84 E0 4C 28 D6 B2 1E 7A 37 53 FF 9B  \ 60
   lineC, B8 DC 70 14 59 3D 91 F5 0B 6F C3 A7 EA 8E 22 46 AF CB 67 03 4E 2A 86 E2 1C 78 D4 B0 FD 99 35 51  \ 80
   lineC, 96 F2 5E 3A 77 13 BF DB 25 41 ED 89 C4 A0 0C 68 81 E5 49 2D 60 04 A8 CC 32 56 FA 9E D3 B7 1B 7F  \ A0
   lineC, E4 80 2C 48 05 61 CD A9 57 33 9F FB B6 D2 7E 1A F3 97 3B 5F 12 76 DA BE 40 24 88 EC A1 C5 69 0D  \ C0
   lineC, CA AE 02 66 2B 4F E3 87 79 1D B1 D5 98 FC 50 34 DD B9 15 71 3C 58 F4 90 6E 0A A6 C2 8F EB 47 23  \ E0

create CRC8table_CRC-8/I-CODE ( -- a )   \ Poly = $1D (rev $B8)  Init = $FD  Xor = $00  Rev = $FF
   lineC, 00 1D 3A 27 74 69 4E 53 E8 F5 D2 CF 9C 81 A6 BB CD D0 F7 EA B9 A4 83 9E 25 38 1F 02 51 4C 6B 76  \ 00
   lineC, 87 9A BD A0 F3 EE C9 D4 6F 72 55 48 1B 06 21 3C 4A 57 70 6D 3E 23 04 19 A2 BF 98 85 D6 CB EC F1  \ 20
   lineC, 13 0E 29 34 67 7A 5D 40 FB E6 C1 DC 8F 92 B5 A8 DE C3 E4 F9 AA B7 90 8D 36 2B 0C 11 42 5F 78 65  \ 40
   lineC, 94 89 AE B3 E0 FD DA C7 7C 61 46 5B 08 15 32 2F 59 44 63 7E 2D 30 17 0A B1 AC 8B 96 C5 D8 FF E2  \ 60
   lineC, 26 3B 1C 01 52 4F 68 75 CE D3 F4 E9 BA A7 80 9D EB F6 D1 CC 9F 82 A5 B8 03 1E 39 24 77 6A 4D 50  \ 80
   lineC, A1 BC 9B 86 D5 C8 EF F2 49 54 73 6E 3D 20 07 1A 6C 71 56 4B 18 05 22 3F 84 99 BE A3 F0 ED CA D7  \ A0
   lineC, 35 28 0F 12 41 5C 7B 66 DD C0 E7 FA A9 B4 93 8E F8 E5 C2 DF 8C 91 B6 AB 10 0D 2A 37 64 79 5E 43  \ C0
   lineC, B2 AF 88 95 C6 DB FC E1 5A 47 60 7D 2E 33 14 09 7F 62 45 58 0B 16 31 2C 97 8A AD B0 E3 FE D9 C4  \ E0

create CRC8table_CRC-8/ITU ( -- a )   \ Poly = $07 (rev $E0)  Init = $00  Xor = $55  Rev = $FF
   lineC, 00 07 0E 09 1C 1B 12 15 38 3F 36 31 24 23 2A 2D 70 77 7E 79 6C 6B 62 65 48 4F 46 41 54 53 5A 5D  \ 00
   lineC, E0 E7 EE E9 FC FB F2 F5 D8 DF D6 D1 C4 C3 CA CD 90 97 9E 99 8C 8B 82 85 A8 AF A6 A1 B4 B3 BA BD  \ 20
   lineC, C7 C0 C9 CE DB DC D5 D2 FF F8 F1 F6 E3 E4 ED EA B7 B0 B9 BE AB AC A5 A2 8F 88 81 86 93 94 9D 9A  \ 40
   lineC, 27 20 29 2E 3B 3C 35 32 1F 18 11 16 03 04 0D 0A 57 50 59 5E 4B 4C 45 42 6F 68 61 66 73 74 7D 7A  \ 60
   lineC, 89 8E 87 80 95 92 9B 9C B1 B6 BF B8 AD AA A3 A4 F9 FE F7 F0 E5 E2 EB EC C1 C6 CF C8 DD DA D3 D4  \ 80
   lineC, 69 6E 67 60 75 72 7B 7C 51 56 5F 58 4D 4A 43 44 19 1E 17 10 05 02 0B 0C 21 26 2F 28 3D 3A 33 34  \ A0
   lineC, 4E 49 40 47 52 55 5C 5B 76 71 78 7F 6A 6D 64 63 3E 39 30 37 22 25 2C 2B 06 01 08 0F 1A 1D 14 13  \ C0
   lineC, AE A9 A0 A7 B2 B5 BC BB 96 91 98 9F 8A 8D 84 83 DE D9 D0 D7 C2 C5 CC CB E6 E1 E8 EF FA FD F4 F3  \ E0

create CRC8table_CRC-8/MAXIM ( -- a )   \ Poly = $31 (rev $8C)  Init = $00  Xor = $00  Rev = $00
   lineC, 00 5E BC E2 61 3F DD 83 C2 9C 7E 20 A3 FD 1F 41 9D C3 21 7F FC A2 40 1E 5F 01 E3 BD 3E 60 82 DC  \ 00
   lineC, 23 7D 9F C1 42 1C FE A0 E1 BF 5D 03 80 DE 3C 62 BE E0 02 5C DF 81 63 3D 7C 22 C0 9E 1D 43 A1 FF  \ 20
   lineC, 46 18 FA A4 27 79 9B C5 84 DA 38 66 E5 BB 59 07 DB 85 67 39 BA E4 06 58 19 47 A5 FB 78 26 C4 9A  \ 40
   lineC, 65 3B D9 87 04 5A B8 E6 A7 F9 1B 45 C6 98 7A 24 F8 A6 44 1A 99 C7 25 7B 3A 64 86 D8 5B 05 E7 B9  \ 60
   lineC, 8C D2 30 6E ED B3 51 0F 4E 10 F2 AC 2F 71 93 CD 11 4F AD F3 70 2E CC 92 D3 8D 6F 31 B2 EC 0E 50  \ 80
   lineC, AF F1 13 4D CE 90 72 2C 6D 33 D1 8F 0C 52 B0 EE 32 6C 8E D0 53 0D EF B1 F0 AE 4C 12 91 CF 2D 73  \ A0
   lineC, CA 94 76 28 AB F5 17 49 08 56 B4 EA 69 37 D5 8B 57 09 EB B5 36 68 8A D4 95 CB 29 77 F4 AA 48 16  \ C0
   lineC, E9 B7 55 0B 88 D6 34 6A 2B 75 97 C9 4A 14 F6 A8 74 2A C8 96 15 4B A9 F7 B6 E8 0A 54 D7 89 6B 35  \ E0

create CRC8table_CRC-8/ROHC ( -- a )   \ Poly = $07 (rev $E0)  Init = $FF  Xor = $00  Rev = $00
   lineC, 00 91 E3 72 07 96 E4 75 0E 9F ED 7C 09 98 EA 7B 1C 8D FF 6E 1B 8A F8 69 12 83 F1 60 15 84 F6 67  \ 00
   lineC, 38 A9 DB 4A 3F AE DC 4D 36 A7 D5 44 31 A0 D2 43 24 B5 C7 56 23 B2 C0 51 2A BB C9 58 2D BC CE 5F  \ 20
   lineC, 70 E1 93 02 77 E6 94 05 7E EF 9D 0C 79 E8 9A 0B 6C FD 8F 1E 6B FA 88 19 62 F3 81 10 65 F4 86 17  \ 40
   lineC, 48 D9 AB 3A 4F DE AC 3D 46 D7 A5 34 41 D0 A2 33 54 C5 B7 26 53 C2 B0 21 5A CB B9 28 5D CC BE 2F  \ 60
   lineC, E0 71 03 92 E7 76 04 95 EE 7F 0D 9C E9 78 0A 9B FC 6D 1F 8E FB 6A 18 89 F2 63 11 80 F5 64 16 87  \ 80
   lineC, D8 49 3B AA DF 4E 3C AD D6 47 35 A4 D1 40 32 A3 C4 55 27 B6 C3 52 20 B1 CA 5B 29 B8 CD 5C 2E BF  \ A0
   lineC, 90 01 73 E2 97 06 74 E5 9E 0F 7D EC 99 08 7A EB 8C 1D 6F FE 8B 1A 68 F9 82 13 61 F0 85 14 66 F7  \ C0
   lineC, A8 39 4B DA AF 3E 4C DD A6 37 45 D4 A1 30 42 D3 B4 25 57 C6 B3 22 50 C1 BA 2B 59 C8 BD 2C 5E CF  \ E0

create CRC8table_CRC-8/WCDMA ( -- a )   \ Poly = $9B (rev $D9)  Init = $00  Xor = $00  Rev = $00
   lineC, 00 D0 13 C3 26 F6 35 E5 4C 9C 5F 8F 6A BA 79 A9 98 48 8B 5B BE 6E AD 7D D4 04 C7 17 F2 22 E1 31  \ 00
   lineC, 83 53 90 40 A5 75 B6 66 CF 1F DC 0C E9 39 FA 2A 1B CB 08 D8 3D ED 2E FE 57 87 44 94 71 A1 62 B2  \ 20
   lineC, B5 65 A6 76 93 43 80 50 F9 29 EA 3A DF 0F CC 1C 2D FD 3E EE 0B DB 18 C8 61 B1 72 A2 47 97 54 84  \ 40
   lineC, 36 E6 25 F5 10 C0 03 D3 7A AA 69 B9 5C 8C 4F 9F AE 7E BD 6D 88 58 9B 4B E2 32 F1 21 C4 14 D7 07  \ 60
   lineC, D9 09 CA 1A FF 2F EC 3C 95 45 86 56 B3 63 A0 70 41 91 52 82 67 B7 74 A4 0D DD 1E CE 2B FB 38 E8  \ 80
   lineC, 5A 8A 49 99 7C AC 6F BF 16 C6 05 D5 30 E0 23 F3 C2 12 D1 01 E4 34 F7 27 8E 5E 9D 4D A8 78 BB 6B  \ A0
   lineC, 6C BC 7F AF 4A 9A 59 89 20 F0 33 E3 06 D6 15 C5 F4 24 E7 37 D2 02 C1 11 B8 68 AB 7B 9E 4E 8D 5D  \ C0
   lineC, EF 3F FC 2C C9 19 DA 0A A3 73 B0 60 85 55 96 46 77 A7 64 B4 51 81 42 92 3B EB 28 F8 1D CD 0E DE  \ E0

[THEN]

\ ***************************************************************************
\ Known Answer Tests ( KAT )
\ ***************************************************************************

variable v_NextKAT_ptr
variable #failed
variable #failed_total
variable #tested
variable #tested_total

: GetNextKAT ( -- c )
   p_CRC8: @ o_OFFSET_TESTS + v_NextKAT_ptr @ + c@
   1 v_NextKAT_ptr +!
;

$40 constant |TestResults|
|TestResults| Buffer: TestResults[]
variable v_TestResultPtr

: TestResultsC! ( c -- )
   TestResults[] v_TestResultPtr @ |TestResults| 1- and + c!
   1 v_TestResultPtr +!
;

variable v_Silent

\ CRCtest  tests the CRC8 of a string given its correct result u.
: CRCtest_Verbose ( a n -- )
   cr  2 spaces  2dup type  $30 over - 0 max spaces
   CRC8  dup TestResultsC!
   dup 2.hex
   GetNextKAT 2dup = if
      2drop ."  ok"
   else
      ."  <-- should be " 2.hex ."  failed!"  drop  1 #failed +!
   then
   1 #tested +!
;

: CRCtest_Silent ( a n -- )
   CRC8  dup TestResultsC!
   GetNextKAT = not if
      1 #failed +!
   then
   1 #tested +!
;

: CRCtest ( a n -- )
   v_Silent @ if
      CRCtest_Silent
   else
      CRCtest_Verbose
   then
;

: Show_TestSetup ( -- )
   cr ." create " p_CRC8: @ o_OFFSET_NAME + count type
   $17 ToColumn
   ." lineC,  "
   p_CRC8: @     c@ 2.hex 3 spaces
   p_CRC8: @ 1 + c@ 2.hex 3 spaces
   p_CRC8: @ 2 + c@ 2.hex 2 spaces
   p_CRC8: @ 3 + c@ 2.hex 2 spaces
   TestResults[] v_TestResultPtr @ over + swap ?do  i c@ 2.hex space  loop
   [char] " emit space  p_CRC8: @ o_OFFSET_NAME + count type [char] " emit
;

\ some scratchpad contents from the DS18B20                                      \ CRC8
create KAT0[] $08 c,   $38 c, $01 c, $1F c, $1F c, $1F c, $FF c, $1F c, $10 c,   \ $9E c,
create KAT1[] $08 c,   $50 c, $01 c, $1F c, $1F c, $1F c, $FF c, $1F c, $10 c,   \ $55 c,
create KAT2[] $08 c,   $48 c, $01 c, $1F c, $1F c, $1F c, $FF c, $1F c, $10 c,   \ $2B c,
create KAT3[] $08 c,   $68 c, $01 c, $1F c, $1F c, $1F c, $FF c, $1F c, $10 c,   \ $83 c,

\ ttcrc  tests a selection of strings against the known answers listed in the current CRC8: definition line.
: Show_CRC8_test ( n -- )
   >r
   0 v_NextKAT_ptr !
   0 v_TestResultPtr !
   0 #failed !
   0 #tested !
   v_Silent @ not if  cr ." CRC8 tests : "  then
   0 0                                                   CRCtest  v_Silent @ not if  ."  ( 0 length string )"  then
   s" 123456789"                                         CRCtest
   s" the quick brown fox jumps over the lazy dog"       CRCtest
   s" THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG"       CRCtest
   s" 0"                                                 CRCtest
   s" 01"                                                CRCtest
   KAT0[] count                                          CRCtest
   KAT1[] count                                          CRCtest
   KAT2[] count                                          CRCtest
   KAT3[] count                                          CRCtest
   s" An Arbitrary String 012345"                        CRCtest
   s" ABCDEFGHIJKLMNOPQRSTUVWXYZ"                        CRCtest
   s" ZYXWVUTSRQPONMLKJIHGFEDBCA"                        CRCtest
   s" abcdefghijklmnopqrstuvwxyz"                        CRCtest
   s" zyxwvutsrqponmlkjihgfedbca"                        CRCtest
   pad #26 $00 fill pad #26                              CRCtest  v_Silent @ not if  ."  ( 26 bytes of 0 )"  then
   pad #26 $11 fill pad #26                              CRCtest  v_Silent @ not if  ."  ( 26 bytes of hex 11 )"  then
   v_Silent @ not if
      cr  #failed @ if
         ." !!!! Tested " #tested @ . ." strings, of which "  #failed @ . ." failed !!!!"
      else
         ." All " #tested @ . ." tests passed"
      then
   then
   r> Show_TestSetup
   #failed @ #failed_total +!
   #tested @ #tested_total +!
;

: Show_Title ( -- )
   cr ." \                                               |                 ... Test results ...             |"
   cr ." \      Name                  Poly Init  Xor Rev   0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16   Name"
;

: Show_CRC8tests_all ( -- )
   -1 v_Silent !     \ change to 0 to see more detailed results
   decimal
   0 #failed_total !
   0 #tested_total !
   Show_Title
   CRC-8/_             CRC8table_Init  Show_CRC8_test
   CRC-8/CDMA2000      CRC8table_Init  Show_CRC8_test
   CRC-8/DARC          CRC8table_Init  Show_CRC8_test
   CRC-8/DVB-S2        CRC8table_Init  Show_CRC8_test
   CRC-8/EBU           CRC8table_Init  Show_CRC8_test
   CRC-8/I-CODE        CRC8table_Init  Show_CRC8_test
   CRC-8/ITU           CRC8table_Init  Show_CRC8_test
   CRC-8/MAXIM         CRC8table_Init  Show_CRC8_test
   CRC-8/ROHC          CRC8table_Init  Show_CRC8_test
   CRC-8/WCDMA         CRC8table_Init  Show_CRC8_test
   cr  #failed_total @ if
      ." !!!! Tested " #tested_total @ . ." strings, of which "  #failed_total @ . ." failed !!!!"
   else
      ." All " #tested_total @ . ." tests passed"
   then
   cr ."
;

: ttCRC8 ( -- )   \ test to view one CRC-8 calculation in "silent" mode
   page Show_Title
   -1 v_Silent !
   CRC-8/_ CRC8table_Init
   Show_CRC8_test 
   cr
   Show_CRC8table
\   Show_CRC8table_C
;

: ttCRC8V ( -- )  \ test to view one CRC-8 calculation in verbose mode
   cr Show_Title
   0 v_Silent !
   CRC-8/_ CRC8table_Init
   Show_CRC8_test 
   cr
   Show_CRC8table
\   Show_CRC8table_C
;

\ *****************************************************************************
\ CRC-8 calculation using a pre-defined table
\ *****************************************************************************

create CRC8table_CRC-8/_ ( -- a )   \ Poly = $07 (rev $E0)  Init = $00  Xor = $00  Rev = $FF
   lineC, 00 07 0E 09 1C 1B 12 15 38 3F 36 31 24 23 2A 2D 70 77 7E 79 6C 6B 62 65 48 4F 46 41 54 53 5A 5D  \ 00
   lineC, E0 E7 EE E9 FC FB F2 F5 D8 DF D6 D1 C4 C3 CA CD 90 97 9E 99 8C 8B 82 85 A8 AF A6 A1 B4 B3 BA BD  \ 20
   lineC, C7 C0 C9 CE DB DC D5 D2 FF F8 F1 F6 E3 E4 ED EA B7 B0 B9 BE AB AC A5 A2 8F 88 81 86 93 94 9D 9A  \ 40
   lineC, 27 20 29 2E 3B 3C 35 32 1F 18 11 16 03 04 0D 0A 57 50 59 5E 4B 4C 45 42 6F 68 61 66 73 74 7D 7A  \ 60
   lineC, 89 8E 87 80 95 92 9B 9C B1 B6 BF B8 AD AA A3 A4 F9 FE F7 F0 E5 E2 EB EC C1 C6 CF C8 DD DA D3 D4  \ 80
   lineC, 69 6E 67 60 75 72 7B 7C 51 56 5F 58 4D 4A 43 44 19 1E 17 10 05 02 0B 0C 21 26 2F 28 3D 3A 33 34  \ A0
   lineC, 4E 49 40 47 52 55 5C 5B 76 71 78 7F 6A 6D 64 63 3E 39 30 37 22 25 2C 2B 06 01 08 0F 1A 1D 14 13  \ C0
   lineC, AE A9 A0 A7 B2 B5 BC BB 96 91 98 9F 8A 8D 84 83 DE D9 D0 D7 C2 C5 CC CB E6 E1 E8 EF FA FD F4 F3  \ E0

\ CRC-8 calculation using a pre-defined table
: CRC8_const ( a n -- c )   \ calculates the CRC8 of the given string using the parameters in the CRC8: definition string stored in p_CRC8:
   ( Init ) $00  -rot  \ v_CRC8 c!      \ initialises the output CRC value in the required way
   over + swap ?do
      i c@
      xor CRC8table_CRC-8/_ + c@
   loop
  \ ( Xor ) $00 xor     \ no need to do this if the value is 0
;

: tt_CRC8_const ( -- )
   cr ." tt_CRC8_const : " 
   s" 123456789" CRC8_const $F4 = if  ." Passed "  else  ." Failed!!!"  then 
;

\ *****************************************************************************
\ *****************************************************************************

cr .( Show_CRCtables_all , Show_CRCtables_all_C or Show_CRC8tests_all )
cr .( Also tt_CRC8_const, ttCRC8 or ttCRC8V )
cr
