#!/bin/bash

HERE=`echo $0 | sed -e s/'^[^\/]*$'/'.'/g -e s/'\/[^\/]*$'//`;
ROOT=$HERE/..;

#gunzip $HERE/data/sqi-conll-rdf-extended-*.ttl.gz

#define file size
#SIZE=('01' '02' '04' '07' '08' '10' '16' '20' '24' '30' '40' '50')
SIZE=('07')

#define number of threads / logical cores to use
#CORES=('1' '4' '16' '32' '48' '96' '64' '128')
CORES=('4')

#define splitting delimiter for 200k triples, 200 triples or 7 triples
#SPLIT=('"###FULL#CORPUS#200K##"' '"###AVG#CORPUS#200tp##"' '""')
SPLIT=('"###AVG#CORPUS#200tp##"')

for size in "${SIZE[@]}" ; do \
  gunzip $HERE/data/sqi-conll-rdf-extended-$size.ttl.gz;
  for split in "${SPLIT[@]}"; do \
    for cores in "${CORES[@]}" ; do \
	  timestamp=$(date +%s);
	  $ROOT/fintan/run.sh -c $HERE/unimorph_fintan_presplit.json -p $HERE/data/sqi-conll-rdf-extended-$size.ttl $cores $split
	  timestamp2=$(date +%s);
	  echo -ne $size'\t'$cores'\t'$split'\t'$timestamp'\t'$timestamp2;
	  echo -e '\t'$(($timestamp2-$timestamp));
	done;
  done;
  gzip $HERE/data/sqi-conll-rdf-extended-$size.ttl;
done

#gzip $HERE/data/sqi-conll-rdf-extended-*.ttl