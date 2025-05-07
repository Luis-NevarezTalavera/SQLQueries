use AssetLibrary 
Select Top (1000) S.AssetID, S.StreamID, S.VariantID, S.StreamName, S.FileUriPath, SL.LanguageTypeID as 'LanguageTypeID', LT1.LookupValue as 'LanguageType', SL.LCID as 'LCID', PropertyName, Case When SP.ValueStr>'' then SP.ValueStr else Convert(varchar(1),SP.ValueInt) end as Value 
		 -- , ES.FileListXML as 'ElemStr.FileListXML', ES.PresentationTypeID as 'ES.PresentationTypeID', EL.LanguageTypeId as'EL.LanguageTypeId', EL.LCID as 'EL.LCID', LT2.LookupDescription as 'EL.LanguageType'
From AlStream S WITH (NOLOCK) Left outer Join ALStreamLanguage SL On S.StreamID = SL.StreamID 
				Left Outer Join LanguageType LT1	On SL.LanguageTypeID = LT1.LookupID 
				Left Outer Join ALStreamProperty SP ON S.StreamID = SP.StreamID 
Where	S.IsDeleted in (0)
-- and  'a1-' + CONVERT(varchar(6),S.AssetId)  in (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where  MasterTitle.MovieTitle like 'QA_Regression_2014/09/15%') --  OR  MasterTitle.MovieTitle like 'QA_Smoke_API_Auto_Title_Jun_24_2014_13:02:4%')  -- and Title.TitleStateId in ('14') ) -- '11','12','15',
-- and  AssetID in  (417957)
-- and  S.StreamId in (5387394)
 and  S.VariantId  in (1) --, 330,331,332,333,334,335,336,337,338,339,340,341,342,343, 3000,3001,3002,3003)
-- and  SL.LanguageTypeID in (1,3,4) -- 1	Subtitle	-- 2	Audio -- 3	ClosedCaption	-- 4	BurnIn
-- and  S.StreamStateTypeID  in (345,512) -- Completed, TranscodedNotTested
-- and  ( PropertyName not in ('CC_EMBEDDED')  and  SP.ValueStr not in ('608','708','608+708','BurnIn') )  -- OR  ( PropertyName in ('LEVEL')  and  SP.ValueInt in (0,1,2) )  ) --
 and  SL.LCID not like 'en-US%'
 and ( LT1.LookupValue not in ('BurnIn','Subtitle','ClosedCaption')) -- 'Audio')  ) -- 
-- and S.FileUriPath like '%IAMNumberFour%'
-- and S.FileUriPath not like '%Trailer'
Order by S.AssetID, S.VariantID

-- select * from LanguageType
-- select top 100 * from ALElemStreamLanguage where CreatedBy = 'PopulateBurnInLCID'
/*
select * from LanguageType
1	Subtitle		
2	Audio			
3	ClosedCaption	
4	BurnIn			

***** Script for SelectTopNRows command from SSMS *****
SELECT TOP 200000 l.[StreamLanguageID],l.[StreamID],[LanguageTypeID],lt.LookupValue,[LCID],l.[CreatedDateTime],l.[CreatedBy],stream.StreamName,stream.VariantID
FROM [AssetLibrary].[dbo].[ALStreamLanguage] as l
INNER JOIN [AssetLibrary].[dbo].[ALStream] AS STREAM WITH(NOLOCK) ON l.StreamID = [STREAM].StreamID
INNER JOIN [AssetLibrary].[dbo].[LanguageType] as lt on lt.LookupID = l.LanguageTypeID
where LanguageTypeID=4 and STREAM.ConfigurationID in (1,5)
order by StreamLanguageID desc
L2s =		(027217 row(s) affected)
L0s,L1s =	(140552 row(s) affected)

�- Populate ALStreamLanguage records for BurnIn assets L2 streams
Insert Into ALStreamLanguage (StreamId, LanguageTypeID, LCID, CreatedDateTime, CreatedBy)
select x.StreamID, 4, x.ValueStr, getutcdate(), 'PopulateBurnInLCID'
from (
	select ALS.StreamID, ap.PropertyName, ap.ValueStr from AssetLIbrary..ALStream ALS (NOLOCK)
	left outer join AssetLibrary..ALStreamLanguage ALSL (NOLOCK) ON ALSL.StreamID = ALS.StreamID and ALSL.LanguageTypeID=4
	join ALAssetProperty ap on ap.AssetID=als.AssetID and ap.PropertyName='SUBTITLE_LANGUAGE' and ValueStr like '%-%'
	join ALAsset a on a.AssetId=ALS.AssetId and a.IsDeleted=0
	where als.IsDeleted=0 and als.ConfigurationID not in (1,2,3,4,5,8,9,10,11,14,15)
	and als.StreamStateTypeID=345 and ap.ValueStr is not null and ALSL.LCID is null
) x

� Populate ALStreamLanguage records for BurnIn assets L0 & L1 streams
Insert Into ALStreamLanguage (StreamId, LanguageTypeID, LCID, CreatedDateTime, CreatedBy)
select x.StreamID, 4, x.ValueStr, getutcdate(), 'PopulateBurnInLCID'
from (
	select ALS.StreamID, ap.ValueStr from AssetLIbrary..ALStream ALS (NOLOCK)
	left outer join AssetLibrary..ALStreamLanguage ALSL (NOLOCK) ON ALSL.StreamID = ALS.StreamID and ALSL.LanguageTypeID=4
	join ALAssetProperty ap on ap.AssetID=als.AssetID and ap.PropertyName='SUBTITLE_LANGUAGE' and ValueStr like '%-%'
	join ALAsset a on a.AssetId=ALS.AssetId and a.IsDeleted=0
	where als.IsDeleted=0 and als.ConfigurationID in (1,5)
	and als.StreamStateTypeID=345 and ap.ValueStr is not null and ALSL.LCID is null
) x

*/