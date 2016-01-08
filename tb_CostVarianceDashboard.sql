if exists (select * from dbo.sysobjects where id = object_id(N'tb_CostVarianceDashboard') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_CostVarianceDashboard
GO

--exec tb_CostVarianceDashboard

CREATE PROCEDURE tb_CostVarianceDashboard

--WITH ENCRYPTION
AS
BEGIN

With C as
(
Select

datepart(year,PODate) as [Year]
,s.POKey
,dl.BlueBinFlag
,s.PurchaseLocation
,dl.LocationName
,s.ItemNumber
,di.ItemDescription
,s.POItemType
,s.VendorCode
,s.VendorName
,s.PONumber
,s.POLineNumber
,s.QtyOrdered
--,s.QtyReceived
,s.PODate
,s.BuyUOM
,s.BuyUOMMult
--,s.UnitCost/(s.BuyUOMMult) as ContractIndPrice
,s.POAmt/(s.BuyUOMMult*s.QtyOrdered) as POIndPrice
,s.POAmt as POSpend

from tableau.Sourcing s
inner join bluebin.DimItem di on s.ItemNumber = di.ItemID
left join bluebin.DimLocation dl on s.PurchaseLocation = dl.LocationID
where s.BuyUOMMult <> 0 and s.QtyReceived <> 0 and s.QtyOrdered <> 0
)


select 
C.BlueBinFlag
,C.PurchaseLocation
,C.LocationName
,C.ItemNumber
,C.ItemDescription
,C.POItemType
,C.VendorCode
,C.VendorName
,C.BuyUOM
,C.BuyUOMMult

,count(c2.POLineNumber) as [2014Orders]
,sum(c2.QtyOrdered) as [2014Qty]
,Max(c2.POIndPrice) as [2014MaxPO]
,AVG(c2.POIndPrice) as [2014AvgPO]
,sum(c2.POSpend) as [2014TotalPOSpend]

,count(c3.POLineNumber) as [2015Orders]
,sum(c3.QtyOrdered) as [2015Qty]
,Max(c3.POIndPrice) as [2015MaxPO]
,AVG(c3.POIndPrice) as [2015AvgPO]
,sum(c3.POSpend) as [2015TotalPOSpend]

,AVG(c2.POIndPrice)-AVG(c3.POIndPrice) as [Avg Variance]
,sum(c2.POSpend)-sum(c3.POSpend) as [TotalVariance]

from C
left join C c2 on C.POKey = c2.POKey and C.[Year] = '2014'
left join C c3 on C.POKey = c3.POKey and C.[Year] = '2015'
where C.BlueBinFlag is not null
group by
C.BlueBinFlag
,C.PurchaseLocation
,C.LocationName
,C.ItemNumber
,C.ItemDescription
,C.POItemType
,C.VendorCode
,C.VendorName
,C.BuyUOM
,C.BuyUOMMult

order by sum(c2.POSpend)-sum(c3.POSpend)


END
GO
grant exec on tb_CostVarianceDashboard to public
GO

