\ libcurl.4th - Libcurl easy interface

((
Copyright (c) 2017
MicroProcessor Engineering
133 Hill Lane
Southampton SO15 5AF
England

tel:   +44 (0)23 8063 1441
fax:   +44 (0)23 8033 9691
email: mpe@mpeforth.com
       tech-support@mpeforth.com
web:   http://www.mpeforth.com
Skype: mpe_sfp

The Community editions of MPE software are released for non-
commercial use only. If you sell an application written with MPE
software, that is commercial use. If you are paid to write
software with MPE software, that is commercial use. If you are a
teacher and want to use MPE software in a class, that is
commercial use, so contact us and ask for written permission.

You convert a Community edition licence to commercial use by
buying an MPE software licence. You will gain additional code
and technical support.

First line contact for support of the community edition should
be to
  jermaine.davies@gmail.com

The VFX Forth Community editions would not exist without the
contributions of
  Construction Computer Software
  Gerald Wodni
  Jermaine Davies

To do
=====

Change history
==============
20170422 JED001 Initial commit - focusing on the easy interface.
))

((
/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2017, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at https://curl.haxx.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ***************************************************************************/
))

only forth definitions
decimal

\ ==========
\ *! Libcurl
\ *T LibCurl
\ ==========
\ *P libcurl is a free and easy-to-use client-side URL transfer library, 
\ ** supporting DICT, FILE, FTP, FTPS, Gopher, HTTP, HTTPS, IMAP, IMAPS, 
\ ** LDAP, LDAPS, POP3, POP3S, RTMP, RTSP, SCP, SFTP, SMTP, SMTPS, Telnet 
\ ** and TFTP. libcurl supports SSL certificates, HTTP POST, HTTP PUT, FTP 
\ ** uploading, HTTP form based upload, proxies, cookies, user+password 
\ ** authentication (Basic, Digest, NTLM, Negotiate, Kerberos), file transfer 
\ ** resume, http proxy tunneling and more! 
\ ** If you have libcurl problems, all docs and details are to
\ ** be found at:
\ *C   http://curl.haxx.se/libcurl/

library: libcurl.dll

  ALSO TYPES DEFINITIONS

: LPCURL      void  * ;
: CURLoption int ;
: CURLINFO   int ;
: CURLcode   int ;
: LPCurl_version_info_data void * ;
: CURLversion int ;
: LPCurl_slist void * ;

  PREVIOUS DEFINITIONS

\ ===========================
\ *S Easy interface functions
\ ===========================

Extern: void "c" curl_easy_cleanup(LPCURL handle); 
\ *G End a libcurl easy handle.

Extern: void "c" curl_easy_reset(xparam );

Extern: LPCurl "c" curl_easy_init( );
\ *G Start a libcurl easy session. 

Extern: CURLcode "c" curl_easy_perform(LPCurl easy_handle);
\ *G Perform a blocking file transfer.

Extern: CURLcode "c" curl_easy_setopt(LPCurl handle, CURLoption option, void * parameter);
\ *G Set options for a curl easy handle. 

Extern: CURLcode "c" curl_easy_getinfo(LPCurl curl, CURLINFO info, void * output);
\ *G Extract information from a curl handle.

Extern: LPCurl_version_info_data "c" curl_version_info(CURLversion type )
\ *G Returns run-time libcurl version info.

Extern: char * "c" curl_version( );
\ *G Returns the libcurl version string. 

Extern: LPCurl_slist "c" curl_slist_append(LPCurl_slist list, const char * string );
\ *G Add a string to an slist.

Extern: void "c" curl_slist_free_all(LPCurl_slist list);

\ ============
\ *S Constants
\ ============

\   /* This is the FILE * or void * the regular output should be written to. */
   10001 CONSTANT CURLOPT_FILE

\   /* The full URL to get/put */
   10002 CONSTANT CURLOPT_URL

\   /* Port number to connect to, if other than default. */
   3     CONSTANT CURLOPT_PORT

\   /* Name of proxy to use. */
   10004 CONSTANT CURLOPT_PROXY

\   /* "name:password" to use when fetching. */
   10005 CONSTANT CURLOPT_USERPWD

\   /* "name:password" to use with proxy. */
   10006 CONSTANT CURLOPT_PROXYUSERPWD

\   /* Range to get, specified as an ASCII string. */
   10007 CONSTANT CURLOPT_RANGE

\   /* Specified file stream to upload from (use as input): */
   10009 CONSTANT CURLOPT_INFILE

\   /* Buffer to receive error messages in, must be at least CURL_ERROR_SIZE
\    * bytes big. If this is not used, error messages go to stderr instead: */
   10010 CONSTANT CURLOPT_ERRORBUFFER

\   /* Function that will be called to store the output (instead of fwrite). The
\    * parameters will use fwrite() syntax, make sure to follow them. */
   20011 CONSTANT CURLOPT_WRITEFUNCTION

\   /* Function that will be called to read the input (instead of fread). The
\    * parameters will use fread() syntax, make sure to follow them. */
   20012 CONSTANT CURLOPT_READFUNCTION

\   /* Time-out the read operation after this amount of seconds */
   13    CONSTANT CURLOPT_TIMEOUT

\   /* If the CURLOPT_INFILE is used, this can be used to inform libcurl about
\    * how large the file being sent really is. That allows better error
\    * checking and better verifies that the upload was successful. -1 means
\    * unknown size.
\    *
\    * For large file support, there is also a _LARGE version of the key
\    * which takes an off_t type, allowing platforms with larger off_t
\    * sizes to handle larger files.  See below for INFILESIZE_LARGE.
\    */
   14    CONSTANT CURLOPT_INFILESIZE

\   /* POST static input fields. */
   10015 CONSTANT CURLOPT_POSTFIELDS

\   /* Set the referrer page (needed by some CGIs) */
   10016 CONSTANT CURLOPT_REFERER

\   /* Set the FTP PORT string (interface name, named or numerical IP address)
\      Use i.e '-' to use default address. */
   10017 CONSTANT CURLOPT_FTPPORT

\   /* Set the User-Agent string (examined by some CGIs) */
   10018 CONSTANT CURLOPT_USERAGENT

\   /* If the download receives less than "low speed limit" bytes/second
\    * during "low speed time" seconds, the operations is aborted.
\    * You could i.e if you have a pretty high speed connection, abort if
\    * it is less than 2000 bytes/sec during 20 seconds.
\    */
\
\   /* Set the "low speed limit" */
   19    CONSTANT CURLOPT_LOW_SPEED_LIMIT

\   /* Set the "low speed time" */
   20    CONSTANT CURLOPT_LOW_SPEED_TIME

\   /* Set the continuation offset.
\    *
\    * Note there is also a _LARGE version of this key which uses
\    * off_t types, allowing for large file offsets on platforms which
\    * use larger-than-32-bit off_t's.  Look below for RESUME_FROM_LARGE.
\    */
   21    CONSTANT CURLOPT_RESUME_FROM

\   /* Set cookie in request: */
   10022 CONSTANT CURLOPT_COOKIE

\   /* This points to a linked list of headers, struct curl_slist kind */
   10023 CONSTANT CURLOPT_HTTPHEADER

\   /* This points to a linked list of post entries, struct curl_httppost */
   10024 CONSTANT CURLOPT_HTTPPOST

\   /* name of the file keeping your private SSL-certificate */
   10025 CONSTANT CURLOPT_SSLCERT

\   /* password for the SSL or SSH private key */
   10026 CONSTANT CURLOPT_KEYPASSWD

\   /* send TYPE parameter? */
   27    CONSTANT CURLOPT_CRLF

\   /* send linked-list of QUOTE commands */
   10028 CONSTANT CURLOPT_QUOTE

\   /* send FILE * or void * to store headers to, if you use a callback it
\      is simply passed to the callback unmodified */
   10029 CONSTANT CURLOPT_WRITEHEADER

\   /* point to a file to read the initial cookies from, also enables
\      "cookie awareness" */
   10031 CONSTANT CURLOPT_COOKIEFILE

\   /* What version to specifically try to use.
\      See CURL_SSLVERSION defines below. */
   32    CONSTANT CURLOPT_SSLVERSION

\   /* What kind of HTTP time condition to use, see defines */
   33    CONSTANT CURLOPT_TIMECONDITION

\   /* Time to use with the above condition. Specified in number of seconds
\      since 1 Jan 1970 */
   34    CONSTANT CURLOPT_TIMEVALUE

\   /* Custom request, for customizing the get command like
\      HTTP: DELETE, TRACE and others
\      FTP: to use a different list command
\      */
   10036 CONSTANT CURLOPT_CUSTOMREQUEST

\   /* HTTP request, for odd commands like DELETE, TRACE and others */
   10037 CONSTANT CURLOPT_STDERR

\   /* 38 is not used */

\   /* send linked-list of post-transfer QUOTE commands */
   10039 CONSTANT CURLOPT_POSTQUOTE

\   /* Pass a pointer to string of the output using full variable-replacement
\      as described elsewhere. */
   10040 CONSTANT CURLOPT_WRITEINFO

   41    CONSTANT CURLOPT_VERBOSE

\  /* throw the header out too */
   42    CONSTANT CURLOPT_HEADER

\  /* shut off the progress meter */
   43    CONSTANT CURLOPT_NOPROGRESS

\  /* use HEAD to get http document */
   44    CONSTANT CURLOPT_NOBODY

\  /* no output on http error codes >= 300 */
   45    CONSTANT CURLOPT_FAILONERROR

\  /* this is an upload */
   46    CONSTANT CURLOPT_UPLOAD

\  /* HTTP POST method */
   47    CONSTANT CURLOPT_POST

\  /* return bare names when listing directories
   48    CONSTANT CURLOPT_DIRLISTONLY

\  /* Append instead of overwrite on upload! */
   50    CONSTANT CURLOPT_APPEND

\   /* Specify whether to read the user+password from the .netrc or the URL.
\    * This must be one of the CURL_NETRC_* enums below. */
   51    CONSTANT CURLOPT_NETRC

\  /* use Location: Luke! */
   52    CONSTANT CURLOPT_FOLLOWLOCATION

\  /* transfer data in text/ASCII format */
   53    CONSTANT CURLOPT_TRANSFERTEXT

\  /* HTTP PUT */
   54    CONSTANT CURLOPT_PUT

\   /* 55 = OBSOLETE */

\   /* Function that will be called instead of the internal progress display
\    * function. This function should be defined as the curl_progress_callback
\    * prototype defines. */
   20056 CONSTANT CURLOPT_PROGRESSFUNCTION

\   /* Data passed to the progress callback */
   10057 CONSTANT CURLOPT_PROGRESSDATA

\   /* We want the referrer field set automatically when following locations */
\   CINIT(AUTOREFERER, LONG, 58),
   58    CONSTANT CURLOPT_AUTOREFERER

\   /* Port of the proxy, can be set in the proxy string as well with:
\      "[host]:[port]" */
\   CINIT(PROXYPORT, LONG, 59),
   59    CONSTANT CURLOPT_PROXYPORT

\   /* size of the POST input data, if strlen() is not good to use */
\   CINIT(POSTFIELDSIZE, LONG, 60),
   60    CONSTANT CURLOPT_POSTFIELDSIZE

\   /* tunnel non-http operations through a HTTP proxy */
\   CINIT(HTTPPROXYTUNNEL, LONG, 61),
   61    CONSTANT CURLOPT_HTTPPROXYTUNNEL

\   /* Set the interface string to use as outgoing network interface */
\   CINIT(INTERFACE, OBJECTPOINT, 62),
   62    CONSTANT CURLOPT_INTERFACE

\   /* Set the krb4/5 security level, this also enables krb4/5 awareness.  This
\    * is a string, 'clear', 'safe', 'confidential' or 'private'.  If the string
\    * is set but doesn't match one of these, 'private' will be used.  */
\   CINIT(KRBLEVEL, OBJECTPOINT, 63),
   63    CONSTANT CURLOPT_KRBLEVEL

\   /* Set if we should verify the peer in ssl handshake, set 1 to verify. */
\   CINIT(SSL_VERIFYPEER, LONG, 64),
   64    CONSTANT CURLOPT_SSL_VERIFYPEER

\   /* The CApath or CAfile used to validate the peer certificate
\      this option is used only if SSL_VERIFYPEER is true */
\   CINIT(CAINFO, OBJECTPOINT, 65),
   10065 CONSTANT CURLOPT_CAINFO

\   /* 66 = OBSOLETE */
\   /* 67 = OBSOLETE */

\   /* Maximum number of http redirects to follow */
\   CINIT(MAXREDIRS, LONG, 68),
   68    CONSTANT CURLOPT_MAXREDIRS

\   /* Pass a long set to 1 to get the date of the requested document (if
\      possible)! Pass a zero to shut it off. */
\   CINIT(FILETIME, LONG, 69),
   69    CONSTANT CURLOPT_FILETIME

\   /* This points to a linked list of telnet options */
\   CINIT(TELNETOPTIONS, OBJECTPOINT, 70),
   10070 CONSTANT CURLOPT_TELNETOPTIONS

\   /* Max amount of cached alive connections */
\   CINIT(MAXCONNECTS, LONG, 71),
   71    CONSTANT CURLOPT_MAXCONNECTS

\   /* What policy to use when closing connections when the cache is filled
\      up */
\   CINIT(CLOSEPOLICY, LONG, 72),
   72    CONSTANT CURLOPT_CLOSEPOLICY

\   /* 73 = OBSOLETE */

\   /* Set to explicitly use a new connection for the upcoming transfer.
\      Do not use this unless you're absolutely sure of this, as it makes the
\      operation slower and is less friendly for the network. */
\   CINIT(FRESH_CONNECT, LONG, 74),
   74    CONSTANT CURLOPT_FRESH_CONNECT

\   /* Set to explicitly forbid the upcoming transfer's connection to be re-used
\      when done. Do not use this unless you're absolutely sure of this, as it
\      makes the operation slower and is less friendly for the network. */
\   CINIT(FORBID_REUSE, LONG, 75),
   75    CONSTANT CURLOPT_FORBID_REUSE

\   /* Set to a file name that contains random data for libcurl to use to
\      seed the random engine when doing SSL connects. */
\   CINIT(RANDOM_FILE, OBJECTPOINT, 76),
   10076 CONSTANT CURLOPT_RANDOM_FILE

\   /* Set to the Entropy Gathering Daemon socket pathname */
\   CINIT(EGDSOCKET, OBJECTPOINT, 77),
   10077 CONSTANT CURLOPT_EGDSOCKET

\   /* Time-out connect operations after this amount of seconds, if connects
\      are OK within this time, then fine... This only aborts the connect
\      phase. [Only works on unix-style/SIGALRM operating systems] */
\   CINIT(CONNECTTIMEOUT, LONG, 78),
   78    CONSTANT CURLOPT_CONNECTTIMEOUT

\   /* Function that will be called to store headers (instead of fwrite). The
\    * parameters will use fwrite() syntax, make sure to follow them. */
\   CINIT(HEADERFUNCTION, FUNCTIONPOINT, 79),
   20079 CONSTANT CURLOPT_HEADERFUNCTION

\   /* Set this to force the HTTP request to get back to GET. Only really usable
\      if POST, PUT or a custom request have been used first.
\    */
\   CINIT(HTTPGET, LONG, 80),
   80    CONSTANT CURLOPT_HTTPGET

\   /* Set if we should verify the Common name from the peer certificate in ssl
\    * handshake, set 1 to check existence, 2 to ensure that it matches the
\    * provided hostname. */
\   CINIT(SSL_VERIFYHOST, LONG, 81),
   81    CONSTANT CURLOPT_SSL_VERIFYHOST

\   /* Specify which file name to write all known cookies in after completed
\      operation. Set file name to "-" (dash) to make it go to stdout. */
\   CINIT(COOKIEJAR, OBJECTPOINT, 82),
   10082 CONSTANT CURLOPT_COOKIEJAR

\   /* Specify which SSL ciphers to use */
\   CINIT(SSL_CIPHER_LIST, OBJECTPOINT, 83),
   10083 CONSTANT CURLOPT_SSL_CIPHER_LIST

\   /* Specify which HTTP version to use! This must be set to one of the
\      CURL_HTTP_VERSION* enums set below. */
\   CINIT(HTTP_VERSION, LONG, 84),
   84    CONSTANT CURLOPT_HTTP_VERSION

\   /* Specifically switch on or off the FTP engine's use of the EPSV command. B
\      default, that one will always be attempted before the more traditional
\      PASV command. */
\   CINIT(FTP_USE_EPSV, LONG, 85),
   85    CONSTANT CURLOPT_FTP_USE_EPSV

\   /* type of the file keeping your SSL-certificate ("DER", "PEM", "ENG") */
\   CINIT(SSLCERTTYPE, OBJECTPOINT, 86),
   10086 CONSTANT CURLOPT_SSLCERTTYPE

\   /* name of the file keeping your private SSL-key */
\   CINIT(SSLKEY, OBJECTPOINT, 87),
   10087 CONSTANT CURLOPT_SSLKEY

\   /* type of the file keeping your private SSL-key ("DER", "PEM", "ENG") */
\   CINIT(SSLKEYTYPE, OBJECTPOINT, 88),
   10088 CONSTANT CURLOPT_SSLKEYTYPE

\   /* crypto engine for the SSL-sub system */
\   CINIT(SSLENGINE, OBJECTPOINT, 89),
   10089 CONSTANT CURLOPT_SSLENGINE

\   /* set the crypto engine for the SSL-sub system as default
\      the param has no meaning...
\    */
\   CINIT(SSLENGINE_DEFAULT, LONG, 90),
   90    CONSTANT CURLOPT_SSLENGINE_DEFAULT

\   /* Non-zero value means to use the global dns cache */
\   CINIT(DNS_USE_GLOBAL_CACHE, LONG, 91), /* To become OBSOLETE soon */
   91    CONSTANT CURLOPT_DNS_USE_GLOBAL_CACHE

\   /* DNS cache timeout */
\   CINIT(DNS_CACHE_TIMEOUT, LONG, 92),
   92    CONSTANT CURLOPT_DNS_CACHE_TIMEOUT

\   /* send linked-list of pre-transfer QUOTE commands */
\   CINIT(PREQUOTE, OBJECTPOINT, 93),
   10093 CONSTANT CURLOPT_PREQUOTE

\   /* set the debug function */
\   CINIT(DEBUGFUNCTION, FUNCTIONPOINT, 94),
   20094 CONSTANT CURLOPT_DEBUGFUNCTION

\   /* set the data for the debug function */
\   CINIT(DEBUGDATA, OBJECTPOINT, 95),
   10095 CONSTANT CURLOPT_DEBUGDATA

\   /* mark this as start of a cookie session */
\   CINIT(COOKIESESSION, LONG, 96),
   96    CONSTANT CURLOPT_COOKIESESSION

\   /* The CApath directory used to validate the peer certificate
\      this option is used only if SSL_VERIFYPEER is true */
\   CINIT(CAPATH, OBJECTPOINT, 97),
   10097 CONSTANT CURLOPT_CAPATH

\   /* Instruct libcurl to use a smaller receive buffer */
\   CINIT(BUFFERSIZE, LONG, 98),
   98    CONSTANT CURLOPT_BUFFERSIZE

\   /* Instruct libcurl to not use any signal/alarm handlers, even when using
\      timeouts. This option is useful for multi-threaded applications.
\      See libcurl-the-guide for more background information. */
\   CINIT(NOSIGNAL, LONG, 99),
   99    CONSTANT CURLOPT_NOSIGNAL

\   /* Provide a CURLShare for mutexing non-ts data */
\   CINIT(SHARE, OBJECTPOINT, 100),
   10100 CONSTANT CURLOPT_SHARE

\   /* indicates type of proxy. accepted values are CURLPROXY_HTTP (default),
\      CURLPROXY_SOCKS4, CURLPROXY_SOCKS4A and CURLPROXY_SOCKS5. */
\   CINIT(PROXYTYPE, LONG, 101),
   101   CONSTANT CURLOPT_PROXYTYPE

\   /* Set the Accept-Encoding string. Use this to tell a server you would like
\      the response to be compressed. */
\   CINIT(ENCODING, OBJECTPOINT, 102),
   10102 CONSTANT CURLOPT_ENCODING

\   /* Set pointer to private data */
\   CINIT(PRIVATE, OBJECTPOINT, 103),
   10103 CONSTANT CURLOPT_PRIVATE

\   /* Set aliases for HTTP 200 in the HTTP Response header */
\   CINIT(HTTP200ALIASES, OBJECTPOINT, 104),
   10104 CONSTANT CURLOPT_HTTP200ALIASES

\   /* Continue to send authentication (user+password) when following locations,
\      even when hostname changed. This can potentially send off the name
\      and password to whatever host the server decides. */
\   CINIT(UNRESTRICTED_AUTH, LONG, 105),
   105   CONSTANT CURLOPT_UNRESTRICTED_AUTH

\   /* Specifically switch on or off the FTP engine's use of the EPRT command (
\   also disables the LPRT attempt). By default, those ones will always be
\      attempted before the good old traditional PORT command. */
\   CINIT(FTP_USE_EPRT, LONG, 106),
   106   CONSTANT CURLOPT_FTP_USE_EPRT

\   /* Set this to a bitmask value to enable the particular authentications
\      methods you like. Use this in combination with CURLOPT_USERPWD.
\      Note that setting multiple bits may cause extra network round-trips. */
\   CINIT(HTTPAUTH, LONG, 107),
   107   CONSTANT CURLOPT_HTTPAUTH

\   /* Set the ssl context callback function, currently only for OpenSSL ssl_ctx
\      in second argument. The function must be matching the
\      curl_ssl_ctx_callback proto. */
\   CINIT(SSL_CTX_FUNCTION, FUNCTIONPOINT, 108),
   20108 CONSTANT CURLOPT_SSL_CTX_FUNCTION

\   /* Set the userdata for the ssl context callback function's third
\      argument */
\   CINIT(SSL_CTX_DATA, OBJECTPOINT, 109),
   10109 CONSTANT CURLOPT_SSL_CTX_DATA

\   /* FTP Option that causes missing dirs to be created on the remote server.
\      In 7.19.4 we introduced the convenience enums for this option using the
\      CURLFTP_CREATE_DIR prefix.
\   */
\   CINIT(FTP_CREATE_MISSING_DIRS, LONG, 110),
   110   CONSTANT CURLOPT_FTP_CREATE_MISSING_DIRS

\   /* Set this to a bitmask value to enable the particular authentications
\      methods you like. Use this in combination with CURLOPT_PROXYUSERPWD.
\      Note that setting multiple bits may cause extra network round-trips. */
\   CINIT(PROXYAUTH, LONG, 111),
   111   CONSTANT CURLOPT_PROXYAUTH

\   /* FTP option that changes the timeout, in seconds, associated with
\      getting a response.  This is different from transfer timeout time and
\      essentially places a demand on the FTP server to acknowledge commands
\      in a timely manner. */
\   CINIT(FTP_RESPONSE_TIMEOUT, LONG, 112),
   112   CONSTANT CURLOPT_FTP_RESPONSE_TIMEOUT

\ #define CURLOPT_SERVER_RESPONSE_TIMEOUT CURLOPT_FTP_RESPONSE_TIMEOUT
   112   CONSTANT CURLOPT_SERVER_RESPONSE_TIMEOUT

\   /* Set this option to one of the CURL_IPRESOLVE_* defines (see below) to
\      tell libcurl to resolve names to those IP versions only. This only has
\      affect on systems with support for more than one, i.e IPv4 _and_ IPv6. */
\   CINIT(IPRESOLVE, LONG, 113),
   113   CONSTANT CURLOPT_IPRESOLVE

\   /* Set this option to limit the size of a file that will be downloaded from
\      an HTTP or FTP server.
\
\      Note there is also _LARGE version which adds large file support for
\      platforms which have larger off_t sizes.  See MAXFILESIZE_LARGE below. */
\   CINIT(MAXFILESIZE, LONG, 114),
   114   CONSTANT CURLOPT_MAXFILESIZE

\   /* See the comment for INFILESIZE above, but in short, specifies
\    * the size of the file being uploaded.  -1 means unknown.
\    */
\   CINIT(INFILESIZE_LARGE, OFF_T, 115),
   30115 CONSTANT CURLOPT_INFILESIZE_LARGE

\   /* Sets the continuation offset.  There is also a LONG version of this;
\    * look above for RESUME_FROM.
\    */
\   CINIT(RESUME_FROM_LARGE, OFF_T, 116),
   30116 CONSTANT CURLOPT_RESUME_FROM_LARGE

\   /* Sets the maximum size of data that will be downloaded from
\    * an HTTP or FTP server.  See MAXFILESIZE above for the LONG version.
\    */
\   CINIT(MAXFILESIZE_LARGE, OFF_T, 117),
   30117 CONSTANT CURLOPT_MAXFILESIZE_LARGE

\   /* Set this option to the file name of your .netrc file you want libcurl
\      to parse (using the CURLOPT_NETRC option). If not set, libcurl will do
\      a poor attempt to find the user's home directory and check for a .netrc
\      file in there. */
\   CINIT(NETRC_FILE, OBJECTPOINT, 118),
   10118 CONSTANT CURLOPT_NETRC_FILE

\   /* Enable SSL/TLS for FTP, pick one of:
\      CURLFTPSSL_TRY     - try using SSL, proceed anyway otherwise
\      CURLFTPSSL_CONTROL - SSL for the control connection or fail
\      CURLFTPSSL_ALL     - SSL for all communication or fail
\   */
\   CINIT(USE_SSL, LONG, 119),
   119   CONSTANT CURLOPT_USE_SSL

\   /* The _LARGE version of the standard POSTFIELDSIZE option */
\   CINIT(POSTFIELDSIZE_LARGE, OFF_T, 120),
   30120 CONSTANT CURLOPT_POSTFIELDSIZE_LARGE

\   /* Enable/disable the TCP Nagle algorithm */
\   CINIT(TCP_NODELAY, LONG, 121),
   121   CONSTANT CURLOPT_TCP_NODELAY

\   /* 122 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
\   /* 123 OBSOLETE. Gone in 7.16.0 */
\   /* 124 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
\   /* 125 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
\   /* 126 OBSOLETE, used in 7.12.3. Gone in 7.13.0 */
\   /* 127 OBSOLETE. Gone in 7.16.0 */
\   /* 128 OBSOLETE. Gone in 7.16.0 */

\   /* When FTP over SSL/TLS is selected (with CURLOPT_USE_SSL), this option
\      can be used to change libcurl's default action which is to first try
\      "AUTH SSL" and then "AUTH TLS" in this order, and proceed when a OK
\      response has been received.
\
\      Available parameters are:
\      CURLFTPAUTH_DEFAULT - let libcurl decide
\      CURLFTPAUTH_SSL     - try "AUTH SSL" first, then TLS
\      CURLFTPAUTH_TLS     - try "AUTH TLS" first, then SSL
\   */
\   CINIT(FTPSSLAUTH, LONG, 129),
   129   CONSTANT CURLOPT_FTPSSLAUTH

\   CINIT(IOCTLFUNCTION, FUNCTIONPOINT, 130),
   20130 CONSTANT CURLOPT_IOCTLFUNCTION

\   CINIT(IOCTLDATA, OBJECTPOINT, 131),
   10131 CONSTANT CURLOPT_IOCTLDATA

\   /* 132 OBSOLETE. Gone in 7.16.0 */
\   /* 133 OBSOLETE. Gone in 7.16.0 */

\   /* zero terminated string for pass on to the FTP server when asked for
\      "account" info */
\   CINIT(FTP_ACCOUNT, OBJECTPOINT, 134),
   10134 CONSTANT CURLOPT_FTP_ACCOUNT

\   /* feed cookies into cookie engine */
\   CINIT(COOKIELIST, OBJECTPOINT, 135),
   10135 CONSTANT CURLOPT_COOKIELIST

\   /* ignore Content-Length */
\   CINIT(IGNORE_CONTENT_LENGTH, LONG, 136),
   136   CONSTANT CURLOPT_IGNORE_CONTENT_LENGTH

\   /* Set to non-zero to skip the IP address received in a 227 PASV FTP server
\      response. Typically used for FTP-SSL purposes but is not restricted to
\      that. libcurl will then instead use the same IP address it used for the
\      control connection. */
\   CINIT(FTP_SKIP_PASV_IP, LONG, 137),
   137   CONSTANT CURLOPT_FTP_SKIP_PASV_IP

\   /* Select "file method" to use when doing FTP, see the curl_ftpmethod
\      above. */
\   CINIT(FTP_FILEMETHOD, LONG, 138),
   138   CONSTANT CURLOPT_FTP_FILEMETHOD

\   /* Local port number to bind the socket to */
\   CINIT(LOCALPORT, LONG, 139),
   139   CONSTANT CURLOPT_LOCALPORT

\   /* Number of ports to try, including the first one set with LOCALPORT.
\      Thus, setting it to 1 will make no additional attempts but the first.
\   */
\   CINIT(LOCALPORTRANGE, LONG, 140),
   140   CONSTANT CURLOPT_LOCALPORTRANGE

\   /* no transfer, set up connection and let application use the socket by
\      extracting it with CURLINFO_LASTSOCKET */
\   CINIT(CONNECT_ONLY, LONG, 141),
   141   CONSTANT CURLOPT_CONNECT_ONLY

\   /* Function that will be called to convert from the
\      network encoding (instead of using the iconv calls in libcurl) */
\   CINIT(CONV_FROM_NETWORK_FUNCTION, FUNCTIONPOINT, 142),
   20142 CONSTANT CURLOPT_CONV_FROM_NETWORK_FUNCTION

\   /* Function that will be called to convert to the
\      network encoding (instead of using the iconv calls in libcurl) */
\   CINIT(CONV_TO_NETWORK_FUNCTION, FUNCTIONPOINT, 143),
   20143 CONSTANT CURLOPT_CONV_TO_NETWORK_FUNCTION

\   /* Function that will be called to convert from UTF8
\      (instead of using the iconv calls in libcurl)
\      Note that this is used only for SSL certificate processing */
\   CINIT(CONV_FROM_UTF8_FUNCTION, FUNCTIONPOINT, 144),
   20144 CONSTANT CURLOPT_CONV_FROM_UTF8_FUNCTION

\   /* if the connection proceeds too quickly then need to slow it down */
\   /* limit-rate: maximum number of bytes per second to send or receive */
\   CINIT(MAX_SEND_SPEED_LARGE, OFF_T, 145),
   30145 CONSTANT CURLOPT_MAX_SEND_SPEED_LARGE

\   CINIT(MAX_RECV_SPEED_LARGE, OFF_T, 146),
   30146 CONSTANT CURLOPT_MAX_RECV_SPEED_LARGE

\   /* Pointer to command string to send if USER/PASS fails. */
\   CINIT(FTP_ALTERNATIVE_TO_USER, OBJECTPOINT, 147),
   10147 CONSTANT CURLOPT_FTP_ALTERNATIVE_TO_USER

\   /* callback function for setting socket options */
\   CINIT(SOCKOPTFUNCTION, FUNCTIONPOINT, 148),
   20148 CONSTANT CURLOPT_SOCKOPTFUNCTION

\   CINIT(SOCKOPTDATA, OBJECTPOINT, 149),
   10149 CONSTANT CURLOPT_SOCKOPTDATA

\   /* set to 0 to disable session ID re-use for this transfer, default is
\      enabled (== 1) */
\   CINIT(SSL_SESSIONID_CACHE, LONG, 150),
   150   CONSTANT CURLOPT_SSL_SESSIONID_CACHE

\   /* allowed SSH authentication methods */
\   CINIT(SSH_AUTH_TYPES, LONG, 151),
   151   CONSTANT CURLOPT_SSH_AUTH_TYPES

\   /* Used by scp/sftp to do public/private key authentication */
\   CINIT(SSH_PUBLIC_KEYFILE, OBJECTPOINT, 152),
   10152 CONSTANT CURLOPT_SSH_PUBLIC_KEYFILE

\   CINIT(SSH_PRIVATE_KEYFILE, OBJECTPOINT, 153),
   10153 CONSTANT CURLOPT_SSH_PRIVATE_KEYFILE

\   /* Send CCC (Clear Command Channel) after authentication */
\   CINIT(FTP_SSL_CCC, LONG, 154),
   154   CONSTANT CURLOPT_FTP_SSL_CCC

\   /* Same as TIMEOUT and CONNECTTIMEOUT, but with ms resolution */
\   CINIT(TIMEOUT_MS, LONG, 155),
   155   CONSTANT CURLOPT_TIMEOUT_MS

\   CINIT(CONNECTTIMEOUT_MS, LONG, 156),
   156   CONSTANT CURLOPT_CONNECTTIMEOUT_MS

\   /* set to zero to disable the libcurl's decoding and thus pass the raw body
\      data to the application even when it is encoded/compressed */
\   CINIT(HTTP_TRANSFER_DECODING, LONG, 157),
   157   CONSTANT CURLOPT_HTTP_TRANSFER_DECODING

\   CINIT(HTTP_CONTENT_DECODING, LONG, 158),
   158   CONSTANT CURLOPT_HTTP_CONTENT_DECODING

\   /* Permission used when creating new files and directories on the remote
\      server for protocols that support it, SFTP/SCP/FILE */
\   CINIT(NEW_FILE_PERMS, LONG, 159),
   159   CONSTANT CURLOPT_NEW_FILE_PERMS

\   CINIT(NEW_DIRECTORY_PERMS, LONG, 160),
   160   CONSTANT CURLOPT_NEW_DIRECTORY_PERMS

\   /* Set the behaviour of POST when redirecting. Values must be set to one
\      of CURL_REDIR* defines below. This used to be called CURLOPT_POST301 */
\   CINIT(POSTREDIR, LONG, 161),
   161   CONSTANT CURLOPT_POSTREDIR

\   /* used by scp/sftp to verify the host's public key */
\   CINIT(SSH_HOST_PUBLIC_KEY_MD5, OBJECTPOINT, 162),
   10162 CONSTANT CURLOPT_SSH_HOST_PUBLIC_KEY_MD5

\   /* Callback function for opening socket (instead of socket(2)). Optionally,
\      callback is able change the address or refuse to connect returning
\      CURL_SOCKET_BAD.  The callback should have type
\      curl_opensocket_callback */
\   CINIT(OPENSOCKETFUNCTION, FUNCTIONPOINT, 163),
   20163 CONSTANT CURLOPT_OPENSOCKETFUNCTION

\   CINIT(OPENSOCKETDATA, OBJECTPOINT, 164),
   10164 CONSTANT CURLOPT_OPENSOCKETDATA

\   /* POST volatile input fields. */
\   CINIT(COPYPOSTFIELDS, OBJECTPOINT, 165),
   10165 CONSTANT CURLOPT_COPYPOSTFIELDS

\   /* set transfer mode (;type=<a|i>) when doing FTP via an HTTP proxy */
\   CINIT(PROXY_TRANSFER_MODE, LONG, 166),
   166   CONSTANT CURLOPT_PROXY_TRANSFER_MODE

\   /* Callback function for seeking in the input stream */
\   CINIT(SEEKFUNCTION, FUNCTIONPOINT, 167),
   20167 CONSTANT CURLOPT_SEEKFUNCTION

\   CINIT(SEEKDATA, OBJECTPOINT, 168),
   10168 CONSTANT CURLOPT_SEEKDATA

\   /* CRL file */
\   CINIT(CRLFILE, OBJECTPOINT, 169),
   10169 CONSTANT CURLOPT_CRLFILE

\   /* Issuer certificate */
   10170 CONSTANT CURLOPT_ISSUERCERT

\   /* (IPv6) Address scope */
   171   CONSTANT CURLOPT_ADDRESS_SCOPE

\   /* Collect certificate chain info and allow it to get retrievable with
\      CURLINFO_CERTINFO after the transfer is complete. (Unfortunately) only
\      working with OpenSSL-powered builds. */
   172   CONSTANT CURLOPT_CERTINFO

\   /* "name" and "pwd" to use when fetching. */
   10173 CONSTANT CURLOPT_USERNAME

   10174 CONSTANT CURLOPT_PASSWORD

\     /* "name" and "pwd" to use with Proxy when fetching. */
   10175 CONSTANT CURLOPT_PROXYUSERNAME

   10176 CONSTANT CURLOPT_PROXYPASSWORD

\   /* Comma separated list of hostnames defining no-proxy zones. These should
\      match both hostnames directly, and hostnames within a domain. For
\      example, local.com will match local.com and www.local.com, but NOT
\      notlocal.com or www.notlocal.com. For compatibility with other
\      implementations of this, .local.com will be considered to be the same as
\      local.com. A single * is the only valid wildcard, and effectively
\      disables the use of proxy. */
   10177 CONSTANT CURLOPT_NOPROXY

\   /* block size for TFTP transfers */
   178   CONSTANT CURLOPT_TFTP_BLKSIZE

\   /* Socks Service */
   10179 CONSTANT CURLOPT_SOCKS5_GSSAPI_SERVICE

\   /* Socks Service */
   180   CONSTANT CURLOPT_SOCKS5_GSSAPI_NEC

\   /* set the bitmask for the protocols that are allowed to be used for the
\      transfer, which thus helps the app which takes URLs from users or other
\      external inputs and want to restrict what protocol(s) to deal
\      with. Defaults to CURLPROTO_ALL. */
   181   CONSTANT CURLOPT_PROTOCOLS

\   /* set the bitmask for the protocols that libcurl is allowed to follow to,
\      as a subset of the CURLOPT_PROTOCOLS ones. That means the protocol needs
\      to be set in both bitmasks to be allowed to get redirected to. Defaults
\      to all protocols except FILE and SCP. */
   182   CONSTANT CURLOPT_REDIR_PROTOCOLS

\   /* set the SSH knownhost file name to use */
   10183 CONSTANT CURLOPT_SSH_KNOWNHOSTS

\   /* set the SSH host key callback, must point to a curl_sshkeycallback
\      function */
   20184 CONSTANT CURLOPT_SSH_KEYFUNCTION

\   /* set the SSH host key callback custom pointer */
   10185 CONSTANT CURLOPT_SSH_KEYDATA

\   /* set the SMTP mail originator */
   10186 CONSTANT CURLOPT_MAIL_FROM

\   /* set the SMTP mail receiver(s) */
   10187 CONSTANT CURLOPT_MAIL_RCPT

\   /* FTP: send PRET before PASV */
   188   CONSTANT CURLOPT_FTP_USE_PRET

\   /* RTSP request method (OPTIONS, SETUP, PLAY, etc...) */
   189   CONSTANT CURLOPT_RTSP_REQUEST

\   /* The RTSP session identifier */
   10190 CONSTANT CURLOPT_RTSP_SESSION_ID

\   /* The RTSP stream URI */
   10191 CONSTANT CURLOPT_RTSP_STREAM_URI

\   /* The Transport: header to use in RTSP requests */
   10192 CONSTANT CURLOPT_RTSP_TRANSPORT

\   /* Manually initialize the client RTSP CSeq for this handle */
   193   CONSTANT CURLOPT_RTSP_CLIENT_CSEQ

\   /* Manually initialize the server RTSP CSeq for this handle */
   194   CONSTANT CURLOPT_RTSP_SERVER_CSEQ

\   /* The stream to pass to INTERLEAVEFUNCTION. */
   10195 CONSTANT CURLOPT_INTERLEAVEDATA

\   /* Let the application define a custom write method for RTP data */
   20196 CONSTANT CURLOPT_INTERLEAVEFUNCTION

\   /* Turn on wildcard matching */
   197   CONSTANT CURLOPT_WILDCARDMATCH

\   /* Directory matching callback called before downloading of an
\      individual file (chunk) started */
   20198 CONSTANT CURLOPT_CHUNK_BGN_FUNCTION

\   /* Directory matching callback called after the file (chunk)
\      was downloaded, or skipped */
   20199 CONSTANT CURLOPT_CHUNK_END_FUNCTION

\   /* Change match (fnmatch-like) callback for wildcard matching */
   20200 CONSTANT CURLOPT_FNMATCH_FUNCTION

\   /* Let the application define custom chunk data pointer */
   10201 CONSTANT CURLOPT_CHUNK_DATA

\   /* FNMATCH_FUNCTION user pointer */
   10202 CONSTANT CURLOPT_FNMATCH_DATA

   CURLOPT_FILE CONSTANT CURLOPT_WRITEDATA

\  CURL CONSTANTS ERROR

   0 CONSTANT CURL_OK
   1 CONSTANT CURLE_UNSUPPORTED_PROTOCOL
   2 CONSTANT CURLE_FAILED_INIT
   3 CONSTANT CURLE_URL_MALFORMAT
   4 CONSTANT CURLE_OBSOLETE4
   5 CONSTANT CURLE_COULDNT_RESOLVE_PROXY
   6 CONSTANT CURLE_COULDNT_RESOLVE_HOST
   7 CONSTANT CURLE_COULDNT_CONNECT
   8 CONSTANT CURLE_FTP_WEIRD_SERVER_REPLY
   9 CONSTANT CURLE_REMOTE_ACCESS_DENIED

  10 CONSTANT CURLE_OBSOLETE10
  11 CONSTANT CURLE_FTP_WEIRD_PASS_REPLY
  12 CONSTANT CURLE_OBSOLETE12
  13 CONSTANT CURLE_FTP_WEIRD_PASV_REPLY
  14 CONSTANT CURLE_FTP_WEIRD_227_FORMAT
  15 CONSTANT CURLE_FTP_CANT_GET_HOST
  16 CONSTANT CURLE_OBSOLETE16
  17 CONSTANT CURLE_FTP_COULDNT_SET_TYPE
  18 CONSTANT CURLE_PARTIAL_FILE
  19 CONSTANT CURLE_FTP_COULDNT_RETR_FILE
  20 CONSTANT CURLE_OBSOLETE20
  21 CONSTANT CURLE_QUOTE_ERROR
  22 CONSTANT CURLE_HTTP_RETURNED_ERROR
  23 CONSTANT CURLE_WRITE_ERROR
  24 CONSTANT CURLE_OBSOLETE24
  25 CONSTANT CURLE_UPLOAD_FAILED
  26 CONSTANT CURLE_READ_ERROR
  27 CONSTANT CURLE_OUT_OF_MEMORY

  28 CONSTANT CURLE_OPERATION_TIMEDOUT
  29 CONSTANT CURLE_OBSOLETE29
  30 CONSTANT CURLE_FTP_PORT_FAILED
  31 CONSTANT CURLE_FTP_COULDNT_USE_REST
  32 CONSTANT CURLE_OBSOLETE32
  33 CONSTANT CURLE_RANGE_ERROR
  34 CONSTANT CURLE_HTTP_POST_ERROR
  35 CONSTANT CURLE_SSL_CONNECT_ERROR
  36 CONSTANT CURLE_BAD_DOWNLOAD_RESUME
  37 CONSTANT CURLE_FILE_COULDNT_READ_FILE
  38 CONSTANT CURLE_LDAP_CANNOT_BIND
  39 CONSTANT CURLE_LDAP_SEARCH_FAILED
  40 CONSTANT CURLE_OBSOLETE40
  41 CONSTANT CURLE_FUNCTION_NOT_FOUND
  42 CONSTANT CURLE_ABORTED_BY_CALLBACK
  43 CONSTANT CURLE_BAD_FUNCTION_ARGUMENT
  44 CONSTANT CURLE_OBSOLETE44
  45 CONSTANT CURLE_INTERFACE_FAILED
  46 CONSTANT CURLE_OBSOLETE46
  47 CONSTANT CURLE_TOO_MANY_REDIRECTS
  48 CONSTANT CURLE_UNKNOWN_TELNET_OPTION
  49 CONSTANT CURLE_TELNET_OPTION_SYNTAX
  50 CONSTANT CURLE_OBSOLETE50
  51 CONSTANT CURLE_PEER_FAILED_VERIFICATION

\ ======
\ *> ###
\ ======

decimal
