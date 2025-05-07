Use OrderProcessing

SELECT
C.ProviderName, IM.ErrorMessage, dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) [CreatedDateTime], cast(I.DeluxeContentXml as varchar(max)) [Error],
I.TitleName, I.SourceName, IM.RecommendedAction, I.SourcePath, I.TargetPath, I.SourceXml, I.DeluxeContentXml, I.DeluxeAvailsXml, I.DeluxeAssetXml, I.TitleID,
I.TitleEditionID, I.AssetID, I.AssetName, ET.Description
FROM [OrderProcessing].[dbo].[IngestionLog] I WITH (NOLOCK)
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionLogMessage] IM WITH (NOLOCK) ON IM.IngestionLogID = I.IngestionLogID
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH (NOLOCK) ON C.ContentProviderID = I.ContentProviderID
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionErrorType] ET WITH (NOLOCK) ON ET.IngestionErrorTypeID = I.IngestionErrorTypeID
 where 
 dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) >= '11/03/2014'
 and IM.ErrorMessage > '' -- like '%has exceeded the allotted timeout of%'
-- I.SourceName like '%jumpingthe%'
order by IM.CreatedDateTime DESC
