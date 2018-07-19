#!/usr/bin/env bash
#
### Program Name: Bashellite
#
### Program Author: Cody Lee Cochran <Cody.L.Cochran@gmail.com>
### Program Contributors: Eric Lake <EricLake@Gmail.com>, Patrick Chandler <pc.seanmckay@gmail.com>
#
### Program Version:
    _r_script_version="0.4.0-beta"
#
### Program Purpose:
#   The purpose of this program is to create an automated method for pulling
#   package files from an upstream mirror on the internet, and exporting
#   the newly created local mirror to an external HDD for import to an "air-gapped"
#   network. The repo data retrieved from upstream repos is staged on a local mirror
#   that does have internet access, and is prepped for export on that local
#   mirror. The local mirror is also used to keep track of what has previously
#   been exported so that a diff can be run each time data is pulled from
#   the upstream repos. This is used to determine what gets exported from the
#   local staging mirror to the downstream air-gapped mirror. The exports are
#   then shipped via a read-only medium to the air-gapped network to prevent
#   leakage from the air-gapped network onto the internet-connected network.
#
################################################################################

# This section is for toggling debugging on/off
# "set -x" toggles debugging on
# "set +x" toggles debugging off
set +x;

# Loads the program's libraries
# They must be in "../lib" relative the bashellite's "./bin" directory
if [[ -f "/usr/bin/realpath" ]] && [[ -f "/usr/bin/dirname" ]]; then
  _n_bashellite_bin_dir="$(/usr/bin/realpath $(/usr/bin/dirname ${0}))";
  _n_bashellite_lib_dir="${_n_bashellite_bin_dir%/bin}/lib";
  source ${_n_bashellite_lib_dir}/util-libs.sh;
  for utilfunction in \
                      utilLog \
                      utilDeps \
                      utilGNU \
                      utilColors \
                      utilDate \
                      utilTime \
                      utilMsg \
                      ;
  do
      readonly -f ${utilfunction};
  done;
  source ${_n_bashellite_lib_dir}/bashellite-libs.sh;
  for bashellitefunction in \
                            bashelliteUsage \
                            bashelliteSetup \
                            bashelliteCallProvider \
                            bashelliteGreatSuccess \
                            ;
  do
      readonly -f ${bashellitefunction};
  done;
else
  echo "[FAIL] Failed to source bashellite library functions; exiting." >&2;
  exit 1;
fi

# Sets up color messaging
utilColors \
  || { \
        echo "[FAIL] Failed to setup colorized output; exiting.";
        exit 1;
     };


# Sets up advanced logging features
utilLog /var/log/bashellite \
  || { \
        echo "[FAIL] Failed to setup logging; exiting.";
        exit 1;
     };

# Runs the setup function that defines all the required variables/constants
while true; do
  bashelliteSetup ${@} \
  || { \
        utilMsg FAIL "$(utilTime)" "Bashellite failed to setup required variables for providers; exiting!";
        exit 1;
     };
  break;
done 1> >(tee -a ${_r_log_dir}/_setup_.${_r_datestamp}.${_r_run_id}.event.log >&1) \
     2> >(tee -a ${_r_log_dir}/_setup_.${_r_datestamp}.${_r_run_id}.error.log >&2);

# Iterates through the repo_name_array defined in bashelliteSetup
# If the "-r" flag was passed, the array contains just one repo_name
# If the "-a" flag was passed, the array contains every repo_name
for repo_name in ${_gr_repo_name_array[@]}; do

  _n_repo_name="${repo_name}";
  _n_mirror_repo_name="${_n_repo_name//__/\/}";
  _n_no_repo_dl_errors=false;
  _n_repo_dl_retry_count=0;

  # Bashellite must have an empty error log for the repo, or it will retry up to 2 times to sync a repo
  until ${_n_no_repo_dl_errors} || [[ ${_n_repo_dl_retry_count} -gt 2 ]]; do
    # Bashellite must perform two successful passes per repo
    for pass in first second; do
      if [[ ${_n_repo_dl_retry_count} == 0 ]]; then
        utilMsg INFO "$(utilTime)" "Starting Bashellite run (${_r_run_id}) for repo (${repo_name}), ${pass} pass...";
      else 
        utilMsg INFO "$(utilTime)" "Starting retry ${_n_repo_dl_retry_count} of Bashellite run (${_r_run_id}) for repo (${repo_name}), ${pass} pass...";
      fi
      if [[ ! -d "${_r_mirror_tld}/${_n_mirror_repo_name}" ]]; then
        utilMsg INFO "$(utilTime)" "Repo's mirror directory (${_r_mirror_tld}/${_n_mirror_repo_name}) does not exist; attempting to create."
        mkdir -p "${_r_mirror_tld}/${_n_mirror_repo_name}" &>/dev/null \
        || { \
              utilMsg FAIL "$(utilTime)" "Unable to create directory (${_r_mirror_tld}/${_n_mirror_repo_name}); check permissions of mirror_tld, and rerun."
              exit 1
           };
      fi
    
      bashelliteCallProvider \
        || { \
              utilMsg FAIL "$(utilTime)" "Bashellite failed to call requested provider, or provider returned with fatal error code; exiting!";
              exit 1;
           };
    done
    bashelliteGreatSuccess;
  done 1> >(tee -a ${_r_log_dir}/${_n_repo_name}.${_r_datestamp}.${_r_run_id}.event.log >&1) \
       2> >(tee -a ${_r_log_dir}/${_n_repo_name}.${_r_datestamp}.${_r_run_id}.error.log >&2);
done

################################################################################

