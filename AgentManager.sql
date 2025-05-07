SELECT key, value, type 
	FROM agent_app_config 
	WHERE key in ('ENABLE_AUTO_PROXY_CREATION_BY_MESSAGE', 'AUTO_PROXY_OUTPUT_PATH')

Update agent_app_config 
    SET value = 'true'
    WHERE key = 'ENABLE_AUTO_PROXY_CREATION_BY_MESSAGE'

SELECT j.id, j.request_id, j.transcoder, j.transcode_action, j.date_created, j.date_completed, j.status, 
       j.job_id, j.workflow_id, j.transcode_job_id, l.type, l.message --, input, output
    FROM agent_transcode_job j Left Outer join agent_request_log l on l.transcode_job_id = j.id
    WHERE transcode_action  in ('PROXY') 
--        and transcode_job_id in ('664088')
    ORDER BY ID DESC
    LIMIT 100

Select id, transcode_job_id, correlation, message, created_date, created_by, type
From agent_request_log
Where -- transcode_job_id = 664088
transcode_job_id = 94922

Select id, requestid, message, createdate
From agent_debug_log
Where -- requestid = 'c9672813-8c8d-4ad1-94c9-b3c2a7a6f670'
createdate >= '2022-06-29' -- 14:49:29.563'