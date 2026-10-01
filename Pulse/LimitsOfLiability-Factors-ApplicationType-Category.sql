Select * from ApplicationTypes;
Select * from Categories;
Select * from LimitsOfLiabilities;
Select * from LimitsOfLiabilityFactors;

Select LL.Code, LL.IsActive, LL.Limit, LF.EffectiveDate, LF.ExpiryDate, LF.Factor, LF.IsActive, LF.Miscellaneous, AT.Type, AT.Classification --, C.CategoryName
From LimitsOfLiabilities LL	Left Outer Join LimitsOfLiabilityFactors LF On LL.Id = LF.LimitsOfLiabilityId
							Left Outer Join ApplicationTypes AT on LL.ApplicationTypeId = AT.Id
							--Left Outer Join Categories C on LL.CategoryId = C.Id
Where AT.Type in ('Facility','Health Care Professional','Dentist','Physician Surgeon','Hospital')
--	and LF.ExpiryDate Is Null
	and LL.IsActive = 1
--	and LF.IsActive = 1;
