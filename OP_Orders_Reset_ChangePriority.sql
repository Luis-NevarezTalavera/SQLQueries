-- Query to Change the Order/Asset Job States so we can Change/Save the Order's "Encoding Resolutions" in the OP Console
Use OrderProcessingConsole
 Update orders  set state_id=1,submit_date=Null, cancel_date=Null, priority_id=4, priority='High'  where id between 333830 and 333850
 Update order_jobs  set processing_counter=0, state_id=1, priority_id=4, priority='High'  where order_id between 333830 and 333850
 select * from orders where orders.id between 333830 and 333850
 