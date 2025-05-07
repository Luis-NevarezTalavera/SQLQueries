-- This Query shows All Elementary Streams
--SELECT        ALStream.AssetId, ALStream.VariantID, COUNT(ALElemStream.StreamID) as ElemStreams_Count
Use AssetLibrary
Select Top (1000) S.AssetId, S.StreamId, S.VariantId, ES.ElemStreamID, S.StreamName, S.FileUriPath, S.FileListXML as L0FileListXML, PT.LookupValue as PresentationType, ESL.LCID, ES.FileListXML, ES.AspectRatioTypeID, 
ES.AvgBitRate, ES.BitDepth, ES.ChannelConfigTypeID, ES.Codec, ES.FrameRateTypeID, ES.PeakBitRate, ES.SampleRate, ES.Height, ES.Width -- , ES.PresentationTypeID 
FROM	ALStream S Left Outer JOIN ALElemStream ES ON S.StreamID = ES.StreamID
		--	Left Outer Join ALAsset A				 On S.AssetID = A.AssetID
		Left Outer Join ALElemStreamLanguage ESL On ES.ElemStreamID = ESL.ElemStreamID
		Left Outer Join PresentationType PT		 On ES.PresentationTypeID = PT.LookupID
Where  ES.IsDeleted = 0
-- and (ALStream.CreatedDateTime < '2012-01-28' and AlStream.VariantID in (37,38,42,43))
-- and s.AssetId >= 115937 and s.AssetId <= 115971
-- and s.StreamId in (2597413)
-- and ES.ElemStreamID = 2733830
-- and ES.PresentationTypeID in (369,370,564) -- 367 Video -- 368 Audio -- 369 Subtitle -- 370 ClosedCaptioning -- 564 CCConformed 
-- and PT.LookupValue in ('ClosedCaptioning','Subtitle',  'CCConformed') -- 'Video','Audio'
-- and ESL.LCID not in ('en-US') and ESL.LCID is not NULL
-- and  'a1-' + CONVERT(varchar(6),s.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  MasterTitle.MovieTitle like 'QA_Regression_2014/03/2%' )  -- and Title.TitleStateId in ('14') 
-- and ( a.AssetName like 'Life of Pi%' OR A.AssetName like 'Sweet Home Alabama%')
-- and  S.VariantID  in (255,256,257) -- OR (S.VariantID >=330 and S.VariantID <= 343) OR (S.VariantID  >=2000  and S.VariantID <= 2003)  OR (S.VariantID  >=2100))
-- group by ALStream.AssetId, ALStream.VariantID
-- having Count(ALElemStream.StreamID) > 8
order by S.AssetId, S.VariantID desc, ES.ElemStreamID desc

 select top(100000) * from ALElemStreamLanguage
-- Select * from ALStreamProperty
-- select top 100 * from ALElemStream E inner join LookupEnum L on  E.PresentationTypeID = L.LookupID  where E.PresentationTypeID not in (368,370) -- 367 = Video, 368 = Audio, 369 = Subtitle, 370 = ClosedCaption
-- order by E.StreamID
--	Select * from LookupEnum where LookupValue like '%CCC%' or LookupValue like '%Closed%'
-- Select * from LanguageType
/* Select * from PresentationType
367	Video
368	Audio
369	Subtitle
370	ClosedCaptioning
371	Graphic
564	CCConformed
*/