if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectQCNType
GO

--exec sp_SelectQCNType 

CREATE PROCEDURE sp_SelectQCNType

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	QCNTypeID,
	Name,
	case 
		when Active = 1 then 'Yes' 
		Else 'No' 
		end as ActiveName,
	Active,
	LastUpdated 
	
	FROM qcn.[QCNType]

END
GO
grant exec on sp_SelectQCNType to appusers
GO
