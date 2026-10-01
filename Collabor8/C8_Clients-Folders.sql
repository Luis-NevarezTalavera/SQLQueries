
Select C.Id, C.ShortName, C.Name as ClientName, F.Id, F.ParentId, F.Name as FolderName, F.CreatedBy, F.CreateDate, I.Name as FileName, CAST(I.FileSize/1048576.0 AS DECIMAL(7,3)) as MbSize, I.IsActive
From Clients C	Left Outer Join ClientFolders F On C.Id = F.ClientId
				Left Outer Join ClientFiles I On F.Id = I.ClientFolderId
Where C.IsActive = 1
-- And ((F.ParentId Is Null and F.CreatedBy = 'System') or (F.ParentId Is Not Null and F.CreatedBy != 'System'))
And F.CreatedBy = 'luis.talavera@bbrown.com'
And C.ShortName = 'My Client'
--	C.Name = 'Acme Corporation'
-- and F.Name = 'Subfolder 1-1 - level 2'
-- And I.Name = 'Brown & Brown Style Guide1 - Print View.pdf'
-- And I.Id = 113
Order By I.FileSize -- C.Id, F.ParentId, F.Id, I.id;

-- Select * From ClientFolders;