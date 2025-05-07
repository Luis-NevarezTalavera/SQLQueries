-- Inserting new Test Plans in TesPlan table  New Starz streams
Use AssetLibrary
/*
Insert AlTestPlan Values ('MP4 H.264 1276x716 4.872M 2.0 AAC 128k High 4.1 2sGOP v380',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1276x716 3.397M 2.0 AAC 128k High 4.1 2sGOP v381',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 1276x716 2.357M 2.0 AAC 128k High 4.1 2sGOP v382',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 960x540 1.624M 2.0 AAC 128k Main 3.1 2sGOP v383',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 704x396 1.107M 2.0 AAC 128k Main 3.1 2sGOP v384',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 640x360 0.743M 2.0 AAC 128k Main 3.1 2sGOP v385',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 512x288 0.550M 2.0 AAC 128k Main 3.1 2sGOP v386',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 640x480 2.444M 2.0 AAC 128k High 4.1 2sGOP v387',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 640x480 1.684M 2.0 AAC 128k High 4.1 2sGOP v388',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 640x480 1.149M 2.0 AAC 128k Main 3.1 2sGOP v389',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 560x420 0.769M 2.0 AAC 128k Main 3.1 2sGOP v390',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('MP4 H.264 480x360 0.504M 2.0 AAC 128k Main 3.1 2sGOP v391',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('WV Tablet MP4 H.264 AAC 640x360 V0.8M A64k Baseline 3.0 2sGOP v392',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('WV Tablet MP4 H.264 AAC 640x480 V0.8M A64k Baseline 3.0 2sGOP v393',NULL,0,'2013-06-24 12:00:00.000','D3',NULL,NULL,1)
*/
DECLARE @variantId AS int
SET @variantId = 380
WHILE (@variantId <= 393)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2013-06-19 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END

-- select * from ALVariant
