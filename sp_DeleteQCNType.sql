if exists (select * from dbo.sysobjects where id = object_id(N'sp_DeleteQCNType') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_DeleteQCNType
GO

--exec sp_DeleteQCNType 

CREATE PROCEDURE sp_DeleteQCNType
@original_QCNTypeID int,
@original_Name varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
	
	Update qcn.[QCNType] set Active = 0
	WHERE 
	[QCNTypeID] = @original_QCNTypeID 
		AND [Name] = @original_Name
END
GO
grant exec on sp_DeleteQCNType to appusers
GO
