SELECT Top 500 dateadd(hour, datediff(hour, getutcdate(), getdate()), L.UpdatedDateTime) [UpdatedDateTime], ST.Description [SectionType], L.*
  FROM [OrderProcessing].[dbo].[EMAConversionStatusLog] L
  INNER JOIN [OrderProcessing].[dbo].[EMAConversionSectionType] ST WITH(NOLOCK) ON ST.SectionTypeID = L.MetadataSectionTypeID
  where FileUriPath like '%Promotion-SIPH_version_201401300600%'

SELECT DISTINCT  ST.Description [SectionType], L.AssetID, L.IsValidSchema, L.IsValidAssetID, L.Imported, L.ErrorMessage, CAST(L.EMAXML AS Varchar(MAX)),
 dateadd(hour, datediff(hour, getutcdate(), getdate()), L.UpdatedDateTime) [UpdatedDateTime],
 dateadd(hour, datediff(hour, getutcdate(), getdate()), L.CreatedDateTime) [CreatedDateTime]
 --CAST (L.EMAXML as varchar(max)) EMAXML
  FROM [OrderProcessing].[dbo].[CMRLoadStatusLog] L
  INNER JOIN [OrderProcessing].[dbo].[EMAConversionSectionType] ST WITH(NOLOCK) ON ST.SectionTypeID = L.MetadataSectionTypeID
  INNER JOIN [OrderProcessing].[dbo].[EMAConversionStatusLog] ESL ON ESL.AssetID = L.AssetID
  where ESL.FileUriPath like '%Promotion-SIPH_version_201401300600%'
  --where AssetID = 'a1-26445'
  order by L.AssetID
  
  