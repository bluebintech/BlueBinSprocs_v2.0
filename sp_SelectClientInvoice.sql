if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectClientInvoice') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectClientInvoice
GO

--exec sp_SelectClientInvoice 'UTMC'
CREATE PROCEDURE sp_SelectClientInvoice
@HardwareCustomer varchar(100)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
            a.POID,
            p.PO,
			a.ClientInvoiceID,
			a.ClientInvoice,
            c.CustomerName,
            v.VendorName,
            a.SubTotal,
			a.Tax,
			a.Shipping,
			a.Total,
            p.OrderDate
             FROM [ClientInvoice] a
			inner join PO p on a.POID = p.POID
            inner join Customer c on a.CustomerID = c.CustomerID
            inner join Vendor v on p.VendorID = v.VendorID
            where c.CustomerName = @HardwareCustomer
END

GO
grant exec on sp_SelectClientInvoice to appusers
GO