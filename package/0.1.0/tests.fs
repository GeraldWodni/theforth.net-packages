package example

defer text
: ex1  s" This is an example" ;
' ex1 is text

PUBLIC

: .example ( -- )  text cr type ;

PRIVATE

: ex2  s" This is an example (cont.)" ;

END-PACKAGE


: tests ( -- )
  ." (1) Expected: This is an example"
  s" .example" evaluate cr cr

  ." (2) Expected: -13 (or in ciforth: 10)"
  s" ex1" ['] evaluate catch nip nip cr . cr cr

  ." (3) Expected: This is an example (cont.)"
  s" package example ' ex2 is text end-package .example" evaluate cr cr
;
