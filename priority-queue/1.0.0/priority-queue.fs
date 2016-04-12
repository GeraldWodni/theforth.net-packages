\ Priority Queue                                   uh 2016-02-21

\ Items that we store in the priority queue are double cell entries.
\ First cell is priority, second cell is value or pointer to a larger
\ data structure.

: q-items ( n -- units )  2 cells * ;
: q-item! ( x1 ... xn addr )  2! ;
: q-item@ ( addr -- x1 ... xn )  2@ ;
: q-item+ ( addr -- addr' )  1 q-items + ;

\ Defining word Priority-Queue:

: Priority-Queue: ( maxsize -- ) 
     \ { maxsize size item_0 item_1 ... item_size-1 }
     \           ^q-start                          ^q-end
     Create dup , 0 , q-items allot ;

\ First field holds maximum size of priority queue
: q-maxsize ( q -- max-size )  @ ;

\ Second field holds actual size of priority queue
: q-'size ( q -- 'size ) cell+ ;
: q-size ( q -- u ) q-'size @ ;
: q-empty? ( q -- f ) q-size 0= ;
: q-clear ( q -- ) 0 swap q-'size ! ;
: q-full? ( q -- )  dup q-size  swap q-maxsize < 0= ;

\ throw values for priority queue exceptions
-5000 Constant #Q-UNDERFLOW
-5001 Constant #Q-OVERFLOW

: ?q-underflow ( q -- ) q-empty? IF #Q-UNDERFLOW throw THEN ;
: ?q-overflow ( q -- )  dup q-size  swap q-maxsize < IF EXIT THEN #Q-OVERFLOW throw ;

\ The following cells hold the queue items
: q-start ( q -- addr ) 2 cells + ;

: q-end ( q -- addr ) \ address of 1st item beyond queue
    dup q-start swap q-size q-items + ;


: q-drop ( q -- )  \ remove front item from queue
    dup ?q-underflow
    -1 over q-'size +! 
    dup >r  q-start dup q-item+ swap  r> q-size q-items cmove ; 

: q@ ( q -- key val ) \ retrieve front item from queue
    dup ?q-underflow  dup >r q-start q-item@   r> q-drop ;

: q-find ( key q -- addr ) \ find address of first item with higher priority
    dup q-end swap q-start ?DO ( key )
        dup  I q-item@ drop  < IF drop I UNLOOP EXIT THEN
    1 q-items +LOOP 
    drop 0 ;

: q-append ( key val q -- )  \ append item at end of queue
    dup ?q-overflow
    dup >r    q-end q-item!   1 r> q-'size +! ;

: q! ( key val q -- )  \ store item in queue according to its priority
    dup ?q-overflow
    2 pick  over  q-find dup IF ( key val q addr ) \ insert item
       over 1 swap q-'size +!  dup >r dup q-item+  rot q-end over - cmove>
       r> q-item! 
       EXIT
    THEN
    drop q-append 
;

: q. ( q -- ) \ show text representation
    cr ." <priority-queue adr='" dup 0 u.r ." ' max-size='" dup q-maxsize 0 u.r ." '>" cr
    dup q-end swap q-start ?DO 
        I q-item@ swap
        ."    <q-item key='" 0 u.r ." '"
        ."  value='" 0 u.r ." '/>" 
        cr
    1 q-items +LOOP
    ." </priority-queue>" ;

cr .( Priority Queue )

