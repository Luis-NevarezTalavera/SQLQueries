Use TranscodeManager -- TestApp
-- Select SIP.ServerIp, J.AssetId, J.JobPriorityId, Count(SIP.ServerIp) as AssignedStreams -- , 
 Select	 -- DISTINCT	-- J.JobId, 
				ROW_NUMBER() OVER(PARTITION BY J.AssetId ORDER BY J.ProfileNumber ASC) AS Row#, J.AssetId, J.StreamId,  Case When (ROW_NUMBER() OVER(PARTITION BY J.AssetId ORDER BY J.ProfileNumber ASC)) = 1 Then J.XmlData Else '' End as TravellerDescriptor, J.CreatedTime, -- J.JobResult, JS1.Name as JobStatus, JS2.Name as JobState, -- SIP.ServerIp, SIP.MaxTranscodes, 
				'<Configure' as Configure,'Path="'+J.XmlData.value('(ContentTraveller/Configure/@Path)[1]', 'nvarchar(200)')+'"' as Path, 'ProfileNumber="'+J.XmlData.value('(ContentTraveller/Configure/@ProfileNumber)[1]', 'nvarchar(200)')+'"' as ProfileNumber, 
				'ForceTwoPass="'+J.XmlData.value('(ContentTraveller/Configure/@ForceTwoPass)[1]', 'varchar(200)')+'"'+' BurnIn="false"' as ForceTwoPass_BurnIn, 'ALStreamId="'+J.XmlData.value('(ContentTraveller/Configure/@ALStreamId)[1]', 'varchar(200)')+'"' as ALStreamId, ' />' as closing
				-- , JH.Message as HistoryMessage -- , S.Message, AT.Name as AssetType, 
FROM Job J  WITH (NOLOCK)	Left Outer Join Server SIP		On J.ServerId 		= SIP.ServerId
			 Left Outer Join JobStatus JS1	On J.JobStatusId 	= JS1.JobStatusId
			 Left Outer Join JobState  JS2	On J.JobStateId  	= JS2.JobStateId
			-- Left Outer Join Source S			On J.SourceId 		= S.SourceId
			-- Left Outer Join AssetType AT		On J.AssetTypeId 	= AT.AssetTypeId
			-- Left Outer Join JobHistory JH 	On J.JobId	= JH.JobId
Where J.IsDeleted in (0) 
-- and  'a1-' + CONVERT(varchar(10), j.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  (MasterTitle.MovieTitle like 'QA_FF%')  ) -- and Title.IsQueuedForTranscoding = 0  and Title.TitleStateId in ('14','18') ) 
-- and  j.AssetID   in (2137126) -- 
-- and  j.StreamId in (15568680)
-- and J.ProfileNumber in (1006) -- 514, 518, 526, 528, 529, 671, 673, 693) 
-- and J.Message not in ('Job is preprocessed','Job is preprocessed already','Job is transcoding','Job is completed') --  like 'Job is canceled by 192%'
 and JS1.Name   in ('Failed') --'Processing','Transcode','AlUpdate') --,'Succeeded','Canceled'
-- and J.JobStatusId=6 -- Error like '%File not found%'
-- and ServerIp = '192.168.98.47'
 and J.CreatedTime >= '2017-03-31 00:00:00.000'
-- Order by J.AssetId, J.StreamId --, SIP.ServerIp -- J.CreatedTime desc

/*
 -- TJM Statitics  -- 
Use TranscodeManager 
Select  Count(J.Message) as JobCount, Substring(J.Message,PATINDEX('%ProgramError%',J.Message),225) as Message, JS1.Name as JobStatus, JS2.Name as JobState, Min(J.AssetId) as MinAssetId, Max(J.AssetId) as MaxAssetId, 
		Min(SIP.ServerIp) as MinServerIP, Max(SIP.ServerIp) as MaxServerIP, MIN(J.CreatedTime) as First, MAX(J.CreatedTime) as Last
From	Job J WITH (NOLOCK) Left Outer Join Server SIP		On J.ServerId 		= SIP.ServerId
							Left Outer Join JobStatus JS1	On J.JobStatusId 	= JS1.JobStatusId
							Left Outer Join JobState  JS2	On J.JobStateId  	= JS2.JobStateId
Where J.IsDeleted in (0)
-- and  J.ProfileNumber = 432
-- and  J.Message not in ('Job is preprocessed','Job is preprocessed already','Job is transcoding','Job is completed','Canceled','Succeeded','Failed') -- like 'Job is canceled by 192%'
 and JS1.Name   in ( 'Failed') --'Canceled') --,'Processing','Transcode','AlUpdate') --,'Succeeded',
-- and j.Message not like 'Job is set to server%' -- '%canceled%'
-- and J.JobStatusId=6 -- Errorlike '%File not found%'
-- and ServerIp = '192.168.98.47'
 and J.CreatedTime >= '2017-03-30 07:00:00.0000000' -- -08:00'
 Group by Substring(J.Message,PATINDEX('%ProgramError%',J.Message),225), JS1.Name, JS2.Name
 Order by Count(J.Message) desc, Substring(J.Message,PATINDEX('%ProgramError%',J.Message),225), JS1.Name, JS2.Name
*/
-- select * from ServerHistory 
-- where serverid=86 and UpdatedTime between '2017-01-06 16:54:01.0599919 -08:00' and '2017-01-8 09:33:16.3912536 -08:00' 
-- order by ServerHistoryId desc

-- Select * from Server
-- Select * from JobStatus
-- Select * from JobState
-- Select * from JobSubstate
-- delete from Job
-- delete from JobHistory
