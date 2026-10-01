SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' 
  -- and TABLE_NAME like '%Document%'
ORDER BY TABLE_NAME;

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Policies';

EXEC sp_help 'InsuranceApplications';

-- TABLE_NAME
-- __EFMigrationsHistory
-- Agencies
-- Agents
-- AggregatedCounter
-- ApplicationTemplates
-- ApplicationTypes
-- AspNetRoleClaims
-- AspNetRoles
-- AspNetUserClaims
-- AspNetUserLogins
-- AspNetUserRoles
-- AspNetUsers
-- AspNetUserTokens
-- Categories
-- ClaimsMadeFactors
-- CommercialGLItems
-- CommercialGLRates
-- Counter
-- CurrentNumber
-- Hash
-- InsuranceApplications
-- InsuredAgencies
-- InsuredDocuments
-- Insureds
-- Job
-- JobParameter
-- JobQueue
-- LimitsOfLiabilities
-- LimitsOfLiabilityFactors
-- List
-- Logs
-- Policies
-- Quotes
-- Schema
-- Server
-- Set
-- Specialties
-- SpecialtyRates
-- State
-- TerritoryZips

Select * From InsuredDocuments;

Select * From ReviewNewCols;

Select * from AspNetUsers;

Select * from AspNetRoleClaims;

Select * from AspNetUserClaims where ClaimType='AgencyId';

Select * from Agents;

Select * from CurrentNumber;

Select * From CommercialGLRates;

Select * From Categories;

Select * From ClaimsMadeFactors Order by Type, 'Year'

Select * from Logs where [TimeStamp] > '2025-12-03 10:00:00.000' Order by  Id desc; -- and Level='Error';

Select * from Quotes;

Select * from Policies;

Select * from ApplicationTypes;

Select * from ApplicationTemplates where TemplateName in ('Physician Surgeon Application','Healthcare Pro Application','Facilities Application') and IsActive = 1

Select * from TerritoryZips where zip='02940';

Select * from InsuredDocuments;

Select * from InsuranceMarketsApproached;

Select * from Agents;
