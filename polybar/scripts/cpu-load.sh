#!/bin/bash

ramp_load_0="▁"
ramp_load_1="▂"
ramp_load_2="▃"
ramp_load_3="▄"
ramp_load_4="▅"
ramp_load_5="▆"
ramp_load_6="▇"
ramp_load_7="█"

bar_used_foreground_0=#55aa55
bar_used_foreground_1=#557755
bar_used_foreground_2=#f5a70a
bar_used_foreground_3=#ff5555

show_numbers='false'
function toggle() {
  if [[ $show_numbers = 'true' ]]; then
    show_numbers='false'
  else
    show_numbers='true'
  fi
  if [ "$sleep_pid" -ne 0 ]; then
    kill $sleep_pid >/dev/null 2>&1
  fi
}

cpus=$(nproc)
colorize_value() {
  value=$1
  text=$2
  int_value=$(printf '%.*f\n' 0 "$value")
  relative_value=$((int_value * 100 / cpus))
  if [[ $relative_value -lt 25 ]]; then
    echo -n "%{F${bar_used_foreground_0}}${text}%{F-}"
  elif [[ $relative_value -lt 50 ]]; then
    echo -n "%{F${bar_used_foreground_1}}${text}%{F-}"
  elif [[ $relative_value -lt 75 ]]; then
    echo -n "%{F${bar_used_foreground_2}}${text}%{F-}"
  else
    echo -n "%{F${bar_used_foreground_3}}${text}%{F-}"
  fi
}

graph_load() {
  int_value=$(printf '%.*f\n' 0 "$1")
  relative_value=$((int_value * 100 / cpus))
  value=$(printf '%.*f\n' 0 "$relative_value")
  if [[ $value -ge 0 && $value -lt 25 ]]; then
    echo -n $ramp_load_0
  elif [[ $value -lt 50 ]]; then
    echo -n $ramp_load_2
  elif [[ $value -lt 75 ]]; then
    echo -n $ramp_load_4
  elif [[ $value -ge 75 ]]; then
    echo -n $ramp_load_6
  fi
}

trap "toggle" USR1

sleep_pid=0
while true; do
  _1_min=$(cat /proc/loadavg | cut -d' ' -f1)
  _5_min=$(cat /proc/loadavg | cut -d' ' -f2)
  _10_min=$(cat /proc/loadavg | cut -d' ' -f3)
  _1_min_output=$(colorize_value "$_1_min" "$(graph_load "$_1_min"):$_1_min")
  _5_min_output=$(colorize_value "$_5_min" "$(graph_load "$_5_min"):$_5_min")
  _10_min_output=$(colorize_value "$_10_min" "$(graph_load "$_10_min"):$_10_min")
  if [[ $show_numbers = 'true' ]]; then
    _1_min_output=$(colorize_value "$_1_min" "$(graph_load "$_1_min"):$_1_min")
    _5_min_output=$(colorize_value "$_5_min" "$(graph_load "$_5_min"):$_5_min")
    _10_min_output=$(colorize_value "$_10_min" "$(graph_load "$_10_min"):$_10_min")
    echo "$_1_min_output $_5_min_output $_10_min_output"
  else
    _1_min_output=$(colorize_value "$_1_min" "$(graph_load "$_1_min")")
    _5_min_output=$(colorize_value "$_5_min" "$(graph_load "$_5_min")")
    _10_min_output=$(colorize_value "$_10_min" "$(graph_load "$_10_min")")
    echo "$_1_min_output$_1_min_output$_5_min_output$_5_min_output$_10_min_output$_10_min_output"
  fi
  sleep 1 &
  sleep_pid=$!
  wait
done
