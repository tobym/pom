pom
===

a minimalist pomodoro-style time-tracker.

synopsis
--------

    pom message [-l [logfile]]

description
-----------

The pom utility counts down for 25 minutes as you work on a task. It will
give an audible alert at 5 and 0 minutes if `say` is in the path and
executable.

`-l [logfile]`
    If provided, log the completed task and timestamp to `logfile`. The
    default is the `POMLOG` environment variable, if set. Otherwise, the
    default is `$HOME/pom.log`.

extras
------

1. Use `#hashtags` in your messages so you can easily grep for them later.
2. Use `awk`/`grep` to add up time spent on projects, or for specific days.

        awk '/#hacks/ { total += $1 } END { print total / 60 " hours" }' pom.log
