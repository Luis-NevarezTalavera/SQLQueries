-- Query for checking on L1s and L2s the TNs/CPNs software version, Stream Level, Encryption ID, Scan Type
Use AssetLibrary
-- Select LEFT(S.UpdatedDateTime,11) as UpdatedDate, Sum(Duration)/3600 as TotalHDHrsPerDay
 Select LEFT(S.UpdatedDateTime,4)+CONVERT(varchar,YEAR(S.UpdatedDateTime)) as Year_Month, S.VariantID, Count(S.VariantID) as Failures
-- SELECT 	DISTINCT Top (2000)	 S.AssetID, S.StreamID, S.VariantID, S.StreamName, S.StreamStateTypeID, S.Status, S.CreatedDateTime, S.UpdatedDateTime --, A.AssetName, A.Duration, 
							-- ,S.EncryptionTypeId, SP.PropertyName, SP.ValueFloat, SP.ValueStr, SP.ValueInt, SP.ValueBool, SP.ValueEnum, S.TNIPAddress, S.TNVersion, S.CPNIPAddress, S.CPNVersion
							 -- LE.LookupValue, SL.LCID, LT.LookupValue as LanguageType,  -- 
FROM ALStream S WITH (NOLOCK) -- Left Outer Join ALStreamProperty SP	ON S.StreamID = SP.StreamID 
							  -- Left Outer Join ALStreamLanguage SL	ON S.StreamID = SL.StreamID
							  -- Left Outer Join LanguageType LT		ON SL.LanguageTypeID = LT.LookupID
							  -- Left Outer Join LookupEnum LE			ON SP.ValueEnum = LE.LookupID 
							  -- Left Outer Join ALAsset A WITH (NOLOCK)				ON S.AssetID = A.AssetID
 Where S.IsDeleted in(0,1) --  and  SP.IsDeleted in(0,1)
-- and S.AssetId in (Select AssetId   FROM ALTitle T WITH (NOLOCK) Left Outer JOIN ALTitleAsset TA ON T.TitleID = TA.TitleID  Where ( TitleName like 'QA_FF_Regression_2017%'  OR  TitleName like '%Order%Setup%' ) ) -- 
-- and  'a1-' + CONVERT(varchar(8), S.AssetId)  in (SELECT asset_id FROM OrderProcessingConsole.dbo.orders INNER JOIN OrderProcessingConsole.dbo.order_jobs ON orders.id = order_jobs.order_id Where orders.id in (30954,30955,30952,30951,30950,30949)) -- 
-- and StreamName like 'CPS%' 
-- and  S.VariantId  in  (225,228,350,436,437,438,439,493,494,496,497,498,499,510,511,512,513,514,515,518,519,520,521,522,523,524,525,537,538,539,540,550,608,617,628,638,648,650,653,665,666,669,670,671,672,673,674,677,678,679,680,682,683,684,685,687,688,689,690,691,692,697,706,707,708,709,710,711,714,716,718,728,729,730,731,745,759,760,778,779,782,783,784,785,797,798,800,801,802,803,806,807,808,809,811,822,823,828,829,837,838,839,840,841,842,843,844,845,846,850,855,857,869,870,871,872,875,876,879,880,881,882,887,888,2001,2003,2008,2009) -- HD
 and  S.VariantID  not in (Select VariantID  From ALVariantBatonBypass)
-- and S.EncryptionTypeId  in  (547)
-- and A.AssetID   in  (1253566,1253567,1253568,1253569) -- 
-- and LT.LookupValue = 'Audio'
-- and ( A.AssetName  like 'Cowboy%' ) --  OR A.AssetName like 'BobBurg%' ) -- 4x3Asset
-- and S.StreamId = 5393734
-- and (S.StreamStateTypeID = 345  or  (S.StreamStateTypeID = 346  and  S.Status like '1:%'))
 and  (S.StreamStateTypeID = 346  and  S.Status like '1:%')
-- and A.Duration > 100
-- and  ( PropertyName  like '%TIME_IN_SECONDS'  OR  PropertyName  like '%REMUX%') -- in ('MUX_TIME_IN_SECONDS','ENCODE_TIME_IN_SECONDS') --, 'MANAGER_SW_VERSION','NODE_SW_VERSION') -- ,'CC_EMBEDDED','LEVEL','DigitalAdEmbedded') --  OR PropertyName like '%Burn%' OR PropertyName like 'Level%' )
-- and ValueFloat > 100
 and S.CreatedDateTime >= '2019-03-31 12:00:00.000' and S.UpdatedDateTime <= '2019-04-05 00:00:00.000'
 GROUP BY LEFT(S.UpdatedDateTime,4)+CONVERT(varchar,YEAR(S.UpdatedDateTime)), S.VariantID -- MES  LEFT(S.UpdatedDateTime,11)
 ORDER BY LEFT(S.UpdatedDateTime,4)+CONVERT(varchar,YEAR(S.UpdatedDateTime)), S.VariantID -- MES  LEFT(S.UpdatedDateTime,11)
-- ORDER BY  S.AssetID, S.VariantID, SP.PropertyName
/*
 Select  Count(TNIPAddress) as Qty, TNIPAddress -- ,AssetID, StreamID, VariantID, TNVersion, CPNIPAddress, CPNVersion 
 From ALStream
 Where IsDeleted=0
 and AssetId in (1682975) -- Select AssetId   FROM ALTitle T WITH (NOLOCK) Left Outer JOIN ALTitleAsset TA ON T.TitleID = TA.TitleID Where (TitleName like 'QA_Regression_2016/11/18%') ) -- 
 and TNIPAddress Is Not Null
 Group by TNIPAddress -- , AssetID, StreamID, VariantID, TNVersion, CPNIPAddress, CPNVersion 
 Order by TNIPAddress -- , AssetID, StreamID, VariantID, TNVersion, CPNIPAddress, CPNVersion 
 */
/*
Select  Status, PropertyName, ValueStr, ValueFloat
from ALStream S Inner Join ALStreamProperty P on S.StreamId = P.StreamId
Where PropertyName IN ('ENCODE_TIME_IN_SECONDS','MUX_TIME_IN_SECONDS','NODE_SW_VERSION')
and S.AssetId BETWEEN 781954 and 781984

select sum(ValueFloat)  as SumEncodePlusMuxTime
FROM ALStream S WITH (NOLOCK) Left Outer Join ALStreamProperty SP	ON S.StreamID = SP.StreamID 
 where AssetID in (152276) and PropertyName in ('MUX_TIME_IN_SECONDS','ENCODE_TIME_IN_SECONDS') and s.IsDeleted=0
 and VariantId in (1,250,266,251,267,244,252,268,245,253,254,269,246,249,238,56,247,239,243,55,240,54,58,241,248)
*/

/* PropertyName   Values
DEMUX_COMPLETE
LEVEL
ENCRYPTION_ID
MANAGER_SW_VERSION
NODE_SW_VERSION
LEVEL
FRAME_RATE
SCAN_TYPE
MUX_TIME_IN_SECONDS
ENCODE_TIME_IN_SECONDS
DigitalAdEmbedded

StreamStateTypeID Values
343 = Pending
345 = Completed
346 = Failed
512 = TranscodedSuccesfull, Not Tested
15 = Transcoding Error                  
	
*/