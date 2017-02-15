\ Demo for using the library with Mecrisp on an MSP430G2553
\ (c)copyright 2017 by Gerald Wodni<gerald.wodni@gmail.com>

\ Wiring:
\ LCD    uC
\ D4  -- P2.0
\ D5  -- P2.1
\ D6  -- P2.2
\ D7  -- P2.3
\ RS  -- P2.4
\ E   -- P2.5

\ RW  -- GND

compiletoflash

\ Ports
$29 constant P2OUT
$2A constant P2DIR

: init-ports
    $3F P2OUT c!
    $3F P2DIR c! ;

: lcd-mode-data ( -- )
    $10 P2OUT cbis! ;

: lcd-mode-cmd ( -- )
    $10 P2OUT cbic! ;

: lcd-nibble ( x -- )
    $F P2OUT cbic!      \ clear data
    $F and P2OUT cbis!  \ set data
    1 us
    $20 P2OUT cbic!     \ pulse E
    4 us
    $20 P2OUT cbis!
    43 us ;

#include hd44780.4th

\ swap-dragon image (3 by 2 custom chars)
create d0 $00 c, $02 c, $03 c, $07 c, $06 c, $00 c, $00 c, $0C c,
create d1 $00 c, $00 c, $00 c, $00 c, $11 c, $11 c, $0A c, $1B c,
create d2 $00 c, $08 c, $18 c, $1C c, $0C c, $00 c, $00 c, $0C c,
create d3 $1F c, $1D c, $18 c, $10 c, $00 c, $00 c, $00 c, $00 c,
create d4 $1B c, $1F c, $1F c, $0E c, $0A c, $0A c, $1B c, $00 c,
create d5 $1F c, $17 c, $03 c, $01 c, $00 c, $00 c, $00 c, $00 c,

: demo
    init-ports \ set ports
    2 lcd-init \ 2 line lcd
    d0 0 lcd-char \ transmit dragon custom chars
    d1 1 lcd-char
    d2 2 lcd-char
    d3 3 lcd-char
    d4 4 lcd-char
    d5 5 lcd-char
    lcd" theforth.net   "
    0 lcd-emit 1 lcd-emit 2 lcd-emit
    $40 lcd-ddram \ 2nd line
    lcd" /lcd-hd44780   "
    3 lcd-emit 4 lcd-emit 5 lcd-emit ;
