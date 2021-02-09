/* 생성된 코드(가져오기) */
/* 소스 파일: BankChurners.csv */
/* 소스 경로: /folders/myshortcuts/myfolder/data */
/* 코드 생성일: 20. 12. 2. 오후 1:36 */

PROC IMPORT 
	DATAFILE='/folders/myshortcuts/myfolder/data/BankChurners.csv'
	DBMS=CSV
	OUT=WORK.BnkCh;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.BnkCh; RUN;
/* PROC PRINT DATA=work.bnkch obs="30";RUN; */

%web_open_table(WORK.BnkCh);

/* 변수명만 보기 */
PROC CONTENTS DATA=WORK.BnkCh VARNUM SHORT; RUN;
/*

CONTENTS 프로시저

변수(생성 순서)
CLIENTNUM 
Attrition_Flag 
Customer_Age 
Gender 
Dependent_count 
Education_Level 
Marital_Status 
Income_Category 
Card_Category 
Months_on_book 
Total_Relationship_Count 
Months_Inactive_12_mon 
Contacts_Count_12_mon 
Credit_Limit 
Total_Revolving_Bal 
Avg_Open_To_Buy 
Total_Amt_Chng_Q4_Q1 
Total_Trans_Amt 
Total_Trans_Ct 
Total_Ct_Chng_Q4_Q1 
Avg_Utilization_Ratio 
Naive_Bayes_Classifier_Attritio 
VAR23
*/
/********************* UNIVARIATE *********************/

/* 1. UNIVARIATE로 히스토그램, 확률분포 그래프 그리기 */
PROC UNIVARIATE DATA=work.BnkCh;
	VAR Credit_Limit; /*분석하기 위한 수치형 변수로 지정 */
	HISTOGRAM Credit_Limit/NORMAL(MU=EST SIGMA=EST); /*지정한 변수에 대한 히스토그램*/
	PROBPLOT Credit_Limit/NORMAL(MU=EST SIGMA=EST); 
	/* INSET : 그래프 안에 추가로 나타낼 지표 */
	INSET n min max mean std var stdmean skewness kurtosis
		/format = 6.1 position = rm header = 'Data Summary';
	
	

/* 2. UNIVARIATE로 히스토그램, 확률분포 (성별로 카드 한도 알아보기) */
PROC SORT DATA=work.bnkch OUT=gen_lim;
	BY descending Gender;
RUN;
PROC UNIVARIATE DATA=gen_lim;
	BY descending gender;
	VAR Credit_Limit;
	HISTOGRAM Credit_Limit/NORMAL(MU=EST SIGMA=EST);
	PROBPLOT Credit_Limit/NORMAL(MU=EST SIGMA=EST); 
	INSET n min max mean std var stdmean skewness kurtosis
		/format = 6.1 position = rm header = 'Data Summary';
RUN;


/* 3. UNIVARIATE로 히스토그램, 확률분포 (소득별로 카드 한도 알아보기) */
PROC SORT DATA=work.bnkch OUT=inc_lim;
	BY descending Income_Category;
RUN;
PROC UNIVARIATE DATA=inc_lim;
	BY descending Income_Category;
	VAR Credit_Limit;
	HISTOGRAM Credit_Limit/NORMAL(MU=EST SIGMA=EST);
	PROBPLOT Credit_Limit/NORMAL(MU=EST SIGMA=EST); 
	INSET n min max mean std var stdmean skewness kurtosis
		/format = 6.1 position = rm header = 'Data Summary';
RUN;

/********************* UNIVARIATE *********************/

/* 1. PLOT (연령 * 카드 한도 & 연령 * 리볼빙 금액) */
PROC PLOT DATA=work.BnkCh;
	PLOT Credit_Limit*Customer_Age="o" 
		 Total_Revolving_Bal*Customer_Age="*"
		/OVERLAY HAXIS= 20 TO 75 BY 10 VAXIS= 1000 TO 40000 BY 5000;
RUN; /* 단위가 달라서 같은 그래프 안에 둘 수 없음 */



/* 2. SGPLOT BOX PLOT 그리기 */
PROC SGPLOT DATA=work.BnkCh;
	VBOX Customer_Age/DATALABEL=Customer_Age;
RUN;


/* 3. VBAR 문에 GROUPDISPLAY = CLUSTER 옵션을 추가하여 스택 그룹 대신 병렬 그룹을 지정 */
PROC SGPLOT DATA=work.BnkCh;
	VBAR Income_Category/GROUPDISPLAY=CLUSTER;
RUN;


/********************* MEAN *********************/
PROC MEANS DATA=work.bnkch;
	CLASS gender;
	VAR Credit_Limit;
	OUTPUT OUT = work.bnk_means
		N(Credit_Limit)=Lim_n
		MEAN(Credit_Limit)=Lim_MEAN
		STD(Credit_Limit)=Lim_STD
		MEDIAN(Credit_Limit)=LIM_MED;
RUN;
PROC PRINT DATA=work.bnk_means;RUN;

