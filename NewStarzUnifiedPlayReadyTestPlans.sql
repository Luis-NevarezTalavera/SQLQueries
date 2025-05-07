	-- Inserting new Test Plans in TesPlan table -- New Starz Unified PlayReady Variants --
Use AssetLibrary

	-- Insert Test Plans for New Starz Unified PlayReady Variants --
Insert AlTestPlan Values ('v1-418 MP4 H.264 16:9 1:1 1920x1080 5.000m High 4.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-419 MP4 H.264 16:9 1:1 1276x716 4.600m High 4.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-420 MP4 H.264 16:9 1:1 1276x716 2.951m High 4.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-421 MP4 H.264 16:9 1:1 1024x576 1.893m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-422 MP4 H.264 16:9 1:1 704x396 1.215m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-423 MP4 H.264 16:9 1:1 640x360 0.780m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-424 MP4 H.264 16:9 1:1 512x288 0.500m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-425 MP4 H.264 16:9 1:1 854x480 1.580m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)
Insert AlTestPlan Values ('v1-426 MP4 H.264 4:3 1:1 640x480 0.769m Main 3.1 2sGOP AAC 128k 2.0',NULL,0,'2014-04-10 12:00:00.000','D3',NULL,NULL,1)

	-- Inserting Mapping between ALVariant and ALTestPlan
DECLARE @variantId AS int
SET @variantId = 418
WHILE (@variantId <= 426)
BEGIN
	-- Inserting Mapping between ALVariant and ALTestPlan
	Insert ALVariantTestPlan Values (@variantId,( select TestPlanID from AlTestPlan where Name like '%v' + CONVERT(varchar(3),@variantId) ),'2014-04-10 12:00:00.000','D3')
	SET @variantId = @variantId + 1
END

/*
 Select V.VariantId, V.VariantName, Tp.* 
 From ALTestPlan TP Inner Join ALVariantTestPlan VT On TP.TestPlanId=VT.TestPlanId
					Inner Join ALVariant V on VT.VariantId=V.VariantId
Where V.VariantId in (418,419,420,421,422,423,424,425,426)

Update AlTestPlan Set Name ='v1-418 MP4 H.264 16x9 1x1 1920x1080 5.000m High 4.1 2sGOP AAC 128k 2.0' where Name like 'v1-418%'
Update AlTestPlan Set Name ='v1-419 MP4 H.264 16x9 1x1 1276x716 4.600m High 4.1 2sGOP AAC 128k 2.0'  where Name like 'v1-419%'
Update AlTestPlan Set Name ='v1-420 MP4 H.264 16x9 1x1 1276x716 2.951m High 4.1 2sGOP AAC 128k 2.0'  where Name like 'v1-420%'
Update AlTestPlan Set Name ='v1-421 MP4 H.264 16x9 1x1 1024x576 1.893m Main 3.1 2sGOP AAC 128k 2.0'  where Name like 'v1-421%'
Update AlTestPlan Set Name ='v1-422 MP4 H.264 16x9 1x1 704x396 1.215m Main 3.1 2sGOP AAC 128k 2.0'   where Name like 'v1-422%'
Update AlTestPlan Set Name ='v1-423 MP4 H.264 16x9 1x1 640x360 0.780m Main 3.1 2sGOP AAC 128k 2.0'   where Name like 'v1-423%'
Update AlTestPlan Set Name ='v1-424 MP4 H.264 16x9 1x1 512x288 0.500m Main 3.1 2sGOP AAC 128k 2.0'   where Name like 'v1-424%'
Update AlTestPlan Set Name ='v1-425 MP4 H.264 16x9 1x1 854x480 1.580m Main 3.1 2sGOP AAC 128k 2.0'   where Name like 'v1-425%'
Update AlTestPlan Set Name ='v1-426 MP4 H.264 4x3 1x1 640x480 0.769m Main 3.1 2sGOP AAC 128k 2.0'    where Name like 'v1-426%'
*/