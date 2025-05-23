-- Inserting new Test Plans in TesPlan table for VUDU variants
Use AssetLibrary
Insert AlTestPlan Values ('TS H.264 1920x1080 V7.700M AC3 5.1 A384k High 4.0 10sGOP v350',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V5.700M AC3 5.1 A384k High 4.0 10sGOP v351',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V3.700M AC3 5.1 A384k High 4.0 10sGOP v352',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V2.350M AC3 5.1 A384k High 4.0 10sGOP v353',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V3.660M AC3 5.1 A384k High 4.0 10sGOP v354',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V2.700M AC3 5.1 A384k High 4.0 10sGOP v355',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V1.640M AC3 5.1 A384k High 4.0 10sGOP v356',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V0.966M AC3 5.1 A384k High 4.0 10sGOP v357',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V1.400M AC3 5.1 A384k High 4.0 10sGOP v358',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.966M AC3 5.1 A384k High 4.0 10sGOP v359',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.516M AC3 5.1 A384k High 4.0 10sGOP v360',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V7.890M AC3 2.0 A128k High 4.0 10sGOP v361',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V5.890M AC3 2.0 A128k High 4.0 10sGOP v362',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V3.890M AC3 2.0 A128k High 4.0 10sGOP v363',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1920x1080 V2.540M AC3 2.0 A128k High 4.0 10sGOP v364',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V3.850M AC3 2.0 A128k High 4.0 10sGOP v365',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V2.890M AC3 2.0 A128k High 4.0 10sGOP v366',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V1.830M AC3 2.0 A128k High 4.0 10sGOP v367',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V1.156M AC3 2.0 A128k High 4.0 10sGOP v368',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 v1.400M AC3 2.0 A128k High 4.0 10sGOP v369',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V1.156M AC3 2.0 A128k High 4.0 10sGOP v370',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 720x480 V0.708M AC3 2.0 A128k High 4.0 10sGOP v371',NULL,0,'2013-06-11 12:00:00.000','D3',NULL,NULL,1)

DECLARE @variantId AS int
SET @variantId = 350
WHILE (@variantId <= 371)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2013-06-11 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END
