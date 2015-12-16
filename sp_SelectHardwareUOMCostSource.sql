if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareUOMCostSource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareUOMCostSource
GO

--exec sp_SelectHardwareUOMCostSource 'MHS'
CREATE PROCEDURE sp_SelectHardwareUOMCostSource
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
		i.[ItemID]
      ,i.[UOM]
      ,i.[OrderUOM]
      ,i.[OrderUOMqty]
	  ,icc.CustomUnitCost
  FROM [Item] i
  inner join Vendor v on i.VendorID = v.VendorID
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareUOMCostSource to appusers
GO