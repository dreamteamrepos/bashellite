# Bashellite


Purpose
----------

Bashellite is a simple mirroring tool used to mirror as many different repository types as possible. It has a pluggable architecture that lets you write wrapper functions that call the "providers" that you would normally use to mirror a specific type of repository. As an example, it uses the following repository types using the following procotols and tools (note: this is not an exhaustive list):

 - rsyncd mirrors via the rsync protocol using the rsync provider
 - http/https mirrors via the http/https protocols using the wget provider
 - pypi mirrors via the https protocol using the bandersnatch provider
 - debian mirrors via the http/https protocols using the apt-mirror provider

If you find yourself trying to mirror several different types of repositories (i.e. rpm, deb, pypi, etc),
and can not find a single tool that does this effectively, bashellite might be what you're looking for.


Features
----------

Bashellite includes many of the same configuration options used by the provider utils that it calls to perform mirroring. Bashellite simply gives these tools some sensible default flags/options, and a standardized, user-friendly, high-configurable interface. Much of the options you would normally pass over the command-line, are either imbedded in the script for you (if they are not something you typically change), or they have been farmed out to configuration files that you then populate with data (if they are something you typically change). This alleviates the need to remember cumbersome command-line flags for each of the underlying tools. Much of the heavy lifting is taken care of for you. 

As an example, Bashellite does syntax checking for you, and prints useful error messages when you make a mistake via it's robust, highly-greppable system of logs. It also has a dry-run mode that shows you exactly what it would do during a real run; however, it should be noted that since some of the underlying providers tools do not natively provide a dry-run mode themselves, bashellite does the best it can to simulate a real run without downloading a bunch of data or making changes to the filesystem.


Usage
----------

         Usage: bashellite v0.4.0-beta
                [-m mirror_top-level_directory]
                [-c configuration_top-level_directory]
                [-p provider_top-level_directory]
                [-h]
                [-d]
                [-r repository_name] | [-a]

                Optional Parameter(s):
                -m:  Sets a temporary disk mirror top-level directory.
                     Only absolute (full) paths are accepted!
                -c:  Sets a temporary configuration top-level directory.
                     Only absolute (full) paths are accepted!
                -p:  Sets a temporary provider top-level directory.
                     Only absolute (full) paths are accepted!
                -h:  Prints this usage message.
                -d:  Dry-run mode. Pulls down a listing of the files and
                     directories it would download, and then exits.
                -r:  The repo name to sync.
                -a:  Mutually exclusive with -r option; sync all repos.

                Note: Repositories can be grouped by naming them with "__";
                      for example, repo: "images__linux" becomes images/linux
                      inside of the mirror directory passed via the "-m" flag.


Automated Installtion on DigitalOcean Droplet
----------------------------------------------

If you have a Digital Ocean account, you can use the `create-host.yml` `ansible` playbook in `.test/` to automatically build and configure a proof-of-concept installation of `bashellite`. Just edit the `.test/vars.yml` file to point to Github org that is hosting your desired fork of `bashellite`, and ensure that a copy of `bashellite-providers` and `bashellite-configs` (with those exact spellings) have also been forked. Alternately, you can just use `AFCYBER-DREAM` as the value of the `org_name` variable to use the current stable version along with our configs.

You'll also need to provide the ssh_key_id(s) that you would like to imbedded in the `centos` user's `authorized_keys` file. This information can be snagged using the DigitialOcean API via their `doctl` command-line util.

Last, but not least, you'll need to generate an `api_token` in your account settings and place that in your `vars.yml` as well; if you plan to push that value into version control, we highly recommend vaulting it `ansible-vault` prior to commiting it.

Once you've setup your variables, run the following:

```
ansible-playbook create-host.yml
```

If you vaulted your api_token and placed your vault password in a file in `~/.vault_pass`, run the following:

```
ansible-playbook --vault-password-file=~/.vault_pass create-host.yml
```

This playbook will create the server, and the server will then `ansible-pull` down the `setup-host.yml` file and run it on itself. After a few minutes, you should be able to login using the `centos` user from the account on your local machine containing one of the keys you specified via `ssh_key_ids`.  Once logged in, `sudo su bashellite` and run `bashellite -h`. You should see the bashellite usage message. If you can not login to the `bashellite` user, it means the `ansible-pull` has not completed. You can monitor it's progress with `watch "ps -aef | grep ansible"`.


Manual Installation of Dependencies
-----------------------------------

### EL7

Bashellite currently aims to support CentOS 7 and Red Hat Enterprise Linux 7 systems; however, it can be installed on Debian-based systems as well. If you are installing on a EL-based system, check out the `.init/` directory. You'll find a `install-deps.sh` script there used to install all the deps required to prep a fresh CentOS7 system for use as a bashellite server. Clone this repository to `/root/bashellite`, and then run the dep installer.

### Non-EL7

If you are using a non-EL7 system, you will have to install your deps manually:

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
   - `make`
 - Ensure `rsync` is installed globally, and in your path, if you would like to sync from rsync mirrors
 - Ensure `wget` is  installed globally, and in your path, if you would like to sync from http/https mirrors
 - Ensure that `pip` and `virtualenv` are installed globally, and in your path, if you would like to sync from pypi mirrors
   - If you have `pip` and `virtualenv` installed, the script will install `bandersnatch` and its deps for you
   - These install inside a python 3 virtual environment located in `/opt/bashellite/providers.d/`
 - Ensure `apt-mirror is installed globally, and in your path, if you would like to sync from debian-formatted repositories
   - On debian-based systems, `apt-mirror` is usually available as a DEB in the base repos if you would like it installed globally
   - If not installed via a package manager, when you run `make install`, the MakeFile will install `apt-mirror` from Github
 - Ensure `git` is installed globally, and in your path, if you would like to sync from Github/Gitlab/Gitweb servers.
 - Ensure `docker` is installed globally, and in your path, if you would like to sync from Docker Hub or another registry
 - Ensure `gem` is installed globally, and in your path, if you would like to sync from Ruby Gems or another gems mirror


Manual Installation of Bashellite
---------------------------------

### EL7

Once you've run `install-deps.sh` in the previous step, you will be ready to run the MakeFile to install bashellite itself. This is as simple as running: 

```
sudo su;
git clone https://github.com/AFCYBER-DREAM/bashellite-providers.git; # (or your fork of the same name)
git clone https://github.com/AFCYBER-DREAM/bashellite-configs.git; # (or your fork of the same name)
cd /root/bashellite/.init/;
make all;
```

   - This `make` command will do several things...
     - Installs `bashellite` in `/usr/local/bin`
     - Installs `bashellite-libs` and `util-libs` in `/usr/local/lib`
     - Creates a new `bashellite` user
     - Creates `/var/ww/bashellite`, `/opt/bashellite`, `/etc/bashellite`, and `/var/log/bashellite` and runs `chown` and `chmod` as appropriate
     - Copies the contents of your `bashellite-configs` and `bashellite-providers` directories into the appropriate locations on the file system

This adds a bashellite user to the server, then creates/copies all the directories and files bashellite needs to run properly. This must be run as run, since `bashellite` is secure by default and does not allow the `bashellite` command-line util to write it's own configs or modify it's own providers. The only thing that will be writable to bashellite is it's default mirror top-level directory, which is `/var/www/bashellite`. If you wish to use an alternate location, you will have to manually create that directory, using the same `mkdir`, `chown`, and `chmod` commands used in the MakeFile. Your mirror directory should be owned by bashellite:bashellite, and have a mode of 2750. The daemon serving the contents of this directory, (i.e ngnix or apache) should be added to the bashellite group so that they have read (but not write) access to it's contents.


### Non-EL7

 - Once the deps are installed, `sudo su -; cd ~; git clone git@github.com:AFCYBER-DREAM/bashellite.git`
 - You will also need to clone `AFCYBER-DREAM/bashellite-configs` and `AFCYBER-DREAM/bashellite-providers` into `/root/` as well
 - Once you've `cd`ed into the newly cloned `bashellite/.init/` directory as `root`, run `make all` to install it
   - This `make` command will do several things...
     - Installs `bashellite` in `/usr/local/bin`
     - Installs `bashellite-libs` and `util-libs` in `/usr/local/lib`
     - Creates a new `bashellite` user
     - Creates `/var/ww/bashellite`, `/opt/bashellite`, `/etc/bashellite`, and `/var/log/bashellite` and runs `chown` and `chmod` as appropriate
     - Copies the contents of your `bashellite-configs` and `bashellite-providers` directories into the appropriate locations on the file system

This adds a bashellite user to the server, then creates/copies all the directories and files bashellite needs to run properly. This must be run as run, since `bashellite` is secure by default and does not allow the `bashellite` command-line util to write it's own configs or modify it's own providers. The only thing that will be writable to bashellite is it's default mirror top-level directory, which is `/var/www/bashellite`. If you wish to use an alternate location, you will have to manually create that directory, using the same `mkdir`, `chown`, and `chmod` commands used in the MakeFile. Your mirror directory should be owned by bashellite:bashellite, and have a mode of 2750. The daemon serving the contents of this directory, (i.e ngnix or apache) should be added to the bashellite group so that they have read (but not write) access to it's contents.


Configuration
----------

After completing the installation process, you must populate your configuration directory if you did not place a cloned copy of `AFCYBER-DREAM/bashellite-configs` in `/root/bashellite-configs` prior to running `make all`. The make commands are idempotent, so feel free to clone and rerun.

Alternately, you can use the sample config `sample-bashellite.conf` to create your own bashellite config file.
The `mirror_tld` specified in this file must exist and the `bashellite` user must have write access.
By default, the installation process creates a `/var/www/bashellite` directory for this purpose, if you choose to use it.
This is also the default mirror location if one is not specified in the configuration file, or as a CLI option.

```
cd /etc/bashellite && sudo cp sample-bashellite.conf bashellite.conf;
sudo sed -i 's%^mirror_tld=.*%mirror_tld=${your_preferred_mirror_location_here}%' bashellite.conf;
```

After creating and populating the global config, you will need to populate a `repo.conf` file for each repo.
These files live in `/etc/bashellite/repos.conf.d/${repo_name}/`.
Please see `sample-repo.conf` for the required config parameters and their accepted options.

```
cd /etc/bashellite && sudo mkdir ${repo_name}/ && sudo cp sample-repo.conf ${repo_name}/repo.conf;
sudo sed -i 's%^repo_url=.*%repo_url=${your_repo_url_here}%' ${repo_name}/repo.conf;
sudo sed -i 's%^repo_provider=.*%repo_provider=${your_repo_provider_here}%' ${repo_name}/repo.conf;
```

After your `repo.conf` is populated, you may need to populate a config file for your provider.
This `provider.conf` file must exist at `/etc/bashellite/repos.conf.d/${repo_name}/provider.conf` for each repo; even if empty.
Each provider.conf will be in a different format for each provider. For example:
  - The `rsync` provider requires an exclude file; see example file, `man rsync`, and read explaination below for examples
  - The `wget` provider requires an include file; this is custom formatted... see example file and read explaination below
  - The `bandersnatch` provider requires a combined config/blacklist file; see example file or project's homepage for formatting details
  - The `apt-mirror` provider requires a combined config/include file; see example file or project's homepage for formatting details

Examples can be found in each providers `config/examples/` directory.

## repo.conf files
Each different repo type has a specific "provider" program that is used to sync it. Below is an explaination of each repo type and each provider.

#### rsync provider repo.conf
If a repo is going to be a rsyncd-served, rsync-synced repo, you'll populate that repo's `repo.conf` with a valid rsync URL. These typically start with "rsync://".
The repo_url parameter line will be: repo_url="rsync://your_url_here"
The repo_provider parameter line will be: repo_provider="rsync"

#### wget provider repo.conf
If it is going to be a http/https-formatted, wget-synced repo, you'll populate that repo's `repo.conf` with a valid "http://" or "https://" address.
The repo_url parameter line will be: repo_url="http:://your_http_url_here" OR "https://your_https_url_here"
The repo_provider parameter line will be: repo_provider="wget"

#### apt-mirror provider repo.conf
If it is going to be a debian-formatted, apt-mirror-synced repo, you'll populate `repo.conf` with a "http://" or "https://".
The repo_url parameter line will be: repo_url="http:://your_http_url_here" OR "https://your_https_url_here"
The repo_provider parameter line will be: repo_provider="apt-mirror"

#### bandersnatch provider repo.conf
If it is going to be a pypi-formatted, bandersnatch-synced repo, you'll populate that repo's `repo.conf` with a valid "http://" or "https://" address.
The repo_url parameter line will be: repo_url="http:://your_http_url_here" OR "https://your_https_url_here"
The repo_provider parameter line will be: repo_provider="bandersnatch"


## provider.conf files 
This file contains provider configs settings, package excludes/blacklists, package and/or includes. This file has a different format, depending on which provider you selected. It is advisable for you to use the dry-run feature (-d flag) to hone your `provider.conf` before executing a live run. A sample config file for each provider is available in `/etc/bashellite/sample-${repo_provider}-provider.conf` for each provider type.

#### rsync-formatted provider.conf
If you are setting up a rsync repo, this is a rsync `--exclude` file. Refer to the man page for rsync to learn more about excludes, includes, and filters. In general, it is better to be explicit than ambigious, so the preferred syntax for syncing rsync repos is the combined exclude/include rsync filter syntax which requires you to end your `provider.conf` with "- *" to ensure only the files you request above that line are grabbed. This will require you to specify each and every directory in a directory tree. For instance, if a tree looks like this: "centos -> 7 -> isos -> [files]" and you only want "[files]", your repo filter should have the following lines, in this order: "+ centos/", "+ centos/7/", "+ centos/7/isos/", "+ centos/7/isos/*", "- *". This will ensure that all other directories are excluded from your rsync, but everything inside of the "isos" subdirectory is grabbed and/or updated during each subsequent rsync run for this repo. The other supported format is the regular "exclude" syntax which require you to list the files and/or directories that you wish to exclude. Use the `bashellite` `-d` flag to test your filtering to ensure you are grabbing exactly the packages your wish to sync.

#### wget-formatted provider.conf
If you are setting up a wget-synced repo, simply include a list of each file or directory you would like to `wget`. The contents of this file are passed into `wget`. If a top-level file is wanted, then a line should specify the exact file name.  Any directories or file filters that are wanted, should prefix the line with "r "(note the space after the "r") to denote recursion is to be be used. Any directory names should end in "/" if you want just the folder downloaded. If you want the folder, and all it's contents, you'll use "<directory_name_here>/*". If you'd like to download just certain files (by extension) within a specific directory, use "<directory_name_here>/*.<file_extension>". If you want to download all files of a certain extension across all directories beneath the base URL you passed in via the `repo_url` parameter, just start the line with "r " and using globbing to specify the wildcards you would like it to match. 

Please note: any filename matching the glob "index.html*" has been inherently excluded for each interation to avoid a mirroring of the pages as well as the content. Also note, that unlike the rsync filter, each line is read-in and acted upon in isolation; each line is read into Bashellite, `wget` is called for that one, specific line, then `wget` exits, and the next line is passed-in to a new instance of `wget`. This means that some lines may encompass the same files in their filter, for example, if you were to specify: "*.iso" on one line, and then "isos/*.iso" on a subsequent line, the later would be redundant and unneccessary, because the "*.iso" line should have already grabbed all iso files in all directorties. Keep this in mind when designing your `provider.conf`.

#### apt-mirror-formatted provider.conf
If you are setting up an apt-mirror repo, the `provider.conf` file is combination config/include file. Refer to the man page for apt-mirror to learn more about how you specify the appropriate architectures and/or repository categories in a `mirror.lists` file. Bashellite uses a file in the `mirror.lists` format, but calls it by a standard naming convention (i.e. provider.conf). Bashellite looks for this combination config file in: `/etc/bashellite/${repo_name}/provider.conf`. The format of this file is similar to that of a "sources.list" file that you would find on any debian-based distro in "/etc/apt/sources.list"; however, there are some subtle differences, so be sure to review the apt-mirror documentation for a full breakdown of config options.

#### bandersnatch-formatted provider.conf
If you are setting up a pypi/bandersnatch-synced repo, the required `provider.conf` file is a valid `bandersnatch.conf` outlined in the provider's documentation on their home page. As part of this file, you will include a "directory" parameter that tells `bandersnatch` where to drop the packages it downloads. This since is already specified in `/etc/bashellite/bashellite.conf`, you must ensure that these values do not conflict. For example, if your ${repo_name} equals "pypi" and you want all your repo mirrors to write to "/mirror/${repo_name}", then the "mirror_tld" parameter in `/etc/bashellite/bashellite.conf` should read "/mirror"; while your `provider.conf` file should have a parameter called "directory" that has the value "/mirror/pypi". The `provider.conf` also includes provisions for a blacklist in a "[blacklist]" section of the config file. Simply include a line reading "[blacklist]" followed by another line reading "packages =" and then a two-space idented list (one package name per indented line) of each package name you would like to exclude. Please note, this is the package name as it appears in the simple index. For example, for the official pypi mirror at pypi.python.org, you would use the names listed here: https://pypi.python.org/simple/ for your exclude names. This will exclude every hosted version of the package. Please note, since older version of `bandersnatch` did NOT include provisions for excluding packages, ensure your bandersnatch install in the virutal environment located in `/opt/bashellite/providers.d/bandersnatch` is up-to-date. To refresh it, simply `rm -fr` the contents of that directory and `bashellite` will reinstall `bandersnatch` next time you attempt to sync a `bandersnatch`-provided repository.


Example Usage After Install is Complete
---------------------------------------

    # Does a dry run of a repository sync on a repository called "test_repo"
    bashellite -r test_repo -d

    # Mirrors a repository called "test_repo" inside the current working directory
    bashellite -m $(pwd) -r test_repo
    
    # Mirrors a repository called "test_repo" inside the ${mirror_tld} directory specified in `/etc/bashellite/bashellite.conf`
    bashellite -r test_repo
    
    # Mirrors a repository called "test_repo" inside a directory called "/mirrors"
    bashellite -m /mirrors -r test_repo
    
    # Mirrors all repositories (${repo_name}) into "/mirrors" that have a `repo.conf` and `provider.conf` in `/etc/bashellite/repos.conf.d/${repo_name}"
    bashellite -m /mirrors -a

    # Does a dry run on every properly-defined repository; this is great for doing an overall deps and syntax check
    bashellite -m $(pwd) -a -d


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
