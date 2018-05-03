bashelliteProviderWrapperRsync() {

  utilMsg INFO "$(utilTime)" "Syncing from upstream mirror to local repo (${_n_repo_name})...";
  if [[ ${_r_dryrun} ]]; then
    local dryrun_flag="--dry-run";
  else
    local dryrun_flag="";
  fi
  rsync -avSP ${_n_repo_url} \
    ${dryrun_flag} \
    --exclude-from="${_r_metadata_tld}/repos.conf.d/${_n_repo_name}/provider.conf" \
    --safe-links \
    --no-motd \
    --hard-links \
    --update \
    --links \
    --delete \
    --delete-before \
    --ignore-existing \
    ${_r_mirror_tld}/${_n__repo_name}
  if [[ "${?}" != "0" ]]; then
    utilMsg WARN "$(utilTime)" "rsync completed with errors for repo (${_n_repo_name})."
  else
    utilMsg INFO "$(utilTime)" "rsync completed successfully for repo (${_n_repo_name})."
  fi

} 
