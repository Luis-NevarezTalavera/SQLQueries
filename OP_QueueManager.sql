/*
select top (100) JR.InstanceID, JR.JobID, JR.TitleID, JRL.Request AS [JobState], JPL.Priority AS [JobPriority], JTL.Type AS [JobType], JR.SubmitDateTime, JR.WFInstanceID, JR.Source, JR.AssignedToUserID, JR.CustomRequest, JR.SubmitDateTime
FROM [QueueManager].dbo.JobRequest JR WITH(NOLOCK)
LEFT OUTER JOIN [QueueManager].dbo.JobRequestLookup JRL WITH(NOLOCK) ON JRL.JobRequestID = JR.JobRequestID
LEFT OUTER JOIN [QueueManager].dbo.JobPriorityLookup JPL WITH(NOLOCK) ON JPL.JobPriorityID = JR.JobPriorityID
LEFT OUTER JOIN [QueueManager].dbo.JobTypeLookup JTL WITH(NOLOCK) ON JTL.JobTypeID = JR.JobTypeID
--LEFT OUTER JOIN [OrderProcessing].dbo.Title T WITH(NOLOCK) ON T.TitleId = JR.TitleID 
--LEFT OUTER JOIN [OrderProcessing].dbo.MasterTitle MT WITH(NOLOCK) ON MT.MasterTitleId = T.MasterTitleId 
order by JR.JobPriorityID asc, JR.SubmitDateTime asc
*/
/*
select  J.InstanceID, J.JobID, J.TitleID, T.ALAssetId, A.AssetName, MT.MovieTitle, JSL.State AS [JobState], J.JobTypeID, JPL.Priority AS [JobPriority], JTL.Type AS [JobType],
	case 
		when JTL.Type = 'Ingestion Workflow' then reverse(left(reverse(J.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)')), charindex('\', reverse(J.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)'))) -1))
		else null 
		end as IngestionSourceFile,
	J.SubmitDateTime, J.WFInstanceID, I.Id, I.IsSuspended, J.AssignedToUserID, J.CustomRequest, J.Source
FROM [QueueManager].dbo.Job J WITH(NOLOCK)
LEFT OUTER JOIN [QueueManager].dbo.JobStateLookup JSL WITH(NOLOCK) ON JSL.JobStateID = J.JobStateID
LEFT OUTER JOIN [QueueManager].dbo.JobPriorityLookup JPL WITH(NOLOCK) ON JPL.JobPriorityID = J.JobPriorityID
LEFT OUTER JOIN [QueueManager].dbo.JobTypeLookup JTL WITH(NOLOCK) ON JTL.JobTypeID = J.JobTypeID
LEFT OUTER JOIN [OP_Persistence].[System.Activities.DurableInstancing].[InstancesTable] I WITH(NOLOCK) ON I.Id = J.WFInstanceID
LEFT OUTER JOIN [OrderProcessing].dbo.Title T WITH(NOLOCK) ON T.TitleId = J.TitleID 
LEFT OUTER JOIN [OrderProcessing].dbo.MasterTitle MT WITH(NOLOCK) ON MT.MasterTitleId = T.MasterTitleId 
LEFT OUTER JOIN [AssetLibrary].[dbo].[ALAsset] A WITH(NOLOCK) ON 'a1-' + CAST(A.AssetId AS VARCHAR(10)) = T.ALAssetId
Where J.SubmitDateTime >= '06/01/2019'
-- and JPL.Priority = 'High'
 and JTL.Type  in ('Baton Qc Workflow') -- 'Ingestion Workflow','CDN Push','Create Order Workflow','Null Packager Workflow','Ingest Art Workflow', 'Convert To EMA Workflow','Closed Caption','Archive') -- 
order by JTL.Type ASC, JSL.State DESC 
*/
-- delete [QueueManager].dbo.Job where JobTypeID=15 and SubmitDateTime >= '2015-03-26 00:38:09.033'

select 
 JTL.Type, JSL.State, JPL.Priority, count(JH.JobID) as JobsQty
/*
JH.JobHistoryID, JH.JobID, JH.TitleID, CustomRequest.value('(/BatonQcRequest/AssetID)[1]','varchar(100)') as AssetID, CustomRequest.value('(/BatonQcRequest/VariantID)[1]','varchar(100)') as VariantID, 
	case 
		when JTL.Type = 'Ingestion Workflow' then reverse(left(reverse(JH.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)')), charindex('\', reverse(JH.CustomRequest.value('(/IngestionRequest/SourceFileUriPathList/string/node())[1]', 'varchar(max)'))) -1))
		else null 
	end as IngestionSourceFile,
	JSL.State AS [JobState], JPL.Priority AS [JobPriority], JTL.Type AS [JobType], JH.AssignedToUserID, JH.WFInstanceID, JH.CustomRequest, JH.Source, JH.SubmitDateTime, JH.CreateDateTime 
*/
FROM [QueueManager].dbo.JobHistory JH WITH(NOLOCK)
LEFT OUTER JOIN [QueueManager].dbo.JobStateLookup JSL WITH(NOLOCK) ON JSL.JobStateID = JH.JobStateID
LEFT OUTER JOIN [QueueManager].dbo.JobPriorityLookup JPL WITH(NOLOCK) ON JPL.JobPriorityID = JH.JobPriorityID
LEFT OUTER JOIN [QueueManager].dbo.JobTypeLookup JTL WITH(NOLOCK) ON JTL.JobTypeID = JH.JobTypeID
--LEFT OUTER JOIN [OrderProcessing].dbo.Title T WITH(NOLOCK) ON T.TitleId = JH.TitleID 
--LEFT OUTER JOIN [OrderProcessing].dbo.MasterTitle MT WITH(NOLOCK) ON MT.MasterTitleId = T.MasterTitleId 
--where JH.TitleID IN (10646, 10733, 10794, 10835)
-- where JSL.State = 'Completed' 
Where JH.CreateDateTime >= '06/01/2019'
-- and JPL.Priority = 'High'
 and JTL.Type  in ('Baton Qc Workflow') -- 'Ingestion Workflow','CDN Push','Create Order Workflow','Null Packager Workflow','Ingest Art Workflow', 'Convert To EMA Workflow','Closed Caption','Archive') -- 
 and JSL.State not in ('Completed') -- 'Queued', 'Running'
-- and JH.WFInstanceID != '00000000-0000-0000-0000-000000000000' -- apparently after moving to Running, the Queued jobs are assigned to '000-000-000' WF InstanceId
-- and ( CustomRequest.value('(/BatonQcRequest/AssetID)[1]','varchar(100)') = 'a1-596186' ) 
-- and ( CustomRequest.value('(/BatonQcRequest/VariantID)[1]','varchar(100)') = '444' ) 
group by JTL.Type, JSL.State, JPL.Priority
order by JTL.Type, JSL.State, JPL.Priority
-- order by JH.JobHistoryID, JTL.Type, JSL.State

/*
select * from job
select * from jobhistory
select * from jobtypelookup
select * from jobstatelookup
select * from jobprioritylookup

delete from job where jobstateid = 4
delete from jobrequest where InstanceID >= 3266

--delete from job where jobstateid = 1 and jobtypeid = 7

 -- If this is not cleared IsInWorkflow check will return a true
 select * from [OrderProcessing].[dbo].[Title] where [IsQueuedForTranscoding] = 1
 
 UPDATE [OrderProcessing].[dbo].[Title]
 SET [WorkflowInstanceId] = null ,[IsQueuedForTranscoding] = 0
 WHERE [IsQueuedForTranscoding] = 1


truncate table JobRequest
truncate table Job
truncate table JobHistory
*/
