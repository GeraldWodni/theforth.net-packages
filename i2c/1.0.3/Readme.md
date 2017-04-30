I2C
===

Matthias Trute <mtrute@web.de>
Version 1.0.3 - 2017-04-30

This package provides some more or less
generic I2C related words. They are generic
in a sense that they depend on a low level
hardware driver, that provides some very
basic routines to access the I2C interface.
They are based on the amforth recipe 
http://amforth.sourceforge.net/TG/recipes/I2C-Generic.html

They are tested with amforth on an Atmega with
it's hardware I2C module called TWI.

The driver uses the following hardware low level words, that
the user has to provide.

i2c.wait ( -- )
  wait for the bus

i2c.start ( -- )
  send start condition

i2c.stop ( -- )
  send stop condition

i2c.restart ( -- )
  send the restart condition

i2c.tx ( c -- )
  send 1 byte

i2c.rx ( -- c )
  receive 1 byte, send ACK

i2c.rxn ( -- c )
  receive 1 byte, send NACK

The following two words are not essential but
are useful for tools and checks.

i2c.status ( -- n )
  get i2c status in a system specific way

i2c.ping?   ( addr -- f )
  detect the presence of a device on the bus, f is true if a device
  at addr responds

i2c.frt
-------

above the specific driver words some generic but
still low level words.

    i2c.begin         -- starts a I2C bus cycle
    i2c.end           -- ends a I2C bus cycle
    i2c.n!            -- send n bytes to device
    i2c.n@            -- read n bytes from device


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

