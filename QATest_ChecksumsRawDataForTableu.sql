USE [QoS]
GO
/****** Object:  StoredProcedure [dbo].[QaChecksums]    Script Date: 10/17/2016 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[QaChecksums] AS
BEGIN

-- This Store Procedure Will Return QA Checksum Results from QA1 QATest DB, combined with info com AssetLibrary and CPI
-- This Query will create one record per Variant-Customer combination, it will also rank the most important Customer per variant
If Object_ID('#VariantsByCustomer') Is Not Null Drop Table #VariantsByCustomer
-- If Object_ID('#QaTestRun') Is Not Null Drop Table #QaTestRun
If Object_ID('QaChecksumsRawData') Is Not Null Drop Table QaChecksumsRawData

-- Select * Into #QaTestRun From [LA1RVSQLSVR001].QATest.dbo.QaTestRunDW

Select VariantID, VariantName, Description, VariantLevel, CustomerID, CustomerName, Priority, Weight, ROW_NUMBER() 
		OVER(Partition by VariantID Order by Weight desc) AS VarCustPiority INTO #VariantsByCustomer
From ( SELECT SC.VariantID, V2.VariantName, V2.Description, 'L2' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	[LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V2 Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.CustomerPriority CP ON CV.CustomerID = CP.CustomerID
								
		Where  C.StreamLevel = 2
		and SC.VariantID  >= 26
		and Cu.CustomerId Is Not Null
		UNION
		SELECT SC.SourceVariantID as VariantID, V1.VariantName, V1.Description, 'L1' as VariantLevel, Cu.CustomerID, Cu.CustomerName, CP.Priority, CP.Weight
		FROM	[LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V2 Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALStreamSourceConfiguration SC on V2.VariantID = SC.VariantID 
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALVariant V1 on V1.VariantID = SC.SourceVariantID
								Left Outer Join [LA1RVSQLSVR001].AssetLibrary.dbo.ALConfiguration C on SC.ConfigurationID = C.ConfigurationID
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.CustomerVariant CV ON 'v1-'+CONVERT(varchar(8),V2.VariantId) = CV.VariantId 
								LEFT OUTER JOIN [LA1RVSQLSVR001].CPI.dbo.Customer Cu ON CV.CustomerID = Cu.CustomerID
								LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.CustomerPriority CP ON CV.CustomerID = CP.CustomerID

              Where  C.StreamLevel = 2
               and SC.VariantID  >= 26
               and Cu.CustomerId Is Not Null
               ) as VariantsByCustomer
Order by VariantID, Weight desc
 
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
Into QaChecksumsRawData
From QaTestRun T	LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QARelease R  on T.qTestRunId=R.qTestRunId 
					LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QAAsset A    on T.qAssetId=A.qAssetId 
					LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.QAStream S   on T.ALassetId=S.ALassetId 
					LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.PipelineConfig P   on S.qVariantId=P.VariantId 
					LEFT OUTER JOIN [LA1RVSQLSVR001].QATest.dbo.#VariantsByCustomer VC   on S.qVariantId=VC.VariantId and VC.VarCustPiority = 1

Where S.qTestRunId>95  -- and qTestPassL1 = 0 and S.qStatus=''
 
Select * From QaChecksumsRawData

END