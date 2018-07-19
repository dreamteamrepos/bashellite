bashelliteProviderWrapperTest() {

  source ${_r_providers_tld}/test/src/bashelliteProviderTest.sh;
  
  unset this_variable_does_not_exist;
  unset this_function_does_not_exist;

  for item_name in \
                   _r_metadata_tld \
                   _r_providers_tld \
                   _r_mirror_tld \
                   _r_run_id \
                   _r_datestamp \
                   _n_repo_name \
                   _n_repo_url \
                   _n_repo_provider \
                   this_variable_does_not_exist \
                   utilLog \
                   utilDeps \
                   utilGNU \
                   utilColors \
                   utilDate \
                   utilTime \
                   utilMsg \
                   bashelliteUsage \
                   bashelliteSetup \
                   bashelliteCallProvider \
                   bashelliteGreatSuccess \
                   this_function_does_not_exist \
                   ;
  do
    bashelliteProviderTest "${item_name}" || return 1;
  done;

  utilMsg BLUE "$(utilTime)" "[provider.conf]";
  utilMsg BLUE "$(utilTime)" "$( \
                                  cat ${_r_metadata_tld}/repos.conf.d/test/provider.conf \
                               )\n";

}

