-- Inserting new Test Plans in TesPlan table -- New Charter Variants --
Use AssetLibrary
-- Change Test Plan name for v1-378 since this variant was re-defined
update AlTestPlan set name='MP4 H.264 960x540 2.400M 2.0 AAC 128k Main 4.0 2sGOP v378' where Name='TS H.264 960x540 3.000M 2.0 AAC 128k Main 3.1 2sGOP v378'  
-- Insert Test Plans for New Charter Variants
Insert AlTestPlan Values ('TS H.264 1920x1080 V6.000M AAC 2.0 A128k Main 4.1 2sGOP v405',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V4.250M AAC 2.0 A128k Main 4.1 2sGOP v406',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 1280x720 V3.500M AAC 2.0 A128k Main 4.1 2sGOP v407',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 864x486 V2.000M AAC 2.0 A128k Main 3.1 2sGOP v408',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x360 V1.500M AAC 2.0 A64k Main 3.1 1sGOP v409',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x360 V1.000M AAC 2.0 A64k Main 3.1 1sGOP v410',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x360 V0.800M AAC 2.0 A64k Main 3.1 1sGOP v411',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x360 V0.600M AAC 2.0 A64k Main 3.1 1sGOP v412',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x480 V1.500M AAC 2.0 A64k Main 3.1 2sGOP v413',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x480 V1.000M AAC 2.0 A64k Main 3.1 2sGOP v414',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x480 V0.800M AAC 2.0 A64k Main 3.1 2sGOP v415',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS H.264 640x480 V0.600M AAC 2.0 A64k Main 3.1 2sGOP v416',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('TS AAC 2.0 A64k v417',NULL,0,'2013-11-20 12:00:00.000','D3',NULL,NULL,1)

DECLARE @variantId AS int
SET @variantId = 405
WHILE (@variantId <= 417)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2013-11-20 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END

-- Select * from ALTestPlan
-- Select * from ALVariantTestPlan