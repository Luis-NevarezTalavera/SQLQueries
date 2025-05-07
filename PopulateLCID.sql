use assetlibrary
-- L1s
Delete from ALStreamLanguage where CreatedBy='PopulateL1LCID'
GO
-- Updated L1 ALStreamLanguage script to exclude non audio variants:
Insert Into ALStreamLanguage (StreamId, LanguageTypeID, LCID, CreatedDateTime, CreatedBy)
select x.StreamID, 2, x.ValueStr, getutcdate(), 'PopulateL1LCID'
from (
	select ALS.StreamID, ALS.VariantId, ALS.StreamName, ap.ValueStr, ALSL.LCID from AssetLIbrary..ALStream ALS (NOLOCK)
	left outer join AssetLibrary..ALStreamLanguage ALSL (NOLOCK) ON ALSL.StreamID = ALS.StreamID and ALSL.LanguageTypeID=2
	left join ALAssetProperty ap on ap.AssetID=als.AssetID and ap.PropertyName='LANGUAGE'
	where als.IsDeleted=0 and als.ConfigurationID=5 and als.VariantId not in (117,500,501,502,503)
	and als.StreamStateTypeID=345 and ap.ValueStr is not null and ALSL.LCID is  null and len(ap.ValueStr)=5 and ap.ValueStr != 'en-US'
) x

 -- L2s
Insert Into ALStreamLanguage (StreamId, LanguageTypeID, LCID, CreatedDateTime, CreatedBy)
select x.StreamID, 2, x.ValueStr, getutcdate(), 'PopulateLCID'
from (
	select ALS.AssetID, ALS.StreamID, ALS.VariantId, ALS.StreamName, ap.ValueStr, ALSL.LCID from AssetLIbrary..ALStream ALS (NOLOCK)
	left outer join AssetLibrary..ALStreamLanguage ALSL (NOLOCK) ON ALSL.StreamID = ALS.StreamID and ALSL.LanguageTypeID=2
	left join ALAssetProperty ap on ap.AssetID=als.AssetID and ap.PropertyName='LANGUAGE'
	where als.IsDeleted=0 and als.ConfigurationID not in (1,2,3,4,5,8,9,10,11,14,15)
	and als.StreamStateTypeID=345 and ap.ValueStr is  null and ALSL.LCID is not null and len(ap.ValueStr)=5 and ap.ValueStr != 'en-US'
) x