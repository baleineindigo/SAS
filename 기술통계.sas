/* 일변량 자료 요약 프로시저
1) UNIVARIATE
2) MEANS
3) SUMMARY
*/

/* ======================================================= */

/* 1)  PROC UNIVARIATE */
/* 정렬부터 해줘야 함 */
PROC SORT DATA= work.bankchurnrename;
	BY Gender;
RUN;

/* Total_Revolving_Bal >0 */
DATA BANKCHURN_REVOLV_NOT_ZERO;
	SET BANKCHURNRENAME;	
	IF Total_Revolving_Bal>0 AND Total_Revolving_Bal<2517;
RUN;

/* 일변량 통계 */
PROC UNIVARIATE  DATA= BANKCHURN_REVOLV_NOT_ZERO;
	BY Gender;	
	VAR Age Total_Revolving_Bal Total_Trans_Amt;
RUN;

/* 정규성 검정을 위한 그래프 작성 */
PROC UNIVARIATE  DATA= BANKCHURN_REVOLV_NOT_ZERO NORMAL PLOT;
	VAR Age Total_Revolving_Bal Total_Trans_Amt;
RUN;
/* 
[Age] 정규성 만족 X
- Kolmogorov-Smirnov = 0.029866			Pr > D	=  <0.0100
- 정규 분위수 그래프에서도 직선 위에 벗어난 데이터가 있음
 */

/* 히스토그램 출력 
- NORMAL : 히스토그램 위에 정규분포곡선 출력하여 히스토그램과 비교
- EST : 데이터에서 추정된 평균과 표준편차 값 사용
*/
PROC UNIVARIATE  DATA= BANKCHURN_REVOLV_NOT_ZERO NORMAL PLOT;
	BY Gender;	
	VAR Total_Revolving_Bal ;
	HISTOGRAM Total_Revolving_Bal /NORMAL (MU=EST SIGMA=EST);
RUN;


/* ======================================================= */

/* 2)  PROC MEANS*/
/* 통계량 키워드 미지정 */
PROC MEANS  DATA= BANKCHURN_REVOLV_NOT_ZERO;
	CLASS Gender;
	VAR Total_Revolving_Bal;
	OUTPUT OUT=MEANS_OF_Revolv;
RUN;

/* 통계량 키워드 지정 */
PROC MEANS DATA= MEANS_OF_Revolv  N MEDIAN LCLM UCLM MEAN STD VAR NMISS CV SKEWNESS CSS  ;
	CLASS Gender;
	VAR Total_Revolving_Bal ;
RUN;

/* OUTPUT OUT= */
PROC MEANS  DATA= BANKCHURN_REVOLV_NOT_ZERO;
	CLASS Gender;
	VAR Total_Revolving_Bal;
	OUTPUT OUT=class_out N(Total_Revolving_Bal)=nn
											  MEAN(Total_Revolving_Bal)=mean
											  MEDIAN(Total_Revolving_Bal)=median
											  VAR(Total_Revolving_Bal)=var
											  STD(Total_Revolving_Bal)=std
											  CV(Total_Revolving_Bal)=cv;
RUN;

PROC PRINT DATA=class_out;RUN;

/* ======================================================= */

/* 3) SUMMARY 
일변량 자료에 대한 기술 통계량을 제공하는 프로시저이지만 결과를 출력창으로 출력하지 않는다. 
결과 출력 시에는 PRINT 옵션을 사용.
*/
PROC SUMMARY DATA=bankchurn_revolv_not_zero MEAN STD MEDIAN PRINT;
	 CLASS Gender;
	 VAR Age Total_Revolving_Bal Total_Trans_Amt;
	 OUTPUT OUT=class_out1 
	 							MEAN(Total_Revolving_Bal)=;
RUN;

PROC PRINT DATA=class_out1;RUN;








