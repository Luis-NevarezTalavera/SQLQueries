Use AssetLibrary
SELECT      ALStream_2.AssetID, ALStream_2.StreamID as L2StreamID, ALStream_2.VariantID as L2VariantId, ALStream_2.StreamName as L2StreamName, C2.ConfigurationID, C2.Name as L2Type, LE2.LookupValue as L2StState,  -- ALStream_2.ContainerTypeID, ALStream_2.EncryptionTypeID, 
            ALStream_1.StreamID AS L1StreamId, ALStream_1.VariantID AS L1VariantId, SC.OrderNumber as L1OrderNumber, SC.BatonRequired, ALStream_1.StreamName AS L1StreamName, ALStream_1.FileUriPath --, C1.ConfigurationID, C1.Name as L1Type
FROM        ALStream AS ALStream_2	Left Outer Join		ALStreamSourceConfiguration SC	ON	ALStream_2.VariantID = SC.VariantID
									Left Outer Join		ALConfiguration C2 on SC.ConfigurationID = C2.ConfigurationID
									Left Outer Join		LookupEnum LE2 ON ALStream_2.StreamStateTypeID = LE2.LookupID 
									Left Outer Join		ALStream AS ALStream_1	ON SC.SourceVariantID = ALStream_1.VariantID  AND ALStream_1.AssetID = ALStream_2.AssetID
									Left Outer Join		LookupEnum LE1 ON ALStream_1.StreamStateTypeID = LE1.LookupID 
									-- Left Outer Join		ALConfiguration C1 on SC.SourceConfigurationID = C1.ConfigurationID
Where ALStream_2.IsDeleted = 0
 and ALStream_2.AssetID  in (177822) 
-- and SC.ConfigurationID in (6,7,12,13,14,15,16,17)
 and C2.StreamLevel = 2
-- and ALStream_2.StreamName LIKE '%Handset%'
-- and ALStream_2.StreamID in (2866345) 
 and ALStream_2.VariantID  in (270)
-- and ALStream_2.EncryptionTypeId in (365) --(547, 
-- and ALStream_2.Status = 'Encryption failed with error processingFailed: ENC_ERR:Sync Frame Too Far Error' and ALStream_2.StreamName like '% TRL %'
 and ALStream_1.StreamName not like '%v1-117 - Subtitle -%'
-- and C1.ConfigurationID<>5
-- and ALStream_1.VariantID in (208,246)
Order by ALStream_2.VariantID, OrderNumber  -- ALStream_1.StreamID, ALStream_1.VariantID, 

/*
select top 100 * from ALStreamSourceConfiguration
select * from ALConfiguration
1	Source
2	Transcode
3	Key Disc, AACS
4	Key Disc, Clear
5	Widevine Transcode
6	Widevine
7	Playready
8	Art Reference: Cover Art
9	Art Reference: Image
10	L1s Only
11	Closed Caption Transform
12	Null Package, Clear
13	DCD Package, Clear
14	Thumbnails
15	Sidecar
16	Unified Streaming
*/