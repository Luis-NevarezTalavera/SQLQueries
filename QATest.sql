Use QATest
Select * From QAAsset where qAssetResolution = '1920x1080' and qAssetName like '%TRL%'
Select * From SourceAssets
Select * from QAOrders
Select * From SourceAssets_QAOrders
-- Update QAOrders set L2sList='2667,2709,2576,2644,2738,2744,2770,2874'						where qOrderId = 101 -- remove 280,281,403
Select * from [QAAPITest]
Select * from QAGoldFiles where ssimResult like '%Fail%' -- qAssetId in(51,68) --  and VariantId in(225,226)
Select * from QAGoldFilesPath where groupid = '013_059'
select * from VestaConfig where Parameter like '%Baton%'
-- update VestaConfig set value='http://prod.baton.d3nw.net:8080' where Parameter='batonURL' -- 
-- Insert into VestaConfig values ('ArchiveBaseLocation','27')
-- update VestaConfig set Value='user id=QAUser;password=D1sn3y132;Data Source=DB.QA1.D3NW.NET;Initial Catalog=AssetLibrary;connection timeout=300;MultipleActiveResultSets=True' Where Parameter='ALDBConnectionStringQA1' -- 'PQevalAudioPass' -- SSIMthreshold	0.01 -- SSIMthresholdDeviation	0.001
-- delete L2Parents  where L2VariantId in(2584,2585,2586,2587,2588,2589,2590,2591,2592,2593,2594,2595,2598,2599) and L1VariantID in (484,485,486,487)

Select * from PipelineConfig  Where AudioType like 'PCM%' order by VideoBitRate desc -- VideoBitRate>10000000  -- OutputFileType='MXF' --  VideoType like 'MPEG%' and     ProfileId between 200 and 2012 -- VariantId in('v1-200','v1-789') -- VideoEmbedCCs='L0 Dependant' and VideoPassthruCCs='Manzanita'  -- VideoSupportedFrameRates like '%23.976 Progressive,29.97 Interlaced,29.97 Progressive,59.94 Progressive%' -- OutputFileType='MXF' -- VariantId in ('v1-755','v1-758') --VideoEncoder='Vanguard' --  -- VideoSupportedFrameRates like '23%' -- AudioMaxTracks>1 --  OR FrameRates like '%12.5 Progressive%' OR FrameRates like '%14.985 Progressive%' --  and      is Null and  ='29.97 Progressive' --  (EmbeddedCCs Is Null or EmbeddedCCs='None') and VideoPassthruCCs Is Null
-- update PipelineConfig set AudioChannelFormat='5/1',AudioCBRVBR='CBR',AudioBitrate=384,AudioMaxTracks=1 Where AudioType='MPA' and VariantId not in('v1-606','v1-607','v1-604') -- VideoEmbedCCs='L0 Dependant' and VideoPassthruCCs='Manzanita' --  OutputFileExtension = 'bif' where OutputFileType='BIF' and (OutputFileExtension='' OR OutputFileExtension Is Null)
-- update PipelineConfig  set  VideoSupportedFrameRates='23.976 Progressive,29.97 Progressive,29.97 Interlaced'  where   VideoSupportedFrameRates = '23.976 progressive,29.97 progressive,29.97 interlaced (TFF)' 
-- update AssetEventPriority set  WFPriority=1, SequenceInRegression=21 Where qAssetId=70 and Environment='QA1'
select * from QAAsset where qAssetName not like '%MPEG2%' and qAssetVideoCodec = 'MPEG Video'
-- delete QAAsset where qAssetId=105
-- Update QAAsset set qAssetName='MagicCity_EPI_MPEGTS_MPEG2_AC3_480i_4-3_29-97_5-1_2-0_2_CC.mpg',qAssetPath='_QASmokeTest\MagicCity_EPI_MPEGTS_MPEG2_AC3_480i_4-3_29-97_5-1_2-0_2_CC\MagicCity_EPI_MPEGTS_MPEG2_AC3_480i_4-3_29-97_5-1_2-0_2_CC.mpg' where qAssetId = 44 -- qAssetFPS='25.0' where qAssetFPS in('25.000000','25') -- ,qAssetAspectRatio='4:3',qAssetResolution='720x576',qAssetContainer='MXF',qAssetVideoCodec='MPEG Video',qVideoAvgBitRate=30000000,qAssetAudioCodec='PCM',qAudioAvgBitRate=768000,qAudioSampleRate=48000,qAssetAudioConfig='Stereo,Stereo',qAssetFPS=25.0,qL0CheckSum='',qAssetTimeStamp='2017-11-15 10:49:26.297',qAudioBitDepth=16,qAssetDuration=30,qAssetCCEmbedded='None',qAssetScanType='Interlaced'
Select Count(qAssetId) as AssetsQty, qAssetAspectRatio, qAssetResolution, qAssetAudioConfig 
	From QAAsset Where qAssetId in (select qAssetId from QATestRun where qTestRunId >200 and qAssetName Not like '%_ART_%jpg%' )
	Group by qAssetAspectRatio, qAssetResolution, qAssetAudioConfig 
	Order by qAssetAspectRatio, qAssetResolution, qAssetAudioConfig --   (qAssetName like '%MXF%25%' ) --  and  qAssetName like '%16-9%') -- 
-- delete QAAsset	where qAssetId=103
-- Insert into QAAsset (qAssetName , qAssetPath, qAssetAspectRatio, qAssetResolution, qAssetContainer, qAssetVideoCodec, qVideoAvgBitRate, qAssetAudioCodec, qAudioAvgBitRate,qAudioSampleRate, qAssetAudioConfig,qAssetFPS, qL0CheckSum, qAssetTimeStamp,qAudioBitDepth,qAssetDuration,qAssetCCEmbedded,qAssetScanType) values ('WashingtonObelisk_ART_JPEG_220x293_YUV_8.jpg','\\La1ppisxhd.d3nw.net\QA1\ContentServer\AL\Content\TFA/_QASmokeTest\BoxArtRepo\WashingtonObelisk_ART_JPEG_220x293_YUV_8.jpg','','220x293','','', '','','','','0','', '110100000020000100FFFF0F0001:9A4747581A0976CC3097875A02D5B3B8',  GETDATE(),0,  0, '','' ) 
Select qAssetId, WFPriority, EventId, SequenceInWF, AP.Summary, EventsQty, SequenceInRegression, Environment 
	From AssetEventPriority AP Left Outer Join EventSequenceInWF SWF On AP.Summary = SWF.Summary
	Where AP.Summary  in ('TJM: Stream Completed') and Environment='QA1' -- ,'WF: Notification Complete' -- and qAssetId=40 -- and WFPriority=5-- 'AL: Asset Created','WF: Asset Submitted','WF: Asset Queued','TJM: Stream Queued','TJM: Stream Completed','WF: CPM Started','WF: CPM Complete','WF: CDN Started','WF: CDN Complete','WF: Notification Complete') -- 'AL: Stream Archived','AL: Stream Packaged','AL: Stream Transcoded','CPM: Stream Queued','CPM: Stream Completed'
	Order by qAssetId, SequenceInWF, Summary, SequenceInRegression --   qAssetId, EventId, 
select * from EventSequenceInWF order by SequenceInWF
select * from AssetEventPriority
Select * from L1FrameRateDetermination  Where L0FPS like '25%'  and  L0ScanType = 'Progressive'  Order by L0FPS, L0ScanType, PipelineFPS --     
-- update L1FrameRateDetermination set PipelineFPS  ='23.976 Progressive,29.97 Interlaced,29.97 Progressive,59.94 Progressive'  Where  PipelineFPS  like '%23.976 Progressive,29.97 Interlaced,29.97 Progressive,59.94 Progressive%'  
Select * from L2CreationLogic where Enable=1 order by L2VariantId --  and L2VariantId in(6500)and DurationLimit>0  ScanType like '%Interlaced-HardTelecine%' -- L2VariantId in (2542) -- and (1080 Between HeightLow and HeightHigh) -- 
Select Count(L2VariantId) as CountL2s, Min(L2VariantId) as FirstL2s, Max(L2VariantId) as LastL2s, AspectRatio,HeightLow,HeightHigh,Audio,ScanType,FrameRate,DurationLimit,AudioGroups
	From L2CreationLogic
	Where Enable=1 and DurationLimit>0  and L2VariantId Not In (Select Distinct qVariantId from QAStream Where qTestRunId=173)
	Group by							AspectRatio,HeightLow,HeightHigh,Audio,ScanType,FrameRate,DurationLimit,AudioGroups
	Order By Count(L2VariantId) desc,	AspectRatio,HeightLow,HeightHigh,Audio,ScanType,FrameRate,DurationLimit,AudioGroups
-- update L2CreationLogic set HeightHigh=2664 Where HeightHigh=2160 -- FrameRate =  RTRIM(LTRIM(FrameRate)) -- DurationLimit=0  where L2VariantId in(112,113,114,115,116,118,120,121,122,161,162,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316) -- UserStory = 'CPS-5801, CPS-8785' ScanType = 'Interlaced-HardTelecine,Progressive-HardTelecine' -- and L2VariantId in (2586,2590) -- 
-- delete L2CreationLogic Where L2VariantId in (1317,1318,1319) 2223,2788,7777,7778,8888,8999,9777,9999) and ScanType = 'Interlaced'
Select * from L2Parents  where L2VariantId in(2584) -- in (Select L2VariantId from L2CreationLogic where (480 Between HeightLow and HeightHigh) and @Duration <= DurationLimit)
-- update QATestRun	set  qAssetId=102 where qAssetId=103
-- update QAStream		set  qAssetId=102 where qAssetId=103
select top(10) * from QATestRunNoXML
-- Delete QAAsset where qAssetId=100
Select TOP(10) * from QARelease order by qTestRunId desc -- Where qEnvironment in('QA1','QA1') 
Select * from QATestRun where qTestRunId >=169 -- and qAssetId = 36 
Select * -- qRelease, R.qEnvironment, R.qTestRunId, R.qRegressionTitle, T.qAssetId, ALassetId, qAssetName, T.qAssetState, qStatus, T.Priority, T.Sequence, T.qTestTimeStamp, T.qL0CheckSum, T.qDescriptorXML, T.qTravellerXML 
	From QARelease R  Left outer join QATestRun T on R.qTestRunId=T.qTestRunId  Left outer join QAAsset A on T.qAssetId=A.qAssetId 
	Where  R.qTestRunId = 186 -- and qAssetName  like '%_MPEG2_%' --  and T.qAssetId>1    and  T.qStatus not in ('Pass') and qAssetState not in ('In Asset Library','Publishing Error') --  -- 
	Order by  R.qRelease desc, R.qTestRunId desc, ALassetId, T.qAssetId 
-- Select * from QARelease where qTestRunId>=169
select qVariantId, count(qVariantId) as Count, Min(VideoWidth) as Width, Min(VideoHeight) as Height, Min(VideoPAR) as PAR, Min(AudioChannelFormat) as AudioConfig 
	 -- Min(Convert(float,IsNull(VideoWidth,'1'))/Convert(float, IsNull(VideoHeight,'1'))) as DAR, 
	from QAStream S Inner Join PipelineConfig P on 'v1-'+CONVERT(varchar(8),S.qVariantId)=P.VariantId 
	Where qTestRunId=184 and qFileName like 'Output.%' 
	 -- and qAssetId=70 and qVariantId=117
	Group by qVariantId  
	Order by Count(qVariantId) desc
Select Top (10000) * from QAStream  -- qAssetId, qVariantId, qFPS_ScanType 
	Where  qTestRunId >= 1 --	and  qAssetId >= 102
--		 and  qTestPassL1 in ('Fail','Inconcl')   and  qTestPassCC not in('Pass','n/a')  
--		 and  qTestPassVideo Not in('Pass','n/a')  and  qTestPassAudio in('Pass','n/a')and  qTestPassFileListXML in('Pass')	and  qBatonFullDecodePass in ('Pass','n/a') 
--		 and  qStatus like '%0%Progressive%' -- OR  qStatus Is Null) -- qStatusOri>'') -- and qStatus not like 'The Closed%' and qStatus not like 'Failed_Transcode%'  and qStatus not like 'SSIM%'  and (qStatus  like 'PQevalAudio: -3%'  OR  qStatus  like 'PQevalAudio: -2%'  OR  qStatus  like 'PQevalAudio: -1%')
--		 and  qL1ZeroOutChecksum='110100000020000100FFFF0F0001:4C5F187753F09D0D9527CE67C387A5A2'
-- 		 and  qStreamPath not like '%Assets%' -- and  qEnvironment='QA1'
--		 and  qFPS_ScanType Is Null --  >'' -- not in ('29.97 Interlaced','23.976 Progressive','29.97 Progressive','59.94 Progressive','1 Progressive')
--		 and  qFilename  like 'Output.%' -- '%.zip' or qFileName like '%.bif'
--		 and  ALAssetID in (2761702) 
		 and  qVariantId < 200 and qVariantId not in (1,117,118,163,166,168,170) -- (select variantId from PipelineConfig where  Encoder = 'Vanguard') -- EmbeddedCCs  in ('608 SCTE20+708','608 SCTE20+608+708') ) -- 'None', -- 
--		 and  (qElementaryAudioChecksum = '110100000020000100FFFF0F0001:5D5E636DC41E710951B012B5A98D2E80' ) -- OR qElementaryVideoChecksum Is Null)
--		 and  DATALENGTH(qFileListXML) = 5
--		 and  (qElementaryCCfileSRT like '%00:00:10,476__WE WERE%' ) -- OR qTestPassCC Is Null)
--		 and  qFPS_ScanType not like '%Progressive' -- (qFPS_ScanType is Null or qFPS_ScanType = '')
--		 and  qTNIP='192.168.97.143' 
--		 and  qTestTimeStamp between '4/26/2016 7:10 PM' and '4/26/2016 7:20 PM'  
--	Group by   qStatus
	Order by   qAssetId, qVariantId, qTestRunId desc
-- update QARelease  set  qRegressionTitle='QA_Regression_2017/12/19_420', qRelease='7.0'  where  qTestRunId = 189   -- qComments=''  and qComments='Release Comments' -- 
-- delete QARelease where qTestRunId >= 194
-- update QARelease set   qTestRunId = 194  where qTestRunId = 195
-- delete QATestRun where qTestRunId >= 194  -- and qAssetId=140   -- and qVariantId in(1)  -- 2873161,2873133,2873139,2873146,2873148)
-- update QATestRun set   qTestRunId = 194  where qTestRunId = 195 -- and qAssetId=105
-- delete QAStream  where qTestRunId >= 194  and qVariantId in(1) -- , 800,801,802,803,806,807,808,809) -- in (1,790,791, 804,805, 2000,2001,2002,2003)  -- and qAssetId=140   -- and qStreamPath like '%Assets%'  --   and ALAssetID >= 2873174 -- 2873161,2873133,2873139,2873146,2873148) --,778,779,784,785, 2766,2768,2770,2772,2774,2778,2780,2782,2784,2786,2767,2769,2771,2773,2775,2779,2781,2783,2785,2787,2768,2770,2786,2769,2771,2787)  --  qStreamPath like '%Assets%' or  ,6500,6501)
-- update QAStream  set   qTestRunId = 194  where qTestRunId = 195 -- , qAssetId=104  where qTestRunId = 184 and qAssetId=105 -- and qVariantId in(1) -- ,706,707,708,709,710,711) -- and  qAssetId in (70)  --  -- and qStreamPath like '%Assets%'  --  and ALAssetId between 1541036 and 1541069  --   qTestTimeStamp >='1/15/2016 1:35 AM'   and   and  qVariantId in (411,415) --  and qAssetId = 96 --   and qAssetId=36 and  qElementaryAudioCheckSum='110100000020000100FFFF0F0001:1EF4F86171C8F7BF854644D63C5A2A5D' -- and  qStatus like 'RunTranscode() failed%'  and  qTestPassAudio in (0,-1)  and qTestPassVideo=1     

-- Insert into QAStream Select * from QATest_old.dbo.QAStream where qTestRunId=161 and qStreamPath like '%Assets%'
-- update QAStream  set  qReferenceFlag=1,qTestPassL1='Pass',qTestPassVideo='Pass',qTestPassAudio='Pass',qTestPassCC='Pass',qTestPassFileListXML='Pass',qBatonFullDecodePass='Pass',qStatus=''  Where  qTestRunId>=184  and qAssetId=103 and qStatus = 'Video Matches, PASS | Audio Matches, PASS | '
-- update QAStream  set  qReferenceFlag=0,qTestPassL1='Fail',qTestPassVideo='Fail',qTestPassCC='Fail', qStatus='CCs left alignment, CPS-10423'	Where  qTestRunId >= 182 and  (qElementaryCCfileSRT like '%00:00:10,_____WE WERE%' ) and qStatus='CCs left alignment' -- and qTestPassCC='Inconcl' and (qStatus like '%The CC608 captions were not present%' OR qStatus like '%CCExtractor%')
-- update QAStream  set  qReferenceFlag=0,qTestPassL1='Pass',qTestPassFileListXML='Pass',qStatus=''	Where  qTestRunId = 163  and qStatus  like 'FileListXML%' and qFileListXML.value('(/fileList/resourceFile[@type="SubtitleBDN"]/@uri)[1]', 'varchar(100)') Is Null
-- update QAStream  set  qTestPassL1='Fail',qTestPassCC='Fail',qStatus='CCs Shifting Late'	Where  qTestRunId >= 170 and qTestPassL1!='Fail' and qAssetId=101 and qElementaryCCfileSRT like '%00:00:4_,___ --> 00:00:50,%'  -- and  qElementaryVideoCheckSum>'' and  'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoPassthruCCs  in ('Manzanita','Telestream')) and 'v1-' + CONVERT(varchar(5), qVariantId)  not in (select variantId From PipelineConfig Where VideoEmbedCCs  in ('None') ) -- and qAssetId not in(51,58,59,61,101) 
-- update QAStream  set  qReferenceFlag=0	Where  qTestPassL1 in('Inconcl','Fail') and qReferenceFlag=1
-- update QAStream  set  qReferenceFlag=0,qTestPassL1='Inconcl',qTestPassVideo='Inconcl',qTestPassCC='Inconcl'	Where  qTestRunId in(173,175) --   and qElementaryCCfileSRT>'' -- and qTestPassCC in('Inconcl','Pass') --'Fail' and qTestPassL1='New' and qVariantId not between 378 and 425 and qVariantId  in(673,674,675,676,800,801,802,803,804,805,806,807,808,809) and qAssetId >=100  and  (qElementaryCCfileSRT='' OR qElementaryCCfileSRT Is Null)
-- update QAStream  set  qTestPassCC='Pass'	Where  qTestRunId in(189,192) and qElementaryCCfileSRT>''  and qTestPassCC='Inconcl' -- and qVariantId in (673,674,675,676, 800,801,802,803,804,805,806,807,808,809, 790,791, 2000,2001,2002,2003)   and qTestPassVideo='Pass'  and qElementaryCCfileSRT like '%â ê î ô û Á É Ó Ú Ü ü ` ¡ *%' and qStatus = '' -- and qTestPassL1='Pass' -- and qElementaryCCfileSRT>''  and qAssetId in(102) 
-- update QAStream  set  qL2ManifestPass='n/a', qL2Manifest='n/a'	Where  qTestRunId >= 1    and (qL2Manifest Is Null Or qL2Manifest = '' )
-- update QAStream  set  qStatus='', qTestPassL1='New'	Where  qTestRunId >= 170  and qAssetId>100 and qTestPassL1='Fail' -- and  qVariantId between 800 and 830 and  qTestPassL1 = 'Inconcl' and qStatus like '%FPS FAIL%'
-- update QAStream  set  qTestPassFileListXML='Inconcl'	Where  qTestRunId >= 164  and  qTestPassFileListXML='n/a'  and qFileListXML.value('(/fileList/resourceFile/@type)[1]', 'varchar(100)') = 'AudioVideo' and qTestPassL1 != 'Pass'
-- update QAStream  set  qStatus=''			 Where  qTestRunId >= 177 and qTestPassVideo='Pass' and qStatus in ('| BATON WARNING: SCTE Information is not present in the transport stream. Specified criteria: Report as Warning if . . ','CCExtractor cant Extract Captions','Video Matches, PASS | Audio Matches, PASS | ')
-- update QAStream  set  qStatus=''	Where  qTestRunId >= 177  and qStatus like 'CCExtractor cant Extract Captions%' and (qBatonFullDecodePass='Pass' or qStreamPAth='' or qTestPassVideo='Pass')
-- update QAStream  set  qTestPassL1='Inconcl' Where  qTestRunId >= 173 and qTestPassL1='Fail' and qStatus=''
-- update QAStream  set  qTestPassVideo='New'  Where  qTestRunId >= 170 and qTestPassL1='New' and qTestPassVideo!='New' -- and qAssetId>=100 -- and qVariantId in (420,212,421,422,423,213,409,214,410,411,216,215,204,206,207,208,211,392,200,412,209,201,205,319,317,202)

-- Alter table QARelease
-- drop CONSTRAINT pk_qReleaseEnvironmentTestRun
-- add CONSTRAINT pk_qReleaseEnvironmentTestRun PRIMARY KEY (qRelease,qEnvironment,qTestRunId)

-- select * from L2CreationLogic
-- Alter Table L2CreationLogic
-- drop column bitdepth

--Alter table L1FrameRateDetermination 
--	ALTER COLUMN  PipelineFPS varchar(100)
--Alter table QATestRun
--	ALTER COLUMN [qAssetState] varchar(50)
-- add CONSTRAINT pk_qTestRunAssetId PRIMARY KEY (qTestRunId,qAssetId) 
-- drop CONSTRAINT pk_qTestRunAssetId
-- sp_rename 'QATestRun.TranscoderConfig', 'qTranscoderConfig', 'COLUMN'
-- ADD CONSTRAINT pk_qAssetVariantRun PRIMARY KEY (qTestRunId,ALAssetId,ALStreamId,qVariantId,qFileName)

-- ALTER TABLE QAAsset
--SET IDENTITY_INSERT QAAsset ON

--	ALTER COLUMN [qAudioBitDepth] INT NULL
/*
DROP INDEX [QAStream].[ix2]
DROP INDEX [QAStream].[ix3]
DROP INDEX [QAStream].[missing_index_21886]
-- DROP INDEX [QAStream].[IX_Qatest3]
DROP INDEX [QAStream].[IX_Qatest4]
DROP INDEX [QAStream].[IX_Qatest5]

ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassVideo
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassAudio
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassL1
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassCC
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qBatonFullDecodePass
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassFileListXML
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qL2ManifestPass

ALTER TABLE QAStream
ADD DEFAULT '' FOR qTestPassVideoOri
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassAudioOri
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassL1Ori
ALTER TABLE QAStream
ADD DEFAULT 'Inconcl' FOR qTestPassCCOri

GO
CREATE NONCLUSTERED INDEX [ix2]
    ON [dbo].[QAStream]([qTestRunId] ASC, [qAssetId] ASC, [qElementaryAudioCheckSum] ASC, [qTestPassAudio] ASC);
GO
-- CREATE NONCLUSTERED INDEX [ix3] -- Error size is greater than limit
--    ON [dbo].[QAStream]([qTestRunId] ASC, [qTestPassL1] ASC, [qReferenceFlag] ASC, [qStatus] ASC);
GO
CREATE NONCLUSTERED INDEX [missing_index_21886]
    ON [dbo].[QAStream]([qAssetId] ASC, [qElementaryAudioCheckSum] ASC)
    INCLUDE([qTestRunId], [ALassetId], [ALstreamId], [qVariantId], [qTestPassAudio], [qStatus], [qFileName]);
GO
CREATE NONCLUSTERED INDEX [IX_Qatest3]
    ON [dbo].[QAStream]([qVariantId] ASC, [qTestTimeStamp] ASC)
    INCLUDE([qTestRunId], [qAssetId], [ALassetId], [ALstreamId], [qStreamPath], [qElementaryVideoCheckSum], [qElementaryAudioCheckSum], [qL1ZeroOutCheckSum], [qTestPassVideo], [qTestPassAudio], [qTestPassL1], [qSVNVerPipelineConfig], [qSVNVerTN], [qReferenceFlag], [qTNIP], [qStatus], [qEnvironment], [qFileName], [qElementaryCCfileSRT], [qTestPassCC], [qEncodeTime], [qMuxTime], [qBatonFullDecodePass], [qFPS_ScanType], [qFileListXML], [qTestPassFileListXML]);
GO
CREATE NONCLUSTERED INDEX [IX_qatest4]
    ON [dbo].[QAStream]([qTestRunId] ASC, [qAssetId] ASC, [qTestPassFileListXML] ASC, [qTestPassL1] ASC)
    INCLUDE([ALassetId], [ALstreamId], [qVariantId], [qStreamPath], [qReferenceFlag], [qFileName], [qTestPassCC]);
GO
CREATE NONCLUSTERED INDEX [ix_qatest5]
    ON [dbo].[QAStream]([qTestRunId] ASC, [qAssetId] ASC)
    INCLUDE([ALassetId], [ALstreamId], [qVariantId], [qFileName], [qElementaryCCfileSRT], [qTestPassCC]);
*/
/*
DECLARE @environment as varchar(5)
DECLARE @testRun AS int
DECLARE @assetId AS int
SET @environment = 'QA1'

SET @testRun = 132
WHILE (@testRun <= 132)
BEGIN

	Insert into QARelease  values ( '5.6',@environment,CONVERT(varchar(6),@testRun),'',GETDATE(),'QA_Regression_MultiPriority_2016/10/10_558' )

	SET @assetId = 12  -- 12
	WHILE (@assetId <= 71)  -- 71
	BEGIN
		PRINT N'<<<<<  Updating rows in QATestRun=' + CONVERT(varchar(6),@testRun) + ', AssetId=' + CONVERT(varchar(8),@assetId) + ' >>>>>>>'
		-- update QAStream  set  qTestPassL1=1, qReferenceFlag=1, qStreamPath	= (select qAssetPath  from QAAsset where qAssetId=@assetId) where qAssetId=@assetId and qVariantId=1 and qStatus=''
		-- update QAStream  set  qL1ZeroOutCheckSum 	= (select qL0CheckSum from QAAsset where qAssetId=@assetId) where qAssetId=@assetId and qVariantId=1 and qStatus=''
		 Insert into QATestRun  values ( @testRun, @assetId,(select TOP(1) ALassetId from QAStream where qTestRunId=@testRun and qAssetId=@assetId and ALassetId>1) , '','','PASS',GETDATE(),'','In Asset Library',@environment,'TEMPORARY_DISABLED_CHECKSUM','0',0)
		-- update QAAsset   set qL0CheckSum = (Select qL1ZeroOutCheckSum from QAStream where qAssetId = @assetId and qTestRunId=103 and qVariantId=1 and qL1ZeroOutCheckSum Is Not Null) where qAssetId = @assetId and qL0CheckSum Is Null
		SET @assetId = @assetId + 1
	END -- @assetId
	
SET @testRun = @testRun + 1
END -- @testRun
*/

-- Query to Generate the filesToSSMI.config
use QATest
Select S.qStatus,S.qTestRunId, S.qAssetId, S.ALAssetId, S.ALstreamId, S.qVariantId, P.VideoType, P.VideoWidth, P.VideoHeight, S.qStreamPath+'/'+qFileName as qStreamPath, 
	(Select TOP(1) S1.qTestRunId  from QAStream S1 WITH (NOLOCK) Where S1.qAssetID = S.qAssetId and S1.qVariantId = S.qVariantId and qTestPassVideo in (1) and qTestRunId>=119  Order by qTestRunId desc) as GoldenTestRunId, -- and qTestRunId>=119 
	(Select TOP(1) S1.qStreamPath+'/'+qFileName from QAStream S1 WITH (NOLOCK) Where S1.qAssetID = S.qAssetId and S1.qVariantId = S.qVariantId and qTestPassVideo in (1) and qTestRunId>=119  Order by qTestRunId desc) as GoldenL1Path -- and qTestRunId>=119 
From QAStream S Left Outer Join PipelineConfig P ON 'v1-' + CONVERT(varchar(5),qVariantId) = VariantId
Where  qFileName like 'Output.%'  and  qTestPassVideo in (0)  and  P.VideoHeight Is Not Null  and  qTestRunId >= 151
-- and  qVariantId  < 714 -- and 1999
 and  (qStatus  Not like '%SSIM FAIL%' ) -- and qStatus like '%FPS Fail%' )
-- and  qAssetId >= 50
-- and  (qFPS_ScanType=''  OR  qFPS_ScanType Is Null  OR  qFPS_ScanType = 'Null')
Order by S.qTestRunId, GoldenTestRunId desc, qStatus, S.qAssetId, S.qVariantId

-- PQevalAudioTest
Select S.qTestRunId, S.qAssetId, S.ALAssetId, S.ALstreamId, S.qVariantId, S.qStreamPath, 
	(Select TOP(1) S1.qTestRunId  from QAStream S1 WITH (NOLOCK) Where S1.qAssetID = S.qAssetId and S1.qVariantId = S.qVariantId and qTestPassAudio in (1) Order by qTestRunId desc) as GoldenTestRunId, 
	(Select TOP(1) S1.qStreamPath from QAStream S1 WITH (NOLOCK) Where S1.qAssetID = S.qAssetId and S1.qVariantId = S.qVariantId and qTestPassAudio in (1) Order by qTestRunId desc) as GoldenL1Path 
From  QAStream S 
Where qFileName like 'Output.%'  and  qTestPassAudio in (0,-1) and qTestPassL1 in (0,-1) and qTestRunId>=156  and qStatus not like '%PQevalAudio%' -- and qAssetId not in (70,71)
Order by qTestRunId, GoldenTestRunId desc, S.qVariantId -- S.qTestRunId, S.qAssetId, 

-- Baton / Blockiness Query
Select qTestRunId, S.qAssetId, S.ALAssetId, S.ALStreamId, S.qVariantId, S.qStreamPath, S.qStatus, P.ProfileId, P.OutputFileType, P.Muxer, P.VideoType, P.VideoEncoder, P.VideoWidth, P.VideoHeight, P.VideoSupportedFrameRates --, P.VideoBRType, P.VideoBitRate, P.GOPSize, P.MaxBFrames, P.SceneDetection, P.VideoPAR
From QAStream S Left Outer Join PipelineConfig P ON 'v1-' + + CONVERT(varchar(5),S.qVariantId) = P.VariantId
Where  qTestRunId>=170  and qBatonFullDecodePass in ('n/a')  --    and (qTestPassL1 in ('New') OR qTestPassVideo in ('New') OR qTestPassAudio in ('New')) and qFilename  like 'Output.%'and qTestPassVideo in (1,0,-1)
--   and qAssetId in (72)
-- and  (qStatus='' or qStatus  like '%Blockiness%') --  
-- and qAssetId=36   'Audio Silence%' --  and qTestPassAudio  in (0) and qTestPAssCC=1    and ALstreamId=5760413 --  and qTNIP='192.168.99.143'   and qTestPassCC in (-1,0)  --  
 and qVariantId >= 800
Order by   qTestRunId desc, qVariantId, qAssetId
