I2C
===

Matthias Trute <<mtrute@web.de>>
Version 1.0.0 - 2016-09-27

This package provides some more or less
generic I2C related words. They are generic
in a sense that they depend on a low level
hardware driver, that provides some very
basic routines to access the I2C interface.
They are still specific to amforth, visit
http://amforth.sourceforge.net/TG/recipes/I2C-Generic.html

They are tested with amforth on an Atmega with
it's hardware I2C module called TWI.

i2c.frt
-------

above the specific driver words some generic but
still low level words.

  i2c.begin         -- starts a I2C bus cycle
  i2c.end           -- ends a I2C bus cycle
  i2c.n>            -- send n bytes to device   (n> means from data stack)
  i2c.>n            -- read n bytes from device (>n means to data stack)


i2c-detect
----------

This command scans the bus and prints a small
overview over the addresses that respond to 
the ping.

 (ATmega1280)> i2c.detect 
       0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
  0:                       -- -- -- -- -- -- -- -- --
 10:  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 20:  -- -- -- -- -- -- -- 27 -- -- -- -- -- -- -- --
 30:  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 40:  -- -- 42 -- -- -- -- -- -- -- -- -- -- -- -- --
 50:  50 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 60:  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
 70:  -- -- -- -- -- -- -- --                        
  ok

The tool and the output is designed to mimic a linux
tool of the same name.

i2c-eeprom*
-----------

The 24Cxx chips using 2 byte addresses are supported. The
interface uses the block wordset API. The API transfers the
standard block size to a fixed block buffer defined outside
of this package.

