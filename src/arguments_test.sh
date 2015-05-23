#!/bin/sh

CMD=$1

if [[ ! -f $CMD ]]
then
	if [[ ! -x $CMD ]]; then
		echo "$0: $CMD not executable!" >&2
	else
		echo "$0: $CMD not found!" >&2
	fi
	exit 1
fi

echo "[TEST]  $CMD"
$CMD
echo "[TEST]  $CMD --help"
$CMD --help
echo "[TEST]  $CMD --help -v"
$CMD --help -v
echo "[TEST]  $CMD foo"
$CMD foo
echo "[TEST]  $CMD bar"
$CMD bar
echo "[TEST]  $CMD foo bar"
$CMD foo bar
