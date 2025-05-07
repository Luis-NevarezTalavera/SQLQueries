Use QATest
-- Expected L2s/L1s
Select qRelease, R.qEnvironment, R.qTestRunId, R.qRegressionTitle, T.qAssetId, ALassetId, qAssetName, T.qAssetState, qStatus, T.Priority, ROW_NUMBER() OVER(Order By  R.qRelease desc, R.qTestRunId desc, ALassetId, T.qAssetId ) AS Seq_Start, 
T.Sequence as Seq_Finish, (ROW_NUMBER() OVER(Order By  R.qRelease desc, R.qTestRunId desc, ALassetId, T.qAssetId ) - T.Sequence) as Poss_Change, T.qTestTimeStamp 
From QARelease R    Left outer join QATestRun T on R.qTestRunId=T.qTestRunId
                    Left outer join QAAsset A   on T.qAssetId=A.qAssetId
                    Left outer join AssetEventPriority AP  on AP.qAssetId=A.qAssetId
Where  R.qEnvironment=AP.Environment and (AP.Summary='WF: Notification Complete' OR AP.Summary Is Null) and  R.qTestRunId >= 180 -- and  T.qAssetId=99

-- CheckSums StatisticqAssetIds by L0 Properties
Select qRelease, Min(Left(qSVNVerTN,8)) as qSVNVerTN, Min(qTestTimeStamp) as qTestTimeStamp, qTestRunId, qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, SUM(New) as New, SUM(Pass) as Pass, SUM(Inconclusive) as Inconclusive, 
SUM(Inc_Video) as Inc_Video, SUM(Inc_Audio) as Inc_Audio, SUM(Inc_CCs) as Inc_CCs, SUM(Fail) as Fail, SUBSTRING(qStatus,0,50) as qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth
From (	Select R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment,  T.qAssetId, T.ALassetId, A.qAssetName, T.qAssetState, T.qStatus as AssetStatus, 
			Case  When qTestPassL1 = 'New'  Then Count(qTestPassL1) Else 0 End as New, 
			Case  When qTestPassL1 = 'Pass' Then Count(qTestPassL1) Else 0 End as Pass, 
			Case  When qTestPassL1 = 'Inconcl'  Then Count(qTestPassL1) Else 0 End as Inconclusive, 
			Case  When qTestPassVideo = 'Inconcl'   Then Count(qTestPassVideo) 	Else 0 End as Inc_Video, 
			Case  When qTestPassAudio = 'Inconcl'   Then Count(qTestPassAudio) 	Else 0 End as Inc_Audio, 
			Case  When qTestPassCC    = 'Inconcl'   Then Count(qTestPassCC) 	Else 0 End as Inc_CCs, 
			Case  When qTestPassL1    = 'Fail'  Then Count(qTestPassL1) Else 0 End as Fail, 
			SUBSTRING(S.qStatus,0,100) as qStatus, Min(CONVERT(Varchar(10), T.qTestTimeStamp, 111 )) as qTestTimeStamp, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth
		From QATestRun T	Left Outer Join QARelease R	on T.qTestRunId=R.qTestRunId 
							Left Outer Join QAAsset A	on T.qAssetId=A.qAssetId 
							Left Outer Join QAStream S	on T.ALassetId=S.ALassetId  
		Where S.qTestRunId>= 156 -- and S.qStatus='' -- and  s.qEnvironment = 'qa1' -- and qAssetName like '%1080p%2-0%'-- -- and S.qAssetId in (37,43,61,62) --  and qVariantId in (1013) and qTestPassL1  in (-1,0) -- and  R.qRelease like '3.11.%'
		Group by  R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment, T.qAssetId, T.ALassetId, A.qAssetName, T.qAssetState, T.qStatus, qTestPassL1, qTestPassVideo, qTestPassAudio, qTestPassCC, S.qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth
	) as QAStatisticsTemp
 Group by  qRelease,		qTestRunId,		 qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, SUBSTRING(qStatus,0,50), qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth
--  Having   SUM(Inconclusive)>1  --  qStatus='' --  qAssetName like '%1080p%2-0%' and qAssetName not like '%5-1%'  SUM(Fail)=0 -- OR  
 Order by  qRelease desc,	qTestRunId desc, qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, SUBSTRING(qStatus,0,50), qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth

-- Group by VariantId Properties
Select qRelease, Left(qSVNVerTN,8) as qSVNVerTN, Min(qTestTimeStamp) as qTestTimeStamp, qTestRunId, qEnvironment, SUM(New) as New, SUM(Pass) as Pass, SUM(Inconclusive) as Inconclusive, SUM(Inc_Video) as Inc_Video, SUM(Inc_Audio) as Inc_Audio, SUM(Inc_CCs) as Inc_CCs, SUM(Fail) as Fail, qStatus, VariantId, 
Muxer,OutputFileExtension,VideoType,VideoEncoder,VideoFrameRate,VideoEmbedCCs,VideoPassthruCCs,VideoEmbedSCTE35,VideoSupportedFrameRates,VideoCBRVBR,VideoGOPLength,VideoMaxBFrames,VideoAdaptiveBFrames,VideoSceneDetection,VideoProfile,VideoLevel,VideoPAR,VideoPasses, AudioType,AudioTargetLoudnessLKFS,AudioUseSpeechGating,AudioSpeechGatingThreshold,AudioMaxTruePeak,AudioDynamicRangeCompression,AudioDRCThreshold,AudioDialNorm,AudioChannelFormat,AudioCBRVBR,AudioBitrate,AudioMaxTracks
From (	Select R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment, 
			Case  When qTestPassL1 = 'New'  Then Count(qTestPassL1) Else 0 End as New, 
			Case  When qTestPassL1 = 'Pass' Then Count(qTestPassL1) Else 0 End as Pass, 
			Case  When qTestPassL1 = 'Inconcl'  Then Count(qTestPassL1) Else 0 End as Inconclusive, 
			Case  When qTestPassVideo = 'Inconcl'   Then Count(qTestPassVideo) 	Else 0 End as Inc_Video, 
			Case  When qTestPassAudio = 'Inconcl'   Then Count(qTestPassAudio) 	Else 0 End as Inc_Audio, 
			Case  When qTestPassCC    = 'Inconcl'   Then Count(qTestPassCC) 	Else 0 End as Inc_CCs, 
			Case  When qTestPassL1    = 'Fail'  Then Count(qTestPassL1) Else 0 End as Fail, 
			SUBSTRING(S.qStatus,0,100) as qStatus, Min(CONVERT(Varchar(10), T.qTestTimeStamp, 111 )) as qTestTimeStamp, VariantId,Muxer,OutputFileExtension,VideoType,VideoEncoder,VideoFrameRate,VideoEmbedCCs,VideoPassthruCCs,VideoEmbedSCTE35,VideoSupportedFrameRates,VideoCBRVBR,VideoGOPLength,VideoMaxBFrames,VideoAdaptiveBFrames,VideoSceneDetection,VideoProfile,VideoLevel,VideoPAR,VideoPasses, 
				AudioType,AudioTargetLoudnessLKFS,AudioUseSpeechGating,AudioSpeechGatingThreshold,AudioMaxTruePeak,AudioDynamicRangeCompression,AudioDRCThreshold,AudioDialNorm,AudioChannelFormat,AudioCBRVBR,AudioBitrate,AudioMaxTracks
		From QATestRun T	Left Outer Join QARelease R	on T.qTestRunId=R.qTestRunId 
							Left Outer Join QAStream S	on T.ALassetId=S.ALassetId  
							Inner Join PipelineConfig P	on 'v1-'+CONVERT(varchar(8),S.qVariantId)=P.VariantId
		Where S.qTestRunId >= 158 -- and  s.qEnvironment = 'qa1' -- and qAssetName like '%1080p%2-0%'-- -- and S.qAssetId in (37,43,61,62) --  and qVariantId in (1013) and qTestPassL1  in (-1,0) -- and  R.qRelease like '3.11.%'
		Group by  R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment, ProfileId, VariantId, qTestPassL1, qTestPassVideo, qTestPassAudio, qTestPassCC, S.qStatus, 
		Muxer,OverallBitrate,OutputFileExtension,VideoType,VideoEncoder,VideoFrameRate,VideoEmbedCCs,VideoPassthruCCs,VideoEmbedSCTE35,VideoSupportedFrameRates,VideoCBRVBR,VideoGOPLength,VideoMaxBFrames,VideoAdaptiveBFrames,VideoSceneDetection,VideoProfile,VideoLevel,VideoPAR,VideoPasses, AudioType,AudioTargetLoudnessLKFS,AudioUseSpeechGating,AudioSpeechGatingThreshold,AudioMaxTruePeak,AudioDynamicRangeCompression,AudioDRCThreshold,AudioDialNorm,AudioChannelFormat,AudioCBRVBR,AudioBitrate,AudioMaxTracks
	) as QAStatisticsTemp
 Group by  qRelease,      Left(qSVNVerTN,8), qTestRunId,      qEnvironment, VariantId, qStatus, Muxer,OutputFileExtension,VideoType,VideoEncoder,VideoFrameRate,VideoEmbedCCs,VideoPassthruCCs,VideoEmbedSCTE35,VideoSupportedFrameRates,VideoCBRVBR,VideoGOPLength,VideoMaxBFrames,VideoAdaptiveBFrames,VideoSceneDetection,VideoProfile,VideoLevel,VideoPAR,VideoPasses, AudioType,AudioTargetLoudnessLKFS,AudioUseSpeechGating,AudioSpeechGatingThreshold,AudioMaxTruePeak,AudioDynamicRangeCompression,AudioDRCThreshold,AudioDialNorm,AudioChannelFormat,AudioCBRVBR,AudioBitrate,AudioMaxTracks
 -- Having SUM(Inconclusive)>=1  --  qStatus='' -- SUM(Fail)=0 -- OR  
 Order by  qRelease desc, Left(qSVNVerTN,8), qTestRunId desc, qEnvironment, VariantId, qStatus, Muxer,OutputFileExtension,VideoType,VideoEncoder,VideoFrameRate,VideoEmbedCCs,VideoPassthruCCs,VideoEmbedSCTE35,VideoSupportedFrameRates,VideoCBRVBR,VideoGOPLength,VideoMaxBFrames,VideoAdaptiveBFrames,VideoSceneDetection,VideoProfile,VideoLevel,VideoPAR,VideoPasses, AudioType,AudioTargetLoudnessLKFS,AudioUseSpeechGating,AudioSpeechGatingThreshold,AudioMaxTruePeak,AudioDynamicRangeCompression,AudioDRCThreshold,AudioDialNorm,AudioChannelFormat,AudioCBRVBR,AudioBitrate,AudioMaxTracks
-- select * from PipelineConfig
-- Embedded Captions Sync
Select 	S.qTestRunId, Count(qVariantId) as Count, Max(S.qSVNVerTN) as qSVNVerTN, SUBSTRING(qElementaryCCfileSRT,PATINDEX('%4__00:0%',qElementaryCCfileSRT),70) as qElementaryCCfileSRT, qTestPassCC, -- qStatus, 
		Max(IsNull(VideoEmbedCCs,'null')) as EmbedCCs, Max(IsNull(VideoPassthruCCs,'Mainconcept')) as PassthruCCs, 
		Max(qAssetName) as ExampleL0Mezz, Max(CONVERT(Varchar(5),qAssetFPS)) as L0MezzFPS, Max(Case When PATINDEX('%0i%',qAssetName)>=1 Then 'Interlaced' else Case When PATINDEX('%6i%',qAssetName)>=1 Then 'Interlaced' else 'Progressive' End End) as L0MezzScanType, 
		Max(A.qAssetId) as ExQAAssetId, Max(ALassetId) as ExALAssetId, Max(qVariantId) as ExVariantId, Max(IsNull(CONVERT(varchar(100),VideoFrameRate),VideoSupportedFrameRates)) as L1FPSScanType, Max(VideoGOPLength) as GOPLength, 
		Max(VideoMaxBFrames) as L1MaxBFrames, Max(VideoSceneDetection) as L1SceneDetection, Max(VideoAdaptiveBFrames) as L1AdaptiveBFrames, Max(qFileName) as L1FileName, Max(qStreamPath) as L1Path
From QAStream S	Left Outer Join PipelineConfig P ON 'v1-' + CONVERT(varchar(10),S.qVariantId) = P.VariantId
				Left Outer Join QAAsset A ON S.qAssetId = A.qAssetId
Where  P.VideoType>''  and   qTestRunId >= 174  and qTestPassCC in ('Pass','Fail','New','Inconcl') 
-- and qVariantId in (415) 
 and  A.qAssetId in (58) -- 51,58,59,61,68,101) 
 and qElementaryCCfileSRT >'' 
Group by  SUBSTRING(qElementaryCCfileSRT,PATINDEX('%4__00:0%',qElementaryCCfileSRT),70), VideoEmbedCCs, VideoPassthruCCs, qTestPassCC, S.qTestRunId -- S.qStatus, 
-- Having Count(qVariantId) > 2
Order by  SUBSTRING(qElementaryCCfileSRT,PATINDEX('%4__00:0%',qElementaryCCfileSRT),70), VideoEmbedCCs, VideoPassthruCCs, qTestPassCC, S.qTestRunId desc -- S.qStatus, 

-- update QAStream  set qTestPassCC=0,qStatus='CCExtractor cant Extract Captions' where qTestRunId>=101 and qElementaryCCfileSRT Is Null  and  qVariantId  in (select variantId from PipelineConfig where PassThruCCs  in ('Manzanita'))  and  qVariantId  in (select variantId from PipelineConfig where EmbeddedCCs not in ('None'))
-- update QAStream  set qTestPassCC=1,qElementaryCCfileSRT=Null,qStatus=''  where qTestRunId>=124  and ( qElementaryCCfileSRT Is Null Or qElementaryCCfileSRT ='')  and  (qStatus Is Null  OR  qStatus in ('CCExtractor cant Extract Captions',''))  and  ( qVariantId  in (select variantId from PipelineConfig where PassThruCCs  in ('Mainconcepts'))  OR  qVariantId  in (select variantId from PipelineConfig where EmbeddedCCs  in ('None')  OR  qVariantId  in (673,674,675,676) ) )  
-- Update QAStream  set qElementaryCCfileSRT = (Select top(1) qElementaryCCfileSRT from QAStream where qAssetId in (83) and qVariantId in (484,485,486,487,641) and qTestRunId>101 and qElementaryCCfileSRT>'' and qTestPassCC=1 )	Where qTestRunId>=101 and qTestRunId<=111 and qAssetId in (83) and qVariantId in (484,485,486,487,641) and qElementaryVideoCheckSum>'' and qElementaryCCfileSRT Is Null and qStatus='CCExtractor cant Extract Captions'
-- update QAStream  set qTestPassCC=1,qStatus=''     where qTestRunId>=100  and  qStatus in ('CCExtractor cant Extract Captions') and (qElementaryCCfileSRT >'' or qVariantId  in (117,431,432,475,476,536,549,627,659,664,1013)) 
-- update QAStream  set qElementaryCCfileSRT = Null,qStatus=''  where qTestRunId=100   and  qStatus in ('CCExtractor cant Extract Captions') and  (qElementaryCCfileSRT ='' or qElementaryCCfileSRT Is Null)
 
-- RAW DATA for Michel's Tablaeu
Select ROW_NUMBER() OVER(Order by T.qTestRunId, S.qAssetId, S.qVariantId) as KeyId, 
		R.qRelease, S.qSVNVerTN, T.qTestRunId, S.qEnvironment, CONVERT(Varchar(10), S.qTestTimeStamp,111) as qTestTimeStamp, VC.CustomerName as Customer, VC.Weight as Weight_Cust, 
		-- Updated Result Fields
		Case  When qTestPassL1 = -1 Then 'New' Else  Case  When qTestPassL1 = 1  Then 'Pass' Else  Case  When qTestPassL1 = 0  and S.qStatus >'' Then 'Fail' Else 'Inconclusive' End End End as Result, 
		Case  When qTestPassVideo in (-1,0)  and (S.qStatus='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_Video, 
		Case  When qTestPassAudio in (-1,0)  and (S.qStatus='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_Audio, 
		Case  When qTestPassCC    in (-1,0)  and (S.qStatus='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_CCs, 
		S.qStatus, 
		-- Original Result Fields
		Case  When qTestPassL1Ori = -1 Then 'New' Else  Case  When qTestPassL1 = 1  Then 'Pass' Else  Case  When qTestPassL1 = 0  and S.qStatusOri >'' Then 'Fail' Else 'Inconclusive' End End End as ResultOri, 
		Case  When qTestPassVideoOri in (-1,0)  and (S.qStatusOri='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_VideoOri, 
		Case  When qTestPassAudioOri in (-1,0)  and (S.qStatusOri='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_AudioOri, 
		Case  When qTestPassCCOri    in (-1,0)  and (S.qStatusOri='' OR S.qStatus is NULL) Then 1 Else 0 End as Inc_CCsOri, 
		S.qStatusOri, 
		-- TN IP Address, EncodeTime, MuxTime
		S.qTNIP, S.qEncodeTime, S.qMuxTime, 
		-- L1 Pipeline Config Properties
		S.qVariantId, Encoder,Muxer,FileType,VideoType,Width,Height,FrameRates,EmbeddedCCs,EmbeddedSCTE35,AudioType,AudioBRType,AudioChannels,
		-- L0 Source Asset Properties
		A.qAssetId, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetResolution, qAssetScanType, qAssetFPS, qAssetAudioConfig, qAudioSampleRate, qAudioBitDepth -- L0 Asset Properties
From QATestRun T	Left Outer Join QARelease R  on T.qTestRunId=R.qTestRunId 
					Left Outer Join QAAsset A    on T.qAssetId=A.qAssetId 
					Left Outer Join QAStream S   on T.ALassetId=S.ALassetId 
					Left Outer Join PipelineConfig P   on S.qVariantId=P.VariantId 
					Left Outer Join VariantsByCustomer VC   on S.qVariantId=VC.VariantId and VC.VarCustPiority = 1
Where S.qTestRunId >=110  -- and qTestPassL1 = 0 and S.qStatus=''

 update QAStream  set  qStatusOri=qStatus, qTestPassL1Ori=qTestPassL1, qTestPassVideoOri=qTestPassVideo, qTestPassAudioOri=qTestPassAudio, qTestPassCCOri=qTestPassCC  where	qTestRunId=@testRun

 select * from PipelineConfig
 select VariantId, FileType, Muxer, Encoder, VideoType, AudioType, Width, Height, VideoPar, EmbeddedCCs, PassThruCCs, EmbeddedSCTE35, VideoBRType, VideoBitRate, GOPSize, AudioBitrate, AudioChannels, AudioMaxTracks, AudioBRType, FrameRates, MaxBFrames, SceneDetection, AdaptiveBFrames 
 from PipelineConfig  where EmbeddedCCs='' -- GOPSize is Null
-- delete  pipelineConfig where profile>=1
 update PipelineConfig set FrameRates='1.0' where VariantId=637 -- Encoder='' -- EmbeddedCCs='L0-Dependent'
-- select * from QARelease
