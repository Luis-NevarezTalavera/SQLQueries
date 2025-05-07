-- Query to Obtain the Parent L1 streams for a specific assetId/L2 streamId, also with the corresponding ALConfiguration records
Use AssetLibrary
-- SELECT	DISTINCT C.StreamLevel, SC.VariantID as L2VariantID, V2.VariantName as L2VariantName, SC.ConfigurationID, C.Name as L2Type, C.IsPackagable, SC.OrderNumber, SC.SourceVariantID as L1VariantID, V1.VariantName as L1VariantName, SC.BatonRequired, CustomerID, CustomerName 
SELECT	Distinct SC.SourceVariantID as VariantID, V1.Description, V1.VariantName, CustomerID, CustomerName 
FROM	ALVariant V2	Left Outer Join ALStreamSourceConfiguration SC ON V2.VariantID = SC.VariantID 
						Left Outer Join ALVariant V1 ON V1.VariantID = SC.SourceVariantID
						Left Outer Join ALConfiguration C ON SC.ConfigurationID = C.ConfigurationID
						Left Outer Join (Select Distinct CONVERT(int,(SUBSTRING(CV.VariantID,4,4))) AS VariantID, CV.CustomerID, C.CustomerName 
											From  CPI.dbo.CustomerVariant CV LEFT OUTER JOIN CPI.dbo.Customer C	WITH (NOLOCK) ON CV.CustomerID 	= C.CustomerID
											Where C.CustomerID is not Null) CV2 ON V2.VariantID = CV2.VariantID
Where    C.StreamLevel = 2
-- and SC.ConfigurationID in (1,2,3,4,5,6,7,12,13,14,15,16,17) -- 15 = Sidecars (Thumbnails, Captions, etc)
-- and SC.VariantID   in (4400,4401,4402,4403,4404,4405) -- 
-- and SC.SourceVariantID   in (410,411) --
 and CustomerId is not Null
-- Order by C.StreamLevel, L2VariantID --, SC.OrderNumber -- L1VariantID, 
 Order by SC.SourceVariantID, V1.Description, V1.VariantName, CustomerID, CustomerName
-- select * from ALVariant
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