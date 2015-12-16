if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectHardwareCustomer') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectHardwareCustomer
GO


CREATE PROCEDURE sp_SelectHardwareCustomer

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	select ConfigValue from bluebin.Config where ConfigName = 'BlueBinHardwareCustomer'

END

GO
grant exec on sp_SelectHardwareCustomer to appusers
GO