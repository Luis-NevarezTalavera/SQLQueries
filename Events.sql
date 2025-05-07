Use OrderProcessing 
 SELECT Min(MT.MovieTitle) as TitleName, Min(T.ALAssetId) as ALAssetId, Min(T.AssetName) as AssetName, Min(Event.Timestamp) as MinTimestamp, Max(Event.Timestamp) as MaxTimestamp, -- Min(Event.[Source]) as ALStreamID, Min(Event.EventId) as MinEventId, Max(Event.EventId) as MaxEventId, 
	Count(Event.EventId) as EventsQty, DateDiff(second,Min(Event.Timestamp),Max(Event.Timestamp)) as ElapsedTime, 
 Min(
 Case When ( Data like '%Exception%'  Or  Data like '%Error%'  Or  Data like '%Fail%'  Or  Data like '%Warning%' ) 
	Then Data 
	Else
		Case When (Data like 'Workflow%') 
			Then 'Workflow Started/Completed' 
			Else
				Case When (Data like 'Transfer%' Or Data like 'Traveller And Descriptor%') 
					Then 'Transfer, Traveller/Descriptor' 
					Else
					Case When (Data like '%Transcode%') 
							Then 'L1 Transcoding' 
							Else
								Case When (Data like 'QC Status%' Or Data like 'Submit%QC%' Or Data like '%Baton%') -- '%QMgr Job%'
									Then 'Baton QC'
									Else
										Case When  (Data like 'Entering Packager%' Or Data like 'Processing v1-%' Or Data like 'Widevine/PlayReady Process Complete%') 
											Then 'L2 Packaging' 
											Else  
												Case When  (Data like '%MD5%') 
													Then 'MD5 Calculation' 
													Else    
														Case When  (Data like '%CDN%') 
															Then 'Push to CDN' 
															Else  Data
														End
												End
										End
								End
						End
				End
			End
	End) as Event_Data, Event.WorkflowInstanceId -- Min(CONVERT(varchar(100),Event.WorkflowInstanceId)) as FirstWFInstanceId, Max(CONVERT(varchar(100),Event.WorkflowInstanceId)) as LastWFInstanceId
FROM	Title T WITH (NOLOCK)	INNER JOIN  MasterTitle MT WITH (NOLOCK) ON T.MasterTitleId = MT.MasterTitleId 
								INNER JOIN  Event WITH (NOLOCK) ON T.TitleId = Event.TitleId
Where	T.ALAssetId  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON T.MasterTitleId = MT.MasterTitleId  where  MT.MovieTitle like 'QA_Regression%' )
-- and T.TitleStateId not in ('14') )
 and T.AssetName  not like '%%_ART_%jpg%%'
-- and T.ALAssetId in  ( 'a1-2762038' )
-- T.titleId=166118
-- and Source = 's1-7073809'
-- and  ( Data  like '%Exception%'  OR  Data  like '%Error%'  OR  Data  like '%Fail%' ) 
-- and  Data like 'Workflow Started%' OR  Data like 'Workflow Completed%'
-- and  Data like 'Transfer Assets%'  OR  Data like 'Traveller And Descriptor%'
-- and  Data like 'Start CC workflow result%'
-- and  Data like 'Transcode%' 
-- and  Data like '%QMgr Job%'
-- and  Data like 'Entering Packager%' OR Data like	'Widevine/PlayReady Process Complete%'
-- and  Data like 'VFS%'
-- and  Data like 'Push to CDN%' 
 and (Timestamp >= '2019-06-01 12:00:00.000' ) -- and   Timestamp <= '2015-11-31 01:07:23.647')
GROUP BY T.AssetName, T.ALAssetId, Event.WorkflowInstanceId, 
 Case When ( Data like '%Exception%'  Or  Data like '%Error%'  Or  Data like '%Fail%' ) 
	Then Data 
	Else
		Case When (Data like 'Workflow%') 
			Then 'Workflow Started/Completed' 
			Else
				Case When (Data like 'Transfer%' Or Data like 'Traveller And Descriptor%') 
					Then 'Transfer, Traveller/Descriptor' 
					Else
					Case When (Data like '%Transcode%') 
							Then 'L1 Transcoding' 
							Else
								Case When (Data like 'QC Status%' Or Data like 'Submit%QC%' Or Data like '%Baton%') -- '%QMgr Job%'
									Then 'Baton QC'
									Else
										Case When  (Data like 'Entering Packager%' Or Data like 'Processing v1-%' Or Data like 'Widevine/PlayReady Process Complete%') 
											Then 'L2 Packaging' 
											Else  
												Case When  (Data like '%MD5%') 
													Then 'MD5 Calculation' 
													Else    
														Case When  (Data like '%CDN%') 
															Then 'Push to CDN' 
															Else  Data
														End
												End
										End
								End
						End
				End
			End
	End
 ORDER BY  T.AssetName, T.ALAssetId, Max(Event.Timestamp), Event.WorkflowInstanceId -- , Event.Data, Min(Event.EventId)
/*
Use OrderProcessing 
 SELECT	top (20) E1.*, E2.*
		-- Source, Count(Source) as Qty
 FROM	Event E1 With (NoLock) Left Outer Join Event E2 With (NoLock) On E1.Source = E2.Source
 WHERE  
	  E1.Timestamp >= '2019-03-01 00:00:00.0000000' and E1.Timestamp < '2019-06-01 00:00:00.0000000'
  and E2.Timestamp >= '2019-03-01 00:00:00.0000000'
  and E1.Data like '%Baton Failed%' and E2.Data like '%QCPASS%'
  -- Data like 'QC Status%' and  Or Data like 'Submit%QC%' Or Data like '%Baton%'
-- Group by Source
-- Having Count(Source) >1
*/