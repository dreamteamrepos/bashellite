#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilMsg() {

  # Tests minimum parameter failure message and return code output
  assertSame "[FAIL] Failed to pass in minimum number of required parameters to function (utilMsg); exiting." "$(utilMsg 1 2 2>&1)";
  assertSame "1" "$(utilMsg 1 2 &>/dev/null; echo $?)";

  # Tests msg_type sanitizing failure message and return code output
  assertSame "[FAIL] Requested message type (F00) passed to function (utilMsg) contains invalid characters; exiting." "$(utilMsg F00 1234 message 2>&1)";
  assertSame "Test input: F00" "1" "$(utilMsg F00 1234 message &>/dev/null; echo $?)";
  assertSame "Test input: Fail" "1" "$(utilMsg Fail 1234 message &>/dev/null; echo $?)";
  assertSame "Test input: \!\*\$F5" "1" "$(utilMsg \!\*\$F5 1234 message &>/dev/null; echo $?)";
  assertSame "Test input: INFO" "0" "$(utilMsg INFO 1234 message &>/dev/null; echo $?)";

  # Tests timestamp sanitizing failure message and return code output
  assertSame "[FAIL] Requested timestamp (foob@r) passed to function (utilMsg) contains invalid characters; exiting." "$(utilMsg INFO foob@r message 2>&1)";
  assertSame "Test input: foob@r" "1" "$(utilMsg INFO foob@r message &>/dev/null; echo $?)";
  assertSame "Test input: \"my,big F00-barred.time_stamp\"" "0" "$(utilMsg INFO "my,big F00-barred.time_stamp" message &>/dev/null; echo $?)";
  assertSame "Test input: \"Fri, 04 May 2018 07:26:36 -0500\"" "0" "$(utilMsg INFO "Fri, 04 May 2018 07:26:36 -0500" message &>/dev/null; echo $?)";

  # Tests msg_type case statement logic
  assertSame "1234 green[INFO] message" "$(PROG_MSG_GREEN="green"; utilMsg INFO 1234 message 2>&1)";
  assertSame "1234 yellow[WARN] message" "$(PROG_MSG_YELLOW="yellow"; utilMsg WARN 1234 message 2>&1)";
  assertSame "1234 red[FAIL] message" "$(PROG_MSG_RED="red"; utilMsg FAIL 1234 message 2>&1)";
  assertSame "1234 blue[SKIP] message" "$(PROG_MSG_BLUE="blue"; utilMsg SKIP 1234 message 2>&1)";
  assertSame "[FAIL] The passed parameter (NULL) is not a valid message type; exiting." "$(utilMsg NULL 1234 message 2>&1)";

  # Tests Info messaging output and return code
  assertSame "1234 [INFO] message" "$(utilMsg INFO 1234 "message")";
  assertSame "0" "$(utilMsg INFO 1234 "message" &>/dev/null; echo $?)";

  # Tests Warn messaging output and return code
  assertSame "1234 [WARN] message" "$(utilMsg WARN 1234 "message" 2>&1)";
  assertSame "0" "$(utilMsg WARN 1234 "message" &>/dev/null; echo $?)";

  # Tests Fail messaging output and return code
  assertSame "1234 [FAIL] message" "$(utilMsg FAIL 1234 "message" 2>&1)";
  assertSame "1" "$(utilMsg FAIL 1234 "message" &>/dev/null; echo $?)";

  # Tests Skip messaging output and return code
  assertSame "1234 [SKIP] message" "$(utilMsg SKIP 1234 "message")";
  assertSame "0" "$(utilMsg SKIP 1234 "message" &>/dev/null; echo $?)";

  # Tests Dryrun messaging output and return code
  assertSame "1234 [DRYRUN|SKIP] message" "$(local PROG_DRYRUN=true; utilMsg SKIP 1234 "message")";
  assertSame "0" "$(local PROG_DRYRUN=true; utilMsg SKIP 1234 "message" &>/dev/null; echo $?)";

}

source $(which shunit2);


#utilMsg() {
#
#  # Ensure locale is set to default to ensure bash pattern-matching works as expected  
#  local LC_COLLATE="C";
#
#  # Ensures there are at least three parameters passed in before continuing
#  if [[ "${#}" -lt "3" ]]; then
#    echo "[FAIL] Failed to pass in minimum number of required parameters to function (${FUNCNAME[0]}); exiting." >&2;
#    return 1;
#  fi
#  
#  # Parses and sanitizes the msg_type parameter passed to function
#  local requested_msg_type="${1}";
#  local msg_type="${requested_msg_type//[^A-Z]}";
#  if [[ "${requested_msg_type}" != "${msg_type}" ]]; then
#    echo "[FAIL] Requested message type (${requested_msg_type}) passed to function (${FUNCNAME[0]}) contains invalid characters; exiting."
#    return 1;
#  fi
#  shift;
#
#  # Parses and sanitizes the timestamp parameter passed to function
#  local requested_timestamp="${1}";
#  local timestamp="${requested_timestamp//[^A-Za-z0-9 ,:._-]}";
#  if [[ "${requested_timestamp}" != "${timestamp}" ]]; then
#    echo "[FAIL] Requested timestamp (${requested_timestamp}) passed to function (${FUNCNAME[0]}) contains invalid characters; exiting."
#    return 1;
#  fi
#  shift;
#  
#  # Determines if this is a dryrun for the parent program
#  if [[ ${PROG_DRYRUN} ]]; then
#    local dryrun_tag="DRYRUN|";
#  fi
#
#  # Sets up color coding provided by parent program
#  unset error_msg;
#  case ${msg_type} in
#    FAIL)
#      local msg_color="${PROG_MSG_RED}";
#      local error_msg="true";
#      ;;
#    WARN)
#      local msg_color="${PROG_MSG_YELLOW}";
#      local error_msg="true";
#      ;;
#    INFO)
#      local msg_color="${PROG_MSG_GREEN}";
#      ;;
#    SKIP)
#      local msg_color="${PROG_MSG_BLUE}";
#      ;;
#    *)
#      echo "[FAIL] The passed parameter (${msg_type}) is not a valid message type; exiting." >&2;
#      return 1;
#      ;;
#  esac
#
# # Prints ${3} and beyond as the message; ${1} is the type; ${2} is the timestamp
#  if [[ "${error_msg}" == "true" ]]; then
#    # If message is an error message, send to STDERR
#    echo -e "${PROG_MSG_WHITE}"${timestamp}" ${msg_color}["${dryrun_tag}""${msg_type}"] $*${PROG_CLEAR_COLOR}" >&2;
#    # If the error is indicating an exit-worthy failure, exit program after printing error message
#    if [[ "${msg_type}" == "FAIL" ]]; then
#      return 1;
#    fi
#  else
#    echo -e "${PROG_MSG_WHITE}"${timestamp}" ${msg_color}["${dryrun_tag}""${msg_type}"] $*${PROG_CLEAR_COLOR}" >&1;
#  fi
#}  
