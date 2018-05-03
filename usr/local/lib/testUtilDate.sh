#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilDate() {

  # Tests fail condition and input sanitization
  assertSame "[FAIL] Failed to set datestamp; ensure date supports \"--iso-8601\" flag!" "$(date() { echo "Not a valid date"; }; utilDate 2>&1)";
  assertSame "1" "$(date() { echo "Not a valid date"; }; utilDate 2>/dev/null; echo "${?}")";

  # Tests success condition
  assertSame "180507" "$(date() { echo "2018-05-07"; }; utilDate;)";  
  assertSame "0" "$(date() { echo "2018-05-07"; }; utilDate &>/dev/null; echo "${?}";)";  

}

source $(which shunit2);

