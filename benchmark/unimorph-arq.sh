#!/bin/bash

HERE=`echo $0 | sed -e s/'^[^\/]*$'/'.'/g -e s/'\/[^\/]*$'//`;
ROOT=$HERE/..;
JAVA=$ROOT/java/jdk-23/bin/java
#JVM_ARGS=

#define file size
#SIZE=('01' '02' '04' '07' '08' '10' '16' '20' '24' '30' '40' '50')
SIZE=('07')

#define jena versions to test
#JENA_VERSION=('3.11.0' '4.9.0' '5.1.0')
JENA_VERSION=('3.11.0')

#define jena updater (arq in-mem or tdb backend)
#JENA_MODE=('tdb2.tdbupdate' 'tdb.tdbupdate' 'arq.update') #rupdate is for remote endpoints
JENA_MODE=('arq.update')

#exec and log
for size in "${SIZE[@]}" ; do \
  gunzip $HERE/data/sqi-conll-rdf-extended-$size.ttl.gz;
  for update in "${JENA_MODE[@]}"; do \
    for ver in "${JENA_VERSION[@]}" ; do \
	  timestamp=$(date +%s);
	  $JAVA -cp $ROOT'/jena/apache-jena-'$ver'/lib/*' \
	        $update \
	          --data=$HERE/data/sqi-conll-rdf-extended-$size.ttl \
	          --update=$HERE/sparql/unimorph2lemon.sparql \
	          --update=$HERE/sparql/linkFEATS-LOAD.sparql \
			  --dump > jena_result.ttl
	  timestamp2=$(date +%s);
	  echo -ne $size'\t'$ver'\t'$update'\t'$timestamp'\t'$timestamp2;
	  echo -e '\t'$(($timestamp2-$timestamp));
	done;
  done;
  gzip $HERE/data/sqi-conll-rdf-extended-$size.ttl;
done

