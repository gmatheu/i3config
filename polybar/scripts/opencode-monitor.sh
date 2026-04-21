#!/bin/bash

ramp_load_0="▁"
ramp_load_1="▂"
ramp_load_2="▃"
ramp_load_3="▄"
ramp_load_4="▅"
ramp_load_5="▆"
ramp_load_6="▇"
ramp_load_7="█"

connected_foreground="#3388ff"
completed_foreground=#55aa55
user_message_foreground=#557755
session_started_foreground=#f5a70a
error_icon=#ff5555

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

log_file=$HOME/.local/share/opencode/opencode-notifier.log

declare -A latest_event
declare -A latest_timestamp
find_opencode_clients() {
  if [[ -f "$log_file" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue

      event=""
      projectName=""
      currentTimestamp=""

      IFS='|' read -ra fields <<<"$line"
      for field in "${fields[@]}"; do
        key="${field%%:*}"
        value="${field#*:}"
        case "$key" in
        event) event="$value" ;;
        projectName) projectName="$value" ;;
        currentTimestamp) currentTimestamp="$value" ;;
        esac
      done

      if [[ -n "$projectName" && -n "$currentTimestamp" ]]; then
        latest_event["$projectName"]="$event"
        latest_timestamp["$projectName"]="$currentTimestamp"
      fi
    done <"$log_file"
  fi

  declare -a lines
  now_epoch=$(date +%s)

  for project in "${!latest_event[@]}"; do
    event="${latest_event[$project]}"
    ts="${latest_timestamp[$project]}"

    icon=$ramp_load_7
    ts_epoch=$(date -d "$ts" +%s 2>/dev/null || echo 0)

    if ((ts_epoch > 0)); then
      diff=$((now_epoch - ts_epoch))
      if ((diff < 60)); then
        icon=$ramp_load_0
      elif ((diff < 120)); then
        icon=$ramp_load_1
      elif ((diff < 180)); then
        icon=$ramp_load_2
      elif ((diff < 300)); then
        icon=$ramp_load_3
      elif ((diff < 480)); then
        icon=$ramp_load_4
      elif ((diff < 780)); then
        icon=$ramp_load_5
      elif ((diff < 1500)); then
        icon=$ramp_load_6
      else
        icon=$ramp_load_7
      fi
    fi

    event_color="#aaaaaa"
    case "$event" in
    client_connected) event_color=$connected_foreground ;;
    session_started) event_color=$session_started_foreground ;;
    user_message) event_color=$user_message_foreground ;;
    complete) event_color=$completed_foreground ;;
    error) event_color=$error_icon ;;
    question) icon="?" ;;
    esac

    lines+=("$ts_epoch|%{F${event_color}}${icon}%{F-}")
  done

  message=""
  if ((${#lines[@]} > 0)); then
    IFS=$'\n' sorted=($(printf '%s\n' "${lines[@]}" | sort -t'|' -k1,1 -nr))
    unset IFS

    first=true
    for line in "${sorted[@]}"; do
      if [[ "$first" == true ]]; then
        message+="${line#*|}"
        first=false
      else
        message+="${line#*|}"
      fi
    done
  fi

  echo "$message"
}

trap "toggle" USR1
trap "show_notification" USR2

sleep_pid=0
while true; do
  if [[ $show_numbers = 'true' ]]; then
    find_opencode_clients
  else
    find_opencode_clients
  fi
  sleep 10 &
  sleep_pid=$!
  wait
done
