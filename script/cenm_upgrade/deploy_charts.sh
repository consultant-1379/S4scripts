#!/bin/bash

namespace=$1
csar_path=$2
chart_name=$3
chart_timeout=$4
messages_timestamp=$(date '+%H:%M:%S')
bro_int_chart_file=$(ls $csar_path/Definitions/OtherTemplates | grep bro-integration)
mon_int_chart_file=$(ls $csar_path/Definitions/OtherTemplates | grep monitoring-integration)
predep_int_chart_file=$(ls $csar_path/Definitions/OtherTemplates | grep pre-deploy-integration)
infra_int_chart_file=$(ls $csar_path/Definitions/OtherTemplates | grep infra-integration)
state_int_chart_file=$(ls $csar_path/Definitions/OtherTemplates | grep stateless-integration)
bro_int_chart_label="eric-enm-bro-integration-$namespace"
mon_int_chart_label="eric-enm-monitoring-integration-$namespace"
predep_int_chart_label="eric-enm-pre-deploy-integration-$namespace"
infra_int_chart_label="eric-enm-infra-integration-$namespace"
state_int_chart_label="eric-enm-stateless-integration-$namespace"
int_values_yaml_file=$(ls $csar_path/Scripts/eric-enm-integration-production-values*.yaml | grep eric-enm-integration)

print_message(){
  message="$1"
  echo "$messages_timestamp $message"
}

check_csar_dir(){
  if [ ! -d "$csar_path" ];then
    echo "SPECIFIED CSAR PATH $csar_path IS NOT EXISTING ON DIRECTOR NODE $hostname"
     exit 1
  fi
}

deploy_chart(){

  local chart_label
  local chart_file
  chart_label=$1
  chart_file=$2
  wait_time=10
  timeout_attempts=$((chart_timeout / wait_time))

  echo "INFO Deployment of $chart_label Chart is in progress (timeout: $chart_timeout)..."
  cd ${csar_path}/Definitions/OtherTemplates
  nohup helm install $chart_label --values $int_values_yaml_file $chart_file --namespace $namespace --wait --timeout ${chart_timeout}s > ${csar_path}/${chart_label}_install_logs 2>&1 &
  counter=0
  while [ $counter -lt $timeout_attempts ];do
    chart_status=$(helm status $chart_label --namespace $namespace | grep STATUS | awk '{print $2}')
    echo "INFO Current status of Chart is: $chart_status (attempt $counter of $timeout_attempts)"
    if [ "$chart_status" == "deployed" ];then
      echo "INFO Chart $chart_label has been successfully deployed"
      break
    fi
    if [ "$chart_status" == "failed" ];then
      echo "ERROR Deployment of Chart $chart_label has failed"
      exit 1
    fi
    sleep 10
    counter=$(( counter + 1 ))
    if [ $counter -ge $timeout_attempts ];then
      echo "ERROR Timeouts during deployment of Chart $chart_label (Chart status: $chart_status)"
      exit 1
    fi
  done
}

chart_selection(){
  case $chart_name in
    bro)
      deploy_chart $bro_int_chart_label $bro_int_chart_file
      ;;
    monitoring)
      deploy_chart $mon_int_chart_label $mon_int_chart_file
      ;;
    predeploy)
      deploy_chart $predep_int_chart_label $predep_int_chart_file
      ;;
    infra)
      deploy_chart $infra_int_chart_label $infra_int_chart_file
      ;;
    stateless)
      deploy_chart $state_int_chart_label $state_int_chart_file
      ;;
    *)
      echo  "ERROR Unknown Chart name $chart_name"
      exit 1
      ;;
  esac
}

initial_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 3 Deployment of Chart $chart_name"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

final_message(){
  echo ""
  echo "---------------------------------------------------------------------------------------------"
  echo "cENM Upgrade: Phase 3 Deployment of Chart $chart_name Successfully Completed"
  echo "---------------------------------------------------------------------------------------------"
  echo ""
}

initial_message
check_csar_dir
chart_selection
final_message
