Use OrderProcessing
SELECT top 500 C.ProviderName, E.WorkflowInstanceID, E.SourceName,  E.Message,
    dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) [CreatedDateTime] ,E.IngestionLogEventID
FROM [OrderProcessing].[dbo].[IngestionEvent] E with(nolock)
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = E.ContentProviderID
WHERE 
  dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) >= '02/12/2014'  and 
  Message not like '%file not found%'  and
SourceName like '%Promotion-SIPH_version_201404080601%' and 
providerName in ( 'Starz') 
order by e.CreatedDateTime desc

SELECT top 1000 C.ProviderName, IM.ErrorMessage, dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) [CreatedDateTime], --cast(I.DeluxeContentXml as varchar(max)) [Error],
 I.TitleName, I.SourceName, IM.RecommendedAction, I.SourcePath, I.TargetPath, I.SourceXml, I.DeluxeContentXml, I.DeluxeAvailsXml, I.DeluxeAssetXml, I.TitleID,  I.TitleEditionID, I.AssetID, I.AssetName, ET.Description
FROM [OrderProcessing].[dbo].[IngestionLog] I WITH(NOLOCK)
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionLogMessage] IM WITH(NOLOCK) ON IM.IngestionLogID = I.IngestionLogID
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = I.ContentProviderID
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionErrorType] ET WITH(NOLOCK) ON ET.IngestionErrorTypeID = I.IngestionErrorTypeID
where 
dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) >= '02/12/2014' and
 IM.ErrorMessage not like '%=Could not find%' and IM.ErrorMessage not like 'FileLists not found.  File not found:%'  and  --- Image files not in Incomming or Destination folders
--and TitleName like '%ep 128%'
 I.SourceName like '%Promotion-SIPH_version_201404080601%' and 
C.ProviderName like 'Starz'
order by IM.CreatedDateTime DESC
