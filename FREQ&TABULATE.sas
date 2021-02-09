DATA HEART;
	SET SASHELP.HEART;
RUN;

PROC CONTENTS DATA=HEART;RUN;
/*  */
/* 12	AgeAtDeath	숫자	8	Age at Death */
/* 5	AgeAtStart	숫자	8	Age at Start */
/* 3	AgeCHDdiag	숫자	8	Age CHD Diagnosed */
/* 15	BP_Status	문자	7	Blood Pressure Status */
/* 14	Chol_Status	문자	10	Cholesterol Status */
/* 13	Cholesterol	숫자	8	  */
/* 2	DeathCause	문자	26	Cause of Death */
/* 8	Diastolic	숫자	8	  */
/* 6	Height	숫자	8	  */
/* 10	MRW	숫자	8	Metropolitan Relative Weight */
/* 4	Sex	문자	6	  */
/* 11	Smoking	숫자	8	  */
/* 17	Smoking_Status	문자	17	Smoking Status */
/* 1	Status	문자	5	  */
/* 9	Systolic	숫자	8	  */
/* 7	Weight	숫자	8	  */
/* 16	Weight_Status	문자	11	Weight Status */



PROC UNIVARIATE DATA=HEART;
	BY Smoking_Status;
RUN;

/* 1) FREQ  /* 1개 특성의 분포표  */
PROC FREQ DATA=SASHELP.HEART; 
	TABLES Smoking_Status; 
RUN;

PROC FREQ DATA=SASHELP.HEART; 
	TABLES Smoking_Status*Status; 
RUN;

PROC FREQ DATA=SASHELP.HEART; 
	TABLES Smoking_Status/MISSING; 
RUN;

PROC FREQ DATA=SASHELP.HEART; 
	TABLES Smoking_Status/MISSPRINT; 
RUN;

PROC FREQ DATA=SASHELP.HEART; 
	TABLES Smoking_Status/PLOTS=FREQPLOT; 
RUN;

PROC FREQ DATA=SASHELP.HEART ORDER=data; 
	TABLES Smoking_Status; 
RUN;


PROC SQL; 
CREATE TABLE TEMP AS SELECT NAME FROM DICTIONARY.COLUMNS ; 
QUIT; 
PROC PRINT DATA=TEMP;RUN;
