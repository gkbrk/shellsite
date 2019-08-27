#!/bin/sh
set -a
BUILDDIR=${BUILDDIR:-_build}
rm -rf "$BUILDDIR"
mkdir "$BUILDDIR"

function get_vars () {
    grep '^#_ ' | sed -E 's/#_ (.*?)/\1/g'
}

function process_file () {
    echo "Processing $1..."

    OUTFILE=''

    . /dev/stdin <<EOF
    `get_vars < "$1"`
EOF

    if [ ! -z $2 ]
    then
        OUTFILE=$2
    else
        OUTFILE=${OUTFILE:-"$1/index.html"}

        mkdir -p "$BUILDDIR/${OUTFILE%/*}"
    fi

    content=$("$1" | ./templates/template)
    echo "$content" > "$BUILDDIR/$OUTFILE"
    echo "$1 -> $BUILDDIR/$OUTFILE"
}

function process_folder () {
    for file in $1/*;
    do
        process_file $file
    done
}
