#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilDeps() {

  # Tests fail condition for if "which" is not in path
  assertSame "[FAIL] Dependency (which) missing!" "$(which() { return 1; }; utilDeps foo 2>&1)";
  assertSame "1" "$(which() { return 1; }; utilDeps foo 2>/dev/null; echo "${?}")";
 
  # Tests fail condition for if requested_function_input contains invalid characters
  assertSame "[FAIL] Requested dependency or array name contains invalid characters; exiting." "$(utilDeps f00b@r! 2>&1)";
  assertSame "1" "$(utilDeps f00b@r! 2>/dev/null; echo "${?}")";

  # Tests success condition for valid array names and single deps
  assertSame "0" "$(utilDeps shunit2 &>/dev/null; echo "${?}")";  
  assertSame "0" "$(unittest_array=( shunit2 ); utilDeps unittest_array &>/dev/null; echo "${?}")";  

  # Tests fail condition for if a dependency is not in path
  assertSame "[FAIL] Dependency (my_fake_dep) missing!" "$(utilDeps my_fake_dep 2>&1)";
  assertSame "1" "$(utilDeps my_fake_dep 2>/dev/null; echo "${?}")";

}

source $(which shunit2);

#utilDeps() {
#
#  # Ensures the dependency checker is actually installed before proceeding
#  which which &>/dev/null \
#    || { echo "[FAIL] Dependency (which) missing!" >&2; return 1; };
#
#  # Sanitizes input to a set of reasonable filename characters
#  local requested_function_input="${1}";
#  local function_input="${requested_function_input//[^A-Za-z0-9_.-]}";
#  if [[ "${requested_function_input}" != "${function_input}" ]]; then
#    echo "[FAIL] Requested dependency or array name contains invalid characters; exiting."
#    return 1;
#  fi
#
# 
#  # Determines if $1 is a single dep or an array name by parsing the output of "declare -p"
#  local input_type="$(declare -p "${function_input}" 2>/dev/null || echo "non_array" )";
#  local input_type="${input_type%%=*}";
#  local input_type="${input_type##declare -}";
#  case "${input_type:0:1}" in
#    a)
#      local input_type="array";
#      ;;
#    *)
#      local input_type="dep_name";
#      ;;
#  esac
#
#  # Populates dep_array with either single dep name or contents of the provided array
#  if [[ "${input_type}" == "array" ]]; then
#    local dep_array=( $(eval echo \$\{${function_input}\[\@\]\}) );
#  else
#    local dep_array=( ${function_input} );
#  fi
#
#  # Performs path check on all deps listed in dep_array
#  for dep in ${dep_array[@]}; do
#    which ${dep} &>/dev/null \
#      || { echo "[FAIL] Dependency (${dep}) missing! >&2"; return 1; };
#  done
#
#}

