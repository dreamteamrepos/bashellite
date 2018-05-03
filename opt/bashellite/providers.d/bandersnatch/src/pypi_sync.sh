#!/bin/bash
                                                                                                                      
# Kill all other bandersnatch operations
pkill bandersnatch

# Remove pypi lock file if it exists
if [ -f /mirrors1/pypi/.lock ]
  then
    rm -f /mirrors1/pypi/.lock
fi
  
# Source the SCL python 3.6 install
source /opt/rh/rh-python36/enable

# Activate the virtualenv for bandersnatch
source /opt/bandersnatch/bin/activate

# Start the mirror operation
/opt/bandersnatch/bin/bandersnatch mirror |& logger -t bandersnatch[mirror]
