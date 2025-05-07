select * from QAOneSherlockJobs where OrderDescription > ''
-- insert into QAOneSherlockJobs values(15, 'HybrikNexGuardId', 'sdlc-qa002', '{ "index": 1, "languageCode": "eng" }, { "index": 2, "languageCode": "spa" },', '{ "index": 3, "languageCode": "fin" },',	'{ "index": 4, "languageCode": "deu" }, { "index": 5, "languageCode": "por" }')
-- update QAOneSherlockJobs set OrderDescription='', DeliveryComponentSpec='sdlc-' where qSherlockJobId=11
select * from QAOneSourceAssets
select * from QAAsset
--select * into QAOneSourceAssets from SourceAssets
-- select SUBSTRING(fileName,charindex('\',fileName)+1,500) from QAOneSourceAssets
