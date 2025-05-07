-- Inserting new Test Plans in TesPlan table  4x3 VUDU variants
Use AssetLibrary
Insert AlTestPlan Values ('TS H.264 720x480 v1.400M AC3 2.0 A192k High 4.0 10sGOP v372',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V1.156M AC3 2.0 A192k High 4.0 10sGOP v373',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.708M AC3 2.0 A192k High 4.0 10sGOP v374',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V1.400M AC3 5.1 A384k High 4.0 10sGOP v375',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.966M AC3 5.1 A384k High 4.0 10sGOP v376',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.516M AC3 5.1 A384k High 4.0 10sGOP v377',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)


DECLARE @variantId AS int
SET @variantId = 372
WHILE (@variantId <= 377)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2013-06-19 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END