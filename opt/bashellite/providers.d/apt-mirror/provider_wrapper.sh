bashelliteProviderWrapper() {
  if [[ ! ${_r_dryrun} ]]; then
    apt-mirror ${_r_metadata_tld}/repos.conf.d/${_n_repo_name}/provider.conf;
  fi
  if [[ "${?}" != "0" ]]; then
    utilMsg WARN "$(utilTime)" "apt-mirror either failed or completed with errors for repo (${_n_repo_name})."
  else
    utilMsg INFO "$(utilTime)" "apt-mirror completed successfully for repo (${_n_repo_name})."
  fi
}
