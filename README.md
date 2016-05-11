# db-tools
fish shell wrappers for common tasks done on mysql databases providing autocompletion and support for compressed dumps.

## Basic idea
for sysadmins and during devops I often had the challenge to treat databases in a similar way like you would normally treat files.
So I started to implement some shortcuts, to enable a way of processsing databases in the same way. It's far from beeing perfect but helps me a lot, so I wanted to share.
Pull requests with improvements or error corrections are welcome!

## Limitations
At the moment you need a working setup for ssh (via ~/.ssh/config) for using the remote hosts and a working setup for mysql and mysqldump (via ~/.my.cnf) for all commands, because at the moment it is not possible to provide credentials at run time.
This should be fixed for future versions.

## Installation
clone the repo and put the content of src/ into your home directory).

## General options
    <some name>                    specifies a local db
    <some name>.sql                specifies a database dump
    <some name>.<supported ext>    specifies a compressed dump 
                                   (supported for input: .tar.bz2, .bz, .bz2, .tar.lz, .tlz, .lz, .tar.lzma, .lzma, .rar, .r[0-9][0-9], .tar.gz, .tgz, .tar.z, .tar.dz, .tar.xz, .txz, .xz, .gz, .z, .dz, .tar, .jar, .war, .ear, .xpi, .zip, .7z, .zoo)
                                   (supported for output: .sql, .bz, .bz2, .gz)

    <[user]@host>:<some name>  database on a remote system reachable via ssh
    <[user]@host>:/<some name>.<supported extension>  database dump on a remote system reachable via ssh (see above for supported extensions)

    http[s]://<someurl>.<supported extension> download dump from http or https (only supported for inputs)

## Commands
### lsdb
    lsdb [<prefix part of db-name>]
Lists databases. Result might be filtered by given prefix.

### touchdb 
    touchdb <db-name>
Tries to create a new database with given name. At the moment it works only locally (no ssh support). It's possible to use autocompletion.

### rmdb 
    rmdb <db-name>
Tries to create a new database with given name. At the moment it works only locally (no ssh support). It's possible to use autocompletion.

### newdb 
    newdb <db-name>
Deletes a given database if it exists and recreates it.

### cpdb
    cpdb <from> <to>
The main command. copies databases from databases or from dumps or to dumps. You could use all options mentioned under General options. Database is cleaned before importing a dump using the newdb command

## Todos
- todo: support ssh requests for source and target
- todo: create posibility to supply credentials to mysqldump or mysql.
- ....