-- Query for Deleting specific Stream Variants with all dependent records in subtables
--Use AssetLibrary
DECLARE @firstAssetId AS int
DECLARE @lastAssetId AS int

DECLARE @variantId1 AS int
DECLARE @variantId2 AS int
DECLARE @variantId3 AS int
DECLARE @variantId4 AS int
DECLARE @variantId5 AS int
DECLARE @variantId6 AS int

SET @firstAssetId = 1151164
SET @lastAssetId  = 1151164

SET @variantId1 = 2
SET @variantId2 = 2100

SET @variantId3 = 3
SET @variantId4 = 3

SET @variantId5 = 4
SET @variantId6 = 4

WHILE (@firstAssetId <= @lastAssetId)
BEGIN

	PRINT N' Deleting streams from AssetId= a1-' + CONVERT(varchar(6),@firstAssetId)

	Delete ALStreamLanguage
	Where  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1) )) -- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) )

	Delete ALStreamProperty 
	Where  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1) )) -- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) )

	Delete ALElemStreamBaseLocation 
	Where ElemStreamID in (Select ElemStreamID from ALElemStream WHERE  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1) )) )-- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) ))
	
	Delete ALElemStreamLanguage 
	Where ElemStreamID in (Select ElemStreamID from ALElemStream WHERE  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1) )) )-- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) ))

	Delete ALElemStream 
	Where  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1) )) -- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) )

	Delete ALStreamBaseLocation 
	Where  StreamID in (Select StreamID from ALStream Where AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )  and (IsDeleted in (0,1))) -- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279) )

	Delete ALStream 
	Where  AssetId  in (@firstAssetId) and ( (VariantID >= @variantId1 and VariantID <= @variantId2)  OR (VariantID >= @variantId3 and VariantID <= @variantId4) OR  VariantId in (@variantId5,@variantId6) )   and (IsDeleted in (0,1) ) -- (select ALAssetId from OrderProcessing.dbo.Title Left Outer JOIN OrderProcessing.dbo.MasterTitle ON Title.MasterTitleId = MasterTitle.MasterTitleId  where MasterTitle.MovieTitle like 'QA_Regression%878') and VariantID  in (279)

	SET @firstAssetId = @firstAssetId + 1
END -- @firstAssetId

-- assetIds: 3937,3929,3946,3839,3838,3837,3834,3826,3825,3817,3815
--and PropertyName like '%SW_VERSION' and StreamName not like '%LEVEL 2'
/* PropertyName   Values
LEVEL
ENCRYPTION_ID
MANAGER_SW_VERSION
NODE_SW_VERSION
LEVEL
FRAME_RATE
SCAN_TYPE
MUX_TIME_IN_SECONDS
ENCODE_TIME_IN_SECONDS
MANAGER_SW_VERSION
NODE_SW_VERSION
*/
