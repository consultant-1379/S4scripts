#!/bin/bash
NETSIM_VMS=$1

CLI_CMD="/opt/ericsson/enmutils/bin/cli_app"
NETSIM_CMD="/opt/ericsson/nssutils/bin/netsim"

check_netsim_started(){

  netsim_status=$($NETSIM_CMD list $NETSIM_VM --no-ansi)
  
  if [[ "$netsim_status" == *"[Re]start Netsim"* ]]; then
    return 1
  fi
}

restore_all_ne_db() {

  if [ -n "$sim" ] || [ -n "$NETSIM_VM" ];then

    sshpass -p netsim ssh -o StrictHostKeyChecking=no netsim@$NETSIM_VM << EOF
cd inst
./netsim_pipe
.open $sim
.selectallsimne
.stop -parallel
.restorenedatabase curr all force
.start -parallel
EOF

  fi
}

get_simulation_names() {
  sims=$($NETSIM_CMD list $NETSIM_VM --no-ansi | grep -v "Netsim operation\|Simulations" | sed 's/ //g' | tail -n +2 | head -n -1)
  if [ -z "$sims" ];then
    echo "ERROR - NO SIMULATIONS HAVE BEEN FOUND ON NETSIM $NETSIM_VM"
    exit 1
  fi
}	

for NETSIM_VM in $NETSIM_VMS;do
  if ! check_netsim_started;then
    echo "Netsim is not started in host: $NETSIM_VM"
    break
  fi
  get_simulation_names
  for sim in $sims;do
    echo "RESTORING NE DB ON SIMULATION: $sim OF NETSIM: $NETSIM_VM"
    restore_all_ne_db
    sleep 2
  done
done  
