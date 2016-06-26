##################################################
#This program will attempt to consolidate many awk scripts for firewall analysis into one single menu-driven script.
#Written by Andrew Staller - June 6, 2003 F.O.U.O
#Last Updated - June 30, 2003
##################################################


BEGIN {

	FS = " "

#######Initialize any values here, including the analysis machine's IP address!
AnalysisIP = 140.47.2.221
counter = 1
##########



	if (tolower(ARGV[0]) != "awk")
		exit
	
	if (ARGV[1] == "" || ARGV[1] == "-menu" || ARGV[1] == "-output" || ARGV[1] == "-noip" || ARGV[1] == "-ip"){
		printf ("\nInput File required.  Type 'awk -f fwreport.awk -?' for more information.\n\n")
		exit
	}
	if (ARGV[1] == "-?"){
		printf ("\nUSAGE:  awk -f fwreport.awk INPUTFILE [-menu MENUCHOICE] [-output OUTPUTFILE] [-ip SOURCE_IP] [-noip] [-domain SEARCHDOMAIN]\n\n")
		exit
	}
	for (c=0;c<ARGC;c++){
		if (tolower(ARGV[c]) == "-output" && ARGV[c+1] !=""){
			outputfile = ARGV[c+1]
			outputfileflag = "true"
		}
		if (tolower(ARGV[c]) == "-menu" && ARGV[c+1] !=""){
			if (ARGV[c+1] >= 1 && ARGV[c+1] <= 6 && length(ARGV[c+1]) ==1){
				menuchoice = ARGV[c+1]
				choiceflag = "valid"
				menuchoiceflag = "true"
			}
		}
		if (tolower(ARGV[c]) == "-noip")
			IPsearchflag = "false"
		if (tolower(ARGV[c]) == "-ip" && ARGV[c+1] !=""){
			IPsearchflag = "true"
			IPsearch = ARGV[c+1]
		}
		if (tolower(ARGV[c]) == "-domain"){
			searchdomainflag = "true"
			searchdomain = ARGV[c+1]
		}

	}
	if (ARGV[1] == ""){
		while (searchfile == ""){
			printf("<<REQUIRED>> Please enter the firewall logfile that will be searched:  ")
			getline searchfile < "-"
		}
	}
	else {
		searchfile = ARGV[1]
	}

	if (outputfileflag !="true"){
		while (outputflag != "valid"){
			printf "\n<<Optional>> Do you want the output sent to a file? (y/n)"
				getline outputchoice < "-"
			if (outputselection == "y" || outputselection == "Y" || outputselection == "n" || outputselection == "N" || outputselection == "")
				outputflag = "valid"
			else
				outputflag = "invalid"
			if (outputchoice == "Y" || outputchoice == "y"){
				printf "\n<<REQUIRED>> Please enter the output file name:  "
				getline outputfile < "-"
			}
	
			else {}
		}
	}
	
	if (menuchoiceflag != "true"){
		while (choiceflag != "valid"){
			printf "\n\nPlease choose a menu option and press <enter>:\n\n"
			printf "(1)  Check log file for possible pornography.\n"
			printf "(2)  Check log file for possible movie, music, .exe, and archive files.\n"
			printf "(3)  Check log file for large file downloads.\n"
			printf "(4)  Check log file for a single domain.\n"
			printf "(5)  Check log file for an IP's estimated internet surfing time.\n"
			printf "(6)  Show all traffic (HIGHLY reccomend searching for a specific IP)\n"
			printf "(e)xit.\n\n"
			printf "\t\t Please enter your choice:  "
			getline menuchoice < "-"
			printf "\n"

		if ((menuchoice >= 1 && menuchoice <=6) &&  (menuchoice % 1) == 0)
				choiceflag = "valid"
			else
				choiceflag =  "invalid"
		if (menuchoice == "e" || menuchoice == "E")
			exit	
		}
	}
		

	
	print "Your menu choice selected:   " menuchoice
	print "This choice is:   " choiceflag
	print "Input filename:   " searchfile
	print "Output filename:   " outputfile
	

##### These lines are CRITICAL to the program working.  It forces the command line parameters into the awk script.  
##### As long as the input file is stored in ARGV[1] (The first command line argument after the script name)
##### These next lines are fine.
	for (c=0; c<ARGC; c++){
		if (ARGV[c] == "-menu" || ARGV[c] == "-output" || ARGV[c] == "-noip" || ARGV[c] == "-ip"){
			ARGC = (c)
			ARGV[ARGC] = "$*"
		}
	}
#####		
#####
#####	


####Load arrays based on menu choices####

	if (menuchoice == 1){
		element = 1
		while ((getline < "porn.list") != 0){
        	        pornArray[element] = $0
                        element++
                }
                close ("porn.list")
		element = 1
		while ((getline < "falseporn.list") !=0){
			falseArray[element] = $0
			element++
		}
		close ("falseporn.list")
	}
	if (menuchoice == 4 && searchdomainflag != "true"){
		printf("\nPlease enter the domain name you're looking for:   ")
		getline searchdomain < "-"
		printf("\n")
	}

	if (IPsearchflag == ""){
		if (menuchoice != 5)	
			printf("\n<<Optional>> Enter the IP you're searching for, or leave blank for all:  ")
		if (menuchoice ==5)
			printf("\n<<REQUIRED>> Enter the IP you're searching for, or leave blank for all:  ")
		getline IPsearch < "-"
		printf("\n")

		IPsearchflag = "false"
		if (IPsearch != "")
			IPsearchflag = "true"
	}	
	
	print "Beginning search ...."	
}	
######End BEGIN code area######
	
{


	if (choiceflag == "valid"){
	getline < searchfile

		split(tolower($13), temparray, "=")
		sourceIPport = temparray[2]
		split(sourceIPport, temparray, "/")
		sourceIP = temparray[1]
		x=split(tolower($17), temparray, "/")
		domain = temparray[3]
		filename = temparray[x]
		url = tolower($17)
		op = tolower($16)
		logfilename = $1
		x=split(tolower($1), temparray, ":")
		month = temparray[x]
		day = tolower($2)
		timestamp = tolower($3)
		transfersize = tolower($11)
		analysisIPfound = "false"

#####Prevents detection of analysis machine for filtering of False Positives#####
	if (sourceIP == AnalysisIP)
		analysisIPfound = "true"
	if (analysisIPfound == "false"){
#####Begin menu choice 1#####
		if (menuchoice == 1){  
			showFlag = ""
			for (pornitem in pornArray){
				if (url ~ pornArray[pornitem]){
					showFlag = "true"
				}
			}
			
			if (showFlag != "false"){
				for (falseitem in falseArray){
					falseterm = falseArray[falseitem]
					if (domain ~ falseterm){
						showFlag = "false"
					}
				}	
			}
			if (showFlag == "true"){
					if ( op == "op=get" || op == "op=post"){
						if (outputfile != ""){
							if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
							print logfilename " " day " " timestamp " --- " sourceIPport " --- " domain "/.../" filename " --- " op " --- " transfersize > outputfile
						}
						else{
							if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
							print logfilename " " day " " timestamp " --- " sourceIPport " --- " domain "/.../" filename " --- " op " --- " transfersize }
					}else{
					print $0	}	
				}else{}

		}else{} 
######End menu choice 1######

#####Begin menu choice 2#####

		
		if (menuchoice == 2){	
			if (url ~ /\.mpeg/ || /\.mp3/ || /\.mpg/ || /\.wmv/ || /\.mov/ || /\.exe/ || /\.zip/ || /\.rar/ || /\.pif/){
  				if ( op == "op=get" || op == "op=post"){
					if (outputfile != ""){
						if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " $16 " --- " $11 "\n" > outputfile
					}
					else {		
						if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " $16 " --- " $11 
					}
				}else{} 
			}else{}		
		}else{} 

######End menu choice 2######

#####Begin menu choice 3#####

		if (menuchoice == 3){   
			x=split(tolower($11), temparray, "=")
			filesize = temparray[2]
			if ( filesize > 1000000){
				if ( op == "op=get" || op == "op=post"){
					if (outputfile !=""){
						if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " filesize " bytes" > outputfile
					}
					else {
						if ((IPsearchflag == "true" && sourceIP == IPsearch) || (IPsearchflag != "true"))	
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " filesize " bytes" 
					}
				}
			}
		}
######End menu choice 3######

#####Begin menu choice 4#####
                if (menuchoice == 4){

                        x=split($17, temparray, "/")
                        x=split(domain, temparray, ".")
                        maindomain = tolower(temparray[x-1])
                        IPstatus = "unique"

                         if (domain ~ searchdomain){
                                for (x=1; x<= IPcounter; x++){
                                monthArray[x] = month
                                dayArray[x] = day
                                        if (IPstatus != "repeat"){
                                                if (IParray[x] == sourceIP){
                                                        IPstatus = "repeat"
                                                        countArray[x]++
                                                }
                                        }
                                        if ((IPsearchflag == "true" && sourceIP == IPsearch)){
                                                if ((monthArray[x] != monthArray[x-1]) || (dayArray[x] != dayArray[x-1]))
                                                print month " --- " day " --- " sourceIP " --- " domain

                                        }
                                 }
                                if (IPstatus == "unique"){
                                        IParray[IPcounter] = sourceIP
                                        countArray[IPcounter]++
                                        if ((IPsearchflag == "true" && sourceIP == IPsearch)){
                                                if ((monthArray[x] != monthArray[x-1]) || (dayArray[x] != dayArray[x-1]))
                                                        print month " --- " day " --- " sourceIP " --- " domain
                                        }
                                        IPcounter++
                                }
                        }

                }else {}
######End menu choice 4######

#####Begin menu choice 5#####
			
		if (menuchoice == 5){
			if (IPsearch == sourceIP){
				 hours = substr   ( $3, 1, 2)
				 minutes = substr ( $3, 4, 2)
				 seconds = substr ( $3, 7, 2)
				 millis = substr  ( $3, 10, 3)
				 timeinseconds = (hours * 3600) + (minutes * 60) + seconds + (millis / 1000)
				 nameArray[counter] = domain
				 timeArray[counter] = timeinseconds
				 monthArray[counter] = month
				 dayArray[counter] = day

				  If (counter >1)
				        if (nameArray[counter] == nameArray[counter - 1] && monthArray[counter] == monthArray[counter-1] && dayArray[counter] == dayArray[counter-1]){
				                if (timeArray[counter] - timeArray[counter - 1] <= 3600)
				                        timeSpent[counter] = timeSpent[counter-1] + timeArray[counter] - timeArray[counter - 1]
	
				                else{
				                        hourCounter[counter] = "True"
			        	                timeSpent[counter] = "UNKNOWN"
			                	}
				        }
				        if (nameArray[counter] != nameArray[counter - 1] && nameArray[counter-1] != nameArray[counter - 2])
				                timeSpent[counter - 1] = .001

				 counter++
			}
		}
######End menu choice 5######

#####Begin menu choice 6#####

		if (menuchoice == 6){
			
			if (outputfile !="")
				if (IPsearchflag == "true" && IPsearch == sourceIP || IPsearchflag != "true"){
					if (op == "op=get" || op == "op=post"){
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " $11 > outputfile}
					else
						print $0 > outputfile
			}
			else{
				if (IPsearchflag == "true" && IPsearch == sourceIP || IPsearchflag != "true"){
					if (op == "op=get" || op == "op=post")
						print $1 " " $2 " " $3 " --- " sourceIPport " --- " $17 " --- " $11
					else
						print $0
					
				}
			}	
		}		
######End menu choice 6######

	}
	}	
}

######End MAIN code area######

END { 

close (searchfile)
	if (menuchoice == 4){
		
		if (outputfile !=""){
			print "Listing of hits for: " searchdomain > outputfile
			print "---------------------------------------" > outputfile
			print "Number of Hits  ------ Source IP Address" > outputfile
			print "---------------------------------------" > outputfile
		}else{
			print "Listing of hits for: " searchdomain
			print "---------------------------------------"
			print "Number of Hits  ------ Source IP Address"
			print "---------------------------------------"
		}
		
		       for (x=1; x< IPcounter; x++){
				if (outputfile !=""){
		    			print countArray[x], "\t------\t", IParray[x]  > outputfile
				}else{
					print countArray[x] "\t------\t" IParray[x] 
				}
       	    		hitsum += countArray[x]
	       
			}	
		if (outputfile !=""){
			print "Number of IPs:  " x > outputfile
			print "Sum of hits:  ", hitsum > outputfile
			print "Domain searched:  ", searchdomain > outputfile
		}else{
			print "Number of IPs:  " x
			print "Sum of hits:  " hitsum
			print "Domain searched:  " searchdomain
		}
		
	}	
	if (menuchoice == 5){

	       printf (" Domain name \t \t \t Time Spent (in seconds)\n")
	       printf ("---------------------------------------------------------------\n\n\n")

	       for (x = 2; x <= counter; x++){
        	        if (timeSpent[x] == 0)
	                        timeSpent[x] = .001
        	        if (nameArray[x] != nameArray[x - 1] || monthArray[x] != monthArray[x-1] || dayArray[x] != dayArray[x-1])
				if (timeSpent[x-1] >=1){
	                	        printf (" %s %s %s \t \t \t %.3f \n", monthArray[x-1], dayArray[x-1], nameArray[x - 1], timeSpent[x - 1])
        				TimeSpentSum += timeSpent[x-1]
				}
	                if (hourCounter[x] == "True"){
        	                printf (" %s %s %s \t \t \t %s \n", monthArray[x], dayArray[x], nameArray[x], timeSpent[x])
                	        printf ("----------------------------------------------------------------\n")
	                }
		}
	        printf ("\n\n Total time spent:  %.3f\n\n", TimeSpentSum)
	}
}
