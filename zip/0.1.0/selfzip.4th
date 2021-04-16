\ zip this package using itself, quite inceptionesque ;)
\ usage: ln -s this package to the parent directory, like so: `cd ..; ln -s zip/selfzip.4th .`
\        then run it i.e. `gforth selfzip.4th`

include zip/zip.4th

s" zip.zip" zip[
    s" zip/" zip-write-dir
    s" zip/zip.4th" zip-write-file
    s" zip/package.4th" zip-write-file
    s" zip/selfzip.4th" zip-write-file
]zip
