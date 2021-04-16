\ ZIP0 - creates a non-compressed archive
\ (c) copyright 2021 by Gerald Wodni <gerald.wodni@gmail.com>

\ modelled after zip -0 -r ftest.zip f-test
\ reference used: https://users.cs.jmu.edu/buchhofp/forensics/formats/pkzip.html
marker z

variable zip-fd     \ main zip file
variable zip-cfd    \ temporary file which contains central dictionary
variable zip-buffer \ write buffer
variable zip-entries \ number of zip-entries in this archive
variable zip-central-start \ start of central dictionary

2variable zip-filename \ current filename

create zip-local-signature
\ *G PKZip local file signature
    CHAR P c, CHAR K c, 3 c, 4 c, $a c, 0 c,
6 constant /zip-local-signature

create zip-central-signature
\ *G PKZip central file signature
    CHAR P c, CHAR K c, 1 c, 2 c, $1e c, 3 c, $a c, 0 c,
8 constant /zip-central-signature

create zip-end-central-signature
\ *G PKZip end of central directory signature
    CHAR P c, CHAR K c, 5 c, 6 c,
4 constant /zip-end-central-signature

: (zip-write) ( c-addr n -- )
    \ write to current zip-fd
    zip-fd @ write-file throw ;

: (zip-cwrite) ( c-addr n -- )
    \ write to current zip-cfd
    zip-cfd @ write-file throw ;

: (zip-buffer-write) ( n -- )
    \ write n bytes from zip-buffer to zip-fd
    >r zip-buffer r> (zip-write) ;

: (zip-buffer-cwrite) ( n -- )
    \ write n bytes from zip-buffer to zip-cfd
    >r zip-buffer r> (zip-cwrite) ;

: (zip-buffer-[c]write) ( n -- )
    \ write n bytes from zip-buffer to zip-fd and zip-fid
    dup (zip-buffer-write)
        (zip-buffer-cwrite) ;

: zip-write-header ( -- )
    \ *G write zip-file header
    \ TODO: save file entry for glossary

    1 zip-entries +!
    \ signature & version
    zip-local-signature /zip-local-signature (zip-write)
    zip-central-signature /zip-central-signature (zip-cwrite)
    \ flags (none)
    0 zip-buffer ! 2 (zip-buffer-[c]write)
    \ compression (none)
    2 (zip-buffer-[c]write)
    \ modification time (useless), fixed at (14:20:00)
    $14E0 zip-buffer w! 2 (zip-buffer-[c]write)
    \ modification date (useless), fixed at (1985-06-15)
    $CF05 zip-buffer w! 2 (zip-buffer-[c]write) ;

: zip-write-file-header ( c-addr-filename n-filename n-filesize x-checksum -- )
    zip-write-header
    \ checksum
    zip-buffer l! 4 (zip-buffer-[c]write)
    \ size (compressed)
    zip-buffer l! 4 (zip-buffer-[c]write)
    \ size (uncompressed) no compression is used, hence same as above
    4 (zip-buffer-[c]write)
    \ file-name length
    dup zip-buffer w! 2 (zip-buffer-[c]write)
    \ extra-field length (not used)
    0 zip-buffer ! 2 (zip-buffer-[c]write)
    \ filename
    (zip-write) ;

: zip-write-dir ( c-addr-dirname n-firname -- )
    0 0 zip-write-file-header ;

: zip-filesize&checksum ( fd -- n-filesize x-checksum )
    dup file-size throw drop
    swap drop
    $12345678 \ pseudo checksum
    ;

: zip-copy-content ( fd-in -- )
    \ write content of fd to zip-fd
    \ copy content
    begin
        dup zip-buffer cell rot read-file throw dup
    while
        (zip-buffer-write)
    repeat 2drop ;

: zip-write-file ( c-addr-filename n-filename -- )
    2dup r/o open-file throw >r

    r@ zip-filesize&checksum zip-write-file-header
    \ copy content
    r@ zip-copy-content

    r> close-file throw ;

: overwrite-extension ( c-addr-filename n-filename c-addr-extension n-extension -- )
    \ Overwrite file extension in filename
    2>r
    r@ - + \ remove extension (i.e. ".zip")
    2r> ( c-addr-filename-without-ext c-addr-extension n-extension )
    >r swap r> cmove \ overwrite (i.e. ".tmp")
    ;

: zip[ ( c-addr-filename n-filename -- )
    \ *G start zipfile, use zip-write-dir and zip-write-file inside.
    \ ** Filename must end with ".zip"
    0 zip-entries !
    2dup zip-filename 2!
    2dup w/o create-file throw zip-fd !     \ zip archive
    2dup s" .tmp" overwrite-extension \ overwrite ".zip" with ".tmp"
         r/w create-file throw zip-cfd !    \ temporary file for central directory
    ;

: zip-write-footer ( -- )
    \ save length of central directory
    zip-fd @ file-position throw drop >r

    \ signature & version
    zip-end-central-signature /zip-end-central-signature (zip-write)
    \ number of this disk
    0 zip-buffer !
    2 (zip-buffer-write)
    \ number of directory start disk
    2 (zip-buffer-write)
    \ zip entries on this disk
    zip-entries @ zip-buffer w! 2 (zip-buffer-write)
    \ zip entries in total
    2 (zip-buffer-write)

    \ size of central directory
    r> zip-central-start @ -
    zip-buffer l! 4 (zip-buffer-write)

    \ offset of central directory
    zip-central-start @ zip-buffer l! 4 (zip-buffer-write)

    \ comment length=0
    0 zip-buffer !
    2 (zip-buffer-write)
    ;

: ]zip ( -- )
    \ *G close zipfile (write central dictionary, clean temp file)
    
    \ save offset of central directory
    zip-fd @ file-position throw drop zip-central-start !

    \ copy central directory (from temp file)
    0 0 zip-cfd @ reposition-file throw
    zip-cfd @ zip-copy-content

    \ write end of central directory
    zip-write-footer

    \ cleanup
    zip-cfd @ close-file throw
    zip-fd @ close-file throw
    zip-filename 2@ delete-file throw               \ delete temp file
    zip-filename 2@ s" .zip" overwrite-extension    \ rename back to zip
    ;
