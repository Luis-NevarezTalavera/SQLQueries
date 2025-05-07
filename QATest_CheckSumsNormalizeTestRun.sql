-- This Store Procedure Will Normalize the Checksums results
GO
CREATE PROCEDURE NormalizeCheckSumsTestRun 
@normalizeTestRun int = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @lastTestRun AS int
	DECLARE @testRun AS int
	DECLARE @assetId AS int
	DECLARE @assetIdCount AS int
	DECLARE @variantId AS int
	DECLARE @variantIdCount AS int
	
	SET @lastTestRun = (select Max(qTestRunId) from QATestRun)

	SET @testRun = 176 -- @normalizeTestRun
	WHILE (@testRun <= 176) -- @normalizeTestRun
	BEGIN
		update QARelease	set  qComments=''												   Where qTestRunId=@testRun and qComments='Release Comments' 
		update QAStream		set  qReferenceFlag=1, qTestPassL1='Pass', qTestPassCC='n/a', qTestPassFileListXML='n/a', qStatus=''  Where qTestRunId=@TestRun  and qVariantId in (1,594,595) --  ( ( qL1ZeroOutCheckSum = (Select qL0CheckSum From QAAsset  Where qAssetId = @assetId) and  qVariantId in (1) ) OR
		update QARelease	set  qTestTimeStamp = (Select TOP(1) qTestTimeStamp From QAStream  Where qTestRunId=@testRun and qVariantId not in (594,595) and qTestTimeStamp > '1900/01/02 00:00:00.00' Order by qTestTimeStamp)  Where qTestRunId=@testRun 
		-- update QAStream		set  qStatus='Failed_Transcode', qEncodeTime=0.0, qMuxTime=0.0		Where qTestRunId=@testRun and qStreamPath not like '%/a1/%' and qVariantId not in (1) and qStatus='' 
		update QAStream		set  qStatus=''	Where qTestRunId=@TestRun  and (qStatus Is NULL Or qStatus like 'ReadyForLibrary:%' Or qStatus like 'TransferFailed: Dirt Transfer Failed:%' Or qStatus in('Transcode Successful','Publish to CDN completed successfully','Failed_QC: Baton Failure: Unable to connect to the remote server','L1_ExtraCheck_PASS | ') )
		delete QAStream		Where	qTestRunId=@testRun and qVariantId  in (1011)
		-- Setting Null, Empty fields to 'n/a' 
		update QAStream	 set  qTestPassAudio ='n/a', qElementaryAudioCheckSum='n/a', qBatonFullDecodePass='n/a'				Where qTestRunId=@testRun and (qElementaryAudioCheckSum Is Null Or qElementaryAudioCheckSum='' Or qElementaryAudioCheckSum='n/a' Or qFileName like '%.zip' Or qFileName like '%.bif' )
		update QAStream	 set  qTestPassVideo ='n/a', qElementaryVideoCheckSum='n/a', qTestPassCC='n/a', qFPS_ScanType='n/a'	Where qTestRunId=@testRun and (qElementaryVideoCheckSum Is Null Or qElementaryVideoCheckSum='' Or qElementaryVideoCheckSum='n/a' Or qFileName like '%.zip' Or qFileName like '%.bif' )
		update QAStream	 set  qTestPassFileListXML='n/a'				Where qTestRunId=@TestRun and (qFileListXML Is Null  Or  DATALENGTH(qFileListXML) = 5 ) 
		update QAStream	 set  qL2ManifestPass='n/a', qL2Manifest='n/a'	Where qTestRunId=@testRun and (qL2Manifest Is Null Or qL2Manifest = '' )
		update QAStream	 set  qL1ZeroOutCheckSum ='n/a'					Where qTestRunId=@testRun and (qL1ZeroOutCheckSum='' Or qL1ZeroOutCheckSum Is Null )
		update QAStream  set  qReferenceFlag=0,qTestPassL1='Inconcl'	Where qTestRunId=@TestRun and  qTestPassL1='Fail' and (qStatus='' OR qStatus like '| FPS PASS | SSIM FAIL%') and (qTestPassVideo!='Fail' and qTestPassAudio!='Fail' and qTestPassCC!='Fail' and qTestPassFileListXML!='Fail' and qL2ManifestPass!='Fail')

		SET @assetIdCount = 0;
		SET @variantIdCount = 0;

		SET @assetId = 12 -- 12
		WHILE (@assetId <= 102) -- 102
		BEGIN
			-- Setting DateTime to the first in that particular asset
			update QATestRun	set  qTestTimeStamp = (Select TOP(1) qTestTimeStamp From QAStream  Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId not in (594,595) and qTestTimeStamp > '1900/01/02 00:00:00.00' Order by qTestTimeStamp)  Where qTestRunId=@testRun and qAssetId=@assetId
			update QAStream		set  qTestTimeStamp = (select TOP(1) qTestTimeStamp From QAStream  Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId not in (594,595) and qTestTimeStamp > '1900/01/02 00:00:00.00' Order by qTestTimeStamp)  Where qTestRunId=@testRun and qAssetId=@assetId and qTestTimeStamp <= '1900/01/02 00:00:00.00'

			PRINT N'--- TestRunId=' + CONVERT(varchar(4),@testRun) + ' qAssetId='+ CONVERT(varchar(4),@assetId) + ' ---'
			-- Check if there are streams for this qAssetId
			SET @assetIdCount = (select count(qAssetId) as Count from QAStream Where qTestRunId=@testRun and qAssetId=@assetId)
			IF @assetIdCount > 2
			BEGIN
				
				SET @variantId = 117 -- 117
				WHILE (@variantId <= 6520) -- 6520
				BEGIN
				
					-- Check if there are streams for this qVariantId
					 SET @variantIdCount = (select count(qVariantId) as Count from QAStream Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and (qTestPassL1!='Pass' OR qTestPassCC!='Pass'))
					 IF @variantIdCount >= 1
					 BEGIN
							PRINT N'			VariantId=' + CONVERT(varchar(4),@variantId)

							BEGIN TRY
									-- In case Elementary Video was not generated or was deleted, we can retrive it From another L1 with same ZeroOutChecksum
									-- Update QAStream  set qTestPassVideo='Fail', qElementaryVideoCheckSum=(
										-- Select top 1 qElementaryVideoCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qElementaryVideoCheckSum>''
										-- and qL1ZeroOutCheckSum in (Select qL1ZeroOutCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId=@testRun) )
										-- Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and (qElementaryVideoCheckSum is NULL or qElementaryVideoCheckSum='') and qVariantId  not in  (1,117,163,164,165,166,167,168,170,417,431,432,475,476, 500,501,502,503, 594,595,655,656,657,658,1011,1013)
				
									-- Pass Audio / Video Elementary streams if checksums match with previous run
									Update QAStream  set qTestPassVideo='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId  and (qElementaryVideoCheckSum>'' and qElementaryVideoCheckSum!='n/a') and qTestPassVideo!='Pass' and qElementaryVideoCheckSum in ( Select qElementaryVideoCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qTestPassVideo='Pass' and qTestRunId >= @lastTestRun-6 )
									Update QAStream  set qTestPassAudio='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId  and (qElementaryAudioCheckSum>'' and qElementaryAudioCheckSum!='n/a') and qTestPassAudio!='Pass' and qElementaryAudioCheckSum in ( Select qElementaryAudioCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qTestPassAudio='Pass' and qTestRunId >= @lastTestRun-6 )
									Update QAStream  set qTestPassAudio='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId!=@variantId and (qElementaryAudioCheckSum>'' and qElementaryAudioCheckSum!='n/a') and qTestPassAudio!='Pass' and qElementaryAudioCheckSum in ( Select qElementaryAudioCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId =@testRun and qTestPassAudio='Pass')
									-- CCs
									-- Update QAStream  set qElementaryCCfileSRT = ( Select top(1) qElementaryCCfileSRT From QAStream  Where qTestRunId!=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassVideo='Pass' and qTestPassCC='Pass' and qElementaryCCfileSRT>'' and qTestRunId >= @lastTestRun-6 )	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and qElementaryVideoCheckSum>'' and (qElementaryCCfileSRT Is Null or qElementaryCCfileSRT='') 
									Update QAStream  set qTestPassCC='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and (qElementaryVideoCheckSum>'' and qElementaryVideoCheckSum!='n/a') and (qTestPassCC!='Pass' or qTestPassCC is null) and qElementaryCCfileSRT  in ( Select qElementaryCCfileSRT From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qTestPassCC='Pass' and qTestRunId >= @lastTestRun-9 and qElementaryCCfileSRT>'' )
									-- Failing Streams with No Captions that had Captions in other TestRuns
									Update QAStream  set qTestPassCC='Inconcl',qTestPassL1='Inconcl',qReferenceFlag=0  Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassCC != 'Pass' and qTestPassL1 != 'Pass' and qTestPassVideo not in ('Pass','n/a') and (qElementaryCCfileSRT Is Null or qElementaryCCfileSRT='') and qVariantId in ( Select qVariantId From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qTestPassCC='Pass' and qTestRunId >= @lastTestRun-6 and qElementaryCCfileSRT>'') -- ,qStatus='CCExtractor cant Extract Captions'
									-- qFPS_ScanType
									Update QAStream  set qFPS_ScanType = ( Select top(1) qFPS_ScanType From QAStream Where qTestRunId!=@testRun and qFPS_ScanType>'' and qElementaryVideoCheckSum in ( Select qElementaryVideoCheckSum From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qTestPassVideo='Pass' and qTestRunId >= @lastTestRun-6 ) Order by qTestRunId desc)	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and qElementaryVideoCheckSum>'' and (qFPS_ScanType Is Null or qFPS_ScanType='' or qFPS_ScanType='NULL') 

									-- Update QAStream  set qFileListXML  = ( Select top(1) qFileListXML  From QAStream Where qTestRunId!=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassL1='Pass' and qFileListXML>'' and qTestPassFileListXML='Pass' and qTestRunId >= @lastTestRun-6 ) Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and (qFileListXML Is Null or qFileListXML='') 
									Update QAStream  set qTestPassFileListXML='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId  and qTestPassFileListXML!='Pass' and DATALENGTH(qFileListXML)!=5 and Convert(varchar(8000),qFileListXML)  in ( Select Convert(varchar(8000),qFileListXML) From QAStream Where qTestRunId!=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassFileListXML='Pass' and qTestRunId >= @lastTestRun-6 ) 
									Update QAStream  set qTestPassFileListXML='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId!=@variantId and qTestPassFileListXML!='Pass' and DATALENGTH(qFileListXML)!=5 and Convert(varchar(8000),qFileListXML)  in ( Select Convert(varchar(8000),qFileListXML) From QAStream Where qTestRunId =@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassFileListXML='Pass') 
									-- qL2ManifestPass
									Update QAStream  set qL2ManifestPass='Pass'	Where qTestRunId=@testRun and qAssetId=@assetId  and qVariantId=@variantId and (qL2Manifest>'' and qL2Manifest!='n/a') and qL2ManifestPass!='Pass' and qL2Manifest in ( Select qL2Manifest From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId!=@testRun and qL2ManifestPass='Pass' and qTestRunId >= @lastTestRun-6 )
									Update QAStream  set qL2ManifestPass='Pass'	Where qTestRunId=@testRun and qAssetId!=@assetId and qVariantId=@variantId and (qL2Manifest>'' and qL2Manifest!='n/a') and qL2ManifestPass!='Pass' and qL2Manifest in ( Select qL2Manifest From QAStream Where qAssetId=@assetId and qVariantId=@variantId and qTestRunId =@testRun and qL2ManifestPass='Pass')

									-- Pass L1s 
									Update QAStream  set qReferenceFlag=1, qTestPassL1='Pass', qStatus='' Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and (qL1ZeroOutCheckSum>'' and qL1ZeroOutCheckSum!='n/a') and qTestPassFileListXML='Pass' and qTestPassL1!='Pass' and qL1ZeroOutCheckSum in ( Select qL1ZeroOutCheckSum From QAStream Where qTestRunId!=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassL1='Pass' and qReferenceFlag=1 and qTestRunId >= @lastTestRun-6 )
									-- Update qStatus column with Error From previous runs that match L1ZeroOutChecksum
									-- Update QAStream  set qReferenceFlag=0, qTestPassL1='Fail', qStatus=(
										--	Select top 1 qStatus From QAStream Where qTestRunId!=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassL1='Fail' and LEN(qStatus)>5 and qTestRunId >= @lastTestRun-6 
											--	and qL1ZeroOutCheckSum = (Select qL1ZeroOutCheckSum From QAStream Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId) )
										-- Where qTestRunId=@testRun and qAssetId=@assetId and qVariantId=@variantId and qTestPassL1!='Pass' and (qStatus='' or qStatus is NULL) and (qL1ZeroOutCheckSum>'' and qL1ZeroOutCheckSum!='n/a')
							END TRY
							BEGIN CATCH
								PRINT 'Exception [' + ERROR_MESSAGE() + '] Catched in Line ' + CONVERT(varchar(3),ERROR_LINE() )
								-- CONTINUE
							END CATCH
	
							-- Increment VariantId, Skipping large not used ranges
							IF @variantId = 117
								SET @variantId = 163
							ELSE
								IF @variantId = 170
									SET @variantId = 200
								ELSE
									IF @variantId = 850
										SET @variantId = 1900
									ELSE
										IF @variantId = 2010
											SET @variantId = 2500
										ELSE
											IF @variantId = 2750
												SET @variantId = 3500
											ELSE
												IF @variantId = 3600
													SET @variantId = 4000
												ELSE
													IF @variantId = 4050
														SET @variantId = 4400
												ELSE
													IF @variantId = 4510
														SET @variantId = 5000
													ELSE
														IF @variantId = 5020
															SET @variantId = 6000
														ELSE
															IF @variantId = 6020
																SET @variantId = 6500
															ELSE
																SET @variantId = @variantId + 1

					 END -- IF @variantIdCount >= 1
					 else
						SET @variantId = @variantId + 1

				END -- @variantId

				update QAStream  set  qTestPassCC='Inconcl',qTestPassL1='Inconcl',qReferenceFlag=0	Where qTestRunId=@TestRun and qAssetId = @assetId and qTestPassL1 != 'Pass' and qTestPassVideo not in ('Pass','n/a') and (qElementaryCCfileSRT Is Null Or qElementaryCCfileSRT='') and 'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoPassthruCCs  in ('Manzanita','Telestream')) and 'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoEmbedCCs not in ('None')) -- qElementaryCCfileSRT='n/a', 
				update QAStream  set  qTestPassCC='Pass',qElementaryCCfileSRT=Null			Where qTestRunId=@TestRun and qAssetId = @assetId and qElementaryVideoCheckSum>'' and qTestPassCC!='Pass' and ( 'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoPassthruCCs  in ('Mainconcepts'))  OR  'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoEmbedCCs  in ('None')  OR  qVariantId  in (673,674,675,676) ) )
				update QAStream  set  qReferenceFlag=1,qTestPassL1='Pass',qTestPassCC='n/a'	Where qTestRunId=@TestRun and qAssetId = @assetId and qTestPassL1 Not In('Pass')  and qTestPassFileListXML='Pass'  and  qL2ManifestPass in('Pass','n/a')  and  qStreamPath like '%Assets%'
				update QAStream  set  qReferenceFlag=1,qTestPassL1='Pass',qStatus=''		Where qTestRunId=@TestRun and qAssetId = @assetId and qTestPassVideo='Pass' and qTestPassAudio='Pass'  and  qTestPassCC='Pass'  and  qStatus like 'Video Matches, PASS | Audio Matches, PASS |%'  and  qBatonFullDecodePass in ('Pass','n/a')
				update QAStream  set  qReferenceFlag=1										Where qTestRunId=@TestRun and qAssetId = @assetId and qTestPassL1='Pass' and qStatus=''
				update QAStream	 set  qStatus=''											Where qTestRunId=@TestRun and (qStatus Is NULL  Or qStatus like 'ReadyForLibrary:%' Or qStatus like 'TransferFailed: Dirt Transfer Failed:%' Or qStatus in('Transcode Successful','Publish to CDN completed successfully','Failed_QC: Baton Failure: Unable to connect to the remote server','L1_ExtraCheck_PASS | ') )
 				update QAStream  set  qStatus=''											Where qTestRunId=@TestRun and qAssetId = @assetId and qStatus like '%The Closed Caption _08 data was not present%' and 'v1-' + CONVERT(varchar(5), qVariantId)  in (select variantId From PipelineConfig Where VideoEmbedCCs  in ('608 SCTE20+708','608 SCTE20+608+708') )
				update QAStream  set  qStatus=''											Where qTestRunId=@TestRun and qAssetId = @assetId and qStatus like 'L2Manifest Mismatches%' and (qL2ManifestPass = 'Pass' Or qL2ManifestPass = 'n/a' Or qL2Manifest = '' Or qL2Manifest Is Null)
				update QAStream  set  qTestPassL1='New'										Where qTestRunId=@TestRun and qAssetId = @assetId and ( (qElementaryVideoCheckSum>'' and qTestPassVideo='New') OR  (qElementaryAudioCheckSum>'' and qTestPassAudio='New') )

			END -- IF @assetIdCount > 1

			SET @assetId = @assetId + 1

		END -- @assetId
		
	SET @testRun = @testRun + 1
	END -- @testRun
	
	PRINT N'<<<<  CheckSums Update Completed Successfully  >>>>'

END