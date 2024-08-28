#!/bin/bash

#to be run on LMS
TO_REMOVE=$("curl -G eshistory:8900/_cat/indices?v | grep -i close | awk {'print $2'}")

