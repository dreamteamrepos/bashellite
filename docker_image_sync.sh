elif [[ -n "${docker_registry_url}" ]]; then
    Info "Running registry container with mounted volume: ${mirror_tld}/${mirror_repo_name}/"
    Info "Command: docker run -d -p 5000:5000 --name registry -v ${mirror_tld}/${mirror_repo_name}:/var/lib/registry registry:2"
    if [[ ${dryrun} == "" ]]; then
      # Only run registry container if not a dry run
      docker run -d -p 5000:5000 --name registry -v ${mirror_tld}/${mirror_repo_name}:/var/lib/registry registry:2
    fi
    for line in $(cat ${script_dir}/_metadata/${repo_name}/repo_filter.conf); do
      # Check to see it tags are listed
      tag_index=0
      tag_index=`expr index "${line}" ':'`
      tags_found=""
      tags_found="${line:${tag_index}}"
      
      if [[ ${tag_index} == 0 ]]; then
        # No tags found, downloading latest tag for image
        Info "Pulling latest tag for image: ${line}"
        Info "Command: docker pull ${docker_registry_url}/${line}:latest"
        if [[ ${dryrun} == "" ]]; then
          # Only pull if not a dry run
          docker pull ${docker_registry_url}/${line}:latest
        fi
        Info "Pushing latest tag for image: ${line} to local registry container"
        Info "Command 1: docker tag ${line}:latest localhost:5000/${line}:latest"
        Info "Command 2: docker push localhost:5000/${line}:latest"
        if [[ ${dryrun} == "" ]]; then
          # Only tag and push if not a dry run
          docker tag ${line}:latest localhost:5000/${line}:latest
          docker push localhost:5000/${line}:latest
        fi
      elif [[ ${tag_index} == 1 || ${tags_found} == "" ]]; then
        Warn "Invalid image/tag format found: ${line}, skipping..."
      else
        # Tags found
        Info "Tags found"
        IFS=$',\n'
        tags_array=( ${tags_found} )
        unset IFS
        image_name=""
        image_name="${line:0:${tag_index} - 1}"
        for each_tag in ${tags_array[@]}; do
          Info "Pulling tag: ${each_tag} for image: ${image_name}"
          Info "Command: docker pull ${docker_registry_url}/${image_name}:${each_tag}"
          if [[ ${dryrun} == "" ]]; then
            #only pull if not a dry run
            docker pull ${docker_registry_url}/${image_name}:${each_tag}
          fi
          Info "Pushing tag: ${each_tag} for image: ${image_name} to local registry container"
          Info "Command 1: docker tag ${image_name}:${each_tag} localhost:5000/${image_name}:${each_tag}"
          Info "Command 2: docker push localhost:5000/${image_name}:${each_tag}"
          if [[ ${dryrun} == "" ]]; then
            # Only tag and push if not a dry run
            docker tag ${image_name}:${each_tag} localhost:5000/${image_name}:${each_tag}
            docker push localhost:5000/${image_name}:${each_tag}
          fi
        done
      fi
    done
    Info "Stopping Registry and removing all containers and images"
    Info "Command 1: docker stop registry"
    Info "Command 2: docker rm -f $(docker ps -a -q)"
    Info "Command 3: docker rmi -f $(docker images -q)"
    if [[ ${dryrun} == "" ]]; then
      # Only tag and push if not a dry run
      docker stop registry
      docker rm -f $(docker ps -a -q)
      docker rmi -f $(docker images -q)
    fi
    unset docker_registry_url;