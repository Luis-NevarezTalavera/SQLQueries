SELECT Action, CASE Action WHEN  1 THEN 'Create' WHEN  3 THEN 'Soft Delete' WHEN 10 THEN 'Upload' WHEN 11 THEN 'Download' WHEN 12 THEN 'Move' WHEN 13 THEN 'Rename' WHEN 20 THEN 'Login' WHEN 21 THEN 'View' ELSE 'Other' END AS ActionText,
CASE EntityType WHEN 1  THEN 'File' WHEN 2  THEN 'Folder' WHEN 3  THEN 'Client' WHEN 4  THEN 'User' ELSE 'Other' END AS EntityTypeText, 
 EntityType, Count(Action) as Count, MIN(EntityName) as FirstEntityName, MAX(EntityName) as LastEntityName, MIN(PerformedByEmail) as FirstPerformedByEmail, MAX(PerformedByEmail) as LastPerformedByEmail
FROM ActivityLogs
-- Where ClientName = 'Acme Corporation'
-- And CreateDate >= '2026-08-01 00:00:00.0000000'
-- And PerformedByEmail = 'Luis.Talavera@bbrown.com'
-- And ClientFileName like '%pdf'
-- And ClientFolderName like '%folder%';
-- And EntityType = 1
-- And Action not in (10,11)
GROUP BY Action, EntityType
ORDER BY Action, EntityType;


Select *
From ActivityLogs
Where ClientName != 'Acme Corporation'
-- And CreateDate >= '2026-08-01 00:00:00.0000000'
-- And PerformedByEmail = 'Luis.Talavera@bbrown.com'
-- And ClientFileName = 'export_form_responses_as_xlsx.xlsx' -- 'file_10MB.txt'
-- And ClientFolderName like '%folder%';
-- And Action = 13 -- not in (1,10,11,12,20,21)
And EntityId = 113
Order by CreateDate desc;

/*
EntityType
1 - File
2 - Folder
3 - Client
4 - User

Action
1  - Create Folder
10 - Upload File
11 - Download File
20 - Login
21 - Access Client
*/
