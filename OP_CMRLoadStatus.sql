Use OrderProcessing
SELECT T.AssetName, C.* FROM [OrderProcessing].[dbo].[CMRLoadStatusLog] C
inner join Title T on C.AssetID = T.ALAssetId
-- WHERE AssetID in ('a1-45546','a1-45545','a1-45306','a1-44104')
Order by UpdatedDateTime desc
