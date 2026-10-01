Select U.*, UC.AccessLevel, C.Name, R.*, C.*, CF.*
From Users U	Left Outer Join UserRoles UR On U.Id = UR.UserId
				Left Outer Join Roles R On UR.RoleId = R.Id
				Left Outer Join UserClients UC On U.Id = UC.UserId
				Left Outer Join Clients C On UC.ClientId = C.Id
				Left Outer Join UserRootFolders URF On C.Id = URF.UserClientId
				Left Outer Join ClientFolders CF On URF.RootFolderId = CF.Id
Where U.IsActive = 1 -- and R.IsActive = 1 and CF.IsActive = 1
And (U.EmailAddress like 'amoquia%' Or U.EmailAddress like 'katie%' Or U.EmailAddress like 'yeshua%' Or U.EmailAddress like 'luis.%' ) -- U.EmailAddress like 'yeshua%' -- U.EmailAddress like 'luis.nevarez.talavera@outlook.com%' -- 
-- And R.Name =  'InternalUser' -- 'ExternalUser' --, 'ExternalUser', 'Admin'
-- And U.LastName like '%Support'
-- And C.Name = 'Acme Corporation'
-- And CF.Name = 'ACME Root'
Order By U.Id, R.Id, C.Id, CF.Id;

select * from Clients;
select * from UserClients;
select * from UserRootFolders;
select * from ClientFolders;

select * from Users;
select * from UserRoles;
select * from Roles;

-- Update UserClients set AccessLevel=1 Where UserId = (Select Id from Users Where EmailAddress='luis.nevarez.talavera@outlook.com');
-- Update Users set LastName = 'Nevarez External Limited' Where EmailAddress='luis.nevarez.talavera@outlook.com';