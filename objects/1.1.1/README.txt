This directory contains my structure and objects packages for Forth
and articles about them.

The files are:

struct.fs	the structures package
objects.fs	the objects package
objexamp.fs	test code for the objects package
fifo-example.fs	a more elaborate example using the package
structs.html	Documentation on the structure package
objects.html	Documentation on the objects package
opinion.html	my opinion on the Neon model and about standardizing OO Forth

You can get this whole directory from
http://www.complang.tuwien.ac.at/forth/objects.zip.

NEWS in version 1.1.0:

Class and interface internal data is now stored in the dictionary for
persistence across system-saving.

Testing:

You can test the package by loading struct.fs, then objects,fs, then
objexamp.fs. The output should look similar to this:
------------
??? ??? Forth Forth Root     ??? 
??? ??? Forth Forth Root     Forth 
??? ??? Forth Forth Root     Forth 

protected2 protected1 n 
Forth Forth Root     Forth 

object:6997952 class:140737331402224 
undefined
0 1 4 4 
object:140737331403496 class:140737331403208 
object:140737331403496 class:140737331403208 
3 
xcounter object:140737331406224 class:140737331404584 made another ten
xcounter object:140737331406224 class:140737331404584 made another ten
20 23 
0 
0 
2 
4 
5 6 
<0> 
-------------
- anton
--
M. Anton Ertl                    Some things have to be seen to be believed
anton@mips.complang.tuwien.ac.at Most things have to be believed to be seen
http://www.complang.tuwien.ac.at/anton/home.html
