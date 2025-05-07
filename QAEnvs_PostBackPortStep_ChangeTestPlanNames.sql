-- POST BACKPORT STEP FOR QA1/QA2
-- Change Test Plan Names to '* QA'
  Update AlTestPlan set Name = Name + ' QA'  Where  TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200) and Name not like '%No Subs %' and Name not like '%(MPEG2)%'
  Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX('No Subs ',Name))+SUBSTRING(Name,CHARINDEX('No Subs ',Name)+8,LEN(Name))+' QA'  Where  Name like '%No Subs %' and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
  Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX(' (MPEG2)',Name))+SUBSTRING(Name,CHARINDEX(' (MPEG2)',Name)+8,LEN(Name))+' QA'  Where  Name like '% (MPEG2)%' and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
  Update AlTestPlan set Name = SUBSTRING(Name,0,CHARINDEX('(MPEG2)' ,Name))+SUBSTRING(Name,CHARINDEX('(MPEG2)' ,Name)+7,LEN(Name))+' QA'  Where  Name like '%(MPEG2)%'  and TestPlanId in (Select TestPlanId from ALVariantTestPlan  Where  VariantID >=200)
