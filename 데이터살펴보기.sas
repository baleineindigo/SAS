/* 생성된 코드(가져오기) */
/* 소스 파일: crime.csv */
/* 소스 경로: /folders/myshortcuts/myfolder/data */
/* 코드 생성일: 20. 12. 2. 오후 1:36 */

PROC IMPORT 
	DATAFILE='/folders/myshortcuts/myfolder/data/crime.csv'
	DBMS=CSV
	OUT=WORK.crime;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.crime; RUN;

%web_open_table(WORK.crime);


/************************* 파일 탐색 ************************/

PROC UNIVARIATE DATA=work.crime;
RUN;

PROC describe DATA=work.crime;
	DESCRIBE 
RUN;

PROC FREQ DATA=work.crime;
	TABLE OFFENSE_DESCRIPTION;
RUN;


/* 연도별 사건 사고 횟수 */
PROC SQL;
	CREATE TABLE incedence_per_year AS
	SELECT
	YEAR,
	COUNT(OFFENSE_CODE) AS CNT_OFFS_CODE
	FROM crime
	GROUP BY YEAR
	;
QUIT;

/* 연도 > 월별 사건 수 */
%MACRO year_mth_incidence(year);
	PROC SQL;
		CREATE TABLE incedence_per_mth AS
		SELECT
		MONTH,
		COUNT(OFFENSE_CODE) AS CNT_OFFS_CODE
		FROM crime
		WHERE YEAR=&year.
		GROUP BY MONTH
		;
	QUIT;
%MEND;

%year_mth_incidence();
%year_mth_incidence(2015);
%year_mth_incidence(2016);
%year_mth_incidence(2017);
%year_mth_incidence(2018);



/* 시간대별 사건 수 */
PROC SQL;
	CREATE TABLE incedence_per_hour AS
	SELECT
	HOUR,
	COUNT(OFFENSE_CODE) AS CNT_OFFS_CODE
	FROM crime
	GROUP BY HOUR
	;
QUIT;

/* 요일별 사건 수 */
PROC SQL;
	CREATE TABLE incedence_per_days AS
	SELECT
	DAY_OF_WEEK,
	COUNT(OFFENSE_CODE) AS CNT_OFFS_CODE
	FROM crime
	GROUP BY DAY_OF_WEEK
	;
QUIT;


/************************* REPORTING ************************/
PROC PRINT DATA=work.crime;RUN;

PROC REPORT data=work.crime;
	COLUMNS REPORTING_AREA;
RUN;

/************************* VISULIZATION ************************/
/* 요일별 사건 수 */
PROC PLOT data=incedence_per_days;
   plot DAY_OF_WEEK*CNT_OFFS_CODE;
run;

/* 시간대별 사건 수 */
PROC GCHART data=work.crime;
	vbar=CNT_OFFS_CODE;
RUN;

proc sgplot data=work.incedence_per_days;
  scatter DAY_OF_WEEK*CNT_OFFS_CODE;
run;





