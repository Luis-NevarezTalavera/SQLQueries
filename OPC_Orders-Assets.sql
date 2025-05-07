-- SQL to Query Orders and Assets within the Orders
Use OrderProcessingConsole
Select id, encode_profilesXML.value('fn:min(encodeProfileListView[1]/encodeProfile[1]/isTwoPassEncodingEnabled)','varchar')
FROM (
SELECT top(10) o.id, o.name, o.owner, o.priority_id, o.priority, o.date, o.submit_date, oj.id AS jobId, oj.title_name,
			CONVERT(xml, o.encode_profiles) as encode_profilesXML
                 --        order_jobs.asset_id, order_jobs.asset_name, order_jobs.state_id, order_jobs.state, order_jobs.processing_counter,order_jobs.message
FROM            orders o INNER JOIN order_jobs oj ON o.id = oj.order_id
 Where
-- (orders.submit_date > '2017-09-30 01:00:00')
-- and name like 'QA_Regression%'
-- and orders.id in (192117)
 oj.asset_id in ('a1-74709')
 Order by o.submit_date desc, o.Id desc
 ) as OrdersTemp

-- Query add new user
-- Select * from user_app
-- insert into user_app values ('Scott Douglas','sdouglas','sdouglas','6279F46B-D53C-4CA4-AD42-ED3BE5E71EB8','Scott.Douglas@bydeluxe.com','admin')

-- select top 20 * from orders order by Id desc

-- Query to Cancell all Orders backported from Prod that Shows as Pending in the OP Console
-- Update orders set state_id=4,cancel_date=GETDATE() where (orders.id <= 101617 OR date <='2016-01-01 12:00:00.000') and state_id in(0,2) 

-- Use OrderProcessingConsole
-- delete order_jobs where Order_id between 249873 and 249889
-- delete orders where id between 249873 and 249889

-- select top 100 * from order_jobs  Order by Order_id desc -- where state = 'Pending' -- job_state_id = -2

-- Query Change the OPC OrderName
-- Update orders set name='QA_Regression_2017/04/13_123' where id=163402
-- Update order_jobs set title_name='QA_Regression_2017/04/13_123' where (order_id between 163402 and 163402) 

-- select * from Order_Profiles
 
/*
-- Query to Change the Order/Asset Job States so we can Change/Save the Order's "Encoding Resolutions" in the OP Console
Use OrderProcessingConsole
 Update orders  set state_id=1,submit_date=Null, cancel_date=Null  where id between 249835 and 249835
 Update order_jobs  set processing_counter=0, state_id=1  where order_id between 249835 and 249835
 select * from orders where orders.id between 249835 and 249835
*/
-- select * from job_state
/*
 job_state_id	display_name
1	Not Processed
2	Queued
3	Processing
4	Failed
5	Completed
6	Cancelled
*/