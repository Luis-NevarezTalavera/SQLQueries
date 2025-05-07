USE AssetLibrary
Select DISTINCT TOP (200000) A.AssetId, A.AssetName, A.Duration, A.AssetTypeID, AL.LookupValue as AssetType, C.CustomerID, C.CustomerName
From	ALAsset A	LEFT OUTER JOIN CPI..CustomerAsset CA WITH (NOLOCK) ON 'a1-'+CONVERT(varchar(8),A.AssetId) = CA.AssetId 
					LEFT OUTER JOIN CPI..Customer C WITH (NOLOCK) ON CA.CustomerID = C.CustomerID
					LEFT OUTER JOIN ALAssetTypeLookup AL WITH (NOLOCK) ON A.AssetTypeID = AL.LookupID 
					Inner Join ALStream S WITH (NOLOCK) ON A.AssetId = S.AssetId 
Where A.AssetID >= 15000  and  A.Duration > 0 
-- and CA.AssetId is NULL
 and  C.CustomerName in ('AT&T','Barnes and Noble') -- 'Charter','Deluxe Digital Distributions','Zip.ca','Blockbuster','Dish','Starz','LGE','QA Test','MoviePlex','Encore','Sensio','Barnes and Noble','Charter','B&N Test','Trial Customer','Sandbox','Spirit Clips','Rogers','Choose Digital','Omni','MobiTV','Samsung','Vudu','Cineplex','Spigot','FilmFresh','AT&T','Frontier') ) 
-- and  C.CustomerName is NULL
-- and A.AssetTypeID in (1,2,3,4,5)
 and S.VariantId in (163,166,1100,1104)
Order by A.AssetId -- , AV.VariantId, C.CustomerID
/* select * from CPI..Customer
1	Deluxe Digital Distributions
2	Zip.ca
3	Blockbuster
4	Dish
5	Starz
6	LGE
22	MoviePlex
23	Encore
24	Sensio
25	Barnes and Noble
26	Charter
27	B&N Test
28	Trial Customer
29	Sandbox
30	Spirit Clips
31	Rogers
32	Choose Digital
33	Omni
34	MobiTV
35	Samsung
36	Vudu
37	Cineplex
38	Spigot
39	FilmFresh
40	AT&T
41	Frontier
42	Du
43	Shaw
44	AT&T Entertainment Zone
45	AT&T Maritime
46	Du_Website
47	ATT POC
48	Redbox
49	Big Starz
50	FrontierEST
51	DirecTV
52	MBC
53	Bell
54	TalkTalk
55	Partner
56	DL3
57	Videotron
58	CharterTWC
59	TalkTalkSVOD
60	CharterBackfill
*/
/* select * from AssetLibrary..ALAssetTypeLookup
1	FeatureFilm
2	TVEpisode
3	ShortFilm
4	Trailer
5	DeletedScene
*/
