#!/usr/bin/env bash

for provider_dir in $(ls /opt/bashellite/providers.d/); do
  chown root /opt/bashellite/providers.d/${provider_dir}/install_provider.sh \
  && chmod u+x /opt/bashellite/providers.d/${provider_dir}/install_provider.sh \
  && /opt/bashellite/providers.d/${provider_dir}/install_provider.sh;
done
