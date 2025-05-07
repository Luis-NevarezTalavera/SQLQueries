-- Refresh the TestPlan Names in QA2 AssetLibrary from DEV AssetLibrary
Use AssetLibrary
Delete ALVariantTestPlan
Delete ALTestPlan
SET IDENTITY_INSERT AssetLibrary.dbo.ALTestPlan ON
Insert Into AssetLibrary.dbo.ALTestPlan (TestPlanID,Name,Description,IsDeleted,CreatedDateTime,CreatedBy,UpdatedDateTime,UpdatedBy,LibraryID)  select * from [192.168.96.115].AssetLibrary.dbo.ALTestPlan
SET IDENTITY_INSERT AssetLibrary.dbo.ALTestPlan OFF
SET IDENTITY_INSERT AssetLibrary.dbo.ALVariantTestPlan ON
Insert Into AssetLibrary.dbo.ALVariantTestPlan (VariantTestPlanID,VariantID,TestPlanID,CreatedDateTime,CreatedBy)  select * from [192.168.96.115].AssetLibrary.dbo.ALVariantTestPlan
SET IDENTITY_INSERT AssetLibrary.dbo.ALVariantTestPlan OFF

-- select * from ALTestPlan
-- select * from ALVariantTestPlan
