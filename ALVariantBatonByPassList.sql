Use AssetLibrary
Select * from AlVariant
Where VariantID not in (	Select VariantID 
							-- Delete 
							From [AssetLibrary].[dbo].[ALVariantBatonBypass] 
							)
 and VariantID >= 200
 and VariantTypeID Not in (1,6,7,8,14,15,16)  and Container Is Not Null
-- and VideoResolution in ('1920x1080','1280x720','960x720','1440x1080')
-- and VariantID in (496,497,498,499,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529 ) --
-- and Description like '%trhu%'
Order by VariantID

-- Select * from ALSetting
-- Update ALSetting set Value = 'false' Where Name='BatonBypassAll'
/*
BatonBypassAll 
BatonByPassHigh 
BatonBypassUrgent 
*/
-- Select * ALVariantTypeLookup
/*
0	Undefined
1	SourceAsset
2	VideoOnly
3	AudioOnly
4	VideoAudio
5	Special
6	Compound
7	ArtReference
8	Subtitle
9	AudioExtraction
13	L1sOnly
14	Thumbnails
15	ConformedDigitialAd
16	ExtractedDigitalAd
*/