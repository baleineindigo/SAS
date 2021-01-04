/* CONTENTS */
PROC CONTENTS DATA=bankChurnRename;
RUN;

/* 확률 밀도함수 
- PDF("NORMAL",x,mu,sigma)
- x: 확률밀도함수 값을 구하고자 하는 x
- mu : 정규분포의 평균 값
- sigma : 정규분포 표준편차
*/
DATA pdf_ex;
	pdf_norm1=PDF('NORMAL',-1,0,1);
	pdf_norm2=PDF('NORMAL',0,0,1);
	pdf_norm3=PDF('NORMAL',1,0,1);
RUN;
PROC PRINT DATA=pdf_ex;
RUN;

/* 분포함수
- CDF("NORMAL",x,mu,sigma)
- x: 분포함수 값을 구하고자 하는 x
- mu : 정규분포의 평균 값
- sigma : 정규분포 표준편차
*/
DATA cdf_ex;
	cdf_norm1=CDF('NORMAL',-1,0,1);
	cdf_norm2=CDF('NORMAL',0,0,1);
	cdf_norm3=CDF('NORMAL',1,0,1);
RUN;
PROC PRINT DATA=cdf_ex;
RUN;

/* 분위함수 
1) QUANTILE("NORMAL",prob,mu,sigma) : 정규분포에서 분위수
- prob : 누적확률 값. P(X<=x)
- mu : 정규분포의 평균 값
- sigma : 정규분포 표준편차

2) QUANTILE("T",prob,df) : T분포에서 분위수

*/
DATA quantile_ex;
	quantile_norm=QUANTILE('NORMAL',0.05,0,1);
	quantile_T=QUANTILE('T',0.05,10);
	quantile_chi=QUANTILE('CHISQUARE',.95,2);
RUN;
PROC PRINT DATA=quantile_ex;
RUN;

/* 난수 생성 */
DATA rand_data;
	DO I=1 TO 30;
		x=RAND('NORMAL',75,5);
		OUTPUT;
	END;
RUN;
PROC PRINT DATA=rand_data;RUN;



