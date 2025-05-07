Use AssetLibrary -- '\\La1ppisxhd.d3nw.net\QA1\ContentServer\Output\'+
SELECT  TOP(10000)	T.TitleId, T.TitleName, A.AssetName, A.Duration,  A.AssetID, S.StreamID, S.VariantID, V.VariantTypeID, --  TE.TitleEditionTypeID,  S.ContainerTypeID, S.EncryptionTypeID, 
 				 Case  When S.VariantId=1						Then FileUriPath+'\'+FileListXml.value('(/fileList/resourceFile/@uri)[1]', 'varchar(100)') -- v1-1 Source
			Else Case  When (S.VariantId between 1100 and 1999 and S.VariantId not between 1900 and 1903)	Then 'http://edge2.dmlib.com/u/QA1/'+FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile/@uri)[1]','varchar(50)') -- Sidecars, Thumbnails
			Else Case  When S.VariantId between 1900 and 1903	Then 'http://edge2.dmlib.com/u/QA1/'+FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile[@type="Manifest"]/@uri)[1]','varchar(50)') -- Thumbnails
			Else Case  When S.EncryptionTypeID in (547)			Then 'http://edge3.dmlib.com/u/QA1/'+FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile[substring(@uri,(string-length(@uri)-3))=".ism"]/@uri)[1]','varchar(50)') + '/manifest' -- PlayReady
			Else Case  When S.EncryptionTypeID in (365,567,573,574) Then 'http://edge2.dmlib.com/u/QA1/'+FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile[@type="AudioVideo"]/@uri)[1]','varchar(50)') 
			Else Case  When S.EncryptionTypeID in (363,561) and FileUriPath like 'Assets%'	Then '\\La1ppisxhd.d3nw.net\QA1\ContentServer\Staging\'+FileUriPath+'\'+FileListXml.value('(/fileList/resourceFile[@type="AudioVideo"]/@uri)[1]','varchar(50)') 
			Else FileUriPath End End End End End End as FileUrlPath, LE.LookupValue as StState, LE1.LookupValue as StSubState, S.Status, S.StreamName, AL.LookupValue as ContentType, S.EncryptionTypeID, LE2.LookupValue as Encryption, -- 
			S.CreatedDateTime, S.UpdatedDateTime, S.UpdatedBy, S.TNIPAddress, S.FileListXML, A.DescriptorXML, S.IsDeleted, FileListXml.value('(/fileList/resourceFile/@fileSizeInBytes)[1]','varchar(15)') as FileSizeFileList --, DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/FileSize)[1]','varchar(15)') as FileSizeDescriptor, 
FROM ALTitle T WITH (NOLOCK) Left Outer Join ALTitleAsset TA WITH (NOLOCK) ON T.TitleID = TA.TitleID				Left Outer Join ALAsset A WITH (NOLOCK) ON TA.AssetID = A.AssetID		
							 Left Outer Join ALStream S WITH (NOLOCK) ON A.AssetID = S.AssetID						Left Outer Join AlVariant V WITH (NOLOCK) ON S.VariantId = V.VariantId
							 Left Outer Join ALAssetTypeLookup AL WITH (NOLOCK) ON A.AssetTypeID = AL.LookupID		Left Outer Join LookupEnum LE2 WITH (NOLOCK) ON S.EncryptionTypeID = LE2.LookupID
							 Left Outer Join LookupEnum LE WITH (NOLOCK) ON S.StreamStateTypeID = LE.LookupID		Left Outer Join LookupEnum LE1 WITH (NOLOCK) ON S.StreamSubStateTypeID = LE1.LookupID	
 Where   S.IsDeleted in (0) 
 and ( TitleName like 'QA_Regression_%_2018/01/%' ) --  OR  TitleName like 'QA_Smoke%Sep_14_2017%') --      OR  TitleName like 'QA_FF%/08/25%'
-- and  'a1-' + CONVERT(varchar(10), S.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  (MasterTitle.MovieTitle like 'QA_Regression_2017/07/21_236%')  and Title.IsQueuedForTranscoding = 1  ) -- and Title.TitleStateId in ('14','18') ) 
-- and  'a1-' + CONVERT(varchar(10), S.AssetId)  in (select asset_id FROM OrderProcessingConsole.dbo.orders O INNER JOIN OrderProcessingConsole.dbo.order_jobs OJ ON O.id = OJ.order_id  Where O.id in (192171,192172,192173,192175,192176,192177,192180,192181,192182,1921783) ) -- order by OJ.submit_date) -- 
-- and  LE.LookupValue   in ('Failed','Canceled') --,'Pending' -- 'Completed' ,'TranscodedNotTested') --
-- and  LE1.LookupValue  Not in ('NoExtractedDigitalAd') --'Failed_Transcode') -- -- 'Canceled') -- 'L0DemuxFail',,'Failed_QC','Failed_KeyDisc','NoExtractedDigitalAd')  --  'EQC_Failure_Other','ReadyForLibrary','Failed_KeyDisc','EQC_Failure%' , 'OPC_L1_Failure' 
 and  (  A.AssetName  not like '%_ART_%jpg%' ) -- and A.AssetName   like  '%simple%' ) --  and  A.AssetName  like '%5-1%'  and  A.AssetName   like  '%16_9%' ) -- 
 and	A.AssetID in (2763047) -- between 1980534 and 1980548 
-- and  S.StreamId   in ()  -- List of streamIds 
-- and 	S.VariantId  in (1) -- ,673,674,675,676, 2606,2607,2608, 2652,2653,2656,2657)
-- and  S.VariantID  in  ( Select VariantId from ALVariant where ( VideoResolution like '%x720'  OR  VideoResolution like '%x1080') )
-- and  ( StreamName   like  '%CC3 - es-MX%' ) --  or StreamName  like '%720%'  )  
-- and  AL.LookupValue in ('ArtReference') -- 'FeatureFilm','Trailer') -- 
-- and  S.UpdatedDateTime  >= '2017-04-21 19:00:00.000'   --  S.CreatedDateTime  >= '01/06/2016 12:00 PM' ) -- 
-- and  ( Status   like '%ParseClosedCaptionEmbedding() languages specified in CaptionLanguage attribute not found in sidecar caption files%' )   -- and  Status  not in('QueueManager Error: Unable to start baton WF','Transcode Successful','Publish to CDN completed successfully') -- 'Baton Failure%' -- 
-- and  FileListXml.value('(/fileList/resourceFile/@uri)[1]','varchar(100)') like '%MXF' --  OR  FileListXml.value('(/fileList/resourceFile/@uri)[4]','varchar(100)') like '%v1-163%' 
-- and  TNIPAddress  not in ('192.168.97.174','192.168.97.182') --,'192.168.73.12','192.168.73.11','192.168.97.177')
-- and  B.BaseLocationID < 13 
-- and  VariantTypeID not in (6)
-- and  A.DescriptorXML  Is Null
-- and  T.TitleID in (566420) 
-- and  A.Duration>=6000 and  A.Duration<=6600
-- and  (Select AssetId from ALAssetProperty Where PropertyName = 'FILE0_FRAME_WIDTH' And ValueInt < 1920) 
-- and  ContainerTypeID not in (347) -- None -- (351) -- MPEG4 -- (362) -- Other 
-- and  S.EncryptionTypeId   in (547) -- PR   --  365 -- WV --  (363) -- None -- (561) Unencrypted --  (567) -- HLS -- (573)	Modular
 and ( FileUriPath   like  'a1%' ) --	OR  FileUriPath    like  '_QASmoke%' )  --  and  S.VariantId not in (278,305,321,326,428,433) )  ) --  
 ORDER BY  TA.TitleID desc, TA.AssetId, S.VariantID -- S.Status   -- S.StreamID,  -- .TitleID desc, -- S.UpdatedDateTime  -- A.AssetName desc,  --   S.EncryptionTypeID, 
/*
Select S.AssetID, AssetName, TNIPAddress, Count(*) as StreamsCount 
from ALStream S Join ALAsset A ON S.AssetID = A.AssetID	
where S.AssetID in (2763352) and TNIPAddress Is Not Null 
Group by S.AssetID, A.AssetName, TNIPAddress 
Order by S.AssetID, A.AssetName, TNIPAddress 
*/
-- Select  LE1.LookupValue as StSubState, Status, PropertyName, ValueStr as Version  From ALStream S Inner Join ALStreamProperty P on S.StreamId = P.StreamId Left Outer Join LookupEnum LE1 ON S.StreamSubStateTypeID = LE1.LookupID	Where PropertyName = 'NODE_SW_VERSION' and S.StreamId in (6083924,6084220,6084240,6089775,6089774,6089761,6090783,6090668,6090801)
-- update ALTitle set TitleName='QA_Regression_2017/04/13_123' where TitleID=925538
-- update ALAsset set DescriptorXML = Null Where AssetID = 367395
/* 
StreamStateTypeID
343 = Pending
345 = Completed
346 = Failed
512 = TranscodedSuccesfull, Not Baton QC Tested

StreamSubStateTypeID
523	Failed_Transcode
524	Failed_QC
525	Failed_KeyDisc
526	Failed_CDN
527	Failed_Archive
542	ReadyForLibrary
543	EQC_Failure_AudioVideo
544	EQC_Failure_Metadata
545	EQC_Failure_Other
549	OPC_L1_Failure
550	EQC_RequiresReview
557	Canceled
559	L0DemuxFail
560	NoClosedCaptioning
566	DCD_Repackage_Request
569	NoExtractedDigitalAd

Select * From ALAssetTypeLookup
1	FeatureFilm
2	TVEpisode
3	ShortFilm
4	Trailer
5	DeletedScene
6	Featurette
7	Interview
8	MakingOf
9	Outtake
10	RatingCard
11	WarningCard
12	Logo
13	Slate
14	Other
15	ArtReference
16	BrandingPreroll
17	AdvertisingPreroll
18	InfoTour
19	Preview

Select * ALVariantTypeLookup
0	Undefined
1	SourceAsset
2	VideoOnly
3	AudioOnly
4	VideoAudio
5	Special
6	Compound
7	ArtReference
8	Subtitle
9	AudioExtraction
13	L1sOnly
14	Thumbnails
15	ConformedDigitialAd
16	ExtractedDigitalAd
*/
-- select * from ALAssetTypeLookup