# zip
Create non-compressed archives which obey most of the PKZip format rules.

## Installation
This package is hosted on [the Forth Net as package 'zip'](https://theforth.net/package/zip),
so you can install it by:

`fget zip 0.1.0`

## Usage / Words
### `zip[ ( c-addr-filename n-filename -- )`
create zip-archive

### `zip-write-dir ( c-addr-dirname n-dirname -- )`
create directory entry

### `zip-write-file ( c-addr-filename n-filename -- )`
create file entry

### `]zip ( -- )`
end archive, write central directoy and cleanup (delete temporary file)

## Example
```forth
s" test.zip" zip[
    s" f-test/" 0 zip-write-dir
    s" f-test/main.4th" zip-write-file
    s" f-test/package.4th" zip-write-file
]zip
```

## Motivation
This package is a bare minimum implementation of the PKZip format to allow easy package upload to [the Forth Net](https://theforth.net) via [fput](https://theforth.net/packages/fput).

## Incomplete!
The resulting zip-file is not up to spec. Reading through [The structure of a PKZip file](https://users.cs.jmu.edu/buchhofp/forensics/formats/pkzip.html)
and [.ZIP File Format Specification](https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT), I stopped programming as soon as the zip file was readable by node.js (used on [the Forth Net](https://theforth.net)).

Your [contribution is very welcome](https://github.com/GeraldWodni/zip), as this is a mere husk for creating zip-files ;)

__TODO:__
- CRC-32 checksum (should be a separate package like CRC-8)
- Compatibility testing (make it work with unzip under linux for starters)
