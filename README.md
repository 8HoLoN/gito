# gito
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9LWA3PBZBJ9ZW)

git (single layer) onion

# Overview
Transform a standard git repository into an secure/encrypt one. With the nesting of a sub repository into the secure one, the logs for the local users are preserved while the ones on the distant repository remain secure.

```
+------------------+                           +------------------+
| remote bare repo | uncrypted                 | remote bare repo | crypted
+--------+---------+                           +--------+---------+
         |                        gito init             |
         | git clone            +----------->           | gito clone
         v                                              v
+--------+---------+                           +--------+---------+
|local working copy| uncrypted                 |local working copy| uncrypted
+------------------+                           +------------------+
```
# Supported Platforms
OS|Linux|Windows|
|--|--|--|
|Script|gito|gito.bat|

# Prerequisites
* Linux
```
apt-get install p7zip-full
```
* Windows : [7z](https://www.7-zip.org/a/7z1806-x64.exe)

# Usage
* Init encrypted repo (only the very first time)
```
gito init <pwd> <repo-uri>
```
* Clone
```
gito clone <pwd> <repo-uri>
```
* Use standard git command to commit your work after doing a gito clone
```
git commit
```
* Pull/Push
```
gito pull <pwd>
gito push <pwd>
```
# Credits
* Author
  * [8HoLoN](https://github.com/8HoLoN) -
**Alexandre REMY** &lt;alexandre.remy.contact@gmail.com&gt;
