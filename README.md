# ffsync
*bash script for fetching and pushing a list of files to and from a ssh host*

## Motivation

This is a bash script to fetch a list of files from a defined ssh host and save them to a subdirectory while preserving the filesystem structure. It can then also push all files found in a subdirectory to a ssh host.

It originated as two [seperate scripts](https://github.com/ansemjo/ff-zea-oktavio_01_ap_01/commit/e74b6b5517001279da2fde9957bddaf70aa65956) for backing up configuration files of [Freifunk](https://hamburg.freifunk.net/mitmachen) routers.

Behind the scenes, it compresses files to stdout with tar, pipes that through a ssh connection and then extracts from stdin again. It is important to note that when pushing files, they all get assigned `--owner=0 --group=0`. This is due to the fact that the script is intended for network devices with a single superuser. It avoids the need for superuser rights locally when editing files and 'preserves' file ownerships properly on remote devices.

## Usage

 `$ ffsync <mode> [-h host] [-d directory] [-l listfile] [-y]`

`<mode>` can be one of:
 - `push` copy all files in a local directory to the remote host
 - `pull` copy the files specified in a file from the remote host and save to a local directory

By default the remote hostname is read from `./host`, the local directory is set to `./filesystem/` and the file list is read from `./list`. All variables are shown before copying and the user is asked for confirmation.

These variables can be overriden with the following options:
 - `[-h `_`host`_`]` connect to _host_ instead
 - `[-d `_`dir`_`]` use _dir_ as local directory instead
 - `[-l `_`list`_`]` read the list of files from _list_ instead
 - `[-y]` override the confirmation dialog
 
Options can be specified in any order and combinations like `ffsync pull -yh `_`host`_ are also possible.

## Configuration

### ssh host config

As you may have noticed the script only takes a single hostname to define the remote host. Thus it is almost mandatory to have a corresponding host configuration in `~/.ssh/ssh_config`. For example:
```
Host ff-node
  HostName 2001:db8::
  Port 22
  User root
  IdentityFile ~/.ssh/id_rsa
```

Then save that name to a file in the workingdirectory, `./file`:
```
# You can use comments if you want
ff-node # Freifunk Node
```

### file list

The script reads all files and folders to pull from a file and compiles a list using `sed` and `xargs`. For example, specify a list `./list` in your working directory like so:
```
# list files & folders to fetch with ffsync here

/etc/profile
/etc/hosts
/etc/dropbear/*   # includes visible files and subdirectories
/etc/config/      # includes all files and subdirectories, including hidden
/root/.ash_aliases
/root/rc.local
```
