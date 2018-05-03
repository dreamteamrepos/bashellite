#!/usr/bin/env bash

main() {

  local provider_tld="/opt/bashellite/providers.d";

  for dep in \
             pip \
             virtualenv \
             rm \
             ; do
    which ${dep} &>/dev/null \
    || {
         echo "[FAIL] Can not proceed until ${dep} is installed and accessible in path; exiting." \
         && exit 1;
       };
  done
  # If pip and virtualenv are installed, ensure bandersnatch is installed in proper location, and functional.
  # If bandersnatch is not installed, or broken, blow away the old one, and install a new one.
  ${providers_tld}/bandersnatch/exec/bin/bandersnatch --help &>/dev/null \
  || {
       echo "[WARN] bandersnatch does NOT appear to be installed, (or it is broken); (re)installing..." \
       && rm -fr ${providers_tld}/bandersnatch/exec/ &>/dev/null \
       && virtualenv --python=python3.5 ${providers_tld}/bandersnatch/exec/ \
       && ${providers_tld}/bandersnatch/exec/bin/pip install -r https://bitbucket.org/pypa/bandersnatch/raw/stable/requirements.txt;
     };
  # Ensure bandersnatch installed successfully
  {
    ${providers_tld}/bandersnatch/exec/bin/bandersnatch --help &>/dev/null \
    && echo "[INFO] bandersnatch installed successfully...";
  } \
  || {
       echo "[FAIL] bandersnatch was NOT installed successfully; exiting." \
       && exit 1;
     };
}

main
