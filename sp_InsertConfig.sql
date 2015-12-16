if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertConfig') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertConfig
GO

--exec sp_InsertConfig 'TEST'

CREATE PROCEDURE sp_InsertConfig
@ConfigName varchar (30)
,@ConfigValue varchar (100)
,@ConfigType varchar (50)


--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
if exists(select * from bluebin.Config where ConfigName = @ConfigName and ConfigType = 'DMS')
BEGIN
GOTO THEEND
END
insert into bluebin.Config (ConfigName,ConfigValue,ConfigType,Active,LastUpdated) VALUES (@ConfigName,@ConfigValue,@ConfigType,1,getdate())

END
THEEND:

GO
grant exec on sp_InsertConfig to appusers
GO