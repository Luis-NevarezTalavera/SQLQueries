Use AssetLibrary
SELECT        TOP (500) T.TitleID, T.TitleName, T.ReleaseDate, T.ContentOwnerAliasID, COA.AliasDescription, TP.PropertyName, TP.ValueStr, TE.SeasonNumber, TEP.PropertyName, TEP.ValueStr, 
A.AssetId, A.AssetName, A.ContentProgrammerID, A.EpisodeNumber, A.SourceFacilityID, SFL.LookupDescription, A.SourceSubfacilityID -- , AP.PropertyName, AP.ValueStr 
FROM	ALTitle T Inner Join	ALTitleAsset TA	ON T.TitleID = TA.TitleID 
				Inner Join		ALAsset A		ON TA.AssetID = A.AssetID 
				Inner Join		ALTitleEdition TE	ON T.TitleID = TE.TitleID
				Left Outer Join ALTitleProperty	TP	ON T.TitleID = TP.TitleID
				-- Left Outer Join ALAssetProperty	AP	ON A.AssetId = AP.AssetID
				Left Outer Join ALTitleEditionProperty TEP	ON TE.TitleEditionID = TEP.TitleEditionID
				left Outer Join ALContentOwnerAlias COA		ON T.ContentOwnerAliasID = COA.AliasID
				left Outer Join ALSourceFacilityLookup SFL	ON A.SourceFacilityID = SFL.LookupID
Where -- TitleName like 'QA_Smoke%Dec_06%' -- OR T.TitleName like 'US2937%' 
 TE.TitleEditionId in (37977)
-- and A.AssetID in (3754)
-- and AP.PropertyName in ('EPISODE_NUM', 'SOURCE_FACILITY', 'FILE0_ASPECT_RATIO')
-- and TE.SeasonNumber is not Null
ORDER BY A.AssetID desc
