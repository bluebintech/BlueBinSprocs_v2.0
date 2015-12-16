if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareItemSource') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareItemSource
GO

--exec sp_SelectHardwareItemSource 'MHS'
CREATE PROCEDURE sp_SelectHardwareItemSource
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	        SELECT 
		i.[ItemID]
      ,i.[ItemNumber]
      ,i.[ItemDescription]
      
  FROM [Item] i
  inner join ItemCustomerCost icc on icc.ItemID = i.ItemID and icc.CustomerID = (Select CustomerID from Customer where CustomerName = @HardwareCustomer) 
END

GO
grant exec on sp_SelectHardwareItemSource to appusers
GO