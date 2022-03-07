#!/bin/bash 

# Mohamed Mahmoud
# Covid-19 Interactive Data Visualization Program

# - Start of the Program - 

#  Error Message subroutine function
errorMSG() {

	# echo the type of error
	echo "Error: $1"

	# echo the required script syntax
	echo 'Script syntax: ./covidata.sh -r procedure id range inputFile outputFile compareFile'

	# echo the 4 legal usages for the script
	echo 'Legal usage examples:                                                

	example 1 : ./covidata.sh get 35 data.csv result.csv

	example 2 : ./covidata.sh -r get 35 2020-01 2020-03 data.csv result.csv

	example 3 : ./covidata.sh compare 10 data.csv result2.csv result.csv

	example 4 : ./covidata.sh -r compare 10 2020-01 2020-03 data.csv result2.csv result .csv'
}

# Error for not having Dominant parameter which is the procedure arguement

# Check if the $1 dominant procedure doesn't exist
if [ -z $1 ]
then

	# If the dominant procedure doesn't exist then call the errorMSG subroutine
	errorMSG "Procedure not provided"

	# End the script
	exit	
fi

# Error for having not having the right procedure name

# Check if the first parameter is 1 of the 4 legal usage examples
if [ "$1" != "-r" ] && [ "$1" != "get" ] && [ "$1" != "compare" ]
then
	
	# If it is not then call the errorMSG subroutine
	errorMSG "Wrong Procedure Name"
	
	# End the script
	exit
fi

# The get procedure"

# Check if the first parameter is get
if [ "$1" == "get" ]
then

	# If it is then also check if the correct number of parameters are used
	if [ "$#" -ne 4 ] 
	then
	
		# Error for the wrong number of arguements for the get procedure
		errorMSG "Wrong number of arguements"
	
		# End the script
		exit
	else

		# Check if the inputfile exists and the correct number of parameters are used
		if [ "$#" -eq 4 ] && [ -f "$3" ]
		then
			# Set the parameters to variables for better readability	
			procedure=$1
			id=$2
			inputfile=$3
			outputfile=$4
	
			# Search for the rows with id and overwrite the outputfile with them
			grep "^$id" $inputfile | awk 'BEGIN{FS=","} {print}' > $outputfile 
	
			# Calculate the number of rows
			rowcount=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' $outputfile)
	
			# Calculate the average of the confirmed cases in column 6
			avgconf=$(awk 'BEGIN{FS=",";sum=0; counter}{sum=sum+$6; counter=counter+1}END{print sum/counter }' $outputfile)
	
			# Calculate the average of the number of deaths in column 8
			avgdeaths=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {print sumtwo/countertwo }' $outputfile)
	
			# Calculate the average of the number of tests in column 11
			avgtests=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {print sumthree/counterthree }' $outputfile)
	
			# Append the calculations to the output file specified
			echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
			echo "$rowcount,$avgconf,$avgdeaths,$avgtests" >> $outputfile

			# If the input file doesnt exist, then call the errorMSG subroutine
		else
			errorMSG "Input file name does not exist"
		fi
	fi
exit
fi

# The compare procedure"

if [ "$1" == "compare" ]
then 
	# Check if the number of parameters is 5 for the compare procedure
	if [ "$#" -ne 5 ]
	then

		# Error for the wrong number of arguments for the compare procedure
        	errorMSG "Wrong number of arguements"
		
		# End the script
 	 	exit	
	else

		# Check if the inputfile exists

		if [ "$#" -eq 5 ] && [ -f "$3" ]

		then		
	
			# Set the parameters to variables for better readability
			procedure=$1
			id=$2	
			inputfile=$3
			outputfile=$4
			compfile=$5

			# Search for the rows containing the id in the input file and overwrite the output file
		       	grep "^$id" $inputfile | awk 'BEGIN{FS=","}{print}' > $outputfile
			
	
			# Calculate the row count
			rowcount=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' $outputfile)
	
			# Calculate the average number of confirmed cases
			avgconf=$(awk 'BEGIN{FS=",";sum=0; counter}{sum=sum+$6; counter=counter+1}END{print sum/counter }' $outputfile)
        
			# Calculate the average number of deaths
			avgdeaths=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {print sumtwo/countertwo }' $outputfile)
        
			# Calculate the average number of tests
			avgtests=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {print sumthree/counterthree }' $outputfile)
	
			# Append everything but the last 2 lines of the compfile into the specified outputfile
			head -n -2 $compfile >> $outputfile
	
			# Append the calculations to the specified output file
			echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
        		echo "$rowcount,$avgconf,$avgdeaths,$avgtests" >> $outputfile
	
			# Append the last 2 lines of the compfile into the the specified outputfile
			tail -n 2 $compfile >> $outputfile
	
			# Isolate the statistics for the output file
			outputfilestats=$(tail -n 4 $outputfile | head -n 2 | tail -n 1)

			# Isolate the statistics for the compfile
			compfilestats=$(tail -n 4 $outputfile | tail -n 1)
	
			touch temporarycompfilestats.csv
			touch temporaryoutputfilestats.csv
	
			# Append the isolated statistics of the compfile to the temporary file
			tail -n 4 $outputfile | tail -n 1 > temporarycompfilestats.csv
	
			# Append the isolated statistics of the outputfile to the temporary file
			tail -n 4 $outputfile | head -n 2 | tail -n 1 > temporaryoutputfilestats.csv
	
			# Set each statistic to a variable for better readability
			a2=$(awk 'BEGIN{FS=","}{print $1}' temporarycompfilestats.csv)
			a1=$(awk 'BEGIN{FS=","}{print $1}' temporaryoutputfilestats.csv)
			b2=$(awk 'BEGIN{FS=","}{print $2}' temporarycompfilestats.csv)
			b1=$(awk 'BEGIN{FS=","}{print $2}' temporaryoutputfilestats.csv)
			c2=$(awk 'BEGIN{FS=","}{print $3}' temporarycompfilestats.csv)
			c1=$(awk 'BEGIN{FS=","}{print $3}' temporaryoutputfilestats.csv)
			d2=$(awk 'BEGIN{FS=","}{print $4}' temporarycompfilestats.csv)
			d1=$(awk 'BEGIN{FS=","}{print $4}' temporaryoutputfilestats.csv)
	
			# Calculate the difference in the number of rows between the output file and the compfile
			diffcount=$(($a1 - $a2))
	
			# Calcualte the difference in the number of average confirmed cases between the output file and the compfile
			diffavgconf=$( bc <<< "$b1 - $b2" )
	
			# Calculate the difference between the number of average deaths between the outputfile and the compfile
			diffavgdeath=$( bc <<< "$c1 - $c2" )
	
			# Calculate the difference between the number of average tests between the outputfile and the compfile
			diffavgtests=$(awk 'BEGIN{print ('$d1') - ('$d2')}')
	
			# Append the calculations of the differences to the specified outputfile
			echo "diffcount,diffavgconf,diffavgdeath,diffavgtests" >> $outputfile
			echo "$diffcount,$diffavgconf,$diffavgdeath,$diffavgtests" >> $outputfile
	
			# If the inputfile doesnt exist, then call the errorMSG subroutine is called
			rm -r temporaryoutputfilestats.csv
			rm -r temporarycompfilestats.csv

		else
			
			# Call the error message if the input file doesn't exist
			errorMSG "Input file name does not exist"
		fi	
	fi
exit
fi

# The -r switch"


# The -r switch with the get procedure

# Check if the -r switch is being used and check if get is the requested procedure
if [ "$1" == "-r" ] && [ "$2" == "get" ]
then
	# Set all the paramaters to variables for easier readability
	switch=$1
	procedure=$2
	id=$3
	startdate=$4-01
	enddate=$5-31
	inputfile=$6
	outputfile=$7

	# Seperate the date into year and month and day
	startyear=${startdate:0:4}
	endyear=${enddate:0:4}
	startmonth=${startdate:5:2}
	originalendmonth=${enddate:5:2}	
	startdayperiod1="01"
	enddayperiod1="15"
	startdayperiod2="16"
	enddayperiod2="31"

	# Check if the correct number of parameters are used        
	if [ "$#" -ne 7 ]
        then
                # Error for the wrong number of arguements for the get procedure
		errorMSG "Wrong number of arguements"
                
		# End the script
		exit
	fi

        # Check if the inputfile exists and the correct number of parameters are used
	if [ "$#" -eq 7 ] && [ -f "$inputfile" ]
        then
        
		# Create 3 temporary files for use
		touch temporaryfile1.csv
		touch temporaryfile2.csv
		touch temporaryfile3.csv

	# Send the data within the requested date range to the output 
	grep "^$id" $inputfile | awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>$outputfile

	# Send the data within the full requested date range to the first temporary file
	grep "^$id" $inputfile | awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>temporaryfile1.csv

	# Calculate the number of rows for the requested date range
	rowcount=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' temporaryfile1.csv)
	
	# Calculate the average confirmed for the requested date range
	avgconf=$(awk 'BEGIN{FS=",";sum=0; counter}{sum=sum+$6; counter=counter+1}END{print sum/counter }' temporaryfile1.csv)
	# Calculate the average deaths for the requested date range
	avgdeaths=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {print sumtwo/countertwo }' temporaryfile1.csv)
        
	# Calculate the average tests for the requested date range
	avgtests=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {print sumthree/counterthree }' temporaryfile1.csv)
	
	# Send the statistics for the entire period to the output file 
	echo "Total Statistics for the Entire Period" >> $outputfile
	echo "TotalRowCount,TotalAvgConf,TotalAvgDeaths,TotalAvgTests" >> $outputfile
	echo $rowcount $avgconf $avgdeaths $avgtests >> $outputfile

	# Use a main while loop to iterate through the years
	while [ $startyear -le $endyear ]
	do
		
		# Check if the starting year is less than the ending year
		if [ $startyear -lt $endyear ]
		then
			# If it is then set the end month to 12 
			endmonth=12

		# Check if the starting year is equal to the ending year	
		elif [ $startyear -eq $endyear ]
		then
			# If it is then set the endmonth to the user-given original end month
			endmonth=$originalendmonth
		fi

		# Use an inner while loop to iterate through the months of the specific year
		while [ $startmonth -le $endmonth ]
		do

			# Send the specfic Year and Month to the Output file for better readability
			echo "Year = $startyear" >> $outputfile
			echo "Month = $startmonth" >> $outputfile
			
			# Set new start and end dates for the first period
			newstart=$startyear-$startmonth-01
			newend=$startyear-$startmonth-15

			# Send the period 1 data to a temporary file
			grep "^$id" temporaryfile1.csv | awk -v startdate=$newstart -v enddate=$newend 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>temporaryfile2.csv
			 
			# Calculate the number of rows for the first period
			rowcount2=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' temporaryfile2.csv)
			
			# Calculate the average of confirmed cases for the first period
			avgconf2=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' temporaryfile2.csv)
			
			# Calculate the average of deaths for the first period
			avgdeaths2=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}  }' temporaryfile2.csv)
			# Calculate the average of test for the first period
			avgtests2=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' temporaryfile2.csv)

			# Send the statistics of the first period to the output file
			echo "Period01-15 statistics" >> $outputfile
			echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
			echo $rowcount2,$avgconf2,$avgdeaths2,$avgtests2 >> $outputfile
			
			# Set new start and end dates for the second period
			newstart2=$startyear-$startmonth-16
			newend2=$startyear-$startmonth-31
			
			# Send the data for the second period to a temporary file
			grep "^$id" temporaryfile1.csv | awk -v startdate=$newstart2 -v enddate=$newend2 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>temporaryfile3.csv

			# Calculate the number of rows for the second period
			rowcount3=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' temporaryfile3.csv)
			
			# Calculate the average of confirmed cases for the second period
			avgconf3=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' temporaryfile3.csv)
			
			# Calculate the average of deaths for the second period
			avgdeaths3=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0} }' temporaryfile3.csv)
			# Calculate the average of tests for the second period
			avgtests3=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0} }' temporaryfile3.csv)
	
			# Send the statistics from the second period to the output file
        		echo "Period16-31 statistics" >> $outputfile
        		echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
        		echo $rowcount3,$avgconf3,$avgdeaths3,$avgtests3 >> $outputfile
	
			# Increment the startmonth by 1 to get the next month
			startmonth=$(expr $startmonth + 1)
	
			# Use an if statement to add a leading 0 to the months that are less than 10 (Comparison is lexicographical so works)
			if [ $startmonth -lt 10 ]
			then
			startmonth="0$startmonth"
			fi

		done

		# Increment the start year by 1 to get the next year
		startyear=$(expr $startyear + 1)	

		# Reset the start month to 01 for the new year
		startmonth=01
	done

	else
		# Call Error message if the input file doesn't exist
		errorMSG "Input file name does not exist"
		
	fi

	# Remove the 3 temporary files after completion
	rm -r temporaryfile1.csv
        rm -r temporaryfile2.csv
        rm -r temporaryfile3.csv

exit	
fi	

if [ "$1"="-r" ] && [ "$2"="compare" ]
then
	
	# Set all the paramaters to variables for easier readability
    switch=$1
    procedure=$2
    id=$3
    startdate=$4-01
    enddate=$5-31
    startdatecopy=$4-01
	enddatecopy=$5-31
	startdatecopy2=$4-01
	enddatecopy2=$5-31
	inputfile=$6
    outputfile=$7
	compfile=$8

    # Seperate the date into year and month and day
    startyear=${startdate:0:4}
	startyearcopy=${startdatecopy:0:4}
	startyearcopy2=${startdatecopy2:0:4}

	endyear=${enddate:0:4}
	endyearcopy=${enddatecopy:0:4}
	endyearcopy2=${enddatecopy2:0:4}

	startmonth=${startdate:5:2}
    startmonthcopy=${startdatecopy:5:2}
	startmonthcopy2=${startdatecopy2:5:2}


	originalendmonth=${enddate:5:2}

	startdayperiod1="01"
    enddayperiod1="15"
        
	startdayperiod2="16"
    enddayperiod2="31"

	 # Check if the correct number of parameters are used
        if [ "$#" -ne 8 ]
        then
                # Error for the wrong number of arguements for the get procedure
                errorMSG "Wrong number of arguements"

                # End the script
                exit
	fi

        # Check if the inputfile exists and the correct number of parameters are used
        if [ "$#" -eq 8 ] && [ -f "$inputfile" ]
        then
		
		 # Create 3 temporary files for use
                touch tmpone.csv
		touch tmptwo.csv
		touch tmpthree.csv
		touch tmpfour.csv
		touch tmpfive.csv
		touch tmpsix.csv
		
        # Send the data within the input file requested date range to the output
        grep "^$id" $inputfile | awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>$outputfile
	
	 awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' $compfile > $outputfile
        
	# Send the data within the full requested date range to the first temporary file
        grep "^$id" $inputfile | awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}'>tmpone.csv

        awk -v startdate=$startdate -v enddate=$enddate 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' $compfile > tmptwo.csv
       	
	# Calculate the Difference Analysis
        
	while [ $startyear -le $endyear ]
        do

                # Check if the starting year is less than the ending year
                if [ $startyear -lt $endyear ]
                then
                        # If it is then set the end month to 12
                        endmonth=12

                # Check if the starting year is equal to the ending year
                elif [ $startyear -eq $endyear ]
                then
                        # If it is then set the endmonth to the user-given original end month
                        endmonth=$originalendmonth
                fi

                # Use an inner while loop to iterate through the months of the specific year
                while [ $startmonth -le $endmonth ]
                do

                        # Send the specfic Year and Month to the Output file for better readability
                        echo "Year = $startyear" >> $outputfile
                        echo "Month = $startmonth" >> $outputfile

                        # Set new start and end dates for the first period
                        newstart=$startyear-$startmonth-01
                        newend=$startyear-$startmonth-15

                        # Send the period 1 data to a temporary file
                        awk -v startdate=$newstart -v enddate=$newend 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' tmpone.csv > tmpthree.csv

                        # Calculate the number of rows for the first period
                        rowcount2=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpthree.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf2=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpthree.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths2=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}  }' tmpthree.csv)
                        # Calculate the average of test for the first period
                        avgtests2=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpthree.csv)

                        # Send the statistics of the first period of the input files to the output file
                        echo "Input file Period01-15 statistics" >> $outputfile
                        echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
                        echo $rowcount2,$avgconf2,$avgdeaths2,$avgtests2 >> $outputfile

                        # Set new start and end dates for the second period
                        newstart2=$startyear-$startmonth-16
                        newend2=$startyear-$startmonth-31

                        # Send the data for the second period to a temporary file
                        awk -v startdate=$newstart2 -v enddate=$newend2 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' tmpone.csv >tmpfour.csv

                        # Calculate the number of rows for the second period
                        rowcount3=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpfour.csv)
                        # Calculate the average of confirmed cases for the second period
                        avgconf3=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpfour.csv)
                        # Calculate the average of deaths for the second period
                        avgdeaths3=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0} }' tmpfour.csv)
                        # Calculate the average of tests for the second period
                        avgtests3=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0} }' tmpfour.csv)

                        # Send the statistics from the second period to the output file
                        echo "Input File Period16-31 statistics" >> $outputfile
                        echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
                        echo $rowcount3,$avgconf3,$avgdeaths3,$avgtests3 >> $outputfile

                        # Increment the startmonth by 1 to get the next month
                        startmonth=$(expr $startmonth + 1)

                        # Use an if statement to add a leading 0 to the months that are less than 10 (Comparison is lexicographical so works)
                        if [ $startmonth -lt 10 ]
                        then
                        startmonth="0$startmonth"
                        fi

                done
                # Increment the start year by 1 to get the next year
                startyear=$(expr $startyear + 1)

                # Reset the start month to 01 for the new year
                startmonth=01
        done

 while [ $startyearcopy -le $endyearcopy ]
        do

                # Check if the starting year is less than the ending year
                if [ $startyearcopy -lt $endyearcopy ]
                then
                        # If it is then set the end month to 12
                        endmonth=12

                # Check if the starting year is equal to the ending year
                elif [ $startyearcopy -eq $endyearcopy ]
                then
                        # If it is then set the endmonth to the user-given original end month
                        endmonth=$originalendmonth
                fi

                # Use an inner while loop to iterate through the months of the specific year
                while [ $startmonthcopy -le $endmonth ]
                do

                        # Send the specfic Year and Month to the Output file for better readability
                        echo "Year = $startyearcopy" >> $outputfile
                        echo "Month = $startmonthcopy" >> $outputfile

                        # Set new start and end dates for the first period
                        newstart=$startyearcopy-$startmonthcopy-01
                        newend=$startyearcopy-$startmonthcopy-15

                        # Send the period 1 data to a temporary file
                         awk -v startdate=$newstart -v enddate=$newend 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' tmptwo.csv >tmpfive.csv

                        # Calculate the number of rows for the first period
                        rowcount2=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpfive.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf2=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpfive.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths2=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}}' tmpfive.csv)
                        # Calculate the average of test for the first period
                        avgtests2=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpfive.csv)

                        # Send the statistics of the first period to the output file
                        echo "Compfile Period01-15 statistics" >> $outputfile
                        echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
			echo $rowcount2,$avgconf2,$avgdeaths2,$avgtests2 >> $outputfile

                        # Set new start and end dates for the second period
                        newstart2=$startyearcopy-$startmonthcopy-16
                        newend2=$startyearcopy-$startmonthcopy-31

                        # Send the data for the second period to a temporary file
                        awk -v startdate=$newstart2 -v enddate=$newend2 'BEGIN{FS=","}{if ($5 >= startdate && $5 <= enddate ) print}' tmptwo.csv>tmpsix.csv

                        # Calculate the number of rows for the second period
                        rowcount3=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpsix.csv)
                        # Calculate the average of confirmed cases for the second period
                        avgconf3=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpsix.csv)
                        # Calculate the average of deaths for the second period
                        avgdeaths3=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0} }' tmpsix.csv)
                        # Calculate the average of tests for the second period
                        avgtests3=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0} }' tmpsix.csv)

                        # Send the statistics from the second period to the output file
                        echo "Comp File Period16-31 statistics" >> $outputfile
                        echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
                        echo $rowcount3,$avgconf3,$avgdeaths3,$avgtests3 >> $outputfile

                        # Increment the startmonth by 1 to get the next month
                        startmonthcopy=$(expr $startmonthcopy + 1)

                        # Use an if statement to add a leading 0 to the months that are less than 10 (Comparison is lexicographical so works)
                        if [ $startmonthcopy -lt 10 ]
                        then
                        startmonthcopy="0$startmonthcopy"
                        fi

                done
                # Increment the start year by 1 to get the next year
                startyearcopy=$(expr $startyearcopy + 1)

                # Reset the start month to 01 for the new year
                startmonthcopy=01
        done

 while [ $startyearcopy2 -le $endyearcopy2 ]
        do

                # Check if the starting year is less than the ending year
                if [ $startyearcopy2 -lt $endyearcopy2 ]
                then
                        # If it is then set the end month to 12
                        endmonth=12

                # Check if the starting year is equal to the ending year
                elif [ $startyearcopy2 -eq $endyearcopy2 ]
                then
                        # If it is then set the endmonth to the user-given original end month
                        endmonth=$originalendmonth
                fi

                # Use an inner while loop to iterate through the months of the specific year
                while [ $startmonthcopy2 -le $endmonth ]
                do

                        # Send the specfic Year and Month to the Output file for better readability
                        echo "Year = $startyearcopy2" >> $outputfile
                        echo "Month = $startmonthcopy2" >> $outputfile

                        # Set new start and end dates for the first period
                        newstart=$startyearcopy2-$startmonthcopy2-01
                        newend=$startyearcopy2-$startmonthcopy2-15

                        
			# Calculate the number of rows for the first period
                        rowcount3=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpthree.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf3=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpthree.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths3=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}}' tmpthree.csv)
                        # Calculate the average of test for the first period
                        avgtests3=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpthree.csv)


                        # Calculate the number of rows for the first period
                        rowcount4=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpfive.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf4=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpfive.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths4=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}}' tmpfive.csv)
                        # Calculate the average of test for the first period
                        avgtests4=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpfive.csv)

                        # Send the statistics of the first period to the output file
			echo "Difference Period01-15 statistics" >> $outputfile
                        #echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile
                        
			# Calculate the difference in the number of rows between the output file and the compfile
                        diffcount=$(($rowcount3 - $rowcount4))

                        # Calcualte the difference in the number of average confirmed cases between the output file and the compfile
                        diffavgconf=$( bc <<< "$avgconf3 - $avgconf4" )

                        # Calculate the difference between the number of average deaths between the outputfile and the compfile
                        diffavgdeath=$( bc <<< "$avgdeaths3 - $avgdeaths4" )

                        # Calculate the difference between the number of average tests between the outputfile and the compfile
                        diffavgtests=$(awk 'BEGIN{print ('$avgtests3') - ('$avgtests4')}')

                        # Append the calculations of the differences to the specified outputfile
                        echo "diffcount,diffavgconf,diffavgdeath,diffavgtests" >> $outputfile
                        echo "$diffcount,$diffavgconf,$diffavgdeath,$diffavgtests" >> $outputfile
			
			# Set new start and end dates for the second period
                        newstart2=$startyearcopy-$startmonthcopy-16
                        newend2=$startyearcopy-$startmonthcopy-31                        
			
			
			 # Calculate the number of rows for the first period
                        rowcount3=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpfour.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf3=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpfour.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths3=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}}' tmpfour.csv)
                        # Calculate the average of test for the first period
                        avgtests3=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpfour.csv)

                        # Calculate the number of rows for the first period
                        rowcount4=$(awk 'BEGIN{;rowcounter=0}{rowcounter=rowcounter+1}END{print rowcounter}' tmpsix.csv)
                        # Calculate the average of confirmed cases for the first period
                        avgconf4=$(awk 'BEGIN{FS=",";sum=0; counter=0}{sum=sum+$6; counter=counter+1}END{if (counter!=0){ print sum/counter} else{print 0} }' tmpsix.csv)
                        # Calculate the average of deaths for the first period
                        avgdeaths4=$(awk 'BEGIN{FS=",";sumtwo=0; countertwo=0}{sumtwo=sumtwo+$8; countertwo=countertwo+1}END {if (countertwo!=0){ print sumtwo/countertwo} else{print 0}}' tmpsix.csv)
                        # Calculate the average of test for the first period
                        avgtests4=$(awk 'BEGIN{FS=",";sumthree=0; counterthree=0}{sumthree=sumthree+$11; counterthree=counterthree+1}END {if (counterthree!=0) {print sumthree/counterthree} else{print 0}  }' tmpsix.csv)

                        # Send the statistics of the first period to the output file
                        echo "Difference Period16-31 statistics" >> $outputfile
                        #echo "rowcount,avgconf,avgdeaths,avgtests" >> $outputfile

                        # Calculate the difference in the number of rows between the output file and the compfile
                        diffcount=$(($rowcount3 - $rowcount4))

                        # Calcualte the difference in the number of average confirmed cases between the output file and the compfile
                        diffavgconf=$( bc <<< "$avgconf3 - $avgconf4" )

                        # Calculate the difference between the number of average deaths between the outputfile and the compfile
                        diffavgdeath=$( bc <<< "$avgdeaths3 - $avgdeaths4" )

                        # Calculate the difference between the number of average tests between the outputfile and the compfile
                        diffavgtests=$(awk 'BEGIN{print ('$avgtests3') - ('$avgtests4')}')

                        # Append the calculations of the differences to the specified outputfile
                        echo "diffcount,diffavgconf,diffavgdeath,diffavgtests" >> $outputfile
                        echo "$diffcount,$diffavgconf,$diffavgdeath,$diffavgtests" >> $outputfile

                        # Increment the startmonth by 1 to get the next month
                        startmonthcopy2=$(expr $startmonthcopy2 + 1)

                        # Use an if statement to add a leading 0 to the months that are less than 10 (Comparison is lexicographical so works)
                        if [ $startmonthcopy2 -lt 10 ]
                        then
                        startmonthcopy2="0$startmonthcopy2"
                        fi

                done
                # Increment the start year by 1 to get the next year
                startyearcopy2=$(expr $startyearcopy2 + 1)

                # Reset the start month to 01 for the new year
                startmonthcopy2=01
        done

else
                errorMSG "Input file name does not exist"
	fi

	rm -r tmpone.csv
	rm -r tmptwo.csv
	rm -r tmpthree.csv
	rm -r tmpfour.csv
	rm -r tmpfive.csv
	rm -r tmpsix.csv

fi
# - End of the Program -
