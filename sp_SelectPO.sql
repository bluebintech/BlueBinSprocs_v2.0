if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectPO') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectPO
GO


CREATE PROCEDURE sp_SelectPO
@POID int

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 

		a.POID,
		b.PO,
		a.POLine,
		c.ItemDescription,
		a.Qty,
		a.Subtotal
 FROM [POLine] a
 inner join [PO] b on a.POID = b.POID
 inner join [Item] c on a.ItemID = c.ItemID
 WHERE a.POID = @POID

END

GO
grant exec on sp_SelectPO to appusers
GO