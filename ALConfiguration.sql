-- Query to Obtain the Parent L1 streams for a specific assetId/L2 streamId, also with the corresponding ALConfiguration records
Use AssetLibrary
 SELECT	DISTINCT C.StreamLevel, SC.VariantID as L2VariantID, V2.VariantName as L2VariantName, SC.ConfigurationID, C.Name as L2Type, C.IsPackagable, SC.OrderNumber, SC.SourceVariantID as L1VariantID, V1.VariantName as L1VariantName, SC.BatonRequired -- S.AssetId, S.StreamId, S.StreamName, S.Status, 
-- SELECT	Distinct SC.SourceVariantID as L1VariantID, V1.VariantName as L1VariantName, SC.BatonRequired -- S.AssetId, S.StreamId, S.StreamName, S.Status, 
FROM	ALVariant V2	Left Outer Join ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
						Left Outer Join ALVariant V1 on V1.VariantID = SC.SourceVariantID
						Left Outer Join ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
Where    C.StreamLevel = 2
-- SC.ConfigurationID in (1,2,3,4,5,6,7,12,13,14,15,16,17) -- 15 = Sidecars (Thumbnails, Captions, etc)
-- and SC.VariantID   in (4400,4401,4402,4403,4404,4405) -- 
 and SC.SourceVariantID   in (484) --
-- and S.StreamName like 'QA_Smoke%'
-- and S.AssetID in (138260) -- ,152535)
-- and S.Status in ('Transcode Successful')
 order by C.StreamLevel, L2VariantID --, SC.OrderNumber -- L1VariantID, 
/*
select Distinct VariantId, ProfileNumber from ALStreamSourceConfiguration where SourceVariantID = 1 -- Order by VariantID, OrderNumber
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