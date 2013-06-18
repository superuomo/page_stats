# AWK second-pass processing script for page_stats.sh

BEGIN {
  OFS=","
  print "url", "date", "count"
}

# Sample input lines:
# [18/Jun/2013:06:28:26 +0100] 200 "GET /
# [18/Jun/2013:06:49:45 +0100] 200 "GET /zonzo
# [18/Jun/2013:10:19:09 +0100] 200 "GET /restaurants/fulham_parsons_green-sw6/All/0-30
match($0, "^\\[([[:digit:]]+/[[:alpha:]]+/[[:digit:]]+):[^]]+] 200 \"GET ([^ ]*)", s) {
 t[s[2], s[1]]++
}

END {
  for (elem in t) {
    split(elem, s, SUBSEP)
    print s[1], s[2], t[s[1], s[2]]
  }
}
