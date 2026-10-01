
Select * from Agents  WHERE FirstName like 'luis%' -- AgencyId Is Null
Select * from Agencies;
Select * from InsuredAgencies;
Select * from AspNetUsers;

SELECT U.UserName, U.Email, I.UserName, I.Email, I.FirstName, I.MiddleName, I.LastName, I.InsuredClassification, Y.Name as AgencyName, Y.Website, 
	A.FirstName, A.LastName, A.Phone, A.Email, A.IsActive, C.ClaimType, C.ClaimValue
FROM AspNetUsers U	Left Outer Join Insureds I on U.Email = I.Email
				Left Outer Join InsuredAgencies IA on IA.InsuredId = I.Id
				Left Outer Join Agencies Y on Y.Id = I.AgencyId
				Left Outer Join Agents A on A.AgencyId = Y.Id
				Left Outer Join AspNetUserClaims C on U.Id = C.UserId
 WHERE A.FirstName like 'QA1%' -- (A.FirstName Is Null or )
 and A.Email like 'QA.Test%'
-- Y.AgencyAddress_City = 'Atlanta'
-- Y.AgencyAddress_State = 'GA'
-- A.IsActive = 'True'

-- Delete from Agents where Email in ('MyNewAgent@mailsc.com','allen.agent2@mailsac.com','AgentA@email.com','amy.angel@mailsac.com','Tim.Minchin@mailsac.com','Alton.Allen@mailsac.com','tom.appleton@mailsac.com','allen.agent@mailsac.com');
