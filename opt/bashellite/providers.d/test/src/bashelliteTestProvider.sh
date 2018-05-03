
bashelliteTestProvider() {

  local variable_name="${1}";

  # Prints variables setup by earlier bashellite functions
  utilMsg INFO "$(utilTime)" "[${variable_name}] $(declare -p ${variable_name} 2>&1)";

}

