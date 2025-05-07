-- Query for checking Source Asset L0 properties (from Mezz Analyzer)
Use AssetLibrary
SELECT 	top(100000)	Min(A.AssetID) as AssetID, Min(A.AssetName) as AssetName, Min(FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile/@uri)[1]', 'varchar(100)')) as FilePath, Min(P.PropertyName) as PropertyName, 
-- SELECT Distinct	top(100000)	A.AssetID, A.AssetName, FileUriPath+'/'+FileListXml.value('(/fileList/resourceFile/@uri)[1]', 'varchar(100)') as FilePath, P.PropertyName, 
MIN(			Case When P.ValueStr is not null	Then P.ValueStr 
												Else Case When L1.LookupValue is not null	Then L1.LookupValue
																							Else Case When P.ValueInt is not null	Then CONVERT(varchar(10),P.ValueInt)
																																	Else Case When P.ValueFloat is not null Then CONVERT(varchar(10),P.ValueFloat)
																																											Else CONVERT(varchar(10),P.ValueBool)
																																	End
																							End
												End
			End) as Value -- , P.CreatedDateTime, P.UpdatedDateTime -- ValueStr, LookupValue, ValueInt, ValueFloat, ValueBool, ValueEnum -- Count(PropertyName) as Count -- , 
FROM        ALAsset A  WITH (NOLOCK)	INNER JOIN ALAssetProperty P WITH (NOLOCK) ON A.AssetID = P.AssetID
										INNER JOIN ALStream S WITH (NOLOCK) ON A.AssetId = S.AssetId
										LEFT OUTER JOIN LookupEnum L1 WITH (NOLOCK) ON P.ValueEnum = L1.LookupID
Where  S.IsDeleted = 0   and S.VariantId in (1)
 and A.AssetID > 1500
-- and 'a1-' + CONVERT(varchar(6), A.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  MasterTitle.MovieTitle like '%QA_Regression_2014/09/15%' ) -- and Title.TitleStateId in ('14') ) -- '11','12','15',
-- and A.AssetId in (Select AssetId from AlAssetProperty Where PropertyName = 'FILE0_ES1_AUDIO_CHAN_MAP' and ValueStr in ('L_R_C_LFE_LS_RS','L_C_R_LS_RS_LFE','5.1+Stereo') )
-- and A.AssetId in (Select AssetId from AlAssetProperty Where PropertyName = 'FILE0_FRAME_WIDTH'  and  ValueInt >= 1900) 
-- and A.AssetId in (Select AssetId from AlAssetProperty Where PropertyName = 'FILE0_FRAME_HEIGHT' and  ValueInt >= 1080) 
-- and A.AssetId in (Select AssetId from AlAssetProperty Where PropertyName = 'FILE0_FRAME_RATE'   and  ValueFloat >= 59.94) 
-- and A.AssetID in (Select AssetId from AlAssetProperty Where PropertyName = 'SCAN_TYPE'  ) -- and  ValueEnum=517) --	517	'Progressive', 518 'Interlaced'
-- and A.AssetId in (Select AssetId from AlAssetProperty Where PropertyName = 'FILE0_ASPECT_RATIO' and  ValueStr = '16:9') 
-- and A.AssetId in (Select AssetId from ALStream S Inner Join ALStreamProperty P On S.StreamID=P.StreamID where  S.IsDeleted=0  and PropertyName like '%CC%' and P.ValueStr like '%08'  ) 
 and A.AssetId in (Select AssetId from AlAssetProperty WITH (NOLOCK) Where PropertyName like 'FILE__ES%LANGUAGE' and  ValueStr not in('xxx','eng','en-US') )
-- and (A.AssetName like '%SweetHome%'  )
-- and PropertyName like '%AUDIO%'
 and PropertyName Like 'FILE__ES%LANGUAGE'  -- 'FILE%_ES%_AUDIO_CODEC' -- '%CHAN_POS' -- 'FILE__ES__AUDIO__AUDIOCHANNELGROUP%CHAN_MAP' -- and (ValueStr='L_R_C_LFE_LS_RS' OR  ValueStr='L_C_R_LS_RS_LFE' ) -- ValueStr='5.1+Stereo') -- 
  and  ValueStr not in('eng','en-US')
-- and PropertyName in ('FILE0_FRAME_RATE','SCAN_TYPE' )  -- ,
-- and (PropertyName in ('FILE0_CONTAINER','FILE0_ASPECT_RATIO','SCAN_TYPE','TIMECODE') Or PropertyName like 'FILE0_FRAME_%' Or ( PropertyName Like '%AUDIO%' )  Or ( PropertyName Like '%VIDEO%' ) ) -- 
-- and ValueStr not in ('Blockbuster','Deluxe','LGE','DDM','GDMX','Starz') -- SOURCE_FACILITY
-- and ValueStr not like '%SampleRate48K%' --  ('Comedy Central','Nickelodeon','SpikeTV','MTV') -- SUB_STUDIO
 and ( (FileUriPath like '_Charter%' and FileUriPath not like '_QASmoke%')
	OR A.AssetId in (Select DISTINCT A.AssetId From  ALAsset A WITH (NOLOCK) LEFT OUTER JOIN CPI..CustomerAsset CA WITH (NOLOCK) ON 'a1-'+CONVERT(varchar(8),A.AssetId) = CA.AssetId  LEFT OUTER JOIN CPI..Customer C WITH (NOLOCK) ON CA.CustomerID = C.CustomerID
						Where A.IsDeleted=0  and  A.AssetID>=15000  and  A.Duration>0  and  C.CustomerName in ('Charter','CharterTWC','CharterBackfill') )  ) -- 'Deluxe Digital Distributions','Zip.ca','Blockbuster','Dish','Starz','LGE','QA Test','MoviePlex','Encore','Sensio','Barnes and Noble','Charter','B&N Test','Trial Customer','Sandbox','Spirit Clips','Rogers','Choose Digital','Omni','MobiTV','Samsung','Vudu','Cineplex','Spigot','FilmFresh','AT&T','Frontier','Du', 'Shaw', 'AT&T Entertainment Zone', 'AT&T Maritime', 'Du_Website', 'ATT POC', 'Redbox', 'Big Starz', 'FrontierEST', 'DirecTV', 'MBC', 'Bell', 'TalkTalk', 'Partner', 'DL3', 'Videotron', 'CharterTWC', 'TalkTalkSVOD') ) )  -- C.CustomerName is NULL  OR   
-- and P.PropertyName = 'CC_EMBEDDED'
-- and P.UpdatedDateTime >= '2015-06-28 00:00:00.000'
GROUP BY  A.AssetId -- PropertyName, ValueStr, LookupValue, ValueInt, ValueFloat, ValueBool
ORDER BY  A.AssetId, PropertyName, Value -- 

-- Select * from ValueEnum  where LookupGroup like 'ALScanType%' --
-- Select * from LookupEnum where LookupGroup like 'ALScanType%' --  LookupValue like 'Interl%' --  
-- Insert into LookupEnum (LookupGroup, LookupValue, DisplaySequence, CreatedBy, LookupDescription) Values ('ALScanType','MBAFF ',7,'D3DBA','MBAFF')
-- Insert into ValueEnum (LookupID, LookupGroup, LookupValue, DisplaySequence, CreatedBy, LookupDescription) Values (575,'ALScanType','MBAFF ',7,'D3DBA','MBAFF')
-- Select * from ALAssetProperty where AssetID  in (595359) and PropertyName = 'SCAN_TYPE'
-- Insert into ALAssetProperty (AssetID, DomainTypeID, PropertyName, ValueTypeID, ValueEnum) Values (5924,432,'SCAN_TYPE',428,517)
-- Delete ALAssetProperty  Where AssetID in (2138,2139,2157,5924)  and PropertyName = 'SCAN_TYPE'
/* PropertyName    Values
ACCEPTABLE_QUALITY
ACQUISITION_METHOD
ASSOCIATED_ID
EPISODE_NUM
EPISODE_NUMBER
ID
LANGUAGE
NOTES
PRODUCTION_ID
REGION
RELEASE_DATE
SCAN_TYPE
SEASON_NUMBER
SOURCE_FACILITY
SUB_STUDIO
SUBTITLE_LANGUAGE
TERRITORY
THREE_D
TICKET_ID
TIMECODE_IN
TIMECODE_OUT
TV_SEASON
FILE0_ASPECT_RATIO
FILE0_CONTAINER
FILE0_FRAME_HEIGHT
FILE0_FRAME_RATE
FILE0_FRAME_WIDTH
FILE0_ES0_VIDEO_AVG_BITRATE
FILE0_ES0_VIDEO_BITRATE_TYPE
FILE0_ES0_VIDEO_CODEC
FILE0_ES1_AUDIO_AVG_BITRATE
FILE0_ES1_AUDIO_BITDEPTH
FILE0_ES1_AUDIO_CHAN_MAP
FILE0_ES1_AUDIO_CHAN_POS
FILE0_ES1_AUDIO_CODEC
FILE0_ES1_AUDIO_LANGUAGE
FILE0_ES1_AUDIO_PEAK_BITRATE
FILE0_ES1_AUDIO_SAMPLE_RATE
FILE0_ES10_AUDIO_AVG_BITRATE
FILE0_ES10_AUDIO_BITDEPTH
FILE0_ES10_AUDIO_CHAN_MAP
FILE0_ES10_AUDIO_CODEC
FILE0_ES10_AUDIO_LANGUAGE
FILE0_ES10_AUDIO_SAMPLE_RATE
FILE0_ES2_AUDIO_AVG_BITRATE
FILE0_ES2_AUDIO_BITDEPTH
FILE0_ES2_AUDIO_CHAN_MAP
FILE0_ES2_AUDIO_CHAN_POS
FILE0_ES2_AUDIO_CODEC
FILE0_ES2_AUDIO_LANGUAGE
FILE0_ES2_AUDIO_SAMPLE_RATE
FILE0_ES3_AUDIO_AVG_BITRATE
FILE0_ES3_AUDIO_BITDEPTH
FILE0_ES3_AUDIO_CHAN_MAP
FILE0_ES3_AUDIO_CHAN_POS
FILE0_ES3_AUDIO_CODEC
FILE0_ES3_AUDIO_LANGUAGE
FILE0_ES3_AUDIO_SAMPLE_RATE
FILE0_ES4_AUDIO_AVG_BITRATE
FILE0_ES4_AUDIO_BITDEPTH
FILE0_ES4_AUDIO_CHAN_MAP
FILE0_ES4_AUDIO_CHAN_POS
FILE0_ES4_AUDIO_CODEC
FILE0_ES4_AUDIO_LANGUAGE
FILE0_ES4_AUDIO_SAMPLE_RATE
FILE0_ES5_AUDIO_AVG_BITRATE
FILE0_ES5_AUDIO_BITDEPTH
FILE0_ES5_AUDIO_CHAN_MAP
FILE0_ES5_AUDIO_CHAN_POS
FILE0_ES5_AUDIO_CODEC
FILE0_ES5_AUDIO_LANGUAGE
FILE0_ES5_AUDIO_SAMPLE_RATE
FILE0_ES6_AUDIO_AVG_BITRATE
FILE0_ES6_AUDIO_BITDEPTH
FILE0_ES6_AUDIO_CHAN_MAP
FILE0_ES6_AUDIO_CHAN_POS
FILE0_ES6_AUDIO_CODEC
FILE0_ES6_AUDIO_LANGUAGE
FILE0_ES6_AUDIO_SAMPLE_RATE
FILE0_ES7_AUDIO_AVG_BITRATE
FILE0_ES7_AUDIO_BITDEPTH
FILE0_ES7_AUDIO_CHAN_MAP
FILE0_ES7_AUDIO_CHAN_POS
FILE0_ES7_AUDIO_CODEC
FILE0_ES7_AUDIO_LANGUAGE
FILE0_ES7_AUDIO_SAMPLE_RATE
FILE0_ES8_AUDIO_AVG_BITRATE
FILE0_ES8_AUDIO_BITDEPTH
FILE0_ES8_AUDIO_CHAN_MAP
FILE0_ES8_AUDIO_CHAN_POS
FILE0_ES8_AUDIO_CODEC
FILE0_ES8_AUDIO_LANGUAGE
FILE0_ES8_AUDIO_SAMPLE_RATE
FILE0_ES9_AUDIO_AVG_BITRATE
FILE0_ES9_AUDIO_BITDEPTH
FILE0_ES9_AUDIO_CHAN_MAP
FILE0_ES9_AUDIO_CODEC
FILE0_ES9_AUDIO_LANGUAGE
FILE0_ES9_AUDIO_SAMPLE_RATE
FILE1_ES0_AUDIO_AVG_BITRATE
FILE1_ES0_AUDIO_BITDEPTH
FILE1_ES0_AUDIO_CHAN_MAP
FILE1_ES0_AUDIO_CHAN_POS
FILE1_ES0_AUDIO_CODEC
FILE1_ES0_AUDIO_LANGUAGE
FILE1_ES0_AUDIO_SAMPLE_RATE
FILE2_ES0_AUDIO_AVG_BITRATE
FILE2_ES0_AUDIO_BITDEPTH
FILE2_ES0_AUDIO_CHAN_POS
FILE2_ES0_AUDIO_CODEC
FILE2_ES0_AUDIO_LANGUAGE
FILE2_ES0_AUDIO_SAMPLE_RATE
FILE3_ES0_AUDIO_AVG_BITRATE
FILE3_ES0_AUDIO_BITDEPTH
FILE3_ES0_AUDIO_CHAN_POS
FILE3_ES0_AUDIO_CODEC
FILE3_ES0_AUDIO_LANGUAGE
FILE3_ES0_AUDIO_SAMPLE_RATE
FILE4_ES0_AUDIO_AVG_BITRATE
FILE4_ES0_AUDIO_BITDEPTH
FILE4_ES0_AUDIO_CHAN_POS
FILE4_ES0_AUDIO_CODEC
FILE4_ES0_AUDIO_LANGUAGE
FILE4_ES0_AUDIO_SAMPLE_RATE
FILE5_ES0_AUDIO_AVG_BITRATE
FILE5_ES0_AUDIO_BITDEPTH
FILE5_ES0_AUDIO_CHAN_POS
FILE5_ES0_AUDIO_CODEC
FILE5_ES0_AUDIO_LANGUAGE
FILE5_ES0_AUDIO_SAMPLE_RATE
FILE6_ES0_AUDIO_AVG_BITRATE
FILE6_ES0_AUDIO_BITDEPTH
FILE6_ES0_AUDIO_CHAN_POS
FILE6_ES0_AUDIO_CODEC
FILE6_ES0_AUDIO_LANGUAGE
FILE6_ES0_AUDIO_SAMPLE_RATE
*/