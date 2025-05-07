-- Update QA1/QA2 AssetLibrary TestPlans Names From DEV.AssetLibrary -- 
Use AssetLibrary
DECLARE @variantId AS int
SET @variantId = 200
WHILE (@variantId <= 2009)
BEGIN
	PRINT 'VariantId: ' + 'v1-' + CONVERT(varchar(4),@variantId)
	Update AlTestPlan set Name = ( Select Top 1 Name from  [192.168.96.115].AssetLibrary.dbo.AlTestPlan TP Left Outer Join [192.168.96.115].AssetLibrary.dbo.ALVariantTestPlan VTP on TP.TestPlanId = VTP.TestPlanId Where VTP.VariantId = @variantId )
		Where TestPlanId=( Select Top 1 TestPlanId TP1 from ALVariantTestPlan VTP1 Where VTP1.VariantId = @variantId)
	SET @variantId = @variantId + 1
	
	IF @variantId = 900
		SET @variantId = 2000
END

Select VTP.VariantId, TP.TestPlanId, TP.Name 
From AlTestPlan TP  Left Outer Join ALVariantTestPlan VTP on TP.TestPlanId = VTP.TestPlanId
 Where  Name like '%'
 and VariantID  >=200 
Order by VariantId, VariantTestPlanId 
