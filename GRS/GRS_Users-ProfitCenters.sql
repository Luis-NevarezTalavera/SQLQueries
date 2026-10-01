Select Division, Region, ProfitCenterProfile, Count(Id) as 'Count Of Profit Centers'
from ProfitCenters
Group by Division, Region, ProfitCenterProfile
Order by Count(Id) desc;

SELECT * FROM [HangFire].[Job];

Select * from Templates Where TemplateId in ('05A9EBE2-BB7B-4F31-AA70-CBCAED6F2B53','439D8B35-4CAC-4D71-946A-BB67E8BAC19F','4F2C8F2F-CF6C-4133-8AB1-30C2C593AEF2');

Select * from ProfitCenters order by ProfitCenterNumber;
Select * from PCExceptions;
Select * from ProfitCenterSilos;
Select * from ADUsers Where displayName like '%Luis%';

Select * from Users Where Email like '%luis.talavera%'; -- ProfitCenterNumber like '621%'; -- 
-- Delete Users Where Id = '14247';

-- Update Users Set ProfitCenterNumber = '699-01' Where Email='luis.talavera@bbrown.com';

Select Currency, ProfitCenterLocation, Count(Id) as UsersCount 
From Users
--Where ProfitCenterLocation like '621 Risk Sol%'
Group by Currency, ProfitCenterLocation
Order by ProfitCenterLocation; --UsersCount desc;

-- Update Users set ProfitCenterLocation = '621 Risk Solutions' where UserName='Luis Talavera' and ProfitCenterLocation = '621 Risk Soliutions';

Select * From IOLReportLogs
Where RecipientEmail like 'Tarisha%';

-- Update Answers Set ProfitCenterName = 'Risk Solutions' Where ProfitCenterNumber = '621';

Select T.Name, T.Currency, A.* 
From Answers A Left Outer Join Templates T on A.TemplateId = T.TemplateId
Where A.IsActive in (0,1) -- = 1 -- 
And A.Currency in ('USD','CAD','GBP')
 And EmployeeEmail='luis.talavera@bbrown.com' 
And Month = MONTH(GETDATE())
-- And A.TemplateId in ('05A9EBE2-BB7B-4F31-AA70-CBCAED6F2B53')
Order by CreateDate desc;

-- Delete Answers Where Id in ('67130','67129','67128');
-- Update Answers Set IsActive=1 Where Id in ('516902');
