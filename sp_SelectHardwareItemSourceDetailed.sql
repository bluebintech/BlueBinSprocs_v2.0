if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareItemSourceDetailed') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareItemSourceDetailed
GO

--exec sp_SelectHardwareItemSourceDetailed 'MHS'
CREATE PROCEDURE sp_SelectHardwareItemSourceDetailed
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
		i.[ItemID]
      ,i.[ItemNumber]
      ,i.[ItemDescription]
      ,v.[VendorName]
      ,i.[VendorItemNumber]
      ,i.[UOM]
      ,i.[OrderUOM]
      ,i.[OrderUOMqty]
	  ,icc.CustomUnitCost
  FROM [Item] i
  inner join Vendor v on i.VendorID = v.VendorID
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareItemSourceDetailed to appusers
GO