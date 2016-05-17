#!bin/bash

# This is an automatic homework scoring tool designed by Ching Tzu Chen
# This script is reponsible to do the following things:
# 1. unzip all the student's hw
# 2. for each hw directory, go into it and make
# 3. find the resulting executable file and execute it with 10 testcase
# 4. diff the result with our answer, if matches, gives score, otherwise show the correct answer on student's grading text.
# 5. when completeing grading, the student's grading text will have his/her total score

# The grading is executed in "Grading_SHA3" directory, there's an Ans folder containing all the testcase's answer


		# ****************Test Cases**************** #	
			testCase[0]="HelloWorld"
			testCaseLen[0]="512"
			
			testCase[1]="ILoveCryptography"
			testCaseLen[1]="2000"
			
			testCase[2]="Atreeconstructedbyhashingpaireddatatheleavesthenpairingandhashingtheresu"
			testCaseLen[2]="800"
			
			testCase[3]="AjudgeinBrazilorderedonMondaythatphonecompaniesblockFacebooksmessagingserviceWhatsAppthroughoutthecountryfor72hoursinresponsetoitsrefusaltocooperateinapoliceinvestigationJudgeMarcelMontalvaodeliveredtheorderbecauseWhatsAppwouldnotturnoverinformationthatcouldrelatetoaninvestigationintonarcoticsactivityandaninterstategangThebanwillgointoeffectat2pmlocaltimeBloombergreportsandthefinetophonecompaniesfornotblockingtheappwouldbeabout143000perdayRoughlyhalfofBrazilspopulationof200millionusesthemessagingserviceasaneconomicalalternativetootherpricierformsofcommunicationsotheshutdownwillhaveabigeffectonmanyBraziliansThisisthesecondtimeinsixmonthsajudgehassuspendedtheserviceinBrazilthoughacourtoverturnedthepreviousdecisioninDecember"
			testCaseLen[3]="3000"



# ***************** Unzip all the zip file *****************

cd "Student_SHA3" ;

find "./" -maxdepth 1 -mindepth 1 -type d | while read DIR ;
	do
		cd "$DIR"
		
		zipFile=$(find -name "*zip")
		unzip "$zipFile"
		
		File=$(find "./" -maxdepth 1 -mindepth 1 -type d)
		mv "$File" "../.."
		cd ..
	done

cd ..
	
rm -rf "Student_SHA3"	


# ***************** cd each folder and compile and execute *****************
find "./" -maxdepth 1 -mindepth 1 -type d | while read DIR ; 	
	do	 
		if [ "$DIR" != "./Ans" ] ; then	
			cd "$DIR" ;
			make ;			
			hwExe=$(find "./" -maxdepth 1 -mindepth 1 -executable -type f)  ;
			ID=$(basename $DIR) ;
			
					
			# Hidden test case
			("$hwExe" "HardCodedYet?" "512" ) > "isHardCode.txt" ;
			Result=$(diff isHardCode.txt ../Ans/checkHardCode.txt) ;
			
			
			if [ $? -eq 0 ] ; then
				printf "******************Pass the hard-coded test*******************\n\n" >> "$ID.score" ;
			
			else
				printf "*****************Hard Coded*******************\n\n" >> "$ID.score" ;
				echo "$ID's total score is 0" >> "$ID.score";
				
				echo "*****************************$ID*****************************" >> "../AllScores.txt" ;
				echo "$ID's total score is 0 (hard coded)" >> "../AllScores.txt" ;
				cd ..
				continue 	
			fi
									
			declare -i totalScore  ;
			totalScore=0 ;
			for(( i=0; i<4; i++ )) 
			do
				
				echo "*************Testcase $i*************" >> "$ID.score";
					

				# Check if there's a hard-coded testcase
				HardCoded=$(grep -r "${testCase[$i]}") ;
				if [ $? -eq 0 ] ; then
					echo "HardCoded" >> "$ID.score" ;
					printf "*************************************\n\n" >> "$ID.score" ;
					continue ;
				fi

					
				("$hwExe" "${testCase[$i]}" "${testCaseLen[$i]}" ) > "$i.txt" ;
				Result=$(diff $i.txt ../Ans/ans_$i.txt) ;
			
				if [ $? -eq 0 ] ; then
					totalScore+=20 ;
					echo "Correct" >> "$ID.score" ;
				else
					echo "Wrong answer, your testcase_$i answer: " >> "$ID.score" ;
					cat "$i.txt" >> "$ID.score" ;
					printf "\n" >> "$ID.score" ;
				fi
				
				printf "*************************************\n\n" >> "$ID.score" ;
			done	
			
			echo "$ID's SHA3 implementation score is $totalScore" >> "$ID.score" ;			
			
			# Write the result to a global file
			echo "*****************************$ID*****************************" >> "../AllScores.txt" ;	
			cat "$ID.score" >> "../AllScores.txt" ;
			
			rm -rf *txt
			cd ..
			
		fi
		
	done
