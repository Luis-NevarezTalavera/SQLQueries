Use OrderProcessing
SELECT top (100) JobTbl.[InstanceID], JobTbl.[JobID], JobTbl.[TitleID], Title.AssetName, ALAsType.[LookupValue] as AssetType,
CASE  WHEN JobType.Type = 'Ingestion Workflow' then reverse(left(reverse(JobTbl.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)')), charindex('\', reverse(JobTbl.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)'))) -1))
  else null end as IngestionSourceFile, TITLE.ALAssetId ,JobPriority.Priority ,JobType.Type ,JobState.State ,JobTbl.[JobPriorityID] ,JobTbl.JobTypeID ,JobTbl.[JobStateID],[WFInstanceID],
  [Source] ,JobTbl.[AssignedToUserID],[SubmitDateTime],JobTbl.[CreatedDateTime],TITLE.TravellerXml,TITLE.TranscoderConfig
 FROM [QueueManager].[dbo].[Job] as JobTbl WITH(NOLOCK) LEFT JOIN  [OrderProcessing].[dbo].[Title] AS TITLE WITH(NOLOCK)  ON  JobTbl.TitleID=TITLE.TitleId
														INNER JOIN [QueueManager].[dbo].[JobTypeLookup] as JobType WITH(NOLOCK)  ON  JobTbl.JobTypeID=JobType.JobTypeID
														INNER JOIN [QueueManager].[dbo].[JobStateLookup] as JobState  WITH(NOLOCK)  ON  JobTbl.JobStateID=JobState.JobStateID
														INNER JOIN [QueueManager].[dbo].[JobPriorityLookup] as JobPriority  WITH(NOLOCK)  ON  JobTbl.JobPriorityID=JobPriority.JobPriorityID
														LEFT JOIN  [AssetLibrary].[dbo].[ALAsset] AS ASSET WITH(NOLOCK)  ON  [TITLE].ALAssetId = 'a1-' + Convert(VarChar(50),Asset.AssetID)
														LEFT JOIN  [AssetLibrary].[dbo].[ALAssetTypeLookup] as ALAsType  WITH(NOLOCK)  ON ASSET.[AssetTypeID]=ALAsType.[LookupID]
--where ALAsType.[LookupValue]= 'ArtReference'
--where JobTbl.JobTypeID=7
--and JobTbl.JobStateID=2
--where JobTbl.JobTypeID<>2 
--where JobTbl.JobPriorityID=-1
--where Title.AssetName like '%Curious%'
--and JobTbl.[TitleID]=1279
/*
 where JobTypeID=5 
 and Title.AssetName like '%(Epix)%'*/
 --WHERE JobTbl.JobTypeID=2
 order by JobTypeID asc, JobPriorityID asc, SubmitDateTime