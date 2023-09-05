#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-05 17:37
#===============================================================================

# $1: option
# $2: default value
tmux_get() {
	local value="$(tmux show -gqv "$1")"
	[ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
	tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' ' ')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')

G01=#268ad1
G02=#569ad8
G03=#77aadf

BG='#002833'
FG=$G01

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$BG,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$BG]#[bg=$BG]$left_arrow_icon#[bg=$BG]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$BG]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$BG"
tmux_set status-left-fg "$FG"
tmux_set status-left-length 150

LS="#[fg=$BG,bg=$FG] $session_icon #S "
if "$show_upload_speed"; then
	LS="$LS#[fg=$FG,bg=$G02]$right_arrow_icon#[fg=$BG,bg=$G02] $upload_speed_icon #{upload_speed} #[fg=$G02,bg=$BG]$right_arrow_icon"
else
	LS="$LS#[fg=$BG,bg=$FG]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
	LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$BG"
tmux_set status-right-fg "$FG"
tmux_set status-right-length 150
RS="#[fg=$G02]$left_arrow_icon#[fg=$BG,bg=$G02] $time_icon $time_format #[fg=$FG,bg=$G02]$left_arrow_icon#[fg=$BG,bg=$FG] $date_icon $date_format "
if "$show_download_speed"; then
	RS="#[fg=$G03,bg=$BG]$left_arrow_icon#[fg=$BG,bg=$G03] $download_speed_icon #{download_speed} $RS"
fi
if "$show_web_reachable"; then
	RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
	RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$FG]$right_arrow_icon#[fg=$BG,bold] #I:#W#F #[fg=$FG,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-statys "fg=$BG,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$BG,bg=default"

# Active pane border
tmux_set pane-active-border-style "fg=$FG,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$FG"
tmux_set display-panes-active-colour "$BG"

# Clock mode
tmux_set clock-mode-colour "$BG"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$FG,bg=$BG"

# Command message
tmux_set message-command-style "fg=$FG,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$BG,fg=$FG"
