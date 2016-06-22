#!bin/bash




		# ****************Test Cases**************** #	
			
			
			testCase[0]="HelloWorld"
			testCaseLen[0]="512"
			
			testCase[1]="ILoveCryptography"
			testCaseLen[1]="2000"
			
			testCase[2]="Atreeconstructedbyhashingpaireddatatheleavesthenpairingandhashingtheresu"
			testCaseLen[2]="800"
			
			testCase[3]="AjudgeinBrazilorderedonMondaythatphonecompaniesblockFacebooksmessagingserviceWhatsAppthroughoutthecountryfor72hoursinresponsetoitsrefusaltocooperateinapoliceinvestigationJudgeMarcelMontalvaodeliveredtheorderbecauseWhatsAppwouldnotturnoverinformationthatcouldrelatetoaninvestigationintonarcoticsactivityandaninterstategangThebanwillgointoeffectat2pmlocaltimeBloombergreportsandthefinetophonecompaniesfornotblockingtheappwouldbeabout143000perdayRoughlyhalfofBrazilspopulationof200millionusesthemessagingserviceasaneconomicalalternativetootherpricierformsofcommunicationsotheshutdownwillhaveabigeffectonmanyBraziliansThisisthesecondtimeinsixmonthsajudgehassuspendedtheserviceinBrazilthoughacourtoverturnedthepreviousdecisioninDecember"
			testCaseLen[3]="3000"
			
			



# ***************** Unzip the zip file *****************


		
	zipFile=$(find -name "*zip")
	unzip "$zipFile"
	rm -rf "$zipFile"	
	rm -rf "__MACOSX"
		
	File=$(find -name "0*")
	ID="$File" ;
	
	if [ "$File" != "./Ans" ] ; then
		
		cd "$File"
		make 			
				
		hwExe=$(find "./" -maxdepth 1 -mindepth 1 -executable -type f)  ;
		
				
			
		echo "*************Hidden Testcase*************" >> "$ID.score";
		("$hwExe" "HardCodedYet?" "512" ) > "isHardCode.txt" ;
		Result=$(diff isHardCode.txt ../Ans/checkHardCode.txt) ;	
		
		if [ $? -eq 0 ] ; then
			echo "Correct" >> "$ID.score" ;
		else
			echo "Wrong answer, your Hidden Testcase answer: " >> "$ID.score" ;
			cat "$isHardCode.txt" >> "$ID.score" ;
			printf "\n" >> "$ID.score" ;
		fi
					
		printf "*************************************\n\n" >> "$ID.score" ;
		
		
		for(( i=0; i<4; i++ )) 
		do
					
				echo "*************Testcase $i*************" >> "$ID.score";
								
					("$hwExe" "${testCase[$i]}" "${testCaseLen[$i]}" ) > "$i.txt" ;
					Result=$(diff $i.txt ../Ans/ans_$i.txt) ;
				
					if [ $? -eq 0 ] ; then
						echo "Correct" >> "$ID.score" ;
					else
						echo "Wrong answer, your testcase_$i answer: " >> "$ID.score" ;
						cat "$i.txt" >> "$ID.score" ;
						printf "\n" >> "$ID.score" ;
					fi
					
					printf "*************************************\n\n" >> "$ID.score" ;
		done	
						
				rm -rf *txt
				cd ..
	fi	
	