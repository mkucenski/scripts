# NOTE: This script does not handle calculations across multiple years 
# PARAMS: year, threshold, timeRange

BEGIN {
   sum=0
   diff=0
   lasttime=-1

   if (timeRange!="*") {
      split(timeRange, separated, "-")
      startTime=separated[1]
      endTime=separated[2]
   }
}

{
   time=$14
   month=strftime("%b", time)
   day=strftime("%d", time)
   hour=strftime("%H", time)
   min=strftime("%M", time)

   if (timeRange=="*" || ((hour min>=startTime) && (hour min<=endTime))) {
      if (lasttime>0) {
         diff=(time-lasttime)/60
         if (diff<threshold) {
            sum+=diff
            addToMonthSummary(month, day, diff)
         }
      }
   
      lasttime=time 
   }
}

END {
   printAllMonthlySummaries()

   print "Total (Hours)"
   print "\t" sum/60
}

function numDaysInMonth(year, month) {
   if (month=="Jan" || month=="Mar" || month=="May" || month=="Jul" || month=="Aug" || month=="Oct" || month=="Dec") {
      return 31
   } else if (month=="Apr" || month=="Jun" || month=="Sep" || month=="Nov") {
      return 30
   } else if (month=="Feb") {
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

function addToMonthSummary(month, day, diff) {
   if (month=="Jan")
      JanSummary[day]+=diff
   else if (month=="Feb")
      FebSummary[day]+=diff
   else if (month=="Mar")
      MarSummary[day]+=diff
   else if (month=="Apr")
      AprSummary[day]+=diff
   else if (month=="May")
      MaySummary[day]+=diff
   else if (month=="Jun")
      JunSummary[day]+=diff
   else if (month=="Jul")
      JulSummary[day]+=diff
   else if (month=="Aug")
      AugSummary[day]+=diff
   else if (month=="Sep")
      SepSummary[day]+=diff
   else if (month=="Oct")
      OctSummary[day]+=diff
   else if (month=="Nov")
      NovSummary[day]+=diff
   else if (month=="Dec")
      DecSummary[day]+=diff
   else
      print "Error!"
}

function printMonthSummary(monthSummaryArray, month) {
   if (monthContainsData(monthSummaryArray)==1) {
      monthSum=0

      print month " Daily Totals (Hours)"

      # Create an array of all days with recorded time
      x=1
      for (i in monthSummaryArray) {
         days[x]=i
         x++
      }

      # Sort the days array into numeric order
      numDays=asort(days)

      # Loop through all of the days in numeric order, printing the recorded time
      for (i=1; i<=numDays; i++) {
         print "\t" days[i] ": " monthSummaryArray[days[i]]/60
         monthSum+=monthSummaryArray[days[i]]
      }

      # Delete all of the days array entries
      for (i in days)
         delete days[i]

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

