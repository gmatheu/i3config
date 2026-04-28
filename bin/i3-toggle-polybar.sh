#!/bin/bash

polybar_name=${1-top}
polybar_top_pid=$(pgrep -f "polybar $polybar_name")
polybar-msg -p "$polybar_top_pid" cmd toggle
