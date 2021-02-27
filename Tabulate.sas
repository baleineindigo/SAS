/* data 불러오기 */
DATA WORK.HEART;SET sashelp.HEART;RUN;
PROC CONTENTS DATA=HEART;RUN;

/* 변수와 속성 리스트(오름차순)
#	변수		유형	길이	레이블
12	AgeAtDeath	숫자	8		Age at Death
5	AgeAtStart	숫자	8		Age at Start
3	AgeCHDdiag	숫자	8		Age CHD Diagnosed
15	BP_Status	문자	7		Blood Pressure Status
14	Chol_Status	문자	10		Cholesterol Status
13	Cholesterol	숫자	8	 
2	DeathCause	문자	26		Cause of Death
8	Diastolic	숫자	8	 
6	Height		숫자	8	 
10	MRW	숫자			8		Metropolitan Relative Weight
4	Sex	문자			6	 
11	Smoking		숫자	8	 
17	Smoking_Status	문자	17	Smoking Status
1	Status		문자	5	 
9	Systolic	숫자	8	 
7	Weight		숫자	8	 
16	Weight_Status	문자	11	Weight Status */


/* Table */
/* AgeAtDeath 합과 평균을 계산한 TABLE 출력 */
PROC TABULATE DATA=heart;
    TABLE AgeAtDeath AgeAtDeath*MEAN ; 	/* SCORE의 합계가 출력 */
	VAR AgeAtDeath;
RUN;


/* Status 레벨에 따른 Smoking의 평균*/
PROC TABULATE DATA=heart;
	CLASS Status;
    VAR Smoking;
    TABLE Smoking*MEAN,Status; 	
    TABLE Status,Smoking*MEAN; 	
RUN;

/* 3개 이상의 변수로 만든 tABLE */
PROC TABULATE DATA=heart;
	CLASS Status Sex;
    VAR Smoking;
	/* STATUS을 행으로, SEX를 열로 한 SMOKING의 평균값*/
    TABLE Status,Sex*Smoking*MEAN;  
	/* SEX를 행으로, STATUS을 열로 한 SMOKING 횟수의 평균값*/
    TABLE Sex*Smoking*MEAN,Status;
RUN;


PROC TABULATE DATA=heart;
	CLASS Status Sex;
    VAR Smoking;
    TABLE Status*Sex*Smoking*MEAN;  
RUN;


/* 테이블 스타일 */
PROC TABULATE DATA=heart STYLE=[FONTSIZE=5];
	CLASS Status / STYLE=[FONTSIZE=3];
    VAR Smoking /STYLE=[FONTWIDTH=WIDE];
    TABLE Status*Smoking*(N MEAN);
RUN;



/* 옵션 */
PROC TABULATE DATA=heart;
	CLASS Status;
    VAR Smoking ;
    TABLE Status,Smoking*(N MEAN SUM MEDIAN MAX MIN STDDEV VAR);
RUN;

