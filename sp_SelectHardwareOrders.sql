if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareOrders') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareOrders
GO

--exec sp_SelectHardwareOrders 'MHS'
CREATE PROCEDURE sp_SelectHardwareOrders
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
            a.POID,
            a.PO,
            c.CustomerName,
            v.VendorName,
            a.Total,
            a.OrderDate
             FROM [PO] a
            inner join Customer c on a.CustomerID = c.CustomerID
            inner join Vendor v on a.VendorID = v.VendorID
            where c.CustomerName = @HardwareCustomer
END

GO
grant exec on sp_SelectHardwareOrders to appusers
GO