 
-- Use QATest
-- Use AssetLibrary
 Select VTP.VariantId, TP.TestPlanId, TP.Name 
From AlTestPlan TP  Left Outer Join ALVariantTestPlan VTP on TP.TestPlanId = VTP.TestPlanId
 Where  Name like '%'
 and VariantId >=100 -- 
Order by VariantId, VariantTestPlanId -- TestPlanId -- 

/*
SELECT * FROM [sys].[servers]
-- OverAll Baton Related Settings
Select * from ALSetting
update ALSetting set value='true' where Name='BatonBypassAll'
BatonBypassAll 
BatonByPassHigh 
BatonBypassUrgent 
*/
/*
-- Change QA Test Plan Names to '* QA'
 Update AlTestPlan set Name = Name + ' QA'  Where  TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200) and Name not like '%No Subs %' and Name not like '%(MPEG2)%'
 Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX('No Subs ',Name))+SUBSTRING(Name,CHARINDEX('No Subs ',Name)+8,LEN(Name))+' QA'  Where  Name like '%No Subs %' and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
 Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX(' (MPEG2)',Name))+SUBSTRING(Name,CHARINDEX(' (MPEG2)',Name)+8,LEN(Name))+' QA'  Where  Name like '% (MPEG2)%' and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
 Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX('(MPEG2)' ,Name))+SUBSTRING(Name,CHARINDEX('(MPEG2)' ,Name)+7,LEN(Name))+' QA'  Where  Name like '%(MPEG2)%'  and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
*/
/*
-- Update TestPlan To Prod Names From DEV.AssetLibrary  -- Inserting new Test Plans in TesPlan table -- 
-- Use AssetLibrary
 Use QATest
DECLARE @variantId AS int
SET @variantId = 200 -- 200
WHILE (@variantId <= 2009) -- 2009
BEGIN
	PRINT 'VariantId: ' + 'v1-' + CONVERT(varchar(4),@variantId)
--	 Insert AlTestPlan Values ((Select Max(TestPlanID)+1 as MaxTestPlanID  from AlTestPlan), 'v1-' + CONVERT(varchar(4),@variantId) + ' QA','v1-' + CONVERT(varchar(4),@variantId),0,GETDATE(),'D3',NULL,NULL,1)
--	 Insert ALVariantTestPlan Values ((Select Max(VariantTestPlanID)+1 as MaxVariantTestPlanID  from AlVariantTestPlan), @variantId,( select TOP(1) TestPlanID from AlTestPlan  Where  Name like 'v1-' + CONVERT(varchar(4),@variantId) + '%' ),GETDATE(),'D3')
	 Update AlTestPlan set Name = ( Select Top 1 Name from  [192.168.96.115].AssetLibrary.dbo.AlTestPlan TP Left Outer Join [192.168.96.115].AssetLibrary.dbo.ALVariantTestPlan VTP on TP.TestPlanId = VTP.TestPlanId Where VTP.VariantId = @variantId )
		 Where TestPlanId=( Select Top 1 TestPlanId TP1 from ALVariantTestPlan VTP1 Where VTP1.VariantId = @variantId)
	
	IF @variantId = 900
		SET @variantId = 2000
	ELSE
		SET @variantId = @variantId + 1
END
*/
/*
-- Changing the QA Test Plan Names for a Range of Variants --
-- Use QATest
 Use AssetLibrary
DECLARE @variantId AS int
SET @variantId = 871
WHILE (@variantId <= 882)
BEGIN
	 Update AlTestPlan Set Name = 'v1-' + CONVERT(varchar(3),@variantId) + ' QA'   Where  Name like ('v1-' + CONVERT(varchar(3),@variantId) + '%' )
	-- Update AlTestPlan Set AlTestPlan.Name = (Select TOP(1) Name  From AssetLibrary..AlTestPlan TP  Left Outer Join AssetLibrary..ALVariantTestPlan VTP on TP.TestPlanId = VTP.TestPlanId  Where TP.TestPlanId = @variantId)   Where AlTestPlan.TestPlanId = @variantId
	SET @variantId = @variantId + 1
END
*/
/*
Select * from AlVariant
Where VariantId not in (
-- Select, Delete Variants to be Bypass from Baton
 Select VariantID 
-- Delete 
From [AssetLibrary].[dbo].[ALVariantBatonBypass] 
-- Where VariantID in (496,497,498,499,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529 ) --
-- and VariantBatonByPassID > = 690
Order by VariantID )
Order by VariantID 
*/