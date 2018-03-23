# Bashellite


Purpose
----------

Bashellite is a simple mirroring tool used to mirror the following repository types using the following procotols and tools:

 - rsync mirrors via the rsync protocol using rsync
 - http/https mirrors via the http/https protocol using wget
 - pypi mirrors via the https protocol using bandersnatch

If you find yourself trying to mirror several different types of repositories (i.e. rpm, deb, pypi, etc),
and can not find a single tool that does this effectively, bashellite might be what you're looking for.


Features
----------

Bashellite includes many of the same configuration options used by the tools it calls to perform mirroring. Bashellite simply gives these tools some sensible default flags/options, and a user-friendly interface. Much of the options you would normally pass over the command-line, are either imbedded in the script, or they have been farmed out to configuration files that you then populate with data. This alleviates the need to remember cumbersome command-line flags for each of the underlying tools. Much of the heavy lifting is taken care of for you. As an example, Bashellite auto-generates it's own configuration files, allowing you to quickly mirror new repositories. It also does syntax checking for you, and prints useful error messages when you make a mistake. Last, but not least, Bashellite has a dry run mode that shows you exactly what it would do during a real run; however, it should be noted that since some of the underlying tools do not provide a dryrun mode, bashellite does the best it can to simulate a real run.


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
 - Ensure that the following non-GNU utils are installed:
   - `tput`
 - Ensure GNU versions of the following are installed:
   - `date`
   - `basename`
   - `realpath`
   - `dirname`
   - `ls`
   - `mkdir`
   - `chown`
   - `touch`
   - `cat`
   - `sed`
   - `ln`
   - `tee`
 - Ensure `rsync` is installed if you would like to sync from rsync mirrors
 - Ensure `wget` is  installed if you would like to sync from http/https mirrors
 - Ensure that `pip` and `virtualenv` are installed if you would like to sync from pypi mirrors
   - If you have `pip` and `virtualenv` installed, the script will install `bandersnatch` and its deps for you
 - `git clone git@github.com:AFCYBER-DREAM/bashellite.git`



Configuration
----------

After completing the installation process, you can immediately start initializing new repositories to mirror. First, you'll need to autogenerate some config boilerplate:

    
`./bashellite.sh -m $(pwd) -r test_repo`
    

This will create a new set of repo definition files in $(pwd)/_metadata/test_repo and print some follow-on instructions for you. At this point, you have to make a choice: what type of repo is this going to be?  

## Repo Types and Providers
Each different repo type has a specific "provider" program that is used to sync it. Below is an explaination of each repo type and each provider.

#### rsync (rsync provider) repo
If this going to be a rsync repo, you'll populate `$(pwd)/_metadata/test_repo/rsync_url.conf` with a valid rsync URL. These typically start with "rsync://".

#### http/https (wget provider) repo
If it is going to be a http/https repo, you'll populate `$(pwd)/_metadata/test_repo/http_url.conf` with a valid "http://" or "https://" address. 

#### apt-mirror (apt-mirror provider) repo
If it is going to be an apt-mirror repo, you'll populate `$(pwd)/_metadata/test_repo/aptmirror_url.conf` with a source list, similar in style to the sources.list file you find in most debian-based distros in /etc/apt/sources.list. See apt-mirror utility documentation for details about how this `mirrors.list` file should be formatted, and place your configuration in `_metadata/<repo_name>/aptmirror_url.conf`. You should avoid changing any of the `*_path` variables in this config file, since bashellite-specific defaults are already specified in the `apt-mirror` script itself for each repo in the `_bin/<repo_name>/apt-mirror` file.

#### pypi (bandersnatch provider) repo
If it is going to be a pypi repo, you'll populate `$(pwd)/_metadata/test_repo/pypi_url.conf` with a valid "http://" or "https://" address.


## Repo Filters (i.e. excludes and includes)
After you've entered an URL into the appropriate *_url.conf file, you will need to setup your repo_filter.conf file. This file has a different format, depending on which repo type you selected. It is advisable for all repo type to first use the dryrun feature (-d flag) to hone your repo filter before executing a live run. 

#### rsync filter
If you are setting up a rsync repo, this is a rsync exclude file. Refer to the man page for rsync to learn more about excludes, includes, and filters. In general, it is better to be explicit than ambigious, so the preferred syntax for syncing rsync repos is to end your `repo_filter.conf` with "- *" to ensure only the files you request above that line are grabbed. This will require you to specific each and every directory in a directory tree. For instance, if a tree looks like this: "centos -> 7 -> isos -> [files]" and you only want "[files]", your repo filter should have the following lines, in this order: "+ centos/", "+ centos/7/", "+ centos/7/isos/", "+ centos/7/isos/*", "- *". This will ensure that all other directories are excluded from your rsync, but everything inside of the "isos" subdirectory is grabbed and/or updated during each subsequent rsync run for this repo.

#### http filter
If you are setting up a http repo, simply include a list of each file or directory you would like to `wget`. The contents of this file are passed into `wget` using the `--include-directories` and/or `--accept` flags. Any directory names should end in "/" if you want just the folder downloaded. If you want the folder, and all it's contents, you'll use "<directory_name_here>/*". If you'd like to download just certain files (by extension) within a specific directory, use "<directory_name_here>/*.<file_extension>". If you want to download all files of a certain extension across all directories beneath the base URL you passed in via `http_url.conf`, just drop the directory name and "/" and using globbing to specify the wildcards you would like it to match. Please note: any filename matching the glob "index.html*" has been inherently excluded for each interation to avoid a mirroring of the pages as well as the content. Also note, that unlike the rsync filter, each line is read-in and acted upon in isolation; each line is read into Bashellite, `wget` is called for that one, specific line, then `wget` exits, and the next line is passed-in to a new instance of `wget`. This means that some lines may encompass the same files in their filter, for example, if you were to specify: "*.iso" on one line, and then "isos/*.iso" on a subsequent line, the later would be redundant and unneccessary, because the "*.iso" line should have already grabbed all iso files in all directorties. Keep this in mind when designing your `repo_filter.conf`.

#### apt-mirror filter
If you are setting up an apt-mirror repo, the repo filter file is not used. Refer to the man page for apt-mirror to learn more about how you specify the appropriate architectures and/or repository categories in a `mirror.lists` file. Bashellite uses a file in the `mirror.lists` format to act as both a "*url.conf" file and a repo filter simultaneously. Bashellite looks for this combination config file in: `_metadata/<repo_name>/aptmirror_url.conf`. The format of this file is similar to that of a "sources.list" file that you would find on any debian-based distro in "/etc/apt/sources.list"; however, there are some subtle differences, so be sure to review the apt-mirror documentation for a full breakdown of config options. Important note: some of the config options that you can set in the `aptmirror_url.conf` file already have some defaults in the apt-mirror script itself located in "_bin/$repo_name/apt-mirror". These defaults are required for apt-mirror to conform to the mirror structure that Bashellite is using. To avoid overriding these defaults, please refrain from setting the "$base_path" and or variables in your "aptmirror_url.conf" file. Please only use this file to specify the repos you would like synced. 

#### pypi filter
If you are setting up a pypi repo, include a list of each package name you would like to exclude. Please note, this is the package name as it appears in the simple index. For example, for the official pypi mirror at pypi.python.org, you would use the names listed here: https://pypi.python.org/simple/ for your exclude names. This will exclude every hosted version of the package. Please note, since `bandersnatch` does NOT include provisions for excluding packages up front, excludes are accomplished after-the-fact, post-download. This can be a little annoying if you have a large number of excludes, since it will redownload them each time the repo syncs.


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

    # Does a dry run on every repository; this is great for doing an overall deps and syntax check
    ./bashellite.sh -m /mirrors -a -d

Troubleshooting
---------------
Bashellite has several built-in provisions for troubleshooting. Most importantly it implements a robust logging mechanism designed to capture both events and errors in a grep-friendly manner. Errors generated during the sync process are written to: `/var/log/bashellite/`

#### Log File Naming Schema
Each repository gets two logs for each and every run Bashellite attempts. One log is the "event" log that documents STDOUT messages from the script and providers. The other log is an "error" log that records STDERR. The naming schema is as follows:

    - /var/log/bashellite/<repo_name>.<YYMMDD>.<run_id>.error.log 
    - /var/log/bashellite/<repo_name>.<YYMMDD>.<run_id>.event.log

#### run_id
The "run_id" is a number generated by the `date` command, and is part of each log name. It ensures that all logs from the same run have matching ids, while ensuring that runs for the same repo, on the same day, but from different runs, have different ids, and therefore slightly different log names. The run_ids are arranged in numerical and chronological order, so a lower numbered run_id will indicate that a run occurred earlier in the day when compared to another run from that same day with a higher run_id. 

#### Message levels
The script prints messages at three levels, and only has one level of verbosity. The message levels are `INFO`, `WARN`, and `FAIL`. `INFO` messages are strictly informational, and are provided for debugging and informational purposes; these are logged in the event log and sent to STDOUT on the terminal. `WARN` messages indicate a problem and are logged to the error log; `WARN` messages may or may not be followed by a `FAIL` message. If they are not, the script continues to execute. `FAIL` messages indicate an issue that is severe enough to warrant stopping execution of the script, and whenever a fail message is invoked, the script always return a non-zero exit code. `FAIL` messages are logged in the error log, along with `WARN` messages. 

#### Log entry numbers
As you are watching output scroll by on the terminal, or reading the logs, you may notice a number on the left-hand side of some lines. These are log entry numbers. They are generated with the `date` command and are in both numerical and chronological order. the format is: HHMMSSNN, where "NN" is the first two digits of the nano-second. This log entry number ensures that no two entries will have the same number, and even lets you compare across the same time each day if your grep-fu is good. These numbers also appear on terminal output so that you can quickly find this same error in the logs. It is written to both simultaneously.

#### Unlogged Errors
On rare occassions, you may run into instances where bashellite fails, but the error is not reported in a log. This is because Bashellite performs some prepatory administrative checks prior to logging being fully setup. If you come across an unlogged failure when invoking Bashellite from a cron job or other non-interactive method, try running it manually from the command-line under similar conditions (i.e. same user, etc.). This test may generate an error message that is printed to STDOUT, but not logged to /var/log/bashellite. If you still can not figure out why the script is failing, there is a debug option in the script that can be toggled on/off by manually editing `bashellite.sh` it manually from the command-line under similar conditions (i.e. same user, etc.). This test may generate an error message that is printed to STDOUT, but not logged to /var/log/bashellite. If you still can not figure out why the script is failing, there is a debug option in the script that can be toggled on/off by manually editing `bashellite.sh`. It is clearly marked and located towards the top of the file.  
