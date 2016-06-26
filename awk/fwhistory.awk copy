# NOTE: This script does not handle calculations across multiple years 
# PARAMS: year, threshold, delim, summaryOnly, timeRange

BEGIN {
   sum=0
   diff=0
   lasttime=-1

   if (timeRange!="*") {
      split(timeRange, separated, "-")
      startTime=separated[1]
      endTime=separated[2]
   }
   
   calendarMonths[1]="Jan"
   calendarMonths[2]="Feb"
   calendarMonths[3]="Mar"
   calendarMonths[4]="Apr"
   calendarMonths[5]="May"
   calendarMonths[6]="Jun"
   calendarMonths[7]="Jul"
   calendarMonths[8]="Aug"
   calendarMonths[9]="Sep"
   calendarMonths[10]="Oct"
   calendarMonths[11]="Nov"
   calendarMonths[12]="Dec"

   if (summaryOnly==0)
      print "MINDIFF" delim "MONTH" delim "DAY" delim "HOUR" delim "MIN" delim "SEC" delim "SRC IP" delim "SRC PORT" delim "DEST IP" delim "DEST PORT" delim "DOMAIN" delim "URL"
}

{
   month=$1
   day=$2
   hour=$3
   min=$4
   sec=$5

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
      if (calendarMonths[i]==month)
         break

      time+=numDaysInMonth(year, calendarMonths[i])*24*60
   }

   return time
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

function addToMonthSummary(month, diff) {
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
         delete ind[i]

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

