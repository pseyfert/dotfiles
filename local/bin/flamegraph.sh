#!/usr/bin/zsh

THISDIR=$(readlink -f ${(%):-%N})
FLAMEGRAPHDIR=${THISDIR:h:h:h}/submodules/FlameGraph
file=$(mktemp --suffix=.csv)
vtune -R top-down -call-stack-mode all -column="CPU Time:Self","Module" -report-out ${file}.org -filter "Function Stack" -format csv -csv-delimiter comma -r $1
tail +2 ${file}.org > ${file}
perl ${FLAMEGRAPHDIR}/stackcollapse-vtune.pl ${file}  | perl ${FLAMEGRAPHDIR}/flamegraph.pl > ${1%.vtune}.svg
rm ${file}.org
rm ${file}
