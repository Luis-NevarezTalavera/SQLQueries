Select qRelease, Min(Left(qSVNVerTN,8)) as qSVNVerTN, Min(qTestTimeStamp) as qTestTimeStamp, qTestRunId, qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, SUM(New) as New, SUM(Pass) as Pass, SUM(Inconclusive) as Inconclusive, SUM(Inc_Video) as Inc_Video, SUM(Inc_Audio) as Inc_Audio, SUM(Inc_CCs) as Inc_CCs, SUM(Fail) as Fail, qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth 
From (	Select R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment,  T.qAssetId, T.ALassetId, A.qAssetName, T.qAssetState, T.qStatus as AssetStatus, 
           Case  When qTestPassL1 = -1 Then Count(qTestPassL1) Else 0 End as New, 
		   Case  When qTestPassL1 = 1  Then Count(qTestPassL1) Else 0 End as Pass, 
		   Case  When qTestPassL1 = 0  and (S.qStatus='' OR S.qStatus is NULL) Then Count(qTestPassL1) Else 0 End as Inconclusive, 
		   Case  When qTestPassVideo in (0)  and (S.qStatus='' OR S.qStatus is NULL) Then Count(qTestPassVideo) 	Else 0 End as Inc_Video, 
		   Case  When qTestPassAudio in (0)  and (S.qStatus='' OR S.qStatus is NULL) Then Count(qTestPassAudio) 	Else 0 End as Inc_Audio, 
		   Case  When qTestPassCC    in (0)  and (S.qStatus='' OR S.qStatus is NULL) Then Count(qTestPassCC) 		Else 0 End as Inc_CCs, 
		   Case  When qTestPassL1 = 0  and S.qStatus >'' Then Count(qTestPassL1) Else 0 End as Fail, 
		   SUBSTRING(S.qStatus,0,100) as qStatus, Min(CONVERT(Varchar(10), T.qTestTimeStamp, 111 )) as qTestTimeStamp, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth 
		From QATestRun T	Left Outer Join QARelease R	on T.qTestRunId=R.qTestRunId 
							Left Outer Join QAAsset A	on T.qAssetId=A.qAssetId 
							Left Outer Join QAStream S	on T.ALassetId=S.ALassetId 
		Where S.qTestRunId= 144 -- and S.qAssetId in (29,32,33,61)
		Group by  R.qRelease, qSVNVerTN, T.qTestRunId, S.qEnvironment, T.qAssetId, T.ALassetId, A.qAssetName, T.qAssetState, T.qStatus, qTestPassL1, qTestPassVideo, qTestPassAudio, qTestPassCC, S.qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth 
	) as QAStatisticsTemp 
Group by  qRelease,	qTestRunId, qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth 
Order by  qRelease desc, qTestRunId desc, qEnvironment, qAssetId, ALassetId, qAssetName, qAssetState, AssetStatus, qStatus, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetAudioConfig, qAssetFPS, qAudioSampleRate, qAudioBitDepth
