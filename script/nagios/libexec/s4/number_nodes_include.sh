#!/bin/bash

        # ############################# ################################ ########################
        for _n in $netypes;do   # Count nodes (total numbers)
            _number_nodes_enm=$(sshpass -p 12shroot ssh nagios@$IP_param "sudo /opt/ericsson/enmutils/bin/cli_app 'cmedit get * NetworkElement.neType==$_n -t' | grep -i $_n | wc -l")
            _tot_number_nodes_enm=$((_tot_number_nodes_enm + _number_nodes_enm))
            eval "_number_nodes_${_n}"=$_number_nodes_enm
        done
        _tot_number_nodes_enm_1=$((_tot_number_nodes_enm + _tot_number_nodes_enm_1))

        _number_nodes_netsim=$(sshpass -p 12shroot ssh nagios@$IP_param "grep -w '$netypes' /opt/ericsson/enmutils/etc/nodes/*$u_check* | wc -l")
        _number_nodes_netsim_1=$((_number_nodes_netsim + _number_nodes_netsim_1))

        _warning_value_float=`echo "$_tot_number_nodes_enm_1 * 0.95" | bc -l`
        _warning_value=${_warning_value_float%.*}
        _warning_value_1=$((_warning_value + _warning_value_1))

        _critical_value_float=`echo "$_tot_number_nodes_enm_1 * 0.8" | bc -l`
        _critical_value=${_critical_value_float%.*}
        _critical_value_1=$((_critical_value + _critical_value_1))
        # ############################# ################################ ########################
