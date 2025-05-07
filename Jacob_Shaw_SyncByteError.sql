Use AssetLibrary
Select assetID, StreamId, VariantID, StreamName, Status, CreatedDateTime, UpdatedDateTime
from ALStream
Where 
(VariantID in (496,497,498,499,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529 ) -- Shaw variants
and Status Is Null ) -- Normal Status = 'Transcode Successful', it will be null if it was Manually Baton Pass
Or (Status like '%Sync%Byte%' and StreamSubStateTypeID = 524) -- FAILED_QC
 