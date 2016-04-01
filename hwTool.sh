#!bin/bash

# This is an automatic homework scoring tool designed by Ching Tzu Chen
# This script is reponsible to do the following things:
# 1. unzip all the student's hw
# 2. for each hw directory, go into it and make
# 3. find the resulting executable file and execute it with 10 testcase
# 4. diff the result with our answer, if matches, gives score, otherwise show the correct answer on student's grading text.
# 5. when completeing grading, the student's grading text will have his/her total score

# The grading is executed in "Grading_SHA3" directory, there's an Ans folder containing all the testcase's answer


# ***************** Unzip all the zip file *****************

find -name "*zip" | while read File ; 
	do
		unzip ${File}		
		rm -rf ${File}
	done


# ***************** cd each folder and compile and execute *****************
find "./" -maxdepth 1 -mindepth 1 -type d | while read DIR ; 	
	do	 
		if [ "$DIR" != "./Ans" ] ; then	
			cd "$DIR" ;
			make ;			
			hwExe=$(find "./" -maxdepth 1 -mindepth 1 -executable -type f)  ;
			ID=$(basename $DIR) ;
						
			testCase[0]="HelloWorld"
			testCase[1]="Syntaxerrornearunexpectedtoken"
			testCase[2]="JointheStackOverflowcommunityto"
			testCase[3]="For the Wikipedia policies regarding the use of lyrics"
			testCase[4]="Lyrics are words that"			
									
			declare -i totalScore  ;
			totalScore=0 ;
			for(( i=0; i<5; i++ )) 
			do
				
				echo "*************Testcase $i*************" >> "$ID.score";
			
				# Check if there's a hard-coded testcase
				HardCoded=$(grep -r "${testCase[$i]}") ;
				if [ $? -eq 0 ] ; then
					echo "HardCoded" >> "$ID.score" ;
					printf "*************************************\n\n" >> "$ID.score" ;
					continue ;
				fi
				
				("$hwExe" "${testCase[$i]}") > "$i.txt" ;
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
			
			echo "$ID's total score is $totalScore" >> "$ID.score" ;			
			rm -rf *txt
			cd .. ;
		fi
		
	done
