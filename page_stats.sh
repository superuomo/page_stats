#!/bin/bash
# Computes hit counts per day for some popular pages.

function grep_request {
  local pat="$1" out="$2";
  shift 2
  # Sample log lines grepped:
  #== search.hungryhouse_access.log ==
  #213.61.228.26 - - [18/Jun/2013:14:27:54 +0100] 200 "GET /restaurants/fulham_parsons_green-sw6/All/0-30 HTTP/1.1" 23836 "-" "Opera/9.80 (X11; Linux x86_64) Presto/2.12.388 Version/12.15" "-" "33" via 10.13.82.33:8080 upstream_response_time 2.662 msec 1371562074.194 request_time 2.684
  #
  #== hungryhouse_access.log ==
  #213.61.228.26 - - [18/Jun/2013:15:01:00 +0100] 200 "GET /zonzo HTTP/1.1" 17781 "-" "Opera/9.80 (X11; Linux x86_64) Presto/2.12.388 Version/12.15" "-" "10" via 10.13.82.23:11211 : 10.13.82.10:8080 upstream_response_time 0.000 : 0.293 msec 1371564060.492 request_time 0.314
  #213.61.228.26 - - [18/Jun/2013:15:04:24 +0100] 200 "GET / HTTP/1.1" 16798 "-" "Opera/9.80 (X11; Linux x86_64) Presto/2.12.388 Version/12.15" "-" "10" via 10.13.82.23:11211 : 10.13.82.10:8080 upstream_response_time 0.001 : 0.027 msec 1371564264.399 request_time 0.031

  # zgrep does not support -h option like grep
  ionice -c3 nice -n 19 zgrep -Ho "\[[^]]*\] 200 \"GET \($pat\) " "$@" |
    ionice -c3 nice -n 19 sed 's/[^:]*:\(.*\)/\1/' >$out
}

# Configure the requests to grep and which files to look each here.
grep_request '/zonzo\|/capri-pizza-kebab\|/' 'hh.out' hungryhouse_access.log*
grep_request '/restaurants/fulham_parsons_green-sw6/All/0-30' 'hhsearch.out' search.hungryhouse_access.log*

ionice -c3 nice -n 19 awk -f page_stats.awk hh.out hhsearch.out
