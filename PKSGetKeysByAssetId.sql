Use PlayreadyKeyStore
OPEN SYMMETRIC KEY sk_AK_001         
		DECRYPTION BY CERTIFICATE ct_AK_001;

	OPEN SYMMETRIC KEY sk_AK_001         
		DECRYPTION BY CERTIFICATE ct_AK_001;
	SELECT * -- AssetID, [PlayReadyKeyID], CONVERT(NVARCHAR(50), DecryptByKey([PlayReadyKeySeed])) [PlayReadyKeySeed]
	FROM [PlayreadyAsset] WITH (NOLOCK)
WHERE 
    AssetID in ('a1-1253473-s1-11210773','a1-1253473-s1-11210768','a1-1253473-s1-11210767')

-- Select * from ContentType
-- Select * from DRMType
