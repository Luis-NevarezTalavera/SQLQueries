USE OrderProcessing
SELECT	TOP(1000)	Row_Number() Over(ORDER BY  MT.MasterTitleId desc, Convert(int,SUBSTRING(T.ALAssetId,4,10))) as Row, -- MT.MasterTitleId, 
					MT.MovieTitle, T.TitleId, T.ALAssetId, T.AssetName, T.Priority, T.TitleStateId, TS.DisplayName AS AssetState, CT.DisplayName AS ContentType, 
					T.IsQueuedForTranscoding as IWF, convert(xml,T.TranscoderConfig) as TranscoderConfig, T.WorkflowInstanceId, T.IsDeleted, DescriptorXML as MezzAnalyzer -- , T.TravellerXml, SUBSTRING(DescriptorXML,PATINDEX('%size=%',DescriptorXML)+6, PATINDEX('%"%',SUBSTRING(DescriptorXML,PATINDEX('%size=%',DescriptorXML)+6,20)) ) as sizeDescriptorXML, 
FROM Title T WITH (NOLOCK)	Left Outer JOIN MasterTitle MT ON T.MasterTitleId = MT.MasterTitleId 
							Left Outer JOIN TitleState  TS ON T.TitleStateId  = TS.TitleStateId 
							Left Outer JOIN ContentType CT ON T.ContentTypeId = CT.ContentTypeId 
WHERE  T.IsDeleted in (0)	-- and  TravellerXml > '' 
 and ( MT.MovieTitle like 'QA_Regression_Priority_2018/01/23_481%'  ) --  OR   MT.MovieTitle like 'QA_Smoke_4_Assets_Sep_14_2017_07:34:5%'  OR  MT.MovieTitle like 'QA_FF%08/25_539'  OR   MT.MovieTitle like 'VBI_Source%') 
-- and  T.ALAssetId  in (select asset_id FROM OrderProcessingConsole.dbo.orders O INNER JOIN OrderProcessingConsole.dbo.order_jobs OJ ON O.id = OJ.order_id  Where O.id in (192171,192172,192173,192175,192176,192177,192180,192181,192182,192183) ) -- order by OJ.submit_date) -- 
 and (T.AssetName  not like '%_ART_%jpg%')  -- and  (T.AssetName  like 'Cowboy%') 
-- and  ALAssetId in ('a1-2603599') -- ','a1-1980395','a1-1980396','a1-1980389','a1-1980390','a1-1980384','a1-1980381','a1-1980382','a1-1980383','a1-1980371','a1-1980372','a1-1980373','a1-1980374','a1-1980370') -- 
-- and T.IsQueuedForTranscoding = 0 
-- and T.TitleId >= 593380 
 and T.TitleStateId  not in ('14','0') -- 14 --	In Asset Library -- '11' --	Transcoding -- '12' --	Baton QC -- 	'13' -- L2 Packaging	--,'15' --	Transcoding Error) -- ,'18' -- Publishing Error	-- , '23' --	Transfer
-- and (TS.DisplayName like '%Error%' ) -- or TS.DisplayName like 'Transcoding%' or TS.DisplayName like 'Baton QC') 
-- and DescriptorXML  like ('%<language>%')  -- and DescriptorXML not like ('%<language>xxx</language>%') -- and DescriptorXML not like ('%<language>qal</language>%') -- and DescriptorXML not like ('%<language>bs-Latn-BA</language>%') -- and DescriptorXML not like ('%<language>__-__</language>%')
-- ( SELECT j.asset_id FROM OrderProcessingConsole.dbo.orders o INNER JOIN OrderProcessingConsole.dbo.order_jobs j ON o.id = j.order_id Where o.id in (721,2275) and o.submit_date > '2013-01-07 00:00:00' ) -- Selecting the Assets from the Orders
-- and T.Priority is null
-- and  T.WorkflowInstanceId like '6c280134-12e7-48d5-b344%'
 ORDER BY  T.MasterTitleId desc, Convert(int,SUBSTRING(T.ALAssetId,4,10)) -- TS.DisplayName desc, , T.Priority desc --  T.IsQueuedForTranscoding,  T.WorkflowInstanceId asc,  ---  


-- Update Title set DescriptorXML = '<OMSAssetDescriptor SchemaVersion="1">    <film name="Growing Up and Other Lies (2015) (AT&amp;T) (SD) (Post-Theatrical) (10 Minute Preview)">      <externalIDs>        <id domain="AMG"></id>        <id domain="EIDR"></id>        <id domain="IMDB"></id>        <id domain="ISAN"></id>        <id domain="Tribune"></id>        <id domain="ClientProductID"></id>        <id domain="FacilityAssetID"></id>      </externalIDs>    </film>    <titleEdition>Theatrical</titleEdition>    <contentType>FeatureFilm</contentType>    <contentOwner>Deluxe Digital Studios</contentOwner>    <scanType>Progressive</scanType>    <programTiming>      <formatLogs>        <formatLog name="Growing Up and Other Lies (2015) (AT&amp;T) (SD) (Post-Theatrical) (10 Minute Preview)">          <timeCodeIn>0</timeCodeIn>          <timeCodeOut>601.98</timeCodeOut>        </formatLog>      </formatLogs>    </programTiming>    <files base="">      <file fileName="_ATT\_Phase4\G\GrowingUpAndOtherLies_2015\Preview\GrowingUpAndOtherLies_10min_1080p_2398_LRCLfeLsRsLtRt.mov" size="13606116230">        <FrameSize>          <height>1080</height>          <width>1920</width>        </FrameSize>        <parts>          <part>1</part>          <total>1</total>        </parts>        <dateCreated>4/16/2015 6:19:21 AM</dateCreated>        <description>Growing Up and Other Lies (2015) (AT&amp;T) (SD) (Post-Theatrical) (10 Minute Preview)</description>        <fileFormatWrapper>MPEG4</fileFormatWrapper>        <frameRate>23.976</frameRate>        <displayAspectRatio>16:9</displayAspectRatio>        <elemStreams>          <elemStream order="1" type="VIDEO">            <video>              <codec>ProRes</codec>              <averageBitrate>171556714</averageBitrate>              <peakBitrate>0</peakBitrate>            </video>          </elemStream>          <elemStream order="2" type="AUDIO">            <audio id="0">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>FrontLeft</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="3" type="AUDIO">            <audio id="1">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>FrontRight</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="4" type="AUDIO">            <audio id="2">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>FrontCenter</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="5" type="AUDIO">            <audio id="3">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>LowFrequency</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="6" type="AUDIO">            <audio id="4">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>LeftSurround</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="7" type="AUDIO">            <audio id="5">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>RightSurround</channelPos>              <averageBitrate>1152000</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>            </audio>          </elemStream>          <elemStream order="8" type="AUDIO">            <audio id="6">              <codec>PCM</codec>              <channelMap>5.1+Stereo</channelMap>              <channelPos>LeftAndRightTotal</channelPos>              <averageBitrate>2304001</averageBitrate>              <peakBitrate>0</peakBitrate>              <language>en-US</language>              <bitDepth>BitDepth24</bitDepth>              <sampleRate>SampleRate48K</sampleRate>              <audioFormatConfig>Config20</audioFormatConfig>            </audio>          </elemStream>        </elemStreams>      </file>    </files>  </OMSAssetDescriptor>'
--    where  ALAssetId in ('a1-367395')
/*
USE OrderProcessing
update Title  set TitleStateId=12, IsQueuedForTranscoding=0, WorkflowInstanceId = Null   Where IsQueuedForTranscoding=0 and ALAssetId in (SELECT asset_id FROM OrderProcessingConsole.dbo.orders INNER JOIN OrderProcessingConsole.dbo.order_jobs ON orders.id = order_jobs.order_id Where orders.id = 209096 )
Update MasterTitle set MovieTitle = 'QA_Smoke_API_Auto_Jul_10_2015_19:50:0' Where MasterTitleId in (303614)
Update MasterTitle set MovieTitle = 'QA_Regression_2015/07/10_144' Where MasterTitleId in (Select MasterTitleId from Title Where ALAssetId >= 'a1-494018' and ALAssetId <= 'a1-494055' )

update title set DescriptorXML = '<?xml version="1.0" encoding="utf-8"?><OMSAssetDescriptor SchemaVersion="1"><film name="Despicable Me"><externalIDs><id domain="AMG">V   475296</id><id domain="EIDR">dummyEIDR</id><id domain="IMDB">tt1323594</id><id domain="ISAN">0000-0002-847B-0000-1-0000-0000-Y</id><id domain="Tribune">MV002732970000</id><id domain="ClientProductID">prod12993013</id><id domain="FacilityAssetID">dummyOMS</id></externalIDs></film><titleEdition>Theatrical</titleEdition><contentType>Trailer</contentType><contentOwner>Universal</contentOwner><programTiming><formatLogs><formatLog name="Despicable Me TRL"><timeCodeIn>0</timeCodeIn><timeCodeOut>147.981</timeCodeOut></formatLog></formatLogs></programTiming><files base=""><file fileName="_UNIVERSAL\D\DespicableMe\Trailer\DespicableMe_Trailer4_HD_8Ch_PJ_Mezz_185.mov" size="1438801088"><FrameSize><height>1080</height><width>1920</width></FrameSize><parts><part>1</part><total>1</total></parts><dateCreated>4/13/2011 2:48:38 PM</dateCreated><description>Despicable Me TRL</description><fileFormatWrapper>MPEG4</fileFormatWrapper><frameRate>23.976</frameRate><displayAspectRatio>16:9</displayAspectRatio><elemStreams><elemStream order="1" type="VIDEO"><video><codec>MjpegA</codec><averageBitrate>71639073</averageBitrate><peakBitrate>0</peakBitrate></video></elemStream><elemStream order="2" type="AUDIO"><audio id="2"><codec>PCM</codec><channelMap>5.1+Stereo</channelMap><averageBitrate>6144000</averageBitrate><peakBitrate>0</peakBitrate><language>en-US</language><bitDepth>BitDepth16</bitDepth><sampleRate>SampleRate48K</sampleRate><audioFormatConfig>Config71</audioFormatConfig></audio></elemStream></elemStreams></file></files></OMSAssetDescriptor>' Where ALAssetId in ('a1-2139')

DECLARE @assetId AS int
SET @assetId = 494018
WHILE (@assetId <= 494055)
BEGIN
	Update Title set AssetName = ( Select AssetName from AssetLibrary.dbo.ALAsset Where AssetId = @assetId ) where ALAssetId = 'a1-'+CONVERT(varchar(6),@assetId)
	SET @assetId = @assetId + 1
END

Select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId 
Where  MasterTitle.MovieTitle like 'QA_Regression_2014/03/12_99%' 
Order by ALAssetId

select * from TitleState
Requires Action	--	0
Corrupted	--	1
Not Available	--	2
Requested	--	3
Acquired	--	4
Ordered	--	5
IQC	--	6
MQC	--	7
Review	--	8
Rejected	--	9
Ready for Processing	--	10
Transcoding	--	11
Baton QC	--	12
L2 Packaging	--	13
In Asset Library	--	14
Transcoding Error	--	15
L2 Packaging Error	--	16
Publishing	--	17
Publishing Error	--	18
Archiving	--	19
Archiving Error	--	20
BD-Live Publishing	--	21
BD-Live Publishing Error	--	22
Transfer	--	23
Transfer Error	--	24
BD-Live Publishing Completed	--	25
Archiving Completed	--	26
Restoring	--	27
Restoring Error	--	28
Restore Completed	--	29
Transfer Complete	--	30
Asset Pre-Check	--	31
Asset Pre-Check Complete	--	32
Asset Pre-Check Error	--	33
*/
/*
-- Query to set admin rights in the OP Console
Use OrderProcessingConsole
update user_app set userRole='admin' where username in ('admin','luis','aditya','michael','arkadiy','bogdan')
select * from user_app
*/
-- Query to Add new user
-- insert into user_app values ('Scott Douglas','sdouglas','sdouglas','6279F46B-D53C-4CA4-AD42-ED3BE5E71EB8','Scott.Douglas@bydeluxe.com','admin')