Priority Queue Glossary
=======================

#Q-UNDERFLOW ( -- x )
---------------------
The throw number that priority queues throw on underflow, i.e. if you
try to fetch a value from an empty priority queue.

#Q-OVERFLOW ( -- x )
--------------------
The throw number that priority queues throw on overflow, i.e. if you
try to append or store a value to a priority queue that has reached its capacity.


Priority-Queue: ( maxsize `<name>` -- )
-------------------------------------
Define a new priority queue named **`<name>`** with the capacity **maxsize**.
When later `<name>` is executed it leaves its address on the data stack.

q! ( key val q -- )
-------------------
Store an item consisting of the priority **key** and the value **val** 
into the the priority queue **q** using the priority to determine its position.
If the priority queue has reached its capacity, then throw a #Q-OVERFLOW exception.

q. ( q -- )
-----------
Display a text representation of the priority queue **q**. Useful for debugging.

q@ ( q -- key val )
-------------------
Retrieve the first item - priority **key** and value **val** -- from the priority queue **q**.
If the queue is empty, throw a #Q-UNDERFLOW exception.

q-append ( key val q -- )
-------------------------
Append an item consisting of the priority **key** and the value **val** to the
end of the priority queue **q**, regardless of the priority value. 
If the priority queue has reached its capacity, then throw a #Q-OVERFLOW exception.

q-clear ( q -- )
----------------
Remove all items from the priority queue **q**.

q-drop ( q -- )
---------------
Remove the first item from the priority queue **q**. If the queue is empty, throw a #Q-UNDERFLOW exception.

q-empty? ( q -- f )
-------------------
Return true if the priority queue **q** is empty, false otherwise.

q-full? ( q -- f )
-------------------
Return true if the priority queue **q** is completely filled up, false otherwise.


q-size ( q -- u )
-----------------
Get the number of items **u** actually in the priority queue **q**.
