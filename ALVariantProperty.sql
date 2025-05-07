--SQL Query to Display ALVariant and ALVariantProperties
Use AssetLibrary
SELECT  DISTINCT V.VariantID,V.VariantName,V.VariantTypeID,V.Container,V.VideoResolution,V.VariantVideoID,V.VariantAudioID,V.VideoCodec,V.VideoProfile,V.VideoLevel,V.VideoAspectRatio,V.VideoBitRate/1000 as VideoBitRateKbsp,
		V.VideoPixelAspectRatioID,V.AudioCodec,V.AudioChannels,V.AudioSampleRate,V.AudioSampleBitDepth,V.AudioBitRate,V.CCEmbeddedRequired, V.CreatedDateTime, V.UpdatedDateTime --, VV.*, 
		 , LE.LookupDescription AS EncryptionType, VTL.LookupValue as VariantType, VP.PropertyName, VP.ValueStr, VP.ValueInt, VP.ValueFloat, VP.ValueBool
FROM	ALVariant V	 LEFT OUTER JOIN LookupEnum LE				ON V.EncryptionTypeID = LE.LookupID 
					 LEFT OUTER JOIN ALVariantTypeLookup VTL	ON V.VariantTypeID = VTL.LookupID
					 LEFT OUTER JOIN ALVariantProperty VP		ON V.VariantID = VP.VariantID 
					 LEFT OUTER JOIN ALVariantVideo VV			ON V.VariantId = VV.VariantID
 WHERE V.IsDeleted = 0
 and  V.VariantID in (117,2000,278)
-- and VariantVideoID in (540) -- v331
-- and (V.VariantName  like '%PAL%' OR V.VariantName  like '%DV%'  OR V.VariantName  like '%D1%')
-- and (V.VideoResolution like '480x272') --   OR  V.VideoResolution like '%x1080')
-- and VideoCodec = 'H264'
-- and PropertyName not in ('TS_REMUX_REQUIRED','THUMBNAIL_INTERVAL_IN_SECONDS' ) -- OR PropertyName like '%SCTE%') -- 'TS_Remux%' --'USING_DCD_PACKAGER%' and ValueBool = 1 --   --  
-- and VideoAspectRatio not in ('16:9','4:3')
-- and EncryptionTypeID in (363) -- None
-- and V.VariantTypeID not in (6)
-- and Container is null -- not in ('MP4','TS') --VideoBitRate > '' and AudioBitRate > ''
ORDER BY  V.VariantID --  (CONVERT(decimal,VideoBitRate) + CONVERT(decimal,AudioBitRate)) desc,

-- Select V.VariantID as ALVariantId, V.Description, V.EncryptionTypeID, LE.LookupDescription AS EncryptionType, P.* FROM	ALVariant V LEFT OUTER JOIN QATest.dbo.PipelineConfig P ON 'v1-'+ CONVERT(varchar(6), V.VariantID) = P.VariantId  LEFT OUTER JOIN LookupEnum LE ON V.EncryptionTypeID = LE.LookupID Where V.VariantID=278
-- update ALVariantProperty set ValueStr='http://lps.qa1.d3nw.net/hls' Where VariantID = 4000 and PropertyName = 'HLS_LICENSE_URL' 
--  Select * from ALVariant where VariantId in(117,2000,278)
-- delete ALVariantProperty where VariantID in (2595)  and PropertyName like  'USING_DCD_PACKAGER%'  and ValueBool = 1 
-- select * from ALVariantProperty where  PropertyName like '%PIXEL%' and ValueBool = 1
-- Insert into ALVariantProperty values (2595,432,'USING_DCD_PACKAGER',427,null,1,null,null,null,null,0,GETDATE(),'D3NW\LNevarez',GETDATE(),'D3NW\LNevarez')
-- Select * from ALVideoPixelAspectRatioTypeLookup
-- select * from ALVariantTypeLookup
/*
ID	LookupValue	LookupDescription
0	Undefined	Variant type is unknown
1	SourceAsset	Variant identifies a source file such as a mezzanine
2	VideoOnly	Variant only contains video
3	AudioOnly	Variant only contains audio
4	VideoAudio	Variant contains both video and audio
5	Special	Variant is special, must examine elementary streams
6	Compound	Variant contains multiple parent variants
7	ArtReference	Art Reference
8	Subtitle	Variant is a Subtitle
9	AudioExtraction	Variant is for an Audio Extraction
13	L1s Only	Variant
14	Thumbnails	Thumbnails
15	ConformedDigitialAd	ConformedDigitialAd
16	ExtractedDigitalAd	ExtractedDigitalAd
*/