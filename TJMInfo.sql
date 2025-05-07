Use TranscodeManager -- TestApp

-- Select SIP.ServerIp, J.AssetId, J.JobPriorityId, Count(SIP.ServerIp) as AssignedStreams -- , 
 Select	--  DISTINCT	
				J.JobId, J.AssetId, J.StreamId,  J.XmlData as TravellerDescriptor, J.Message, J.JobResult, JS1.Name as JobStatus, JS2.Name as JobState, SIP.ServerIp, SIP.MaxTranscodes 
				, '<Configure' as Configure,'Path="'+J.XmlData.value('(ContentTraveller/Configure/@Path)[1]', 'nvarchar(200)')+'"' as Path, 'ProfileNumber="'+J.XmlData.value('(ContentTraveller/Configure/@ProfileNumber)[1]', 'nvarchar(200)')+'"' as ProfileNumber 
				, 'ForceTwoPass="'+J.XmlData.value('(ContentTraveller/Configure/@ForceTwoPass)[1]', 'varchar(200)')+'"'+' BurnIn="false"' as ForceTwoPass_BurnIn, 'ALStreamId="'+J.XmlData.value('(ContentTraveller/Configure/@ALStreamId)[1]', 'varchar(200)')+'"' as ALStreamId, ' />' as closing
				 , JH.* --as HistoryMessage
FROM Job J  WITH (NOLOCK) 
			 Left Outer Join Server SIP		On J.ServerId 		= SIP.ServerId
			 Left Outer Join JobStatus JS1	On J.JobStatusId 	= JS1.JobStatusId
			 Left Outer Join JobState  JS2	On J.JobStateId  	= JS2.JobStateId
			 Left Outer Join Source S		On J.SourceId 		= S.SourceId
			 Left Outer Join AssetType AT	On J.AssetTypeId 	= AT.AssetTypeId
			 Left Outer Join JobHistory JH 	On J.JobId	= JH.JobId
Where J.IsDeleted in (0)
 and  J.AssetID   in (2260861,2261490,2262295) --,
 and  j.StreamId  in (18471986,18517354,18537042)
-- and  J.ProfileNumber in (709)
-- and J.Message not in ('Job is preprocessed','Job is preprocessed already','Job is transcoding','Job is completed') --  like 'Job is canceled by 192%' -- like '%Error 7 in CreateAudioDecoder%' -- 
-- and JH.Message not like 'Job is transcoding%'
-- and JS1.Name   in ('Failed','Canceled') --'Processing','Transcode','AlUpdate') --,'Succeeded',
-- and J.JobStatusId=6 -- Error like '%File not found%'
-- and ServerIp = '192.168.98.47'
-- and JH.CreatedTime >= '2016-12-10 00:00:00.0000000 -08:00'
 Order by J.AssetId, J.StreamId, J.JobId --, JH.JobHistoryId --, SIP.ServerIp -- J.CreatedTime desc

/*
 -- TJM Statitics  -- 
Use TranscodeManager -- TestApp
Select  Count(J.Message) as Count, Case  When CHARINDEX('OutputPath=',J.Message)>1 THEN SUBSTRING(J.Message,CHARINDEX('StatusString=',J.Message),9000) ELSE J.Message END as Message, JS1.Name as JobStatus, JS2.Name as JobState, JSS.Name as JobSubState, Min(J.AssetId) as FirstAssetId, Max(J.AssetId) as LastAssetId, 
		Min(SIP.ServerIp) as FirstServerIP, Max(SIP.ServerIp) as LastServerIP, MIN(J.CreatedTime) as FirstDateTime, MAX(J.CreatedTime) as LastDateTime
From	Job J WITH (NOLOCK) Left Outer Join Server SIP		On J.ServerId 		= SIP.ServerId
							Left Outer Join JobStatus JS1	On J.JobStatusId 	= JS1.JobStatusId
							Left Outer Join JobState  JS2	On J.JobStateId  	= JS2.JobStateId
							Left Outer Join JobSubState JSS	On J.JobSubstateId  = JSS.JobSubstateId
Where J.IsDeleted in (0)
-- and  J.ProfileNumber = 432
-- and  J.Message not in ('Job is preprocessed','Job is preprocessed already','Job is transcoding','Job is completed') -- like 'Job is canceled by 192%' 'Job is set to server%' 
 and  JS1.Name   in ('Initial','Processing','Pausing','Canceling','Failing','Paused','Failed','Canceled','Succeeded') -- JobStatus
 and  JS2.Name   in ('Initial','Assign','Read','Preprocess','Transcode','Write','AlUpdate','Succeeded') -- JobState
 and  JSS.Name   in ('Initial','AssignQueued','Assigning','Assigned','ReadQueued','Reading','Read','PreprocessQueued','Preprocessing','PreprocessingExtractCaptions','PreprocessingExtractScte35','Preprocessed','TranscodeQueued','Transcoding','AudioAnalysis','AudioExtraction','TranscodingFirstPass','TranscodingSecondPass','Muxing','Transcoded','WriteQueued','Writing','Written','AlUpdateQueued','AlUpdating','AlUpdated','Succeeded') -- JobSubState
-- and  ServerIp = '192.168.98.47'
 and  J.CreatedTime >= '12/01/2016 12:00 PM -07:00'
 Group by JS1.Name, JS2.Name, JSS.Name, Case  When CHARINDEX('OutputPath=',J.Message)>1 THEN SUBSTRING(J.Message,CHARINDEX('StatusString=',J.Message),9000) ELSE J.Message END -- J.Message
 Order by Count(J.Message) desc, JS1.Name, JS2.Name, MIN(J.CreatedTime) -- J.Message
*/
-- Select * from Server
-- Select * from JobStatus
-- Select * from JobState
-- Select * from JobSubstate
-- delete from Job
-- delete from JobHistory
