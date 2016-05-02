\ mwords : list all words of current wordlist that match a parsed string
\ voc-mwords : list all matching words in all wordlists
\ April 2016 mb
\ Reason why and hints how to use are in readme.md
\ I spend much efforts on the formatting of the outputs. Unfortunately gforth has no word to ask for the
\ position of the cursor. This is due to the underlying terminal.
\ Without success my first try was to hook in the deferred words emit, type an cr. But as there are many 
\ 'ghost' chars this fails. So I take a similar approach as the original .word used by words.
\ I tried to comment heavily. Hope that someone will enjoy this.
\ All helper word are hidden in mwords-hide

get-current 				\ get wid of current wordlist; wid is on TOS
vocabulary mwords-hide 			\ create a wordlist 'mwords-hide'
also mwords-hide 			\ put it into the search order
definitions				\ make it the compilation wordlist


: UPPERCASE ( c-str u -- )		\ changes all chars of c-str to upper case
  0 ?DO count toupper over 1- c! 
    LOOP drop ; 

: target$ ( -- c-str u )		\ string to hit
   here count ;
   
: name$ ( -- c-str u )			\ name string of actual word   
   here count + count ; 

: match? ( nt -- flag )			\ matches the name token the target sting? 
    name>string 			\ get the corresponding sting and 
    target$ + place 			\ place as 2nd string to here
    name$ 2dup UPPERCASE 		\ capitalize it
    target$				\ string to match to is here
    search nip nip  ;			\ part of 2nd string?
    
: target ( /str -- )			\ reads string to match to from input     
    bl word count 2dup UPPERCASE 	\ in gforth the parsed word is in here
    here place  ; 			\ but could we rely on it?
    
\ ********** formatting words *************************************    
    
5 Value margin  			\ left margin for formatted output
  
: cr+margin ( -- n )     		\ start a new line beginning at position of margin
  cr margin dup spaces ;
  
: new_pos ( n -- n' )			\ look into the glass bowl where the new (cursor) position will be
   name$ nip 1+ + 			\ new position (old pos + length of name string + space)
   dup cols margin - > 			\ will reach end of line?
   IF drop cr+margin name$ nip + 	\ if --> cr 
   THEN ; 		
   
\ ********** the searching routines *******************************   
    
: .mword ( x-pos nt -- x-pos )		\ prints the name of current word in wordlist if it matches the target
   dup					\ duplicate the name token
   match?  				\ does it match?
   IF swap new_pos swap .name 		\ if print it
   ELSE drop 				\ else drop name token
   THEN ;				\ finish

: exist-mword? ( flag flag nt -- flag )	\ 'match?' version fitting to traverse-wordlist    
   match?    				\ old match?
   IF    drop true false  		\ drop flag leave one flag for traverse-wordlist one for further use
   ELSE  true 				\ didn’t match so true tells traverse-wordlist to go on 
   THEN ; 				\ finish
   
: mwords? ( wid -- flag ) 		\ looks if there is at least one word in wordlist (wid) that matches 
  false 				\ if this flag isn’t changed later there is no matching word 
  ['] exist-mword? 			\ xt of searching routine
  rot traverse-wordlist ; 		\ traverse-wordlist will use the above xt with the given wid
  
: .voc-mword ( wid -- ) 		\ formatted list of matching words of wordlist wid
  dup mwords?				\ duplicate wid and look if there is at least one word in wordlist (wid) that matches
  IF dup cr ." Vocabulary: " .voc	\ if print name of wordlist
     cr+margin 				\ new line with margin
     swap ['] .mword map-wordlist drop 	\ list matching words
  ELSE 	drop   				\ if not drop duplicated wid
  THEN ; 				\ finish

\ ********** the main words: mwords and voc-mwords *******************************  

set-current 				\ restore original (i.e., public) compilation wordlist

: mwords ( / "STR" -- )			\ list all words of current wordlist that match the parsed string
  target				\ parse sting to here
  cr+margin get-current			\ new line with margin, get wid of current wordlist
  ['] .mword map-wordlist drop ;	\ map wordlist executes .mwords  

: voc-mwords ( / "STR" -- )		\ list all matching words in all wordlists
  target 				\ parse sting to here
  ['] .voc-mword map-vocs ;   		\ map-vocs will excute .voc-mword
  
previous 				\ restore original search order (helper words become invisible)
  
\ ********** primary versions with minor formatting ******************************* 
\\\    
: .voc-mword ( wid -- ) 
  dup 
  cr ." Vocabulary: " .voc 
  25 swap ['] .mword map-wordlist drop ; 
  
: voc-mwords ( / "STR" -- )
  bl word count 2dup UPPERCASE here place
  ['] .voc-mword map-vocs ; 
  

    