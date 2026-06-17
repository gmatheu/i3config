#!/bin/bash

polybar_name=${1-top}
if [ "${polybar_name}" = "all" ]; then
  polybar-msg cmd toggle
else
  polybar_top_pid=$(pgrep -f "polybar $polybar_name")
  polybar-msg -p "$polybar_top_pid" cmd toggle
fi
