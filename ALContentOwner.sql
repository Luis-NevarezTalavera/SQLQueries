use AssetLibrary
Select top (100) T.TitleID, T.TitleName, T.TitleTypeID, T.ContentOwnerAliasID, A.AliasDescription, A.ContentOwnerID, L.LookupDescription 
from ALTitle T Left outer join ALContentOwnerAlias A on T.ContentOwnerAliasID = A.AliasID
						Left outer join ALContentOwnerLookup L on A.ContentOwnerID = L.LookupID
 where 
 -- TitleID in (11820, 11844, 11864, 11941, 11948, 11956, 11959, 11964, 12002, 12059, 12279, 12296, 12297, 12302, 12999, 13528, 13594, 13652, 14015, 14034, 14466, 16999, 21599, 21607, 21621)
 TitleName like 'QA_Smoke_2013-02%'
 or TitleId in (21844)
 order by TitleID desc

Select * from ALContentOwnerAlias  order by AliasDescription --where AliasDescription like 'Warner%' order by AliasID
select * from ALContentOwnerLookup  order by Lookupid  -- order by LookupDescription
