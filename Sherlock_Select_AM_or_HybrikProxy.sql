--default to AM
update app_config ac set value  = 'deluxe.deluxeone.combinedstreampackager.process.2.0'
where key = 'COMBINED_STREAM_PACKAGER_WORKFLOW';
update app_config ac set value  = 'deluxe.dependencygraph.execute.process.2.3'
where key = 'EXECUTE_WORKFLOW';
update app_config ac set value  = 'deluxe.deluxeone.streampackager.process.2.3'
where key = 'STREAM_PACKAGER_WORKFLOW';

--default to Proxy
update app_config ac set value  = 'deluxe.deluxeone.combinedstreampackager.process.1.2'
where key = 'COMBINED_STREAM_PACKAGER_WORKFLOW';
update app_config ac set value  = 'deluxe.dependencygraph.execute.process.1.20'
where key = 'EXECUTE_WORKFLOW';
update app_config ac set value  = 'deluxe.deluxeone.streampackager.process.1.14'
where key = 'STREAM_PACKAGER_WORKFLOW';

--Checking values
Select key, value, right(value,3) as Version, '2.x = AM is Default; 1.xx Proxy is Default' as AM_Proxy
From app_config
where key in ('COMBINED_STREAM_PACKAGER_WORKFLOW','EXECUTE_WORKFLOW','STREAM_PACKAGER_WORKFLOW');
--and right(value,3) like '2.%';