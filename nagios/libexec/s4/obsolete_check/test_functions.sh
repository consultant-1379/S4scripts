#!/bin/bash
source ./common_functions.sh

number_nodes_enm=$(count_number_nodes_enm 141.137.208.23 10.151.193.14 ERBS)

echo $number_nodes_enm


number_nodes_cmsuperv=$(count_number_nodes_cmsuperv 141.137.208.23 10.151.193.14 ERBS)

echo $number_nodes_cmsuperv


number_nodespmsuperv=$(count_number_nodes_pmsuperv 141.137.208.23 10.151.193.14 ERBS)

echo $number_nodes_pmsuperv

number_nodes_syn=$(count_number_nodes_syn 141.137.208.23 10.151.193.14 ERBS)

echo $number_nodes_syn

nodes_hb_fail=$(count_nodes_hb_fail 141.137.208.23 10.151.193.14 ERBS)

echo $nodes_hb_fail
