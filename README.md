# wikicli
A command-line tool for updating MediaWiki servers

# Motivations
One day while updating my backup scripts, I decided that I wanted to be able to programatically capture the output of the system in my wiki.  So to do that, I wrote this tool to do the work for me of updating pages with free-form content in an API-driven way.  And since I'm a fan of opensource software, here you find it.  Enjoy it.

# Usage
wikicli [--verbose] <--action action> <--title page_title> [--help]

* 'action' may be one of [get, update, append]
* 'title' refers to the page title
* Page content should be fed to standard input

Features coming soon:

* action = delete

# Configuration
This took expects a yaml config file, .wikiclirc, located in $HOME.  It should be populated with these attributes:
```
user: value
password: value
apiurl: https://whatever
```

Bugs and issues
====

OpenSSL Self-signed Certificates
----
If you run a wiki with a self-signed cert then you might run into this problem:

```
in `connect': SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (Faraday::SSLError) 
```

The underlying libraries that support this, net/http and faraday, usually need to verify the SSL ceritificate chain.  One way to work around that is to copy your server's to your local cert store.  Here is an approach for [Linux](http://unix.stackexchange.com/questions/90450/adding-a-self-signed-certificate-to-the-trusted-list).
