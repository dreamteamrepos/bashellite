utilLog() {

  # Determines log directory of program
  if [[ "${#}" == "1" ]]; then
    readonly _r_log_dir="${1}";
  else
    utilDeps basename || return 1;
    utilGNU basename || return 1;
    readonly _r_log_dir="/var/log/$(basename ${0})";
  fi

  # Ensures the log directory has been created
  if [[ ! -d "${_r_log_dir}" ]]; then
    utilMsg FAIL "$(utilTime)" "Log directory (${_r_log_dir}) does not exist; exiting.";
  fi
  
  # Attempts to set program execution's datestamp
  { \
     unset _r_datestamp \
     && readonly _r_datestamp="$(utilDate)";
  } \
  || { \
        utilMsg FAIL "$(utilTime)" "Failed to set variable (datestamp)!";
        return 1;
     };


  # Attempts to set program execution's run_id
  { \
     unset _r_run_id \
     && readonly _r_run_id="$(utilTime)";
  } \
  || { \
        utilMsg FAIL "$(utilTime)" "Failed to set variable (run_id)!";
        return 1;
     };

} 


utilDeps() {

  # Ensures the dependency checker is actually installed before proceeding
  which which &>/dev/null \
    || { echo "[FAIL] Dependency (which) missing!" >&2; return 1; };
  
  # Sanitizes input to a set of reasonable filename characters
  local requested_function_input="${1}";
  local function_input="${requested_function_input//[^A-Za-z0-9_.-]}";
  if [[ "${requested_function_input}" != "${function_input}" ]]; then
    echo "[FAIL] Requested dependency or array name contains invalid characters; exiting." >&2;
    return 1;
  fi
 
  # Determines if $1 is a single dep or an array name by parsing the output of "declare -p"
  local input_type="$(declare -p "${function_input}" 2>/dev/null || echo "non_array" )";
  local input_type="${input_type%%=*}";
  local input_type="${input_type##declare -}";
  case "${input_type:0:1}" in
    a)
      local input_type="array";
      ;;
    *)
      local input_type="dep_name";
      ;;
  esac

  # Populates dep_array with either single dep name or contents of the provided array
  if [[ "${input_type}" == "array" ]]; then
    local dep_array=( $(eval echo \$\{${function_input}\[\@\]\}) );
  else
    local dep_array=( ${function_input} );
  fi

  # Performs path check on all deps listed in dep_array
  for dep in ${dep_array[@]}; do
    which ${dep} &>/dev/null \
      || { echo "[FAIL] Dependency (${dep}) missing!" >&2; return 1; };
  done

}


utilGNU() {

  # Sanitizes input to a set of reasonable filename characters
  local requested_function_input="${1}";
  local function_input="${requested_function_input//[^A-Za-z0-9_.-]}";
  if [[ "${requested_function_input}" != "${function_input}" ]]; then
    echo "[FAIL] Requested GNU dependency or array name contains invalid characters; exiting." >&2;
    return 1;
  fi
 
  # Determines if $1 is a single dep or an array name by parsing the output of "declare -p"
  local input_type="$(declare -p "${function_input}" 2>/dev/null || echo "non_array" )";
  local input_type="${input_type%%=*}";
  local input_type="${input_type##declare -}";
  case "${input_type:0:1}" in
    a)
      local input_type="array";
      ;;
    *)
      local input_type="dep_name";
      ;;
  esac

  # Populates dep_array with either single dep name or contents of the provided array
  if [[ "${input_type}" == "array" ]]; then
    local dep_array=( $(eval echo \$\{${function_input}\[\@\]\}) );
  else
    local dep_array=( ${function_input} );
  fi

  # Performs path check on all deps listed in dep_array
  for dep in ${dep_array[@]}; do
    ${dep} --version 2>&1 \
    | { \
         read -r line;
         parsed_line="${line//*GNU*/GNU}";
         if [[ "${parsed_line}" != "GNU" ]]; then
           echo "[FAIL] Dependency (${dep}) not GNU version!" >&2;
           return 1;
         fi;
      };
  done

}


utilColors() {

  for color in \
               PROG_MSG_CLEAR="$(tput sgr0)" \
               PROG_MSG_WHITE="$(tput setaf 7)" \
               PROG_MSG_BLUE="$(tput setaf 4)" \
               PROG_MSG_GREEN="$(tput setaf 2)" \
               PROG_MSG_YELLOW="$(tput setaf 3)" \
               PROG_MSG_RED="$(tput setaf 1)" \
               PROG_MSG_COLORS_SET="true" \
               ;
  do
    if [[ "${PROG_MSG_COLORS_SET}" != "true" ]]; then    
      readonly "${color}" &>/dev/null;
    else
      # Used later by shunit2 to detect if colors are already set
      local colors_already_set="true";
    fi
  done

  export \
         PROG_MSG_CLEAR \
         PROG_MSG_WHITE \
         PROG_MSG_BLUE \
         PROG_MSG_GREEN \
         PROG_MSG_YELLOW \
         PROG_MSG_RED \
         PROG_MSG_COLORS_SET \
         ;

  if [[ "${shunit2_testing}" == "true" ]]; then
    if [[ "${colors_already_set}" != "true" ]]; then
      # Print the value of specified variable set above
      declare -p "${1}" | while read line; do echo "${line%%\=*}"; done
    else
      echo "colors already set";
    fi
  fi

}


utilDate() {

  # Check to ensure the date binary is present in path, and the GNU version
  utilDeps date;
  utilGNU date;

  local datestamp="$(date --iso-8601 2>/dev/null)";
  local datestamp="${datestamp//[^0-9]}";
  local datestamp="${datestamp:2}"
  if [[ -z "${datestamp}" ]]; then
    echo "[FAIL] Failed to set datestamp; ensure date supports \"--iso-8601\" flag!" >&2;
    return 1;
  else
    echo ${datestamp};
  fi

}


utilTime() {

  # Check to ensure the date binary is present in path, and the GNU version
  utilDeps date;
  utilGNU date;

  local timestamp="$(date --iso-8601='ns' 2>/dev/null)";
  local timestamp="${timestamp//[^0-9]}";
  local timestamp="${timestamp:8:8}";
  if [[ -z "${timestamp}" ]]; then
    echo "[FAIL] Failed to set timestamp; ensure date supports \"--iso-8601\" flag!" >&2;
    return 1;
  else
    echo "${timestamp}";
  fi

}


utilMsg() {

  # Ensure locale is set to default to ensure bash pattern-matching works as expected  
  local LC_COLLATE="C";

  # Ensures there are at least three parameters passed in before continuing
  if [[ "${#}" -lt "3" ]]; then
    echo "[FAIL] Failed to pass in minimum number of required parameters to function (${FUNCNAME[0]}); exiting." >&2;
    return 2;
  fi
  
  # Parses and sanitizes the msg_type parameter passed to function
  local requested_msg_type="${1}";
  local msg_type="${requested_msg_type//[^A-Z]}";
  if [[ "${requested_msg_type}" != "${msg_type}" ]]; then
    echo "[FAIL] Requested message type (${requested_msg_type}) passed to function (${FUNCNAME[0]}) contains invalid characters; exiting."
    return 2;
  fi
  shift;

  # Parses and sanitizes the timestamp parameter passed to function
  local requested_timestamp="${1}";
  local timestamp="${requested_timestamp//[^A-Za-z0-9 ,:._-]}";
  if [[ "${requested_timestamp}" != "${timestamp}" ]]; then
    echo "[FAIL] Requested timestamp (${requested_timestamp}) passed to function (${FUNCNAME[0]}) contains invalid characters; exiting."
    return 2;
  fi
  shift;
  
  # Sets up color coding provided by parent program
  case ${msg_type} in
    FAIL|WARN|INFO|SKIP)
      case ${msg_type} in
         FAIL)
           local msg_color="${PROG_MSG_RED}";
           local error_msg="true";
           ;;
         WARN)
           local msg_color="${PROG_MSG_YELLOW}";
           local error_msg="true";
           ;;
         INFO)
           local msg_color="${PROG_MSG_GREEN}";
           ;;
         SKIP)
           local msg_color="${PROG_MSG_BLUE}";
           ;;
      esac
      local opener="[";
      local closer="]";
      if [[ ${_r_dryrun} ]]; then
        local dryrun_tag="DRYRUN|";
      fi
      ;;
    RED|YELLOW|GREEN|BLUE)
      case ${msg_type} in
         RED)
           local msg_color="${PROG_MSG_RED}";
           local error_msg="true";
           ;;
         YELLOW)
           local msg_color="${PROG_MSG_YELLOW}";
           local error_msg="true";
           ;;
         GREEN)
           local msg_color="${PROG_MSG_GREEN}";
           ;;
         BLUE)
           local msg_color="${PROG_MSG_BLUE}";
           ;;
      esac
      local msg_type="    ";
      local opener=" ";
      local closer=" ";
      if [[ ${_r_dryrun} ]]; then
        local dryrun_tag="       ";
      fi
      local timestamp="$(eval printf \' %.0s\' {1..${#timestamp}})";
      ;;
    *)
      echo "[FAIL] The passed parameter (${msg_type}) is not a valid message type; exiting." >&2;
      return 2;
      ;;
  esac

  # Prints ${3} and beyond as the message; ${1} is the type; ${2} is the timestamp
  if [[ "${error_msg}" == "true" ]]; then
    # If message is an error message, send to STDERR
    echo -e "${PROG_MSG_WHITE}${timestamp} ${msg_color}${opener}${dryrun_tag}${msg_type}${closer} $*${PROG_MSG_CLEAR}" >&2;
    # If the error is indicating an exit-worthy failure, exit program after printing error message
    if [[ "${msg_type}" == "FAIL" ]]; then
      return 1;
    fi
  else
    echo -e "${PROG_MSG_WHITE}${timestamp} ${msg_color}${opener}${dryrun_tag}${msg_type}${closer} $*${PROG_MSG_CLEAR}" >&1;
  fi
  
}
