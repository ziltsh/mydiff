#! /bin/bash
#
# mydiff - bash script to show mysql custom config variables
#   i.e. `postconf -n`
####### ####### ####### ####### ####### ####### ####### ####### #######
# prepare

set -u

THIS="$(basename $0)"

CFGFILE="${1:-/etc/my.cnf}"

T1="$(mktemp /tmp/$THIS.c.XXXXXXXX)"
T2="$(mktemp /tmp/$THIS.d.XXXXXXXX)"

trap Dying EXIT SIGINT SIGKILL SIGTERM


####### ####### ####### ####### ####### ####### ####### ####### #######
# functions

function GetConfig () {
	local cfgfile="$CFGFILE"
	printf "origin config\n"
	/usr/sbin/mysqld --defaults-file=$cfgfile --verbose --help \
		|& sed -ne '/^Variables/,$p'
	return $?
}

function GetDefaults() {
	printf "origin defaults\n"
	/usr/sbin/mysqld --no-defaults --verbose --help \
		|& sed -ne '/^Variables/,$p'
	return $?
}

function Dying () {
	shred -uxzn0 $T1
	shred -uxzn0 $T2
	#find /tmp -user $USER -type f -name $THIS.\[cd\].\?\?\?\?\?\?\?\? -mmin +1 -exec rm -v {} \; 2> /dev/null
	return $?
}


####### ####### ####### ####### ####### ####### ####### ####### #######
# functions

# sanity check
if [ ! -r $CFGFILE ]; then
	printf "Cannot read config file '%s' !\n" "$CFGFILE"
	exit
fi

# mention mysqld version # mysqld -V
mysqld --version

GetConfig	> $T1
GetDefaults	> $T2

join -j 1 $T2 $T1 \
	| awk '
NF==3 && $2!=$3 { printf "%-24s %24s %-24s\n", $1, $2, $3 }
#NR==1{ print "####### ####### ####### ####### ####### ####### ####### ####### #######" }
NR==1{ print "" }
'
exit 0


####### ####### ####### ####### ####### ####### ####### ####### #######
#.
