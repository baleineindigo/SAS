/* 자료요약 */
PROC CONTENTS DATA=SASHELP.HEART;
RUN;

PROC PRINT DATA=SASHELP.HEART(obs=20);
RUN;

/* 1. 도수분포표 및 분할표
1) FREQ */
/* 1개 요인 분포표 */
PROC FREQ DATA=SASHELP.HEART;
	TABLES Smoking_Status;
RUN;

/* 두 요인의 교차분포 */
PROC FREQ DATA=SASHELP.HEART;
	TABLES Status*Smoking_Status;
	TABLES Status *Sex;
RUN;

/* 3개 요인 : 흡연여부와 사망여부 & 몸무게와 사망여부,*/
PROC FREQ DATA=SASHELP.HEART;
	TABLES Status*(Smoking_Status Weight_Status);
RUN;

/* ================================================================================================ */
/* 2. 적합도 검정
크기 N의 관측치를 X개의 범주로 분류했을 때 각 관측치들이 각각의 그룹에 속할 확률이 알려져 있는 경우
실제로 이러한 형태대로 관측값들이 분류되었는지 검정하는 방법 */
/* 아래 예시 : 흡연 상태별 수가 많이 차이나는지 >> 차이가 있다 */
PROC FREQ DATA=SASHELP.HEART;
	TABLES Smoking_Status/TESTP=(0.2 0.2 0.2 0.2 0.2);
RUN;

/* ================================================================================================ */
/* 3. 독립성 검정
- 2개의 특성 사이의 연관관계 유무를 파악하기 위함. 연관성이 없다면 독립
- 연관성 측도 : 파이계수, 분할 계수, 크래머 V 등
*/
DATA WORK.HEART_SMOKE;
	SET SASHELP.HEART;
	Smoking_YN="Y";

	IF Smoking_Status="Non-smoker" THEN
		Smoking_YN="N";
RUN;

PROC FREQ DATA=HEART_SMOKE;
	TABLES Smoking_YN*SEX/CHISQ;
RUN;


/* ================================================================================================ */
/* 4. 동질성 검정
어떤 특성에 대한 자료의 분포가 동일한지 검정하는 방법으로 독립 검정과 유사하나 
자료를 얻는 방법에서 차이가 있습니다. 동질성검정은 전체 자료를 검정하려는 특성에 따라 먼저 분류한 후
각 범주별로 정해진 수만큼의 자룔를 조사하여 각 범주별로 비율이 다른지 검정
*/
PROC FREQ DATA=HEART_SMOKE;
	TABLES SEX*Smoking_YN/CHISQ NOPERCENT MEASURES;
RUN;
