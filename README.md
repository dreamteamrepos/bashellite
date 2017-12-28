# Bashellite


Purpose
----------

Bashellite is a simple mirroring tool used to mirror the following  repository types using the following procotols and tools:

 - rsync mirrors via the rsync protocol using rsync
 - http/https mirrors via the http/https protocol using wget

If you find yourself trying to mirror several different types of repositories (i.e. rpm, deb, etc),
and can not find a single tool that does this effectively, bashellite might be what you're looking for.


Features
----------

Bashellite includes many of the same configuration options used by the tools it calls to perform mirroring. Bashellite simply gives these tools some sensible default flags/options, and a user-friendly interface. Much of the options you would normally pass over the command-line, are either imbedded in the script, or they have been farmed out to configuration files that you then populate with data. This alleviates the need to remember cumbersome command-line flags for each of the underlying tools. Much of the heavy lifting is taken care of for you. As an example, Bashellite auto-generates it's own configuration files, allowing you to quickly mirror new repositories. It also does syntax checking for you, and prints useful error messages when you make a mistake. Last, but not least, Bashellite has a dry run mode that shows you exactly what it would do during a real run.


Usage
----------

    Usage: bashellite.sh
           -m mirror_top-level_directory
           [-h]
           [-d]
           [-r repository_name] | [-a]
    
           Mandatory Parameter(s):
           -m:  Sets the disk mirror top-level directory.
                Only absolute (full) paths are accepted!
    
           Optional Parameter(s):
           -h:  Prints this usage message.
           -d:  Dry-run mode. Pulls down a listing of the files and
                directories it would download, and then exits.
           -r:  The repo name to sync.
           -a:  Mutually exclusive with -r option; sync all repos.


Installation
----------

 - Ensure GNU/Linux versions of `bash`, `ls`, `basename`, `tput`, `cat`, `mkdir`, `touch`, `chown`, `dirname`, and `realpath` are installed
 - Ensure the GNU/Linux version of `rsync` is installed if you would like to sync from rsync mirrors
 - Ensure the GNU/Linux version of `wget` is  installed if you would like to sync from http/https mirrors
 - `git clone git@github.com:AFCYBER-DREAM/bashellite.git`



Configuration
----------

After completing the installation process, you can immediately start initializing new repositories to mirror. First, you'll need to autogenerate some config boilerplate:

    
`./bashellite.sh -m $(pwd) -r test_repo`
    

This will create a new set of repo definition files in $(pwd)/_metadata/test_repo and print some follow-on instructions for you. At this point, you have to make a choice: is this going to be a rsync repo or a http repo? If this going to be a rsync repo, you'll populate `$(pwd)/_metadata/test_repo/rsync_url.conf`. If it is going to be a http repo, you'll populate `$(pwd)/_metadata/test_repo/http_url.conf`. After you've entered a http://, https://, or rsync:// formatted URI, you will need to setup your repo_filter.conf file. This file has a different format, depending on which repo type you selected. If you are setting up a rsync repo, this is a rsync exclude file. Refer to the man page for rsync to learn more about excludes, includes, and filters. If you are setting up a http repo, simply include a list of each file or directory you would like to `wget`. Bashellite recursively mirrors, so be cautious about what you include. It is advisable for either repo type to first use the dryrun feature (-d flag) to hone your repo filter before executing a live run.


Examples
----------

    # Mirrors/creates a repository called "test_repo" inside the current working directory
    ./bashellite.sh -m $(pwd) -r test_repo
    
    # Does a dry run of a repository sync on a repository called "test_repo"
    ./bashellite.sh -m $(pwd) -r test_repo -d
    
    # Creates/mirrors a repository called "test_repo" inside a directory called "/mirrors"
    ./bashellite.sh -m /mirrors -r test_repo
    
    # Mirrors/creates all repositories into "/mirrors" that are defined inside of "./_metadata/"
    ./bashellite.sh -m /mirrors -a
