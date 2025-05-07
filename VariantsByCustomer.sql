-- Query to Obtain the Parent L1 streams for a specific assetId/L2 streamId, also with the corresponding ALConfiguration records
Use AssetLibrary
SELECT	DISTINCT  SC.VariantID, V2.VariantName, V2.Description, 'L2' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
FROM	ALVariant V2	Left Outer Join ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
						Left Outer Join ALVariant V1 on V1.VariantID = SC.SourceVariantID
						Left Outer Join ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
						LEFT OUTER JOIN CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
						LEFT OUTER JOIN CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID
						LEFT OUTER JOIN QATest..CustomerPriority CP ON CV.CustomerID = CP.CustomerID
Where	C.StreamLevel = 2
-- SC.ConfigurationID in (1,2,3,4,5,6,7,12,13,14,15,16,17) -- 15 = Sidecars (Thumbnails, Captions, etc)
 and SC.VariantID  >= 26
-- and SC.SourceVariantID   in ( 496,497,498,499,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529 )
-- and S.StreamName like 'QA_Smoke%'
-- and S.AssetID in (138260) -- ,152535)
-- and S.Status in ('Transcode Successful')
-- and Cu.IsDeleted=0 and CV.IsDeleted=0
 and Cu.CustomerId Is Not Null
UNION 
SELECT	DISTINCT  SC.SourceVariantID as VariantID, V1.VariantName, V1.Description, 'L1' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
-- SELECT	Distinct SC.SourceVariantID as L1VariantID, V1.VariantName as L1VariantName, SC.BatonRequired -- S.AssetId, S.StreamId, S.StreamName, S.Status, 
FROM	ALVariant V2	Left Outer Join ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
						Left Outer Join ALVariant V1 on V1.VariantID = SC.SourceVariantID
						Left Outer Join ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
						LEFT OUTER JOIN CPI..CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
						LEFT OUTER JOIN CPI..Customer Cu ON CV.CustomerID = Cu.CustomerID
						LEFT OUTER JOIN QATest..CustomerPriority CP ON CV.CustomerID = CP.CustomerID
Where	C.StreamLevel = 2
-- SC.ConfigurationID in (1,2,3,4,5,6,7,12,13,14,15,16,17) -- 15 = Sidecars (Thumbnails, Captions, etc)
 and SC.VariantID  >= 26
-- and SC.SourceVariantID   in ( 496,497,498,499,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529 )
-- and S.StreamName like 'QA_Smoke%'
-- and S.AssetID in (138260) -- ,152535)
-- and S.Status in ('Transcode Successful')
-- and Cu.IsDeleted=0 and CV.IsDeleted=0
 and Cu.CustomerId Is Not Null
Order by VariantID, CP.Weight desc, CustomerID --, SC.OrderNumber -- 