#!/bin/bash

# check phusion passenger processes

PROGNAME=`basename $0`

CMD="/var/lib/gems/1.9.1/bin/passenger-memory-stats"

ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3

print_version() {
    echo "$VERSION"
}

print_help() {
	echo "USAGE: $PROGNAME <nginx|rack> <-p|-d|-v>"
	echo " nginx - show stats for nginx processes"
	echo " rack - show stats for rack processes"
	echo " -p - process count"
	echo " -d - total private dirty memory"
	echo " -v - vmsize sum"
	exit $ST_UK
}

if [ $# -ne 2 ]; then
	print_help
	exit $ST_UK
fi

case "$1" in
"nginx")
	case "$2" in
		-p)
			passenger_memory_stats_passenger_processes_nginx_count=`${CMD}  2>/dev/null | sed -n '/^-* Nginx processes -*$/,/^$/p' | grep "nginx: " | wc -l`
			output="$passenger_memory_stats_passenger_processes_nginx_count nginx processes"
			perfdata="'pms_p_count'=$passenger_memory_stats_passenger_processes_nginx_count"
			;;
		-d)
			passenger_memory_stats_nginx_processes_total_private_dirty=`${CMD} 2>/dev/null | sed -n '/^-* Nginx processes -*$/,/^$/p' | grep "Total private dirty" | sed 's/.*: //; s/ //;'`
			output="$passenger_memory_stats_nginx_processes_total_private_dirty nginx total private dirty"
			perfdata="'pms_p_dirty'=$passenger_memory_stats_nginx_processes_total_private_dirty"
			;;
		-v)
			passenger_memory_stats_passenger_processes_nginx_vmsize_sum=`${CMD} 2>/dev/null | sed -n '/^-* Nginx processes -*$/,/^$/p' | grep "nginx: " | awk '{ sum += $3 }; END { print sum }'`
			output="${passenger_memory_stats_passenger_processes_nginx_vmsize_sum}MB nginx vmsize sum"
			perfdata="'pms_p_vm_sum'=${passenger_memory_stats_passenger_processes_nginx_vmsize_sum}MB"
			;;
	esac

	echo "OK - ${output} | ${perfdata}"
	exit $ST_OK
	;;
"rack")
	case "$2" in
		-p)
			passenger_memory_stats_passenger_processes_rails_count=`${CMD} 2>/dev/null | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Rack: " | wc -l`
			output="$passenger_memory_stats_passenger_processes_rails_count rack processes"
			perfdata="'pms_p_count'=$passenger_memory_stats_passenger_processes_rails_count"
			;;
		-d)
			passenger_memory_stats_passenger_processes_total_private_dirty=`${CMD} 2>/dev/null | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Total private dirty" | sed 's/.*: //; s/ //;'`
			output="$passenger_memory_stats_passenger_processes_total_private_dirty rack total private dirty"
			perfdata="'pms_p_dirty'=$passenger_memory_stats_passenger_processes_total_private_dirty"
			;;
		-v)
			passenger_memory_stats_passenger_processes_rails_vmsize_sum=`${CMD} 2>/dev/null | sed -n '/^-* Passenger processes -*$/,/^$/p' | grep "Rack: " | awk '{ sum += $2 }; END { print sum }'`
			output="${passenger_memory_stats_passenger_processes_rails_vmsize_sum}MB rack vmsize sum"
			perfdata="'pms_p_vm_sum'=${passenger_memory_stats_passenger_processes_rails_vmsize_sum}MB"
			;;
	esac

	echo "OK - ${output} | ${perfdata}"
	exit $ST_OK
	;;
*)
	print_help
	exit $ST_UK
	;;
esac
