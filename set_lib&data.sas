/* 라이브러리 설정 */
LIBNAME ice "/folders/myshortcuts/myfolder/data/";

/* 생성된 코드(가져오기) */
/* 소스 파일: BankChurners.csv */
/* 소스 경로: /folders/myshortcuts/myfolder/data */
/* 코드 생성일: 21. 1. 4. 오전 10:34 */

PROC IMPORT OUT=bankChurn
	DATAFILE="/folders/myshortcuts/myfolder/data/BankChurners.csv"
	DBMS=CSV replace;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=bankChurn; RUN;

/* 데이터 전처리 */

/* 1. 컬럼명 변경 */
/*  기존 컬럼명
137                        CLIENTNUM
 138                        Attrition_Flag  $
 139                        Customer_Age
 140                        Gender  $
 141                        Dependent_count
 142                        Education_Level  $
 143                        Marital_Status  $
 144                        Income_Category  $
 145                        Card_Category  $
 146                        Months_on_book
 147                        Total_Relationship_Count
 148                        Months_Inactive_12_mon
 149                        Contacts_Count_12_mon
 150                        Credit_Limit
 151                        Total_Revolving_Bal
 152                        Avg_Open_To_Buy
 153                        Total_Amt_Chng_Q4_Q1
 154                        Total_Trans_Amt
 155                        Total_Trans_Ct
 156                        Total_Ct_Chng_Q4_Q1
 157                        Avg_Utilization_Ratio
 158                        Naive_Bayes_Classifier_Attritio
 159                        VAR23 
 */

DATA bankChurnRename;
	RENAME 
		CLIENTNUM=ID
		Attrition_Flag=Attrition
		Customer_Age=Age
		Education_Level=Education
		Income_Category=Income
		Marital_Status=Marital
		Card_Category=Card;
	SET BANKCHURN;
RUN;










