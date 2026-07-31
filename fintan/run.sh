#!/bin/bash
#
# Fintan wrapper script using a uber-jar instead of the default maven-exec.

# store the path of the fintan.jar
backend_dir="$(dirname -- "$(realpath -- "$0")")"
package_jar="${backend_dir}/fintan.jar"
JAVA=../java/jdk-23/bin/java


$JAVA -Dfile.encoding=UTF8 -jar "${package_jar}" "$@"
