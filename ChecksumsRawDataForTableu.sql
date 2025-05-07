USE [QoS]
GO
/****** Object:  StoredProcedure [dbo].[ChecksumsRawDataForTableu]    Script Date: 09/21/2017 15:15:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ChecksumsRawDataForTableu] AS
BEGIN

-- Recreate QAStreamNoXML
DECLARE @RunStoredProcSQL VARCHAR(1000);
SET @RunStoredProcSQL = 'EXEC QATest.dbo.[RecreateQAStreamNoXML]';
-- SELECT @RunStoredProcSQL --Debug
EXEC (@RunStoredProcSQL) AT [LA1RVSQLSVR001];

-- This Query will create one record per Variant-Customer combination, it will also rank the most important Customer per variant
Drop Table VariantsByCustomer
Select VariantID, VariantName, Description, VariantLevel, CustomerID, CustomerName, Priority, Weight, ROW_NUMBER() OVER(Partition by VariantID Order by Weight desc) AS VarCustPiority INTO VariantsByCustomer
From (	SELECT	SC.VariantID, V2.VariantName, V2.Description, 'L2' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	[LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V2 Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.CustomerPriority CP ON CV.CustomerID = CP.CustomerID
		Where	C.StreamLevel = 2 
		 and SC.VariantID  >= 26 
		 and Cu.CustomerId Is Not Null 
		UNION 
		SELECT	SC.SourceVariantID as VariantID, V1.VariantName, V1.Description, 'L1' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	[LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V2 Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.CustomerPriority CP ON CV.CustomerID = CP.CustomerID
		Where	C.StreamLevel = 2 
		 and SC.VariantID  >= 26 
 	 	 and Cu.CustomerId Is Not Null 
		 ) as VariantsByCustomer
Order by VariantID, Weight desc

-- Create QaChecksumsRawData table for Michel's Tablaeu Report
Drop Table QaChecksumsRawData
Select * INTO QaChecksumsRawData
From (	Select ROW_NUMBER() OVER(Order by T.qTestRunId, S.qAssetId, S.qVariantId) as KeyId, 
				R.qRelease, S.qSVNVerTN, T.qTestRunId, S.qEnvironment, CONVERT(Varchar(10), S.qTestTimeStamp,111) as qTestTimeStamp, VC.CustomerName as Customer, VC.Weight as Weight_Cust, 
				-- Updated Result Fields
				qTestPassL1    as Result, 
				qTestPassVideo as Inc_Video, 
				qTestPassAudio as Inc_Audio, 
				qTestPassCC    as Inc_CCs, 
				S.qStatus, 
				-- Original Result Fields
				qTestPassL1Ori as ResultOri, 
				qTestPassVideoOri as Inc_VideoOri, 
				qTestPassAudioOri as Inc_AudioOri, 
				qTestPassCCOri    as Inc_CCsOri, 
				S.qStatusOri, 
				-- TN IP Address, EncodeTime, MuxTime
				S.qTNIP, S.qEncodeTime, S.qMuxTime, 
				-- L1 Pipeline Config Properties
				-- ProfileId	VariantId	Env	OutputFileType	Muxer	OverallBitrate	OutputFileExtension	VideoType	VideoEncoder	VideoWidth	VideoHeight	VideoFrameRate	VideoEmbedCCs	VideoPassthruCCs	VideoEmbedSCTE35	VideoSupportedFrameRates	VideoCBRVBR	VideoBitrate	VideoCPBBufferSize	VideoBufferFullnessInitial	VideoBufferFullnessTarget	VideoMaxIFrameSize	VideoMaxPFrameSize	VideoGOPLength	VideoMaxBFrames	VideoAdaptiveBFrames	VideoSceneDetection	VideoProfile	VideoLevel	VideoPAR	VideoPasses	AudioType	AudioTargetLoudnessLKFS	AudioUseSpeechGating	AudioSpeechGatingThreshold	AudioMaxTruePeak	AudioDynamicRangeCompression	AudioDRCThreshold	AudioDialNorm	AudioChannelFormat	AudioCBRVBR	AudioBitrate	AudioMaxTracks	CreationDateTime
				S.qVariantId, VideoEncoder as Encoder,Muxer,OutputFileType as FileType,VideoType,VideoWidth as Width, VideoHeight as Height,VideoSupportedFrameRates as FrameRates,VideoEmbedCCs as EmbeddedCCs,VideoEmbedSCTE35 as EmbeddedSCTE35,AudioType,AudioCBRVBR as AudioBRType,AudioChannelFormat as AudioChannels,
				-- L0 Source Asset Properties
				A.qAssetId, qAssetContainer, qAssetVideoCodec, qAssetAudioCodec, qAssetAspectRatio, qAssetResolution, qAssetScanType, qAssetFPS, qAssetAudioConfig, qAudioSampleRate, qAudioBitDepth -- L0 Asset Properties
		From [LA1RVSQLSVR001].QATest.dbo.QATestRunNoXML T	LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QARelease R  on T.qTestRunId=R.qTestRunId 
							LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QAAsset A    on T.qAssetId=A.qAssetId 
							LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QAStreamNoXML S   on T.ALassetId=S.ALassetId 
							LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.PipelineConfig P   on 'v1-'+CONVERT(varchar(8),S.qVariantId)=P.VariantId 
							LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.VariantsByCustomer VC   on S.qVariantId=VC.VariantId and VC.VarCustPiority = 1
		Where S.qTestRunId>=130  -- and qTestPassL1 = 0 and S.qStatus=''
	 ) as QaChecksumsRawData

END

-- [ChecksumsRawDataForTableu]