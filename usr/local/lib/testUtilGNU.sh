#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilGNU() {

  # Tests fail condition for if requested_function_input contains invalid characters
  assertSame "[FAIL] Requested GNU dependency or array name contains invalid characters; exiting." "$(utilGNU f00b@r! 2>&1)";
  assertSame "1" "$(utilGNU f00b@r! 2>/dev/null; echo "${?}")";

  # Tests success condition for valid array names and single deps
  assertSame "0" "$(grep() { echo "This is the GNU version of grep"; }; utilGNU grep &>/dev/null; echo "${?}")";  
  assertSame "0" "$(grep() { echo "Yay GNU"; }; unittest_array=( grep ); utilGNU unittest_array &>/dev/null; echo "${?}")";  

  # Tests fail condition for if a dependency is not a GNU dep
  assertSame "[FAIL] Dependency (wrong_dep) not GNU version!" "$(wrong_grep() { echo "This is not the FSF-released version of dep"; }; utilGNU wrong_dep 2>&1)";
  assertSame "1" "$(utilGNU wrong_dep 2>/dev/null; echo "${?}")";

}

source $(which shunit2);

