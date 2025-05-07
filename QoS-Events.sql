Use AssetLibrary
Select 
		T.TitleID, T.TitleName, A.AssetId, A.AssetName,  Min(EventId) as EventId, Count(EventID) as EventsQty, 
		Min(EventTime) as MinTimestamp, Max(EventTime) as MaxTimestamp, Summary
		-- nEventID, EventData, IsError, Error, Subsystem
From	ALTitle T WITH (NOLOCK)	Left Outer Join ALTitleAsset TA WITH (NOLOCK) ON T.TitleID = TA.TitleID
								Left Outer Join ALAsset A WITH (NOLOCK) ON TA.AssetID = A.AssetID
								Left Outer Join QoS.dbo.Event E WITH (NOLOCK) ON TA.AssetID = E.ALAssetID 
Where A.IsDeleted=0
-- and TA.TitleID in ( Select T.TitleID from AssetLibrary.dbo.ALTitle T WITH (NOLOCK)  Where  ( TitleName like 'QA_Regression%' ) ) 
 and A.AssetName not like '%_ART_%jpg%' and A.AssetName not like '%_ART_%bmp%' -- and A.AssetName  like 'Partner%'
-- and  ( E.ALAssetID IS NULL) 
-- AlTitleId=166118
-- and TA.AssetID in (2762038)
-- and EventId in (2040)
-- and ( Summary like '%Exception%'  Or  Summary like '%Error%'  Or  Summary like '%Fail%' ) --
 and  Summary  in ('AL: Stream Transcoded')  -- 1459 + 1460 = 2919
 -- OR Summary like '%Fail%' ) 
 -- 'AL: Asset Created'
 -- 'WF: Asset Submitted'
 -- 'WF: Asset Queued'
 -- 'TJM: Stream Queued', 'TJM: Stream Completed', 'AL: Stream Transcoded',
 -- 'WF: CPM Started','WF: CPM Complete' -- 'CPM: Stream Queued','CPM: Stream Completed' -- 'AL: Stream Packaged',
 -- 'WF: CDN Started','WF: CDN Complete','WF: Notification Complete') ) 
 -- 'AL: Stream Archived',
 and (EventTime >= '2019-01-01 12:00:00.000' ) -- and  EventTime < '2019-06-01 12:00:00.000')
 GROUP BY T.TitleID, T.TitleName, A.AssetId, A.AssetName, Summary -- Summary, 
-- HAVING Count(nEventID) > 1
 ORDER BY Max(EventTime), A.AssetId, Summary -- 
 
-- select top(20) * from QoS.dbo.Event

/*
  SELECT TOP 1000 * 
  FROM  QoS.dbo.Event 
  Where Summary  like 'Transcode/QC Failure 1:%'
  and Subsystem = 5
  and ALStreamID > 0
  and (EventTime >= '2019-03-01 12:00:00.000'  and  EventTime < '2019-06-01 12:00:00.000')

  --  in ('TJM: Stream Completed','AL: Stream Transcoded') --- and Summary not like '%AL: Stream Transcoded%'

SELECT  ALAssetId, Min(EventId) as EventId, Count(nEventID) as EventsQty, Min(EventTime) as MinTimestamp, Max(EventTime) as MaxTimestamp, Summary 
FROM ALTitleAsset TA WITH (NOLOCK)		Left Outer Join ALAsset A       WITH (NOLOCK) ON TA.AssetID = A.AssetID 
										Left Outer Join QoS.dbo.Event E WITH (NOLOCK) ON TA.AssetID = E.ALAssetID 
WHERE 
ALTitleID in ( SELECT TitleId FROM ALTitle WITH (NOLOCK) WHERE  TitleName like 'QA_Regression%' )  
And  Summary  like '%Baton%' -- in ('WF: Notification Complete') 
And  A.AssetName not like '%_ART_%' 
GROUP  BY Summary, ALAssetId 
ORDER  BY Summary, Max(EventTime)
*/