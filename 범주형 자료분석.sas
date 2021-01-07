/* 자료요약 */
PROC CONTENTS DATA=SASHELP.HEART;
RUN;

PROC PRINT DATA=SASHELP.HEART;
RUN;

/* 1. 도수분포표 및 분할표
1) FREQ */
/* 1개 요인 분포표 */
PROC FREQ DATA=SASHELP.HEART;
	TABLES Smoking_Status;
RUN;

/* 두 요인의 교차분포 */
PROC FREQ DATA=SASHELP.HEART;
	TABLES Smoking_Status*Status;
	TABLES Status *Sex;
RUN;

/* 3개 요인 : 흡연여부와 사망여부 & 몸무게와 사망여부,*/
PROC FREQ DATA=SASHELP.HEART;
	TABLES (Smoking_Status Weight_Status)*Status;
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