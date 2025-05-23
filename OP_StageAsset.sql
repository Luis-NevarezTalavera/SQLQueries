/****** Script for SelectTopNRows command from SSMS  ******/
SELECT IM.ErrorMessage,
	case 
		when IM.ErrorMessage LIKE 'FileLists not found.%' or IM.ErrorMessage LIKE 'Could not find file%' then reverse(left(reverse(IM.ErrorMessage), charindex('\',reverse(IM.ErrorMessage), 1) - 1)) 
		else null
		end as [MissingFile],
	--cast(I.DeluxeContentXml as varchar(max)) [Error],
	I.TitleName, I.SourceName, I.SourcePath, I.TargetPath, I.SourceXml, I.DeluxeContentXml, --cast(I.DeluxeContentXml as varchar(max)),
	I.DeluxeAvailsXml, I.DeluxeAssetXml, I.TitleID, I.TitleEditionID, I.AssetID, I.AssetName, ET.Description,
	dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) [CreatedDateTime]
FROM [OrderProcessing].[dbo].[IngestionLog] I WITH(NOLOCK)
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionLogMessage] IM WITH(NOLOCK) ON IM.IngestionLogID = I.IngestionLogID
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = I.ContentProviderID
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionErrorType] ET WITH(NOLOCK) ON ET.IngestionErrorTypeID = I.IngestionErrorTypeID
-- WHERE I.SourceName = '711117_wildthingsii_version_1_0.xml'
where dateadd(hour, datediff(hour, getutcdate(), getdate()), IM.CreatedDateTime) >= '3/5/2013'
order by I.CreatedDateTime desc

--Could not find file '\\la1ppnassvr001.d3nw.net\ContentServer\AL\Content\TFA\_STARZ\promo\starz\85_111554_S_FEAT_1280x350.jpg'.

/*
truncate table [OrderProcessing].[dbo].[IngestionLog]
*/

SELECT TOP (100) C.ProviderName, E.WorkflowInstanceID, E.SourceName, E.Message, dateadd(hour, datediff(hour, getutcdate(), getdate()), E.CreatedDateTime) [CreatedDateTime]
FROM [OrderProcessing].[dbo].[IngestionEvent] E with(nolock)
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = E.ContentProviderID
-- where E.SourceName = '711117_wildthingsii_version_1_1.xml'
order by e.CreatedDateTime desc

/*
truncate table [OrderProcessing].[dbo].[IngestionEvent]
*/
