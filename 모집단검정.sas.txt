/* 자료 요약 */
PROC SORT DATA=work.bankchurnrename;
	BY Gender;
RUN;
PROC UNIVARIATE DATA=WORK.bankchurnrename;
	VAR TOTAL_REVOLVING_BAL;
RUN;		/* 평균 : 1162.814 */


/* Total_Revolving_Bal >0 */
DATA BANKCHURN_REVOLV_NOT_ZERO;
	SET BANKCHURNRENAME;
    if Total_Revolving_Bal>0 and Total_Revolving_Bal<2517;
RUN;

/* 1. 단일 모집단의 모평균에 대한 검정 */
/* 1) TTEST */
PROC TTEST DATA=work.BANKCHURN_REVOLV_NOT_ZERO H0=1162.814 ALPHA=0.95;
	VAR TOTAL_REVOLVING_BAL;
RUN;

/* 2) UNIVARIATE */
PROC UNIVARIATE DATA=BANKCHURN_REVOLV_NOT_ZERO
											MU0=1162 ALPHA=0.95  CIBASIC;
	VAR TOTAL_REVOLVING_BAL ;
RUN;


/* ****************************************************************************************************************************************************** */

/* 2.독립표본에 대한 모평균 차의 검정 
서로 독립인 두 모집단의 모평균이 동일한지 검정을 위한 검정 통계량은 두 모집단의 분산이 동일한지 여부에 따라 달라진다.

두 모집단의 분산이 같은 경우(Pooled), 다른 경우(Satterthwaite)
*/
PROC TTEST DATA=BANKCHURN_REVOLV_NOT_ZERO;
	CLASS GENDER;
	VAR TOTAL_REVOLVING_BAL;
RUN;


/* ****************************************************************************************************************************************************** */
/* 3. 짝 표본에 대한 모평균 차의 검정

- 두 모집단이 서로 독립이 아닐 경우 짝비교 방법 사용합니다. 
이때, 실험단위를 동질적인 쌍으로 묶은 다음 각 쌍을 임의로 추출하여 두 처리를 적용시킵니다. 

- n개의 짝표본 (x1,y1),(x2,y2),(x3,y3),...(xn,yn)의 차이는 di=(xi-yi)이다.
mu0는 모집단의 두 짝표본의 차이 di의 평균이며, 이들의 차이가 없다는 것이 귀무가설이다.
*/



