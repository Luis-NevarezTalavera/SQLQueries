-- Inserting new Test Plans in TesPlan table  Samsung variants
Use AssetLibrary
Insert AlTestPlan Values ('M2TS MPEG2 1920x1080 V15.00M AC3 A128k High 4.0 1sGOP v330',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1920x1080 V4.00M AAC A128k Baseline 4.0 2sGOP v331',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1280x720 V4.00M AAC A128k Main 4.0 2sGOP v332',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1280x720 V2.50M AAC A128k Baseline 3.1 2sGOP v333',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1280x720 V2.50M AAC A128k Main 4.0 2sGOP v334',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1280x720 V0.750M AAC A128k Main 4.0 1sGOP v335',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 800x448 V1.80M AAC A128k Main 3.1 2sGOP v336',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 800x448 V1.20M AAC A128k Main 3.1 2sGOP v337',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('3GP H.264 800x448 V0.750M AAC A128k Main 3.1 2sGOP v338',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 800x448 V0.750M AAC A128k Main 3.1 1sGOP v339',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('M2TS H.264 720x480 V15.00M AC3 A128k High 4.0 1sGOP v340',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('M2TS H.264 1280x720 V10.00M AC3 A128k High 4.0 1sGOP v341',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 800x448 V1.20M AAC A128k Main 3.1 2sGOP v342',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 800x448 V0.750M AAC A128k Main 3.1 2sGOP v343',NULL,0,'2013-06-19 12:00:00.000','D3',NULL,NULL,1)

DECLARE @variantId AS int
SET @variantId = 330
WHILE (@variantId <= 343)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2013-06-19 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END
