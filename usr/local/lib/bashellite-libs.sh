bashelliteUsage() {

  if [[ "${#}" == "1" ]]; then
    case "${1}" in
      FAIL)
        local msg="FAIL";
        local usg="RED";
        ;;
      WARN)
        local msg="WARN";
        local usg="YELLOW";
        ;;
      INFO)
        local msg="INFO";
        local usg="GREEN";
        ;;
      SKIP)
        local msg="SKIP";
        local usg="BLUE";
        ;;
      *)
        utilMsg FAIL "$(utilTime)" "Invalid input for function (${FUNCNAME[@]}); exiting."
        ;;
    esac
  else
    local msg="INFO";
    local usg="GREEN";
  fi

  utilMsg $msg "$(utilTime)" "See $(basename ${0}) usage below..." 
  echo
  utilMsg $usg "12345678"     "Usage: $(basename ${0}) v${_r_script_version}"
  utilMsg $usg "12345678"     "       [-m mirror_top-level_directory]"
  utilMsg $usg "12345678"     "       [-c configuration_top-level_directory]"
  utilMsg $usg "12345678"     "       [-p provider_top-level_directory]"
  utilMsg $usg "12345678"     "       [-h]"
  utilMsg $usg "12345678"     "       [-d]"
  utilMsg $usg "12345678"     "       [-r repository_name] | [-a]"
  echo
  utilMsg $usg "12345678"     "       Optional Parameter(s):"
  utilMsg $usg "12345678"     "       -m:  Sets a temporary disk mirror top-level directory."
  utilMsg $usg "12345678"     "            Only absolute (full) paths are accepted!"
  utilMsg $usg "12345678"     "       -c:  Sets a temporary configuration top-level directory."
  utilMsg $usg "12345678"     "            Only absolute (full) paths are accepted!"
  utilMsg $usg "12345678"     "       -p:  Sets a temporary provider top-level directory."
  utilMsg $usg "12345678"     "            Only absolute (full) paths are accepted!"
  utilMsg $usg "12345678"     "       -h:  Prints this usage message."
  utilMsg $usg "12345678"     "       -d:  Dry-run mode. Pulls down a listing of the files and"
  utilMsg $usg "12345678"     "            directories it would download, and then exits."
  utilMsg $usg "12345678"     "       -r:  The repo name to sync."
  utilMsg $usg "12345678"     "       -a:  Mutually exclusive with -r option; sync all repos."
  echo
  utilMsg $usg "12345678"     "       Note: Repositories can be grouped by naming them with \"__\";"
  utilMsg $usg "12345678"     "             for example, repo: \"images__linux\" becomes images/linux"
  utilMsg $usg "12345678"     "             inside of the mirror directory passed via the \"-m\" flag."
  echo

}


bashelliteSetup() {
  # This section unsets and/or initializes some of the script's variables
  # This prevents it from inheriting exported variables from the parent env.
  for var in \
              _r_mirror_tld \
              requested_target_repo_name \
              target_repo_name \
              metadata_tld \
              _r_metadata_tld \
              _r_dry_run \
              all_repos \
              providers_tld \
              _r_providers_tld \
              config_file_mirror_tld \
              config_file_providers_tld \
              _r_repo_name_array \
              mirror_repo_name \
             ;
  do
     unset ${var} \
       || { \
             utilMsg FAIL "$(utilTime)" "Unable to unset variable (${var}); exiting." >&2;
             return 1;
          };
  done
  
  # Determines if deps are installed
  _n_bashellite_deps=( \
                        grep \
                        date \
                        tput \
                        basename \
                        realpath \
                        dirname \
                        ls \
                        mkdir \
                        chown \
                        touch \
                        cat \
                        sed \
                        ln \
                        tee \
                     );
  
  utilDeps _n_bashellite_deps || return 1;
  
  # Determines if specified deps are GNU versions
  _n_bashellite_gnu_deps=( \
                            grep \
                            date \
                            basename \
                            realpath \
                            dirname \
                            ls \
                            mkdir \
                            chown \
                            touch \
                            cat \
                            sed \
                            ln \
                            tee \
                         );
  
  utilGNU _n_bashellite_gnu_deps || return 1;
 
  # Ensure command-line arguments were actually passed to the program
  if [[ "${#}" == "0" ]]; then
    bashelliteUsage FAIL;
    utilMsg FAIL "$(utilTime)" "Bashellite has mandatory parameters; review usage message and try again." >&2;
    return 1;
  fi
  
  # Bash-builtin getopts is used to perform parsing, so no long options are used.
  while getopts ":m:r:c:p:dah" passed_parameter; do
   case "${passed_parameter}" in
      m)
        # Variable initialized here, but finalized below case statement
        local mirror_tld="${OPTARG}";
        ;;
      r)
        # Sanitizes the directory name of spaces or any other undesired characters.
        local requested_target_repo_name="${OPTARG}";
        local target_repo_name="${requested_target_repo_name//[^a-zA-Z0-9_-]}";
        if [[ "${requested_target_repo_name}" != "${target_repo_name}" ]]; then
          utilMsg FAIL "$(utilTime)" "Requested repo_name contains invalid characters; exiting.";
          return 1;
        else
          readonly _r_target_repo_name="${target_repo_name}" \
            || { \
                  utilMsg FAIL "Failed to set constant (target_repo_name)";
                  return 1;
               };
        fi
        ;;
      c)
        # Variable finalized below case statement
        local metadata_tld="${OPTARG}";
        ;;
      p)
        # Variable finalized below case statement
        local providers_tld="${OPTARG}";
        ;;
      d)
        # Lets all subsequent conditionals know that this is a dryrun is "-d" flag is passed
        readonly _r_dryrun=true \
          || { \
                utilMsg FAIL "$(utilTime)" "Failed to set constant (dryrun)";
                return 1;
             };
        ;;
      a)
        # Ensures that the repo_name_array gets populated with all configured repos if "-a" is passed
        local all_repos=true \
          || { \
                utilMsg FAIL "$(utilTime)" "Failed to set local variable (all_repos)";
                return 1;
             };
        ;;
      h)
        # Help option; prints usage message, then returns 0
        bashelliteUsage INFO;
        return 0;
        ;;
      *)
        # Invalid option; prints usage message, then returns 1
        bashelliteUsage FAIL;
        utilMsg FAIL "$(utilTime)" "Invalid option passed to \"$(basename ${0})\"; exiting. See Usage below.";
        return 1;
        ;;
    esac
  done
  shift $((OPTIND-1));

  ### Finalizes the value of variable (metadata_tld) ###
  # Sets the default value of variable, if not otherwise already defined elsewhere
  local metadata_tld="${metadata_tld:=/etc/bashellite}";
  # Sanitizes user inputs for variable
  local metadata_tld="${metadata_tld//[^a-zA-Z1-9_-/]}";
  local metadata_tld=${metadata_tld//\"};
  if [[ "${metadata_tld:0:1}" != "/" ]]; then
    bashelliteUsage FAIL;
    utilMsg FAIL "$(utilTime)" "\nAbsolute paths only, please; exiting.\n";
  else
    # Drops the last "/" from the value to ensure uniformity for functions using it
    # Note: as a side-effect, this effective prevents using just "/" as the value
    local metadata_tld="${metadata_tld%\/}";
  fi
  # Makes the variable a constant and exports it
  readonly _r_metadata_tld="${metadata_tld}" \
    || { \
          utilMsg FAIL "$(utilTime)" "Failed to set constant (metadata_tld)";
          return 1;
       };
  
  ### Finalizes the value of variable (mirror_tld) ###
  # Gets and sets value of variable from config file (if it is defined there)
  local config_file_mirror_tld="$(grep -oP "(?<=(^mirror_tld=)).*" ${metadata_tld}/bashellite.conf)";
  local mirror_tld="${mirror_tld:=$config_file_mirror_tld}";
  # Sets the default value of variable, if not otherwise already defined elsewhere
  local mirror_tld="${mirror_tld:=/var/www/bashellite/mirror}";
  # Sanitizes user inputs for variable
  local mirror_tld="${mirror_tld//[^a-zA-Z1-9_-/]}";
  local mirror_tld=${mirror_tld//\"};
  if [[ "${mirror_tld:0:1}" != "/" ]]; then
    bashelliteUsage FAIL;
    utilMsg FAIL "\nAbsolute paths only, please; exiting.\n";
  else
    # Drops the last "/" from the value to ensure uniformity for functions using it
    # Note: as a side-effect, this effective prevents using just "/" as the value
    local mirror_tld="${mirror_tld%\/}";
  fi
  # Makes the variable a constant and exports it
  readonly _r_mirror_tld="${mirror_tld}" \
    || { \
          utilMsg FAIL "$(utilTime)" "Failed to set constant (mirror_tld)";
          return 1;
       };
  # Ensures mirror_tld directory exists, if not tries to create it (requires user to have appropriate filesystem permissions).
  if [[ ! -d "${_r_mirror_tld}" ]]; then
    utilMsg INFO "$(utilTime)" "Mirror top-level directory (${_r_mirror_tld}) does not exist; attempting to create."
    mkdir "${_r_mirror_tld}" &>/dev/null \
    || utilMsg FAIL "$(utilTime)" "Unable to create directory (${_r_mirror_tld}); create manually, set permissions, and rerun."
  fi

  ### Finalizes the value of variable (providers_tld) ###
  # Gets and sets value of variable from config file (if it is defined there)
  local config_file_providers_tld="$(grep -oP "(?<=(^providers_tld=)).*" ${_r_metadata_tld}/bashellite.conf)";
  local providers_tld="${providers_tld:=$config_file_providers_tld}";
  # Sets the default value of variable, if not otherwise already defined elsewhere
  local providers_tld="${providers_tld:=/opt/bashellite/providers.d}";
  # Sanitizes user inputs for variable
  local providers_tld="${providers_tld//[^a-zA-Z1-9_-/]}";
  local providers_tld=${providers_tld//\"};
  if [[ "${providers_tld:0:1}" != "/" ]]; then
    bashelliteUsage FAIL;
    utilMsg FAIL "$(utilTime)" "\nAbsolute paths only, please; exiting.\n";
    return 1;
  else
    # Drops the last "/" from the value to ensure uniformity for functions using it
    # Note: as a side-effect, this effective prevents using just "/" as the value
    local providers_tld="${providers_tld%\/}";
  fi
  # Makes the variable a constant and exports it
  readonly _r_providers_tld="${providers_tld}" \
    || { \
          utilMsg FAIL "$(utilTime)" "Failed to set constant (providers_tld)";
          return 1;
       };
  
  # If the "-a" flag is passed, populate the repo_name_array with all repos
  # Otherwise, if the "-r" is passed, populate it with value of ${target_repo_name}
  if [[ "${all_repos}" == "true" ]]; then
    declare -gr _gr_repo_name_array=( $(ls ${_r_metadata_tld}/repos.conf.d/) );
  elif [[ -d "${_r_metadata_tld}/repos.conf.d/${_r_target_repo_name}/" ]]; then
    declare -gr _gr_repo_name_array=( ${_r_target_repo_name} );
  fi

  # Ensures repo_name_array is not empty
  if [[ -z "${_gr_repo_name_array[@]}" ]]; then
    utilMsg FAIL "$(utilTime)" "Bashellite requires at least one valid repository.";
    return 1;
  fi

  # Exit if both "-a" and "-r" are passed and display usage
  if [[ "${all_repos}" == "true" ]] && [[ "${#_r_target_repo_name}" != "0" ]]; then
    bashelliteUsage FAIL;
    utilMsg FAIL "$(utilTime)" "The flags -a and -r are mutually exclusive. Use one or the other; exiting.\n";
    return 1;
  fi

}


bashelliteCallProvider() {

  # Validating pre-sanitized repo_name variable was passed in properly
  if [[ -z "${_n_repo_name}" ]]; then
    utilMsg FAIL "$(utilTime)" "Failed to pass a value for variable (_n_repo_name) to function (${FUNCNAME[0]}).";
    return 1;
  fi

  # Validating pre-sanitized metadata_tld variable was passed in properly
  if [[ -z "${_r_metadata_tld}" ]]; then
    utilMsg FAIL "$(utilTime)" "Failed to pass a value for variable (metadata_tld) to function (${FUNCNAME[0]}).";
    return 1;
  fi

  # Validates that repo_url and/or repo_provider is set in config file
  utilMsg INFO "$(utilTime)" "Validating repo (${_n_repo_name}) metadata...";
  if [[ -f "${_r_metadata_tld}/repos.conf.d/${_n_repo_name}/repo.conf" ]]; then
    for parameter in $( \
                         grep -oP "^repo_(url|provider)=.*" ${_r_metadata_tld}/repos.conf.d/${_n_repo_name}/repo.conf
                      );
    do
      declare _n_${parameter};
    done
  else
    utilMsg FAIL "$(utilTime)" "No metadata for (${_n_repo_name}) present in repo metadata directory (${_r_metadata_tld}/repos.conf.d/${_n_repo_name}); exiting."
    return 1;
  fi
 
  # Sanitizes repo_url
  if [[ ! -z "${_n_repo_url}" ]]; then
    _n_repo_url="${_n_repo_url//[^a-zA-Z1-9_.-:/]}";
    _n_repo_url="${_n_repo_url//\"/}";
    _n_repo_url="${_n_repo_url%\/}";
  else
    utilMsg FAIL "$(utilTime)" "repo_url not set in repo.conf file for (${_n_repo_name})"
    return 1;
  fi

  # Sanitizes repo_provider
  if [[ ! -z "${_n_repo_provider}" ]]; then
    _n_repo_provider="${_n_repo_provider//[^a-z-]}";
  else
    utilMsg FAIL "$(utilTime)" "repo_provider not set in repo.conf file for (${_n_repo_name})"
    return 1;
  fi

  # Sources appropriate bashellite provider_wrapper function based on inputs
  source ${_r_providers_tld}/${_n_repo_provider}/provider_wrapper.sh;
  # Finds first function defined in the sourced provider_wrapper file; function must use "funcname() {" format to define function
  local provider_wrapper="$(grep -oP "[a-zA-Z_]+?(?=(\(\)\s*\{))" ${_r_providers_tld}/${_n_repo_provider}/provider_wrapper.sh | head -n 1)";
  # Ensures a valid function name was actually parsed/set, and then executes the function (if set) or returns 1 (if not set)
  if [[ "${provider_wrapper}" != "$(grep "${provider_wrapper}" < <(set))" ]]; then
    ${provider_wrapper} || return 1;
  else
    utilMsg FAIL "$(utilTime)" "Failed to source provider_wrapper for provider (${_n_repo_provider}); exiting."
    return 1;
  fi

}


bashelliteGreatSuccess() {

  if [[ -s "/var/log/bashellite/${_n_repo_name}.${_r_datestamp}.${_r_run_id}.error.log" ]]; then
    utilMsg WARN "$(utilTime)" "Bashellite has successfully completed requested task for repo (${_n_repo_name}), but...";
    utilMsg WARN "$(utilTime)" "Please see error log for error details; minor errors detected in this run's error log:";
    utilMsg WARN "$(utilTime)" " errors => /var/log/bashellite/${_n_repo_name}.${_r_datestamp}.${_r_run_id}.error.log"
    _n_no_repo_dl_errors=false;
    _n_repo_dl_retry_count=$((_n_repo_dl_retry_count+1));
    echo
  else
    utilMsg INFO "$(utilTime)" "Bashellite has successfully completed requested task for repo (${repo_name})!";
    utilMsg INFO "$(utilTime)" "Please see logs for event details; no errors detected in this run's error log:";
    utilMsg INFO "$(utilTime)" " events => /var/log/bashellite/${_n_repo_name}.${_r_datestamp}.${_r_run_id}.event.log"
    _n_no_repo_dl_errors=true;
    echo
  fi

}

