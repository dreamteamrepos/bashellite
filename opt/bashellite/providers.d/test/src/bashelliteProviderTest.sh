
bashelliteProviderTest() {

  local item_name="${1}";

  # Prints variables setup by earlier bashellite functions
  utilMsg BLUE "$(utilTime)" "[${item_name}]";
  utilMsg BLUE "$(utilTime)" "$( \
                                  declare -p ${item_name} 2>/dev/null \
                                  || declare -pF ${item_name} 2>/dev/null \
                                  || echo "No variable or function found in environment!" \
                               )\n";

}

