param(
	$goal,
	[switch]$l,
	$POMLOG = $env:pomlog,
	[switch]$h
)

#
# NAME
#     pom -- a minimalist pomodoro-style time-tracker.
#
# SYNOPSIS
#     pom message [-l [logfile]]
#
# DESCRIPTION
#     The pom utility counts down for 20 minutes as you work on a task. It will
#     give an audible alert at 5 and 0 minutes if `say` is in the path and
#     executable.
#
#     -l [logfile]
#         If provided, log the completed task and timestamp to [logfile]. The
#         default is the POMLOG environment variable, if set. Otherwise, the
#         default is $HOME/pom.log.
#
# by @tobym (Toby Matejovsky) 2012-09-19.
# ported to powershell by @luv2code (Matthew Taylor) 2012-09-19

# Runtime of a single session.
$time_in_minutes = 25
$script_name = $MyInvocation.MyCommand.Name


# Print current status.
# First argument is number of minutes elapsed.
function print_status ($minutes) {
  clear
  $minutes_remaining=$(($time_in_minutes - $minutes))
  $log_line=$(if($logfile) { " ($logfile)" } else { "" })
  echo "Pomodoro$log_line: $minutes_remaining minutes remaining to complete: $goal"
  if ( $minutes_remaining -eq 5 ) {
      safe_say "$minutes_remaining minutes remaining in your pomadoro"
  }
}

# Print final status. Optionally log this event.
function finish {
  clear
  $msg="$time_in_minutes minute pomodoro done at $(date) for: $goal"
  echo $msg

  if ( $logfile ) {
    echo $msg >> $logfile
  }

  $break_msg="Pomadoro complete. Take a 5 minute break."
  echo $break_msg
  safe_say "$break_msg" 
  ring_bell
}

# Audibly say something, if possible.
function safe_say($text) {
	Add-Type -AssemblyName System.Speech
	$synthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer

	# This line converts the text to speech
	$synthesizer.SpeakAsync($text)

}

# Try to ring the terminal bell.
function ring_bell {
  [Console]::Beep()
}

# Print short version of help.
function print_usage {
  echo "Usage: $script_name message [-l [logfile]]"
}

# Print help.
function print_help {
  $help_text='
  NAME
      pom -- a minimalist pomodoro-style time-tracker.

  SYNOPSIS
      pom message [-l [logfile]]

  DESCRIPTION
      The pom utility counts down for 20 minutes as you work on a task. It will
      give an audible alert at 5 and 0 minutes if `say` is in the path and
      executable.

      -l [logfile]
          If provided, log the completed task and timestamp to [logfile]. The
          default is the POMLOG environment variable, if set. Otherwise, the
          default is $HOME/pom.log.
'

  echo "$help_text"
}

# Main function.
function run_main {
  1..$time_in_minutes | % {
    print_status $(($_))
    Start-Sleep -s 60
  }
  finish
}

# Parse options, and run main.
if ( $l ) {
  if($POMLOG) {
    $logfile=$POMLOG
  } else {
    $logfile=Join-Path $env:home 'pom.log'
  }
}

if($h -or $goal -eq "--help") {
  print_help 
  return
} else {
  run_main
}
# then
  # print_usage && exit 1
# elif [ ! -z "$2" ] && [ "$2" != "-l" ]
# then
  # print_usage && exit 1
# else
  # run_main
# fi
