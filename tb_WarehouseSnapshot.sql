if exists (select * from dbo.sysobjects where id = object_id(N'tb_WarehouseSnapshot') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_WarehouseSnapshot
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_WarehouseSnapshot

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT 
	SnapshotDate,
	SUM(SOH * UnitCost) as DollarsOnHand,
	LocationID,
	LocationName
FROM   bluebin.FactWarehouseSnapshot a
INNER JOIN bluebin.DimLocation b
ON a.LocationKey = b.LocationKey
GROUP BY
	SnapshotDate,
	LocationID,
	LocationName
END
GO
grant exec on tb_WarehouseSnapshot to public
GO


