Select request_id, job_status, request_type, date_created, date_started, date_completed, execute_time, execute_count 
  from agent_request_queue
  where date_completed is Null and job_status in ('Completed') -- date_created >= date_started or date_started >= date_completed 
  and Left(Cast(date_created as varchar),10) >= '2022-10-28'

Select Left(Cast(date_created as varchar),10) as Date_Created, Left(Cast(date_started as varchar),10) as Date_Started, Left(Cast(date_completed as varchar),10) as Date_Completed, job_status, request_type, 
  Sum(execute_time) as sum_execute_time, Sum(execute_count) as sum_count, Sum(execute_time)/Sum(execute_count) as avg_time, 
  Max(execute_time) as max_execute_time, Max(execute_count) as max_count, 
  Min(execute_time) as min_execute_time, Min(execute_count) as min_count
from agent_request_queue
Where Left(Cast(date_created as varchar),10) >= '2022-11-03'  and Left(Cast(date_created as varchar),10) <='2022-11-04' 
--	and date_completed is Null
	and job_status in ('Completed', 'Failed')
Group By Left(Cast(date_created as varchar),10), Left(Cast(date_started as varchar),10), Left(Cast(date_completed as varchar),10), job_status, request_type
Order By Left(Cast(date_created as varchar),10) desc, Left(Cast(date_started as varchar),10) desc, Left(Cast(date_completed as varchar),10) desc, job_status, request_type
