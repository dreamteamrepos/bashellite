####################
#
### REPOSITORY DOCUMENTATION
### ius-repo
#
####################
#

#####
# Mirror Information
#####

This repository is a mirror of Rackspace's Inline w/ Upstream Vendor (IUS) repo located on the internet at:
rsync://dl.iuscommunity.org/ius/

This repo is designed to offer drop-in replacements for base CentOS and RHEL packages.
The reason behind this is because RHEL/CentOS default to a stability-over-feature policy.
This family of OSes version-locks releases of common packages and backports security updates
for the life of the OS, rather than providing newer releases of those packages.
If newer features are required, IUS provides a safe upgrade path. IUS should be used sparingly.
It requires you use the base RHEL/CentOS packages for all dependencies when updgrading a package.
Therefore, is an example f you upgrade PHP from 5.3 to 7, you should use the base Apache 2.2, not 2.4.

In order to install the repository, you must first install EPEL, since this is a dependency.
Next, create a file in /etc/yum.repos.d/ called "ius.repo" with the following contents:

----------
[ius]
name=IUS Community Packages for Enterprise Linux 7 - $basearch
baseurl=https://dl.iuscommunity.org/pub/ius/stable/Redhat/7/$basearch
#mirrorlist=https://mirrors.iuscommunity.org/mirrorlist?repo=ius-el7&arch=$basearch&protocol=http
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY
----------

You will also need to place the following public key in a file located at the location noted in the repo file:

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.2.6 (GNU/Linux)

mQGiBEqdoRgRBADVoaxeu3wXCqG+EmrgBoJ8WUjrf5IWl2SvbkASQIyZThZKIizM
+HBGc6rZhLmcoYJsUeef5y915f+B2VHlW2HRDi3qnPUpl1UOMsKxl7/EUSK6Owe0
9x/j044Ji22g5CCzl28EvdJY7yNKFvfhSKKkTmmC+WcQwsc5W5CGurtQEwCg5uMI
p7IzURfXlE0nvaqOgQBdSiMD/1qizNAafb+3GGmkSFP7M3KVLoaIlVziNs6ovDZC
JnlSD+YdcFlhA8vy7Wy0H4fYUIOCSBYbuFgZmYTI3AphGOrogBiURUANxL4oIK3I
N6ClxUofoPw6t3xUecELmK6xnsOfIWXRVMjH7xWEVxHLABXWcUYO/63+DO5JZW3u
XWn9BACzXzWCtHarTKvQRqtEDhd4RxR7of3mZG6dtvaD7Oao2+NoO6ydAQgINnbX
sSKjGgX4x5c3jIMcOc64sdlsaiNi6Xw8NTF8xw5TeurFTx1teDnIEgTRDk33JuSa
bPj5ppDDnBI3G+8a3c+SR2wYBjpYnySY3PM9R+MRzdX1PfkUjbQwSVVTIENvbW11
bml0eSBQcm9qZWN0IDxjb3JlZGV2QGl1c2NvbW11bml0eS5vcmc+iF4EExECAB4F
AkqdoRgCGwMGCwkIBwMCAxUCAwMWAgECHgECF4AACgkQ2iIc35zUlT8UqgCgy1OF
Adsy9z6oDjdW+euAF+CGs9gAn3pb8/btMK1GWtAZEus1mjZG3wm3uQENBEqdoRgQ
BADzG6p1xsbW7eNcCCuL6aIHnN1oqWaoofhegF0nq/GJw3kPRgt7dzMJkJdLVo6J
Jn7cE1vUWpj49C7C+EJQgntvVQIOG1/ExhFPhP+B6E3dAA6rxJoI7Of28wTydOjB
Cxrp+zqSXcsaW8CxqZWnrOGU/6skY1NL+N/4di+O9w6scwADBgQAs91884xBgpLN
9HrqsctFCXaZKHEEashvBCnPjZNHZrRDWnbzrmZxlI8YuvhFy5w11QeNR4I0Slew
prP/WNF7aR/n0aHQ/hBlM0exJovvA2MxWL9Aid1efZfPyjDQtfqrcgSuxUMum8pU
wTv9ONNxsl4tU1rd0aw9KTMR+3hFK8+ISQQYEQIACQUCSp2hGAIbDAAKCRDaIhzf
nNSVP9KyAKDQc01jMA04wjR/XgA+mfzC/kpFPQCaAjXYn804voIOQp5J1cBFWz5q
jBo=
=MxD1
-----END PGP PUBLIC KEY BLOCK-----

This public key can be retreived from the following URL, and only applies to the RHEL7 repo:
https://rhel7.iuscommunity.org/ius-release.rpm

Notes: by default, this points to a mirror list. This has been comment out to use the baseurl.
The Debug and Source RPM repos are not included since these are not mirrored at this time.

To replace a base package, you must first install yum-plugin-replace.
Then, you run a command similar to the following:

yum replace php --replace-with php71u

You can also use a new yum built-in new to RHEL7 called "yum swap"

yum swap php php71u

Either of these will strip out php53 (and all deps) and replace them with equivalant php7 packages.
The end result is that you should be able to run a "php -m" and see the same modules you had before.

See IUS usage page for more details:
https://ius.io/Usage/


#####
# Retention Policy
####

We are currently mirroring stable IUS packages for RHEL7 only.

We believe that this retention policy is sufficient for our internal infrastructure needs.
If you would like packages for another version of RHEL/CentOS from their repos,
please create a ticket on the JIRA service desk for the Unit Software License Manager (USLM).
