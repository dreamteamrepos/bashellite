#!/usr/bin/env bash

oneTimeSetUp() {
  local lib_dir="$(dirname $(realpath ${0}))"
  source ${lib_dir}/util-libs.sh;
}

testUtilTime() {

  # Tests fail condition and input sanitization
  assertSame "[FAIL] Failed to set timestamp; ensure date supports \"--iso-8601\" flag!" "$(date() { echo "Not a valid date"; }; utilTime 2>&1)";
  assertSame "1" "$(date() { echo "Not a valid time"; }; utilTime 2>/dev/null; echo "${?}")";

  # Tests success condition
  assertSame "13542403" "$(date() { echo "2018-05-07T13:54:24,038845689-05:00"; }; utilTime;)";  
  assertSame "0" "$(date() { echo "2018-05-07T13:54:24,038845689-05:00"; }; utilTime &>/dev/null; echo "${?}";)";  

}

source $(which shunit2);

