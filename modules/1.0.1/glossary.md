Modules Glossary
================

END-MODULE ( old-current -- )
-----------------------------
End a module definition. All module internal words are no longer accessible.
Only words that have been `EXPORT`ed are still available.


EXPORT ( <name> old-current -- old-currrent )
---------------------------------------------
Make the word named __name__ accessible outside the module currently defined.
After ´END-MODULE` this word is still available.


EXPOSE-MODULE ( <name> -- )  
---------------------------
Make all internal words of the module named __name__ available.


MODULE          ( <name> -- old-current )
-----------------------------------------
Start the definition of a new module named __name__.
