# NAME

synconf - synchronize disconnected directories (i.e. laptops, USB memory pens).

# SYNOPSIS

    synconf  < -a/--action <print | listmnemonics> >
    synconf  < -a/--action sync > < -m/--mnemonic <host mnemonic> >
             [ -s/--shout ] [ -n/--norun ]
    synconf  [ -h/--help ] [ -v/--version ]

# DESCRIPTION

**synconf** will Synchronize data using rsync for detached large media
devices like laptops, USB memory pens, etc.  It does other related tasks like
adjusting permissions on files, which are useful for things like synchronizing
from the MS Windows world (where permissions are arbitrary) to UNIX.

# TERMS

- **synchronization configuration**

    A list of hosts each with a configuration that is keyed by a _mnemonic_.
    Each _mnemonic_ contains the list of directories (globs) which associated
    default options.

    The mnemonic is something the user must provide to indicate which set of
    directories to synchronize.  For instance, for host **X** you might want to
    synchronize from a memory pen (or laptop, etc).  You might want to call this
    mnemonic `fromusb` since it synchronizes from the memory pen to the local
    machine.

    Similarly, you include a `tousb` that synchronizes files from the local
    machine back on to the memory pen.

# OPTIONS

- **-a, --action**

    Indicates what to do.  The action can be one of:

    - &lt;sync>

        This is the primary synchronize command.  This command invokes [rsync](https://metacpan.org/pod/rsync) that
        does the file syncronization from one server and/or filesystem to another.

    - &lt;print>

        This prints the _synchronization configuration_ (see [TERMS](https://metacpan.org/pod/TERMS) section).

    - &lt;listmnemonics>

        Lists the mnemonics that used for this host.

- **-m, --mnemonic**

    This indicates which list of directories to sync for the `sync` action (see
    \-a).

- **-c, --config** _configuration file_

    Specifies the XML configuration file used to indicate what to sync and how.

- **-s, --shout**

    Provide verbose logging.  This passes `-v` given to [rsync](https://metacpan.org/pod/rsync).

- **-n, --norun**

    Do a dryrun.  That is, act like the script is running for real but don't do
    anything (this is the same `-n` given to [rsync](https://metacpan.org/pod/rsync)).

- **-h, --help**

    Print a brief help message and exits.

- **-l, --longhelp**

    Prints the long help page and exists.

- **-v, --version**

    Prints program version and exists.

# XML Configuration File

The configuration file defines what is to be synced and how.

Here is a simple example:

    <sync>
      <vars>
        <property name="views" value="emacs,home-dir"/>
      </vars>
      <defaults>
        <property name="checksum" value="true"/>
      </defaults>
      <host name="localhost">
        <mnemonic name="laptop">
          <package>
            <pathset>
              <path src="pluto:~/view/{${views},bsh}" dst="~/view"/>
              <path src="pluto:~/opt/var/tosync" dst="~/opt/var"/>
            </pathset>
            <property name="delete" value="true"/>
            <property name="noPerms" value="true"/>
            <property name="noCvs" value="true"/>
            <property name="user" value="plandes"/>
            <modify path="~/view/emacs" mode="0664"/>
          </package>
        </mnemonic>
      </host>
    </sync>

In this example, we recursively synchronize files from ~/view/emacs,
~/view/home-dir on host pluto to the same directories on the local box.  The
one and only configuration is for mnemonic `laptop` and is always used as the
host name uses the wildcard `localhost`.

When synchronizing in this example, we delete files on host pluto that aren't
local, we don't copy `.git`, `.CVS` or `.svn` directories, we use user
`plandes` to login to pluto and we chmod all files to `0664` locally after
we're done.

Since we've defined `checksum` as a default, it's aplies to our one and only
configuration, so it checks by checksum instead of file size and time.

- Element **property**

    Properties define a key value pair and appear in more than one place (i.e. in
    **default** and **vars**.  If the definition only lists the name of the property,
    then it is a boolean property with legal values `true` and `false` with
    `false` as the default without it's presence.

- Element **vars**

    The vars element contains `property` nodes that are later substituted in
    the form `${_variable name_}`.

- Element **defaults**

    The vars element contains `property` nodes that are copied for each and every
    `pathset` element.  You can override this by declaring yet another property
    with the same name and different value.

- Element **host**

    The host element contains configuration for the host the program runs on (not
    the remote host).  This is useful for networked shared configuration files or
    even configurations that get rsynced.  The **name** attribute is the host name
    or can be `localhost`, which is used when a the local host name isn't found in
    the definition.

- Element **mnemonic**

    Identifies which sync configuration to use for the mnemonic supplied on the
    command line with **-m**, which referenced by the **name** attribute.

- Element **package**

    A package is a list of paths and properties that apply specifically to that
    package.  In this example, we synchronize by deleting all files/elements
    locally that aren't on _pluto_, we don't change permissions, don't copy
    `.git`, `.CVS`, `.svn` directories and use the user of _plandes_.

    In the **package** element, the following properties using the mentioned
    **property** element are valid and apply (note that these are different from the
    **vars/property** elements):

    - **delete**

        Delete files/elements at the destination that aren't at the source.  See the
        **--delete** rsync option.

    - **backup** _directory_

        With this option, preexisting destination files are renamed as each file is
        transferred or deleted.  The files removed/deleted go in _directory_.  See the
        **--backup** rsync option.

    - **noCvs**

        See the **--cvs-exclude** rsync option.

    - **noPerms**

        Opposite of the **--perms** in rsync (i.e. **--no-perms**).

    - **clobberNewer**

        Opposite of the **-u** (-**update**) in rsync.  This overwrites al files that differ from
        source even if the target has newer (timestamp) files.

    - **followLinks**

        Opposite of the **-l** (-**links**) in rsync.  This follows (symbolic) links
        instead of copying them over as links.

    - **verbose**

        See the **--verbose** rsync option.

    - **dryRun**

        See the **--dry-run** rsync option.

    - **chmod** _mode_

        Change mode (**chmod**) recursively using _mode_.

    - **dsStore**

        Like **noCvs** but applies to Apple .DS\_Store files.

    - **rsyncPath** _path on server_

        See the **--rsync-path** rsync option.

    - **rsh** _path on server_

        See the **--rsh** rsync option.

    - **exclude** _file pattern_

        See the **--exclude** rsync option.

    - **user**

        User to login in as on the remote host.  In rsync, this is the user in the
        form:

        >         **user**@host:path

        You can also put the user in the **src** and **dst** attributes of the **pathset**
        element, but it isn't recommended and both can't be present.

    - **existing**

        Skip creating new files on receiver.  See the **--existing** rsync option.

- Element **pathset**

    This is the list of paths to synchronize.  Attribute **src** contains where it
    comes from, which is either a local directory or a remote directory in the
    form:

    >     <_host_>:<**path**>

    and in this case is _pluto_:**~/opt/var/tosync**.

    When paths are in a comma separated list in curly braces, they are expanded
    like BSD UNIX paths.  In our example, _pluto_:**~/view/{${views},bsh}** becomes:

        pluto:~/view/emacs
        pluto:~/view/home-dir
        pluto:~/view/bsh

    after variable substitution and expansion.

- Element **modify**

    Specifying this initiates a recursive _chmod_ on the directory specified after
    _rsync_ completes.  This is useful to run on a UNIX machine for syncing from a
    windows mounted file system.

# Perl Native Configuration

If the Perl library `XML::LibXML` isn't available, you can require in or
modify the script itself to include in the `BEGIN` the same data structure as
would be read in from the XML file.

Here's an example of that data structure that is equivelant to the XML example
given previously in the ["XML Configuration File"](#xml-configuration-file) section:

    %SYNC_CONF =
      (
       "pluto" =>
       {
        fromusb => [ { filesSync => [[ "pluto:~/view/{emacs,home-dir,bsh}",
                                       "$ENV{HOME}/view" ],
                                     [ "pluto:~/opt/var/tosync",
                                       "$ENV{HOME}/opt/var" ],
                                    ],
                       attribs => { delete => 1, noPerms => 1,
                                    user => 'plandes', noCvs => true },
                       dirMod => [ { dirs => [ "$ENV{HOME}/view/emacs" ],
                                     mode => "0664",
                                   }, ],
                     },
                   ],

# Emacs Integration

This program integrates with the
[choice-program](https://github.com/plandes/choice-program) library.

See [synconf.el](https://github.com/plandes/synconf/blob/master/synconf.el) for
an example configuration.

# COPYRIGHT

Copyright (C) 2009 - 2019  Paul Landes

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING.  If not, write to the
Free Software Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA 02111-1307, USA.

# AUTHOR

Paul Landes
