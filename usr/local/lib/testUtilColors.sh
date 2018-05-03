#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilColors() {

  # Tests to ensure color variables are set read-only and exported
  assertSame "declare -rx PROG_MSG_CLEAR" "$(shunit2_testing="true"; utilColors PROG_MSG_CLEAR 2>/dev/null)";
  assertSame "declare -rx PROG_MSG_BLUE" "$(shunit2_testing="true"; utilColors PROG_MSG_BLUE 2>/dev/null)";
  assertSame "declare -rx PROG_MSG_RED" "$(shunit2_testing="true"; utilColors PROG_MSG_RED 2>/dev/null)";
  assertSame "declare -rx PROG_MSG_WHITE" "$(shunit2_testing="true"; utilColors PROG_MSG_WHITE 2>/dev/null)";
  assertSame "declare -rx PROG_MSG_GREEN" "$(shunit2_testing="true"; utilColors PROG_MSG_GREEN 2>/dev/null)";

  # Ensures function reports failure properly if variables are NOT assigned properly
  assertSame "" "$(local shunit2_testing="true"; utilColors NOT_A_VALID_VARIABLE_NAME 2>/dev/null)";
  assertSame "declare -- local_variable" "$(shunit2_testing="true"; local local_variable="true"; utilColors local_variable 2>/dev/null)";

  # Tests to ensure function can properly detect if variables are already read-only and exported
  assertSame "colors already set" "$(shunit2_testing="true"; utilColors &>/dev/null; utilColors 2>/dev/null)";

}

source $(which shunit2);


