Select * from ApplicationTypes;
Select * From Specialties Where UISection is not null order by UISection, CategoryId; -- CategoryID='e530756a-ced6-4dd0-979b-ab8e6db5c921' and 
Select * From SpecialtyRates;
Select * From Categories where Id ='0c355626-9dfc-4942-a0d0-6ac8673887c8'

-- Id	                                CategoryName
-- 1f216994-30d8-4207-aac4-3a6f8b073dac	HealthCareProfessional
-- e1f089a7-cf19-4fc9-8319-4b43a42a259b	Facility
-- 0c355626-9dfc-4942-a0d0-6ac8673887c8	PhysicianSurgeon
-- 7312294c-4d7f-4c97-81cf-7fc01d62dde0	Individual
-- e530756a-ced6-4dd0-979b-ab8e6db5c921	FacilityApp

Select DISTINCT S.Id, S.Code, S.Name as SpecialityName, SR.Rate, LLF.Factor, SR.PolicyType, S.PremiumBaseDescription, S.PremiumBaseValue, S.UISection, S.BaseSpecialty, S.Miscellaneous, S.IsActive, SR.EffectiveDate, SR.ExpiryDate, SR.EmployedRate, SR.IsActive as SRIsActive, AT.Type as AppType, AT.Classification , C.CategoryName
From Specialties S  Left Outer JOIN SpecialtyRates SR On SR.SpecialtyId = S.Id
                    Left Outer JOIN ApplicationTypes AT On AT.Id = S.ApplicationTypeId
                    Left Outer JOIN Categories C On C.Id = S.CategoryId
                    Left Outer JOIN LimitsOfLiabilityFactors LLF On S.ILFType = LLF.ILFType
Where  S.IsActive = 1 and SR.ExpiryDate Is Null -- and SR.Rate Is Not Null and PremiumBaseDescription Is NOT NULL -- and S.IsActive = 1 and S.UISection is not null 
    -- and S.Id in ('e876410f-42b1-4e0c-b85a-740ee6eae92a')
    -- and S.Name Not in ('Employed Chiropractor','Employed Dentist','Employed Podiatrist','Employed Physicians and Surgeons','PARTNERSHIP/CORPORATION')
    -- and S.Name in ('Dentist - Class IV','HAND SURGERY')
    -- and (SR.Rate Is Null Or SR.Rate=0 Or LLF.Factor Is Null Or LLF.Factor=0) -- and S.BaseSpecialty=1
    -- and SR.PolicyType in ('Occurrence','Claims Made') --  
    -- and s.code in ('80225')
    -- and S.UISection Is Not Null
    -- and C.CategoryName in ('FacilityApp') -- ,'HealthCareProfessional','PhysicianSurgeon') -- 
    -- and AT.Type in ('Facility') --, 'Health Care Professional','Physician Surgeon') --'Dentist',
    -- and S.UISection in ('PhysicianInTraining') -- 
    -- and AT.Type is not null
    --    and S.BaseSpecialty = 0
Order by S.Name, S.Code -- , AT.Classification, C.CategoryName, 
-- Group by AT.Type
-- Order by AT.Type

-- UPDATE Specialties SET UISection = 'newspecialties' WHERE UISection='' or Name like '%Medical Student%';
