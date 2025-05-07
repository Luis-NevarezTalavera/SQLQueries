Select  DISTINCT 
	Left(CAST(par.id AS text),8) as partner_id, par.name as par_name, -- par.create_datetime, par.update_datetime, par.limit_call, -- Left(CAST(par.id AS text),8)
	vtr.partner_internal_tenant_id as veson_partnerTenantId, Left(vtr.partner_tenant_token,16) as veson_TenantToken, -- vtr.enable,  
	Left(etr.blob_conn_string,23) as ecdis_conn_string, -- etr.enable, 
	ten.id tenant_id, ten.client_tenant_id, ten.name AS ten_name, -- ten.is_deleted, ten.create_datetime, ten.update_datetime, -- Left(CAST(ten.id AS text),8)
	Left(Cast(cli.client_id AS text),8) as client_id, -- cli.client_name, cli.create_datetime, cli.update_datetime, 
--	vss.imo, vss.name as vss_name, vss.type, -- vss.deadweight, 
	vop.vessel_imo_no, vop.voyage_plan_no, vop.status, vop.source_datetime, vop.commence_datetime, vop.complete_datetime, vop.raw_data_reference, 
--	iti.port_no, iti.port_name, iti.port_func, iti.eta_datetime, iti.etd_datetime, 
--	itb.fuel_type,  ibe.berth_short_name, 
	vvp.voyage_plan_no as veson_vp_no, vvp.sql_id, vvp.vessel_code, vvp.opr_type, vvp.vessel_type_original, 
--	vit.arr_dep_status, vit.order, vit.arrival_local, vit.departure_local, -- latest new records PersistCanonicalized logs 2024-02-23T16:00:46.650114682Z 'message':'Executed DbCommand   INSERT INTO veson_itinerary
--	vch.cargo_id, vch.cargo_short_name, vch.bl_quantity, 
--	pvi.order as prev_order, pvi.seq as prev_seq, -- pvi.ballast_laden_from_port as prev_ballast_laden_from_port,  -- latest new records PersistCanonicalized logs 2024-02-23T16:00:46.650350787Z 'message':'Executed DbCommand   INSERT INTO prev_voyage_plan_itinerary
--	ktr.username as ktr_username -- ktr.password, ktr.enable, 
	dat.dataset_id --, dat.datatype, dat.interval
From tenant AS ten	Left  Outer Join partner_tenant_ref	AS ptr on ptr.tenant_id =	ten.id
					Left  Outer Join partner 			AS par on par.id		=	ptr.partner_id
					Left  Outer Join client_tenant_ref	AS ctr on ctr.tenant_id	=	ten.id
					Left  Outer Join client 			AS cli on cli.client_id = ctr.client_id
					Left  Outer Join ecdis_tenant_ref	AS etr on etr.tenant_id	  =	ten.id
					Left  Outer Join kongsberg_tenant_ref AS ktr on ktr.tenant_id =	ten.id
					Left  Outer Join vessel_tenant_ref	AS vstr on vstr.tenant_id =	ten.id
					Left  Outer Join vessel				AS vss on vss.imo		=	vstr.imo
					Left  Outer Join voyage_plan		AS vop on vop.tenant_id	=	ten.id
					Left  Outer Join itinerary			AS iti on iti.tenant_id	=	ten.id and iti.voyage_plan_no=vop.voyage_plan_no and iti.source_datetime=vop.source_datetime
					Left  Outer Join itinerary_bunker	AS itb on itb.itinerary_id = iti.id
					Left  Outer Join itinerary_berth	AS ibe on ibe.itinerary_id = iti.id
					Left  Outer Join veson_tenant_ref	AS vtr on vtr.tenant_id	=	ten.id
					Left  Outer Join veson_voyage_plan	AS vvp on vvp.tenant_id	=	ten.id and vvp.voyage_plan_no=vop.voyage_plan_no and vvp.source_datetime=vop.source_datetime
					Left  Outer Join veson_itinerary	AS vit on vit.veson_voyage_plan_id=vvp.id
					Left  Outer Join veson_voyage_plan_cargo_handling AS vch on vch.veson_itinerary_id=vit.id
					Left  Outer Join prev_voyage_plan_itinerary  	  AS pvi on pvi.veson_itinerary_id=vit.id
					Left  Outer Join dataset			AS dat on dat.partner_id=	par.id and dat.tenant_id=ptr.tenant_id 
 Where   cli.client_id in('b13e06ac-a6c3-49fa-8532-79fe6b1f5eb6','1ddc8e55-ab17-4651-bdd8-5cca50c9ba59') -- 
--	 ten.client_tenant_id='xyz - 0111' -- like 'xyz - 01%' -- ('xyz - 0118','xyz - 0119','xyz - 0120') --
--	and ten.id='6e48e955-0756-4df6-8079-7c01d4e8e4e5' -- 'c43e3a76-107e-448e-98e0-0d48f6e0f3b5' -- in('774c8b25-5f63-4dbc-aff4-6dcecc3ffa52') -- ten.name='Test tenant' -- ten.is_deleted=true -- 
	and par.name='Veson' -- par.id='xxx' -- par.is_deleted=true -- 
--	and vtr.partner_internal_tenant_id='PRTR' -- vtr.partner_tenant_token='xxx'
--	and vss.imo = '12345' -- in ('102','103') -- 
--	and vss.name like 'vessel - 01%' -- vss.type='test type' -- vss.is_deleted=true -- 
--  and cli.client_name like 'test_client%' -- 
--	and	vop.voyage_plan_no IS NOT NULL -- 40,278 records as of 03/08/2024 -- 28,477 recods as of 02/28/2024 7:45 PST -- 11,153 records as of 02/27/2024 8:50 PST
--	and vop.source_datetime <= '2024-03-31' -- not in  ('2024-01-03 21:15:20.372','2024-01-03 21:15:20.371','2024-01-03 21:15:20.37','2024-01-03 21:15:20.369')
--  and vop.raw_data_reference like '%PublishVoyage%'
--	and vop.voyage_plan_no='2' -- '1' -- '3'
--	and vop.vessel_imo_no='12345' -- vop.vessel_imo_no IS NOT NULL and ='2284023' -- '9473406' -- '12345' -- '9257058'
--	and vop.status='Commenced'
--	and iti.port_name='BARCELONA' -- 'TUXPAN' -- 'PIRAEUS'
--  and ibe.berth_short_name IS NOT NULL
--  and vvp.vessel_code='PDEMO' -- 'CALY'
--  and pvi.order IS NOT NULL
--	and etr.blob_conn_string='xxx'
--	and dat.dataset_id='xxx'
-- Group by cli.client_name, par.name, ten.name, ten.external_tenant_id
-- Order by ten.client_tenant_id, vop.voyage_plan_no, vop.commence_datetime, vop.complete_datetime, vop.vessel_imo_no, iti.eta_datetime, iti.etd_datetime, vit.arrival_local, vit.departure_local,  vit.order --
 Order by ten.client_tenant_id, vop.source_datetime desc, vop.voyage_plan_no, vop.vessel_imo_no,  vop.commence_datetime, vop.complete_datetime -- vit.arrival_local, vit.departure_local,  vit.order --

-- Select * From status_indicator
-- Select * From function_classifier
-- Select * From country_code
-- Select * from veson_ports where unlocode_country > '' order by unlocode_country, unlocode_location --  veson_tenant_name!='Shared'
-- Select count(veson_tenant_name) from veson_ports -- 9,614 records 4/5/24  -- 9,608 records 4/2/24 
-- Select distinct veson_tenant_name, count(*) From veson_ports group by veson_tenant_name order by count(*) desc
-- Select * From ports
-- Select * From unlocode_code_list where name<>name_wo_diacritics and iata>'' -- function like '1%' and   country='MX' -- and name='Chihuahua'
-- Select * From time_info
-- Select * From subdivision_code
-- Select * From function_classifier
-- Select * From country_code
-- Select * From status_indicator

-- Update ports set unlocode_country=left(unlocode_country,2);


-- Select * From dataset
-- Select * From partner where id!='64ea0440-c980-4cc7-9a11-8128fc88ab37'
-- Select * From partner_tenant_ref  where partner_id='9edab309-ee0a-4f0e-a9c7-a307ade2c5ac' and tenant_id='b4893665-e398-46ca-879e-52e63e41427e' -- order by tenant_id -- tenant_id='74145ea6-9e6f-42d2-8c4c-6d66aa2bf820'
-- Select * From client where id='b13e06ac-a6c3-49fa-8532-79fe6b1f5eb6'
-- Select * From client_tenant_ref Where external_id like 'xxx%' --  name = ' qa test - 0110' -- id='04a5d4ff-f252-4a54-88ee-2de0a25fc561'; --
-- Select * From tenant Where id='6e48e955-0756-4df6-8079-7c01d4e8e4e5' -- client_tenant_id like 'xyz - 0119%'
-- Select * From vessel_tenant_ref Where name like 'vessel - 011%' order by imo --  
-- Select * From vessel  order by imo -- Where name like 'vessel - 011%' 
/*
 Select  DISTINCT vessel_imo_no , vvp.vessel_code 
 From voyage_plan AS vop Left  Outer Join veson_voyage_plan	AS vvp on  vvp.voyage_plan_no=vop.voyage_plan_no and vvp.source_datetime=vop.source_datetime
 Where vessel_imo_no!=''
 Order by vessel_imo_no --, vvp.vessel_code 
*/
-- Select * From voyage_plan
-- Select * from itinerary where port_no in (Select port_no from veson_ports where unlocode_country > '')
-- Select * from itinerary_bunker where itinerary_id='5e2f2ad6-2864-474c-99fa-63f8506d6ae6'
-- Select itinerary_id, count(id) from itinerary_bunker group by itinerary_id Having count(id)>3 order by itinerary_id
-- Select * from itinerary_berth
-- Select * from unlocode_code_list where country like 'MX%'
-- Select * From veson_tenant_ref order by partner_internal_tenant_id --  Where tenant_id='6e48e955-0756-4df6-8079-7c01d4e8e4e5' '74145ea6-9e6f-42d2-8c4c-6d66aa2bf820'
-- Select * From veson_voyage_plan order by voyage_plan_no, vessel_code, source_datetime
-- Select * From veson_itinerary
-- Select * From veson_voyage_plan_cargo_handling 
/*
 Select cargo_id, cargo_short_name, bl_quantity, count(cargo_id) 
-- Select *
 From veson_voyage_plan_cargo_handling 
 Where (cargo_id=0 or cargo_id IS NULL) and (cargo_short_name ='' or cargo_short_name IS NULL) and (bl_quantity=0 or bl_quantity IS NULL)
 Group by cargo_id, cargo_short_name, bl_quantity 
 Order by count(cargo_id) desc
 */
-- Select * From prev_voyage_plan_itinerary
-- Select veson_itinerary_id, count(veson_itinerary_id) from prev_voyage_plan_itinerary group by veson_itinerary_id order by count(veson_itinerary_id) desc
-- Select * From ecdis_tenant_ref order by blob_conn_string
-- Delete From ecdis_tenant_ref where blob_conn_string='' -- tenant_id in ('c43e3a76-107e-448e-98e0-0d48f6e0f3b5','6e48e955-0756-4df6-8079-7c01d4e8e4e5')
-- Select * From kongsberg_tenant_ref
-- Delete From kongsberg_tenant_ref
-- Select * From partner where id=
-- Select * From partner_tenant_ref where tenant_id='6e48e955-0756-4df6-8079-7c01d4e8e4e5' -- '87c97aac-6d90-48d8-9792-1cdad8492122' -- partner_id

-- SELECT table_name FROM information_schema.columns WHERE table_schema='public' AND table_name='dataset' and ordinal_position=1
-- Delete From partner_tenant_ref where tenant_id='b3f644b3-4c1d-4d53-b332-67c949fe3456'
-- Insert Into partner_tenant_ref (partner_id, tenant_id, enable) values ('582b8d8f-b591-4b5a-b98b-37a8cb5aa555', Where tenant_id='74145ea6-9e6f-42d2-8c4c-6d66aa2bf820', true) -- 'b3f644b3-4c1d-4d53-b332-67c949fe3456',true)
/*
 Insert into vessel values ('12342q','PANAMAX','DEMO1',115000)
 Insert into vessel values ('106','Unknown','vessel-0106',106,now(),null,false)
 Insert into vessel_tenant_ref values ('346d8489-9a5b-42ac-b9d1-16894567df0e','106')
 Insert into veson_tenant_ref values ('74145ea6-9e6f-42d2-8c4c-6d66aa2bf820', 'PRTR', '123-4567-890-0109',true)
 Insert into veson_tenant_ref values ('c43e3a76-107e-448e-98e0-0d48f6e0f3b5','PRTR', '741cc32d80a2f74677594350e807140a96ee68014170d284657d119cdf317a51',true)
 Update veson_tenant_ref Set partner_internal_tenant_id='PRTR - 0119', partner_tenant_token='123-4567-890-0119' Where tenant_id=('6e48e955-0756-4df6-8079-7c01d4e8e4e5')
 Update tenant set is_deleted=true Where id='a0e47b34-c21b-410f-8406-5e3ba76c8863' -- client_tenant_id = 'xyz - 0109';
Update client_tenant_ref set client_id='b13e06ac-a6c3-49fa-8532-79fe6b1f5eb6' where client_id!='b13e06ac-a6c3-49fa-8532-79fe6b1f5eb6'

-- DELETE TENANT --
 -- Update tenant set is_deleted=true Where client_tenant_id like 'xyz - 1___';
 
 Delete From client_tenant_ref	Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From vessel_tenant_ref	Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From vessel where name like 'vessel - 1___'
 Delete From veson_tenant_ref	Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From ecdis_tenant_ref	Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From kongsberg_tenant_ref Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From partner_tenant_ref Where tenant_id  in (Select id from tenant  Where is_deleted=true); -- client_tenant_id = 'xyz - 0109');
 Delete From tenant Where is_deleted=true; -- client_tenant_id = 'xyz - 0109';

-- DELETE VOYAGE_PLAN --

 Delete From veson_voyage_plan_cargo_handling  Where veson_itinerary_id in (Select id from veson_itinerary  Where veson_voyage_plan_id  in (Select id from veson_voyage_plan  Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref')));
 Delete From prev_voyage_plan_itinerary  Where veson_itinerary_id in (Select id from veson_itinerary  Where veson_voyage_plan_id  in (Select id from veson_voyage_plan  Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref')));
 Delete From veson_itinerary		Where veson_voyage_plan_id  in (Select id from veson_voyage_plan  Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref'));
 Delete From veson_voyage_plan		Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref');
 Delete From itinerary_bunker		Where itinerary_id in (Select id from Itinerary Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref'));
 Delete From itinerary_berth		Where itinerary_id in (Select id from Itinerary Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref'));
 Delete From itinerary				Where voyage_plan_no in (Select voyage_plan_no from voyage_plan  Where raw_data_reference='ref');
 Delete From voyage_plan			Where raw_data_reference='ref';

 Select * from databasechangelog
*/
-- SELECT * FROM unlocode_code_list where iata is not null