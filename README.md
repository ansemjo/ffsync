# ffsync
*bash script for fetching and pushing a list of files to and from a ssh host*

## Motivation

This is a bash script to fetch a list of files from a defined ssh host and save them to a subdirectory while preserving the filesystem structure. It can then also push all files found in a subdirectory to a ssh host.

It originated as two [seperate scripts](https://github.com/ansemjo/ff-zea-oktavio_01_ap_01/commit/e74b6b5517001279da2fde9957bddaf70aa65956) for backing up configuration files of [Freifunk](https://hamburg.freifunk.net/mitmachen) routers.

Behind the scenes, it compresses files to stdout with tar, pipes that through a ssh connection and then extracts from stdin again. It is important to note that when pushing files, they all get assigned `--owner=0 --group=0`. This is due to the fact that the script is intended for network devices with a single superuser. It avoids the need for superuser rights locally when editing files and 'preserves' file ownerships properly on remote devices.

The configuration might resemble ansible a bit and you could probably do all this with ansible too. But this script is much simpler and more lightweight as it serves a very specific purpose. It does not require anything besides a ssh server and the tar command remotely.

## Usage

 `$ ffsync <mode> [-c config] [-h host] [-d directory] [-l filelist] [-y]`

`<mode>` can be one of:
 - `push` copy all files in a local directory to the remote host
 - `pull` copy the files specified in a file from the remote host and save to a local directory

By default the variables are read from `ffsync.yml`, which is file in YAML format. This can be overriden with the following options. All variables are shown before copying and the user is asked for confirmation.

Variables can be overriden with the following options:
 - `[-c `_`config.yml`_`]` read configuration from _config.yml_ instead
 - `[-h `_`host`_`]` connect to _host_ instead (this can be hostname + options specific to your ssh client)
 - `[-d `_`dir`_`]` use _dir_ as local directory instead
 - `[-l `_`list`_`]` fetch the files in _list_ instead
 - `[-y]` override the confirmation dialog
 
Options can be specified in any order and combinations like `ffsync pull -yh `_`host`_ are also possible.

## Configuration

The configuration is done in a YAML-formatted file:

```
# remote host; can contain options for ssh client
hostconf:   freifunk-node
# where filesystem tree is saved
datadir:    filesystem
# skip check before transmitting files
yesyes:     false
# list of files to fetch, pushing copies ALL files in $datadir
filelist:
    - /etc/profile
    - /etc/hosts
    - /etc/sysupgrade.conf
    - /etc/dropbear/authorized_keys
    - /etc/config/network
    - /etc/config/wireless
    - /root/
```

There are plans to allow more than one host with different directories per file.