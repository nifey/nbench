#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Usage: $0 path/to/pb2.5datasets_standard.tar.gz"
	exit
fi

tmpdir=/tmp/pbdataset
mkdir $tmpdir
tar xvf $1 --directory=$tmpdir
for bench in `ls $tmpdir/datasets`
do
	if [ -d $bench ]
	then
		if [ -d $bench/data ]
		then
			echo "$bench/data alreadly exists. Skipping"
			continue
		fi
		mv $tmpdir/datasets/$bench $bench/data
	fi
done
yes | rm -r $tmpdir
