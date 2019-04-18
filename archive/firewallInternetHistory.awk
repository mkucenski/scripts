#NOTE: This script does not handle calculations across multiple years 
#REQ PARAMS: year, threshold

BEGIN {
   sum=0

   lastmonth=-1
   lastday=-1
   lasthour=-1
   lastmin=-1
   lastsec=-1
}

{
   month=$1
   day=$2
   hour=$3
   min=$4
   sec=$5
   
   time=sec+(min*60)+(hour*60*60)+(day*24*60*60)
   if (month=="Jan" || month=="Mar" || month=="May" || month=="Jul" || month=="Aug" || month=="Oct" || month=="Dec") {
      time+=month*31*24*60*60
   } else if (month=="Apr" || month=="Jun" || month=="Sep" || month=="Nov") {
      time+=month*30*24*60*60
   } else if (month=="Feb") {
      if (year%4==0 || year%400==0) {
         time+=month*29*24*60*60
      } else {
         time+=month*28*24*60*60
      }
   } else {
      print "Error!"
   }

   if (lastmonth!=-1) {
      diff=time-lasttime
      if (diff<(threshold*60)) {
         sum+=diff
      }
   }

   print $0 "|" diff/60

   lastmonth=month
   lastday=day
   lasthour=hour
   lastmin=min
   lastsec=sec
   lasttime=time 
}

END {
   print sum/60/60 " Hours of Activity"
}

