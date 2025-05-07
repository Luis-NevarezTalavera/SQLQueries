-- Query For ErrorLogging for the Auto IngestWorkFlow
SELECT  top (1000) * -- C.ProviderName, I.ErrorMessage,  I.TitleName, I.SourceName, I.SourcePath, I.TargetPath, I.SourceXml, I.DeluxeContentXml, I.DeluxeAvailsXml, I.DeluxeAssetXml, I.TitleID, I.TitleEditionID, I.AssetID, I.AssetName, ET.Description, I.CreatedDateTime  --IM.ErrorMessage, --IM.RecommendedAction,
 FROM [OrderProcessing].[dbo].[IngestionLog] I WITH(NOLOCK)
--LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionLogMessage] IM WITH(NOLOCK) ON IM.IngestionLogID = I.IngestionLogID
INNER JOIN [OrderProcessing].[dbo].[ContentProvider] C WITH(NOLOCK) ON C.ContentProviderID = I.ContentProviderID
LEFT OUTER JOIN [OrderProcessing].[dbo].[IngestionErrorType] ET WITH(NOLOCK) ON ET.IngestionErrorTypeID = I.IngestionErrorTypeID
--WHERE I.ErrorMessage not like 'test_CreateL0Stream failed:%' --113,  8
--WHERE I.ErrorMessage like 'FileLists not found.%' --70
--WHERE I.ErrorMessage like '%Customer does not have rights to this content%' --122
--WHERE I.ErrorMessage like '%Transform failed%' --34
--WHERE I.ErrorMessage like 'Source file%does not exist%' --3
--WHERE I.ErrorMessage like 'File is locked%' --2, 2
--WHERE I.ErrorMessage like 'FileCopy failed%' --2, 2
--WHERE I.ErrorMessage like '%Could not find a part of the path%' --0, 296
--WHERE I.SourceName = '631926_badboys_version_1_0.xml'
--Where I.SourcePath like '\\La1rvconsvr001\qa2\ContentServer\%'
Order by IngestionLogID desc