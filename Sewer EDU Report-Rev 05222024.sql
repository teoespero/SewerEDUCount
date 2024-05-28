select 
	l.Misc_1 as [Boundary],
	l.Misc_2 [ST Category],
	l.Misc_5 as [Subdivision],
	bd.Cust_No,
	bd.Cust_Sequence,
	bd.Service_Code,
	bd.Amount,
	(case 
		when (left(bd.Service_Code,2) = 'SB' or left(bd.Service_Code,2) = 'SW') then bd.amount /  17.98
		when left(bd.Service_Code,2) = 'SF'  then bd.amount /  38.15
	end) as EDU
FROM Springbrook.UB_Bill_Detail AS BD 
LEFT OUTER JOIN
	Springbrook.UB_Bill_Detail_Tier AS bdt 
	ON bdt.UB_Bill_Detail_ID = BD.UB_Bill_Detail_ID 
LEFT OUTER JOIN
	dbo.UB_Customers AS C 
	ON C.Cust_No = BD.Cust_No 
	AND C.Cust_Sequence = BD.Cust_Sequence 
LEFT OUTER JOIN
	Springbrook.Lot AS L 
	ON L.Lot_No = C.Lot_No 
LEFT OUTER JOIN
	Springbrook.UB_Meter_Con AS mc 
	ON mc.Lot_No = C.Lot_No 
	AND mc.Con_Status = 'Active'                                                 
	AND mc.Route_No = BD.Route_No 
	AND mc.Sequence_No = BD.Sequence_No 
LEFT OUTER JOIN
	Springbrook.UB_Device AS D 
	ON D.UB_Device_ID = mc.UB_Device_ID 
LEFT OUTER JOIN
	Springbrook.ub_class AS CL 
	ON CL.class_code = L.Class_Code 
LEFT OUTER JOIN
	dbo.UniqueBills AS BD2 
	ON BD2.UB_Bill_Detail_ID = BD.UB_Bill_Detail_ID 
LEFT OUTER JOIN
	Springbrook.UB_Device_Type AS DT 
	ON DT.UB_Device_Type_ID = D.UB_Device_Type_ID
INNER JOIN
	Springbrook.UB_Master m
	on m.Cust_No=bd.Cust_No
	and m.Cust_Sequence=bd.Cust_Sequence
where
	(bd.Service_Code like 'SF%' or bd.Service_Code like 'SW%' or bd.Service_Code like 'SB%')
	and bd.Tran_Type = 'Billing'
	and bd.Tran_Date between '04/01/2024' and '04/30/2024'
order by
	l.Misc_1,
	l.Misc_2,
	l.Misc_5,
	bd.Cust_No,
	bd.Cust_Sequence