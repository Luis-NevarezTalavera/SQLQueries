-- Query for checking Source Asset L0 properties (from Mezz Analyzer)
USE AssetLibrary

DECLARE @TotalAssets AS Float
SET @TotalAssets = ( SELECT DISTINCT Count(A.AssetId) as TotalAssets
FROM	ALAsset A  WITH (NOLOCK)	INNER JOIN		ALStream S		WITH (NOLOCK) ON  A.AssetID = S.AssetID 
WHERE	S.VariantID = 1 and A.IsDeleted = 0  and FileUriPath  not like '_QASmokeTest%'   and A.Duration > 0   and A.AssetID >= 15000  and  PATINDEX('%\%',S.FileUriPath)>=1 );

SELECT Count(*) as AssetsCount, ROUND((Count(*)/@TotalAssets)*100,5) as Percentage, Max(AssetID) as AssetId, Case  When Container Is Null Then 'bbmx' Else Container End as Container, VideoCodec, AudioCodec, FPS, ScanType, ScanOrder, Width, Height, DAR, FirstAudio, LastAudio, Tracks, AudioSampleRate, AudioBitDepth, CC_EMBEDDED --, VideoAvgBitRate, AudioAvgBitRate
FROM ( SELECT DISTINCT  TOP(1000) -- 
	A.AssetID, A.AssetName, FileUriPath+'\'+SUBSTRING(CONVERT(varchar(8000),FileListXML),48, PATINDEX('%"%', SUBSTRING(CONVERT(varchar(8000),FileListXML),50,200) )+1) as FilePath 
	,(Select A1.ValueStr from ALAssetProperty A1 WITH (NOLOCK) Where A1.PropertyName = 'FILE0_CONTAINER' and A1.AssetID = A.AssetId ) as Container 
	,(Select A6.ValueStr from ALAssetProperty A6 WITH (NOLOCK) Where A6.PropertyName = 'FILE0_ES0_VIDEO_CODEC' and A6.AssetID = A.AssetId ) as VideoCodec 
	,(Select Top(1) A7.ValueStr from ALAssetProperty A7 WITH (NOLOCK) Where A7.PropertyName like '%AUDIO_CODEC' and A7.AssetID = A.AssetId ) as AudioCodec 
	,(Select A10.ValueStr from ALAssetProperty A10 WITH (NOLOCK) Where A10.PropertyName = 'FILE0_ASPECT_RATIO' and A10.AssetID = A.AssetId ) as DAR 
	,(Select A2.ValueInt from ALAssetProperty A2 WITH (NOLOCK) Where A2.PropertyName = 'FILE0_FRAME_WIDTH' and A2.AssetID = A.AssetId ) as Width 
	,(Select A3.ValueInt from ALAssetProperty A3 WITH (NOLOCK) Where A3.PropertyName = 'FILE0_FRAME_HEIGHT' and A3.AssetID = A.AssetId ) as Height 
	,(Select ROUND(A4.ValueFloat,3) from ALAssetProperty A4 WITH (NOLOCK) Where A4.PropertyName = 'FILE0_FRAME_RATE' and A4.AssetID = A.AssetId ) as FPS 
	,(Select L1.LookupValue from ALAssetProperty A5 WITH (NOLOCK) LEFT OUTER JOIN LookupEnum L1 WITH (NOLOCK) ON A5.ValueEnum = L1.LookupID Where A5.PropertyName = 'SCAN_TYPE' and A5.AssetID = A.AssetId ) as ScanType 
	, A.DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/ScanOrder)[1]', 'varchar(20)') as ScanOrder
	, A.DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/BitDepth)[1]', 'varchar(20)') as BitDepth
	,(Select Top(1) A8.ValueStr from ALAssetProperty A8 WITH (NOLOCK) Where (A8.PropertyName like '%AUDIOCHANNELGROUP%_CHAN_MAP'  or  A8.PropertyName like '%AUDIO_CHAN_MAP' ) and A8.AssetID = A.AssetId Order by AssetPropertyID Asc) as FirstAudio  -- '%AUDIOCHANNELGROUP__CHAN_MAP'
	,(Select Top(1) A15.ValueStr from ALAssetProperty A15 WITH (NOLOCK) Where (A15.PropertyName like '%AUDIOCHANNELGROUP%_CHAN_MAP'  or  A15.PropertyName like '%AUDIO_CHAN_MAP' ) and A15.AssetID = A.AssetId Order by AssetPropertyID Desc) as LastAudio -- '%AUDIOCHANNELGROUP__CHAN_MAP'
	,(Select Count(A16.ValueStr) from ALAssetProperty A16 WITH (NOLOCK) Where A16.PropertyName like '%CHAN_POS' and A16.AssetID = A.AssetId ) as Channels 
	,(Select Count(A13.ValueStr) from ALAssetProperty A13 WITH (NOLOCK) Where A13.PropertyName like '%AUDIO_CODEC' and A13.AssetID = A.AssetId ) as Tracks 
	,IsNull((Select Top(1) Case When A12.ValueStr='SampleRate48K' Then '48000' Else Case When A12.ValueStr in ('SampleRate44K','SampleRate441K','SampleRate44_1K') Then '44100' Else Case When A12.ValueStr='SampleRate32K' Then '32000' Else A12.ValueStr End End End as ValueStr from ALAssetProperty A12 WITH (NOLOCK) Where A12.PropertyName like '%AUDIO_SAMPLE_RATE' and A12.AssetID = A.AssetId ),'48000') as AudioSampleRate 
	,IsNull((Select Top(1) Case When A14.ValueStr='BitDepth16' Then '16' Else Case When A14.ValueStr='BitDepth24' Then '24' Else Case When A14.ValueStr='BitDepth8' Then '8' Else A14.ValueStr End End End as bits  from ALAssetProperty A14 WITH (NOLOCK) Where A14.PropertyName like '%AUDIO_BITDEPTH' and A14.AssetID = A.AssetId ),'16') as AudioBitDepth 
--	,(Select A9.ValueStr from ALAssetProperty A9 WITH (NOLOCK) Where A9.PropertyName = 'FILE0_ES0_VIDEO_AVG_BITRATE' and A9.AssetID = A.AssetId ) as VideoAvgBitRate 
--	,(Select Top(1) A11.ValueStr from ALAssetProperty A11 WITH (NOLOCK) Where A11.PropertyName like '%AUDIO_AVG_BITRATE' and A11.AssetID = A.AssetId ) as AudioAvgBitRate 
	,IsNull((Select Top(1) SP.ValueStr  from AlStream S1 WITH (NOLOCK) Left outer Join ALStreamProperty SP ON S1.StreamID = SP.StreamID Where S1.VariantId in (1) and SP.PropertyName = 'CC_EMBEDDED' and S1.AssetId = A.AssetId ),'None') as CC_EMBEDDED 
	,A.Duration, A.CreatedDateTime, A.UpdatedDateTime 
	FROM  ALAsset A WITH (NOLOCK)  INNER JOIN  ALStream S WITH (NOLOCK) ON A.AssetID = S.AssetID 
	WHERE S.VariantID in (1) and A.IsDeleted in (0)  and A.AssetID>=1500  and  PATINDEX('%\%',S.FileUriPath)>=1
	 and FileUriPath not  like '_QASmokeTest%'  -- and (A.Duration < 500)  -- 
	 and (A.AssetName not like '%_ART_%')
	-- and A.AssetID in (2600583) 
	-- and S.AssetId in (Select TA.AssetId From ALTitle T With (NOLOCK) Left Outer Join ALTitleAsset TA ON T.TitleID = TA.TitleID  Where  TitleName  like 'QA_FF_Regression_2017/08/25_539%'  ) 
	 and A.AssetId in (Select DISTINCT A.AssetId From  ALAsset A  LEFT OUTER JOIN CPI..CustomerAsset CA WITH (NOLOCK) ON 'a1-'+CONVERT(varchar(8),A.AssetId) = CA.AssetId  LEFT OUTER JOIN CPI..Customer C WITH (NOLOCK) ON CA.CustomerID = C.CustomerID
						Where A.IsDeleted=0 and A.AssetID>=15000 and A.Duration>0 and (C.CustomerName is NULL  OR   C.CustomerName in ('Charter','CharterTWC','CharterBackfill') ) ) --'Charter','Deluxe Digital Distributions','Zip.ca','Blockbuster','Dish','Starz','LGE','QA Test','MoviePlex','Encore','Sensio','Barnes and Noble','Charter','B&N Test','Trial Customer','Sandbox','Spirit Clips','Rogers','Choose Digital','Omni','MobiTV','Samsung','Vudu','Cineplex','Spigot','FilmFresh','AT&T','Frontier') ) ) 
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where  PropertyName = 'FILE0_CONTAINER'		and  ValueStr Is Null) -- in ('MXF') )  --  'AVI','bbxm','MPEG4','MPEGPS','MPEGTS','QuickTime','MXF'
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where  PropertyName = 'FILE0_ES0_VIDEO_CODEC'	and  ValueStr  in ('ProRes') )  -- 'AVC','CineForm','DV25','DV50','HuffYUV','MjpegA','MPEG1','MPEG2','MPEG4','MPEG-4 Visual','MPEG Video','ProRes','RAW','RGB','RLE','VC3','VC-3','YUV'
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where  PropertyName like '%AUDIO_CODEC'		and  ValueStr  in ('AAC') )  -- 'AAC','DolbyDigital','MPEG Audio','MPEG','MPEGL2','PCM','WMA9'
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName = 'FILE0_FRAME_WIDTH'  and  ValueInt  in (720)) --160,352,528,640,704,720,854,864,872,912,960,1024,1066,1248,1280,1440,1800,1880,1888,1920,2240) ) 
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName = 'FILE0_FRAME_HEIGHT' and  ValueInt  < 720 ) -- 120,264,272,296,304,308,320,336,344,360,384,388,392,408,432,472,480,486,512,576,608,702,704,720,816,960,1036,1038,1062,1080) ) 
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName = 'FILE0_ASPECT_RATIO' and  ValueStr  in ('4:3')) --'1.667','1.860','1.897','2.000','2.35:1','2.40:1','3:2','4:3','5:4','16:9') ) 
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName = 'FILE0_FRAME_RATE' and  ROUND(ValueFloat,3) in (50.000)) -- 23.976,25.000,29.970,50.000,59.940,60.000) ) 
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Left Outer Join LookupEnum ON ValueEnum = LookupID Where PropertyName = 'SCAN_TYPE'  and  LookupValue  = ('Interlaced') ) -- 'Progressive','Interlaced','Interlaced-HardTelecine','Interlaced-SoftTelecine','Progressive-HardTelecine') ) -- (517,518,519,520,546) ) --	517='Progressive', 518='Interlaced', 519='Interlaced-HardTelecine', 520='Interlaced-SoftTelecine', 546='Progressive-HardTelecine'
	-- and (  A.AssetId in (Select AssetId from AlAsset WITH (NOLOCK) Where A.DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/ScanOrder)[1]', 'varchar(20)') not in ('BFF','TFF') )  -- 'BFF','TFF',NULL,''
		--	OR A.AssetId in (Select AssetId from AlAsset WITH (NOLOCK) Where A.DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/ScanOrder)[1]', 'varchar(20)') Is Null )   )-- 'BFF','TFF',NULL,''
	-- and A.AssetId in (Select AssetId from AlAsset WITH (NOLOCK) Where A.DescriptorXML.value('(/OMSAssetDescriptor/files/file/tracks/track/BitDepth)[1]', 'varchar(20)') not in ('','0','8') )  -- 'BFF','TFF',NULL,''
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName like '%ES1_AUDIO_CHAN_MAP' and ValueStr  in ('Stereo') ) -- 'Mono','Mono2Ch','Stereo','L_C_R_LFE','L_R_C_LFE_LS_RS','L_C_R_LS_RS_LFE','L_R_C_LFE_Lss_Rss_Lsr_Rsr','5.1+Stereo','7.1') )
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName like '%AUDIO_SAMPLE_RATE' and ValueStr  In ('0','8000','44100','47952','48000','46034','50000','50050','SampleRate44K','SampleRate441K','SampleRate44_1K','SampleRate32K','SampleRate48K') )
	-- and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName like '%AUDIO_BITDEPTH'     and ValueStr  in ('0','8','16','24','BitDepth8','BitDepth16','BitDepth24') )
	-- and A.AssetId in (Select S.AssetId  From	ALStream S  WITH (NOLOCK) Where S.VariantId in(4412) and S.IsDeleted=0 )
	-- and A.AssetId in (Select S.AssetId  From	ALStream S  WITH (NOLOCK) Left Outer JOIN ALElemStream ES  WITH (NOLOCK) ON S.StreamID = ES.StreamID  Left Outer Join ALElemStreamLanguage ESL  WITH (NOLOCK) On ES.ElemStreamID = ESL.ElemStreamID  Left Outer Join PresentationType PT  WITH (NOLOCK) On ES.PresentationTypeID = PT.LookupID
		-- Where  ES.IsDeleted = 0  and PT.LookupValue in ('ClosedCaptioning','CCConformed','Subtitle','Video','Audio')  and ESL.LCID  in ('es-MX','es-ES','en-US') and ESL.LCID is not NULL  )
	-- and CONVERT(varchar(8000),FileListXML) like '%pid-bravotv.com-aid-NBCU2014111800000983-movie%'
	-- and A.CreatedDateTime < '2014-01-01 00:00:00.000'
	Order by AssetID desc
	) as AssetsTemp
GROUP BY 				Container, VideoCodec, AudioCodec, FPS, ScanType, ScanOrder, Width, Height, DAR, FirstAudio, LastAudio, Tracks, AudioSampleRate, AudioBitDepth, CC_EMBEDDED -- VideoAvgBitRate, AudioAvgBitRate
ORDER BY Count(*) desc, Container, VideoCodec, AudioCodec, FPS, ScanType, ScanOrder, Width, Height, DAR, FirstAudio, LastAudio, Tracks, AudioSampleRate, AudioBitDepth, CC_EMBEDDED -- VideoAvgBitRate, AudioAvgBitRate

/* CustomerName
Deluxe Digital Distributions
Zip.ca
Blockbuster
Dish
Starz
LGE
QA Test
MoviePlex
Encore
Sensio
Barnes and Noble
Charter
B&N Test
Trial Customer
Sandbox
Spirit Clips
Rogers
Choose Digital
Omni
MobiTV
Samsung
Vudu
Cineplex
Spigot
FilmFresh
AT&T
Frontier
*/
-- select top(10) * from ALAsset