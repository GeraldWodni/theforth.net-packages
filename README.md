# theforth.net-packages
Packages hosted on [theforth.net](https://theforth.net)

**Important copyright notice:**
Neither do I claim copyright nor authorship of all packages.
Please consult each package individually for copyright and authorship information.
Some packages do not contain an explicit license file. In that case consult the package.4th file within,
search for a line starting with "key-value license" and treat the rest of the line as licensing information.

## Structure
- Each folder represents a package.
- Within each package you will find the following structure
 - **versions**: Each line contains a version which is present as subdirectory
 - **x.x.x**: symlink to the highest version directory
 - **x.x.x-version**: file containing the highest version number (e.g. 1.2.3)
 - **N.x.x**: symlink to the highest version directory starting with *N.*
 - **N.x.x-version**: file containing the highest version number starting with *N.* (e.g. N=10: 10.22.33)
 - **N.M.x**: symlink to the highest version directory starting with *N.M.*
 - **N.M.x-version**: file containing the highest version number starting with *N.M.* (e.g. N=2, M=4: 2.4.123)
 - **current**: same as *x.x.x*
 - **current-version**: same as *x.x.x-version*
 - **recent**: symlink to most recently added version
 - **recent-version**: file containing the most recently added version number
 - **N.M.L**: directory containing the specified version
 
## Further reading
- [Information about theforth.net](https://theforth.net)
- [Package Guidelines and package.4th](https://theforth.net/guidelines)
