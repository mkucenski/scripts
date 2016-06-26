# NOTE: This script does not handle calculations across multiple years 
# PARAMS: threshold, delim, summaryOnly, timeRange

BEGIN {
   sum=0
   diff=0
   lasttime=-1

   if (timeRange!="*") {
      split(timeRange, separated, "-")
      startTime=separated[1]
      endTime=separated[2]
   }
   
   if (summaryOnly==0)
      print "MINDIFF" delim "MONTH" delim "DAY" delim "HOUR" delim "MIN" delim "SEC" delim "DOMAIN"
}

{
   month=$1
   day=$2
   year=$3
   hour=$4
   min=$5

   if (timeRange=="*" || ((hour min>=startTime) && (hour min<=endTime))) {
      time=timestamp(year, month, day, hour, min, sec)

      if (lasttime>0) {
         diff=time-lasttime
         if (diff<threshold) {
            sum+=diff
            addToMonthSummary(month, diff)
         }
      }

      if (summaryOnly==0)
         print diff delim $0

      lasttime=time 
   }
}

END {
   if (summaryOnly==0)
      print ""

   printAllMonthlySummaries()

   print "Total (Hours)"
   print "\t" sum/60
}

function timestamp(year, month, day, hour, min, sec) {
   time=0

   # Minutes since beginning of current month
   time=(sec/60) + (min) + (hour*60) + (day*24*60)

   # Minutes since beginning of current year
   for (i=1; i<=12; i++) {
      if (i==month)
         break

      time+=numDaysInMonth(year, i)*24*60
   }

   return time
}

function numDaysInMonth(year, month) {
   if (month==1 || month==3 || month==5 || month==7 || month==8 || month==10 || month==12) {
      return 31
   } else if (month==4 || month==6 || month==9 || month==11) {
      return 30
   } else if (month==2) {
      if (year%4==0 || year%400==0) {
         return 29
      } else {
         return 28
      }
   }

   return 0
}

function printAllMonthlySummaries() {
   printMonthSummary(JanSummary, "Jan")
   printMonthSummary(FebSummary, "Feb")
   printMonthSummary(MarSummary, "Mar")
   printMonthSummary(AprSummary, "Apr")
   printMonthSummary(MaySummary, "May")
   printMonthSummary(JunSummary, "Jun")
   printMonthSummary(JulSummary, "Jul")
   printMonthSummary(AugSummary, "Aug")
   printMonthSummary(SepSummary, "Sep")
   printMonthSummary(OctSummary, "Oct")
   printMonthSummary(NovSummary, "Nov")
   printMonthSummary(DecSummary, "Dec")
}

function addToMonthSummary(month, diff) {
   if (month==1)
      JanSummary[day]+=diff
   else if (month==2)
      FebSummary[day]+=diff
   else if (month==3)
      MarSummary[day]+=diff
   else if (month==4)
      AprSummary[day]+=diff
   else if (month==5)
      MaySummary[day]+=diff
   else if (month==6)
      JunSummary[day]+=diff
   else if (month==7)
      JulSummary[day]+=diff
   else if (month==8)
      AugSummary[day]+=diff
   else if (month==9)
      SepSummary[day]+=diff
   else if (month==10)
      OctSummary[day]+=diff
   else if (month==11)
      NovSummary[day]+=diff
   else if (month==12)
      DecSummary[day]+=diff
   else
      print "Error! " month " " diff
}

function printMonthSummary(monthSummaryArray, month) {
   if (monthContainsData(monthSummaryArray)==1) {
      monthSum=0

      print month " Daily Totals (Hours)"

      # Sort into numeric order
	asort(monthSummaryArray)

      # Loop through all of the days, printing the recorded time
	for (x in monthSummaryArray) {
         print "\t" x ": " monthSummaryArray[x]/60
	   monthSum+=monthSummaryArray[x]
      }

      print ""

      print month " Total (Hours)"
      print "\t" monthSum/60 "\n"
   }
}

function monthContainsData(monthSummaryArray) {
   for (i in monthSummaryArray)
      return 1

   return 0
}

