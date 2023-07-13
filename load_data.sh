#!/bin/bash
if [ $# -ne 2 ]
then
	echo "Usage: $0 path/to/pb2.5datasets_standard.tar.gz path/to/rodinia_3.1.tar.bz2"
	exit
fi

# Parboil data
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
		echo "Copying data for $bench"
		mv $tmpdir/datasets/$bench $bench/data
	fi
done
yes | rm -r $tmpdir

# Rodinia data
tmpdir=/tmp/roddataset
mkdir $tmpdir
tar xvf $2 --directory=$tmpdir
rm -rf $tmpdir/rodinia_3.1/data/bfs # We use parboil bfs
for bench in `ls $tmpdir/rodinia_3.1/data`
do
	if [ -d $bench ]
	then
		if [ -d $bench/data ]
		then
			echo "$bench/data alreadly exists. Skipping"
			continue
		fi
		echo "Copying data for $bench"
		mv $tmpdir/rodinia_3.1/data/$bench $bench/data
	fi
done
yes | rm -r $tmpdir
