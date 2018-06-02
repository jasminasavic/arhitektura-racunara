#!/bin/bash
# testiranje rešenja zadatka sa unapred definisanim ulazima

#   Copyright 2017 Žarko Živanov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

# exit 0 - stiglo se do testova
# exit 1 - greška u kompajliranju
# exit 2 - nije nađen fajl

TESTS=(01 02 03 04 05 06)
EXITS=(0 1 0 1 0 1)
EMPTY="#"
QUIET=0
KEEP=0
SIG=""
OUT1=/tmp/out1

TEST01=$(cat <<EOL
anavolimilovana
EOL
)

OUTP01=$(cat <<EOL
Unesite string:anavolimilovana
String je palindrom.
EOL
)

TEST02=$(cat <<EOL
corsokak
EOL
)

OUTP02=$(cat <<EOL
Unesite string:corsokak
String nije palindrom.
EOL
)

TEST03=$(cat <<EOL
avdaterajaretadva
EOL
)

OUTP03=$(cat <<EOL
Unesite string:avdaterajaretadva
String je palindrom.
EOL
)

TEST04=$(cat <<EOL
enijepalindrom
EOL
)

OUTP04=$(cat <<EOL
Unesite string:enijepalindrom
String nije palindrom.
EOL
)

TEST05=$(cat <<EOL
12345654321
EOL
)

OUTP05=$(cat <<EOL
Unesite string:12345654321
String je palindrom.
EOL
)

TEST06=$(cat <<EOL
123456754321
EOL
)

OUTP06=$(cat <<EOL
Unesite string:123456754321
String nije palindrom.
EOL
)

function echoq {
    if [ $QUIET -eq 0 ]; then
        echo "$@"
    fi
}

if [ "$1" == "-q" ]; then
    QUIET=1
    shift
fi
if [ "$1" \> "00" ] && [ "$1" \< "99" ]; then
    TESTS=($1)
    KEEP=1
    shift
fi

if [ "$1" != "" ] && [ -f "$1" ]; then
    echoq -e "\n\e[01;32mKompajliranje...\e[00m"
    grep ".text" $1 1>/dev/null 2>/dev/null && (grep ".globl" $1 1>/dev/null 2>/dev/null || grep ".global" $1 1>/dev/null 2>/dev/null)
    if [ $? -ne 0 ]; then
        echoq -e "\e[01;31m\n\nNije asemblerski program!\e[00m\n"
        exit 1
    fi
    GLAVNI=""
    if [ $(grep -c "main:" $1) == "0" ]; then
        if [ -f glavni.c ]; then
            GLAVNI=glavni.c
        else
            echoq -e "\e[01;31m\n\nNije nađen glavni.c!\e[00m\n"
        fi
    fi
    #nalaženje fajlova od kojih se sastoji rešenje
    zfiles=$(grep -E "^[[:space:]]*#[[:space:]]*fajlovi[[:space:]]*:" $1)
    if [ "$zfiles" != "" ]; then
        zfiles=${zfiles#*:}
    else
        zfiles="$@"
    fi
    gcc -g -m32 -o zad $GLAVNI $zfiles 1>$OUT1 2>&1
    if [ $? -ne 0 ]; then
        echoq -e "\e[01;31m\n\nGreška u kompajliranju!\e[00m\n"
        if [ $QUIET -eq 0 ]; then
            cat $OUT1
        else
            echo "0"
        fi
        rm -f $OUT1
        exit 1
    fi
else
    if [ "$1" != "" ]; then
        echoq -e "\e[01;31mFajl \"$1\" nije nađen!\e[00m"
    fi
    lasttest=${TESTS[${#TESTS[@]}-1]}
    echoq -e "\n\e[01;32mUpotreba:\e[00m"
    echoq -e "\e[01;34m$0 [-q] [TT] \e[01;32mime_programa.S\e[00m"
    echoq -e "Opcija -q ispisuje samo procenat uspešnih testova"
    echoq -e "Opcija TT (01<=TT<=$lasttest) pokreće samo zadati test i ispisuje diff izlaz za njega\n"
    if [ $QUIET -ne 0 ]; then
        echo "0"
    fi
    exit 2
fi

cat >./run <<EOL
spawn -noecho [lindex \$argv 0]
for {set i 1} {\$i < [llength \$argv]} {incr i 1} {
    sleep 0.5
    send -- "[lindex \$argv \$i]"
    send "\r"
}
expect eof
catch wait reason
set sig [lindex \$reason 5]
if {\$sig == ""} {
    set code [lindex \$reason 3]
} elseif {\$sig == "SIGFPE"} {
    set code [expr 128+8]
} elseif {\$sig == "SIGSEGV"} {
    set code [expr 128+11]
} elseif {\$sig == "SIGINT"} {
    set code [expr 128+2]
} elseif {\$sig == "SIGILL"} {
    set code [expr 128+4]
} elseif {\$sig == "SIGKILL"} {
    set code [expr 128+9]
} else {
    set code [expr 128+1]
}
exit \$code
EOL

passed=0
total=0
nn=0
for n in "${TESTS[@]}"; do
    echoq -e 