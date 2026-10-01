
Select * from CommercialGLItems;
Select * from CommercialGLRates;
Select * from TerritoryZips where Zip = 02940;

Select CGLI.Id, CGLI.Code, CGLI.Description, CGLR.Territory, CGLR.BaseRate, CGLI.ILF, CGLI.CGLPBase, CGLI.CGLPBaseUnit, CGLI.IsActive as 'ItemIsActive', CGLR.IsActive as 'RateIsActive', TZ.Zip, CGLR.EffectiveDate, CGLR.ExpiryDate, GETDATE() as Today
-- Select CGLR.Territory, Count(CGLI.Code) as Count, ROUND(Sum(CGLR.BaseRate),4) as Sum, ROUND(AVG(CGLR.BaseRate),4) as Avg, MAX(CGLR.BaseRate) as Max, MIN(CGLR.BaseRate) as Min
From CommercialGLItems CGLI	Left Outer Join CommercialGLRates CGLR on CGLI.Id = CGLR.CommercialGLItemId
							Left Outer Join TerritoryZips TZ on TZ.Territory = CGLR.Territory
Where CGLI.IsActive = 1 and CGLR.IsActive = 1 -- 
 and TZ.Zip in (02901, 02905, 02828)
-- and CGLR.Territory = 503
-- and CGLI.Code in ('12014','46112') -- '12014','13507','16820','40005','40006','40101','40102','41715','41716','44427','44428','44429','44430','44431','44432','44433','44434','44435','44436','44437','44438','44439','44440','44500','44501','46112','46622','60010','61000','61226','61227','66561','68606','68706','49451')
-- and CGLI.Description like '%Amb%'
/*
(	(CGLI.Description in ('Medical Office Building','Convalescent / Nursing Home - FP') and TZ.Zip = 02940)
	OR
	(CGLI.Description in ('Vacant Land','Boarding or Rooming House') and TZ.Zip = 02842)
)
*/
-- CGLPBase='Per unit'
and CGLR.EffectiveDate >= '2026-11-01 00:00:00.0000000' -- GETDATE()
--and (CGLR.ExpiryDate >= GETDATE() or CGLR.ExpiryDate Is Null)
 Group by CGLR.Territory, CGLR.EffectiveDate
Order by CGLI.Code, CGLR.Territory, TZ.Zip, CGLR.EffectiveDate;