
bashelliteProviderWrapper() {

  source ${_r_providers_tld}/test/src/bashelliteTestProvider.sh;
  
  bashelliteTestProvider "_r_metadata_tld";
  bashelliteTestProvider "_r_providers_tld";
  bashelliteTestProvider "_r_mirror_tld";
  bashelliteTestProvider "_r_run_id";
  bashelliteTestProvider "_r_datestamp";
  bashelliteTestProvider "_n_repo_name";
  bashelliteTestProvider "_n_repo_url";
  bashelliteTestProvider "_n_repo_provider";

}

