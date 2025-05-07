-- Query to Manually modify for x,y,z StreamsID it's Stream state
Use AssetLibrary
UPDATE	ALStream 
SET  
	 StreamStateTypeID = 346 -- Failed  -- 345 -- Completed      -- 512	--	TranscodedNotTested  --  528	--	Canceled -- 343 -- Pending -- 
--	, StreamSubStateTypeID = 528	--	Canceled --		NULL -- Undefined --		524	--	Failed_QC --		542	--	ReadyForLibrary --		523	--	Failed_Transcode --  
--	, FileUriPath = '' -- 'a1/6A/89/a1-170600/s1-3310055/7f75104a-de32-444f-906b-bc0a8cbf80ed'
--	, Status = '' -- 
--	, IsDeleted = 0
--	, FileListXML = '<fileList><resourceFile type="AudioVideo" uri="Output.ts" fileSizeInBytes="5522037896" presentationTimeInSeconds="0" /></fileList>'
-- select * from ALStream 
Where IsDeleted in (0) 
 and AssetId in (Select AssetId   FROM ALTitle T WITH (NOLOCK) Left Outer JOIN ALTitleAsset TA ON T.TitleID = TA.TitleID Where (TitleName like 'QA_Regression_2019/04/01_262' ) ) -- OR  TitleName like 'QA_Smoke%Mar_20%') ) -- OR  TitleName like 'QA_FF%' ) ) --
 and  AssetID in (4340890,4340898) 
-- and  'a1-' + CONVERT(varchar(8), AssetId)  in (SELECT asset_id FROM OrderProcessingConsole.dbo.orders INNER JOIN OrderProcessingConsole.dbo.order_jobs ON orders.id = order_jobs.order_id Where orders.id in (30313)) -- 30308,30310,
-- and StreamId in (13576899,13576902,13576905,13576908,13576911)
-- and StreamName like '%es-MX%' --
 and VariantId not in (1)
-- and StreamStateTypeID = 346 -- Failed	--  != 345 -- Completed   --  528	--	Canceled -- 343 -- Pending -- 345 -- Completed   --  512	--	TranscodedNotTested  --  
-- and StreamSubStateTypeID = 524	--	Failed_QC -- 523	--	Failed_Transcode -- 
-- and (Status like 'Transcode Successful%') --  OR Status like '%WxH%')-- 
-- and CreatedDateTime < '2015-07-17 20:00:00.000'
-- and ContainerTypeID not in (347) 
-- and EncryptionTypeId  not in (363,561) -- (363) None -- 365 -- WV --  (547) -- PR  -- (561) Unencrypted -- (567)	HLS -- (573)	Modular
-- and FileUriPath   like 'a1/%' -- '%Assets%' -- 
/*	
update AlStream set fileListXMl = '<fileList><resourceFile type="Subtitle" language="en-AU" uri="Subtitle_en-AU.smi" hashValue="0ef42264892be96c73fd0578e85b3d6d" hashMethod="md5" fileSizeInBytes="1728" /></fileList>'
 where AssetId=136950 and StreamId=2868851 -- 2868840 -- 2868804
 select * from ALStream where   AssetID in (170600)  and StreamId in (3310055,3310056)

StreamStateTypeID
343	--	Pending
344	--	Processing
345	--	Completed
346	--	Failed
512	--	TranscodedNotTested
513	--	TranscodedTested
528	--	Canceled
556	--	WaitingForSource

ALStreamSubStateTypeID Values
NULL -- Undefined
557	--	Canceled
559	--	L0DemuxFail
560	--	NoClosedCaptioning
542	--	ReadyForLibrary
543	--	EQC_Failure_AudioVideo
544	--	EQC_Failure_Metadata
545	--	EQC_Failure_Other
549	--	OPC_L1_Failure
550	--	EQC_RequiresReview
523	--	Failed_Transcode
524	--	Failed_QC
525	--	Failed_KeyDisc
526	--	Failed_CDN
527	--	Failed_Archive
	*/

--	select * from LookupEnum where LookupGroup like '%Stream%State%' order by LookupGroup