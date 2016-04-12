Priority Queue
==============

Ulrich Hoffmann <<uho@xlerb.de>>

Version 1.0.0 - 2016-02-21

This package provides an implementation of priority queues for standard 
Forth-94 and Forth-2012 compliant systems.

A priority queue is an abstract data type that allows to store items along with a priority
and to retrieve these items in order of their prioriority.

## Installation

To use the priority queue data structure, just `INCLUDE priority-queue.fs` on any standard system. 
This makes the defining word `Priority-Queue:` and the priotioty queue accessor
words available. After loading you still have a standard system.

The items that are stored in the queues are double cell values, the priority along with a single cell
value, that can be either the value of interest itself or a pointer to the data.

## Documentation

See the file [**glossary.md**](glossary.md) for a description of the defined words.

## Example usage

Here are some examples how to use priority queues (actually from the unit tests):

    Test,_that 

       10 Priority-Queue: q  \ define priority queue of size 10
    
       \ fill queue with some items
       10 ( prio )  100 ( val )  q q-append
       20 ( prio )  200 ( val )  q q-append
       30 ( prio )  300 ( val )  q q-append

       \ insert new value at appropriate position according to its priority 
       25 ( prio )  250 ( val ) q q!

       \ retrieve priorities and values in priority order (lowest first)
       q q@   ( 10 100 )
       q q@   ( ... 20 200 )
       q q@   ( ... 25 250 )
       q q@   ( ... 30 300 )
    
    has 

       10 100   20 200   25 250    30 300

    as_result.


    Test,_that  ( priority queues raise an error on underflow )
    
       3 Priority-Queue: q  \ define priority queue of size 3

       \ fetch empty priority queue
       q ' q-drop catch  nip

    has
   
       #Q-UNDERFLOW

    as_result.


    Test,_that ( priority queues raise an error on overflow )

       3 Priority-Queue: q  \ define priority queue of size 3

       \ fill priority queue with more items than it can hold
       1 10 q ' q-append catch  ( ok )
       2 20 q ' q-append catch  ( ok ) 
       3 30 q ' q-append catch  ( ok )
       4 40 q ' q-append catch  ( 4 40 q err ) nip nip nip  

    has

       0 0 0 #Q-OVERFLOW 

    as_result.

## Bug Reports

Please send bug reports, improvements and suggestions to Ulrich Hoffmann <<uho@xlerb.de>>

## Conformance

This program conforms to Forth-94 and Forth-2012

May the Forth be with you!
