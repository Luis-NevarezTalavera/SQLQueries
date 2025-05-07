Select "ContentOwner_Name", Count(*)
From sourceassettypes
Group by "ContentOwner_Name"

-- Select Distinct *
-- From sourceassettypes
-- Where "AssetID" in ('A12729792','A12729792')

-- Update sourceassettypes 
--   set "ContentOwner_Name" = 'AT&T' 
--   where "ContentOwner_Name" like 'AT&T%' 
-- "AT&T", "Charter", "Funimation", "Rogers", "Shaw", "Disney"
-- Update sourceassettypes 
--   set "Display_A/R" = '16:9'
--   set "Channel_Config" = '2.0'
--   where "Channel_Config" = '2'