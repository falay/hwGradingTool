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

#find -name "*zip" | while read File ; 
#	do
#		unzip ${File}		
#		rm -rf ${File}
#	done


# ***************** cd each folder and compile and execute *****************
find "./" -maxdepth 1 -mindepth 1 -type d | while read hwFolder ; 	
	do	
		if [ "$hwFolder" != "./Ans" ] ; then	
			cd "$hwFolder" ;
			make ;			
			hwExe = $( find "./" -maxdepth 1 -mindepth 1 -executable -type f ) ;
			
			totalScore = 0 ;
			testCase[0] = "HelloWorld"
			testCase[1] = "Syntaxerrornearunexpectedtoken"
			testCase[2] = "JointheStackOverflowcommunityto"
			testCase[3] = "For the Wikipedia policies regarding the use of lyrics"
			testCase[4] = "Lyrics are words that"
			
			for(( i=0; i<5; i++ )) 
			do
				./"$hwExe" testCase[i] >> "$hwFolder_$i.txt" ;
				if [ $( diff $hwFolder_$i.txt ../Ans/ans_$i.txt ) = "" ] ; then
					totalScore += 20 ;
					echo "Testcase_$i is correct\n" >> "$hwFolder_result.txt" ;
				else
					echo "Wrong answer, your testcase_$i answer: " >> "$hwFolder_result.txt" ;
					cat "$DIR_$i.txt" >> "$hwFolder_result.txt" ;
					echo "\n" >> "$hwFolder_result.txt" ;
				fi
			done	
			
			echo "Total score is $totalSore" >> "$hwFolder_result.txt" ;			
			cd .. ;
		fi
		
	done
