if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectClientInvoiceLines') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectClientInvoiceLines
GO

--exec sp_SelectClientInvoiceLines 43

CREATE PROCEDURE sp_SelectClientInvoiceLines
@ClientInvoiceID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 

		a.ClientInvoiceID,
		b.ClientInvoice,
		a.ClientInvoiceLine,
		c.ItemDescription,
		a.Qty,
		a.UnitCost,
		a.Subtotal
 FROM [ClientInvoiceLine] a
 inner join [ClientInvoice] b on a.ClientInvoiceID = b.ClientInvoiceID
 inner join [Item] c on a.ItemID = c.ItemID
 WHERE a.ClientInvoiceID = @ClientInvoiceID

END

GO
grant exec on sp_SelectClientInvoiceLines to appusers
GO