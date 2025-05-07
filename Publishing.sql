Use Publishing
SELECT   TOP(200)	Mail.FromUserGUID, [User].ScreenName, Mail.Subject, Mail.MailType, Mail.MessageText, Mail.CreatedDateTime, Mail.InformationText1, Mail.InformationText2, Mail.IsDeleted, 
					MailData.MailDataTypeID, MailData.XMLData,MailRecipient.MailFolderID, MailRecipient.IsDeleted, MailRecipient.CreatedDateTime -- MailRecipient.RecipientUserGUID, MailRecipient.MailGUID
FROM			Mail Left Outer JOIN MailData ON Mail.MailGUID = MailData.MailGuid
INNER JOIN		MailRecipient ON Mail.MailGUID = MailRecipient.MailGUID
INNER JOIN     [User] ON Mail.FromUserGUID = [User].UserGUID 
Where  -- MessageText like '%95__(%' 
  InformationText1 in ('a1-451053','a1-451054') -- , 'a1-160522',
-- and InformationText2 in ('s1-3884907')
 and ScreenName in ('TJMSourceUser') --,'CPMMailUser') 
-- and MailRecipient.IsDeleted = 0
-- and MailRecipient.MailFolderID = 100 
--and Mail.CreatedDateTime > '2012-04-05'
ORDER BY Mail.CreatedDateTime desc, MailData.CreatedDateTime desc, MailRecipient.CreatedDateTime desc

--update MailRecipient set IsDeleted = 1 where MailRecipient.MailFolderID = 200 
--and MailGuid in (select MailGUID from Mail where InformationText1 in ('a1-3828','a1-3827','a1-3826','a1-3821','a1-3820','a1-3819','a1-3818') and InformationText2 in ('s1-62601','s1-62026','s1-64706'))

/*
update Mail set Isdeleted=1
update MailPackage  set Isdeleted=1
update MailData  set Isdeleted=1
select * from parameters
*/