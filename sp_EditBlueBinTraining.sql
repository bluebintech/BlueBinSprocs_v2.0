if exists (select * from dbo.sysobjects where id = object_id(N'sp_EditBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_EditBlueBinTraining
GO

--exec sp_EditBlueBinTraining '2','Yes','Yes','Yes','No','No','No','No','No','No','No','No','gbutler@bluebin.com'
--select * from [bluebin].[BlueBinTraining]


CREATE PROCEDURE sp_EditBlueBinTraining
@BlueBinTrainingID int, 
@Form3000 varchar(10),
@Form3001 varchar(10),
@Form3002 varchar(10),
@Form3003 varchar(10),
@Form3004 varchar(10),
@Form3005 varchar(10),
@Form3006 varchar(10),
@Form3007 varchar(10),
@Form3008 varchar(10),
@Form3009 varchar(10),
@Form3010 varchar(10),
@Updater varchar(255)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON


update [bluebin].[BlueBinTraining]
set
	Form3000 = @Form3000,
	Form3001 = @Form3001,
	Form3002 = @Form3002,
	Form3003 = @Form3003,
	Form3004 = @Form3004,
	Form3005 = @Form3005,
	Form3006 = @Form3006,
	Form3007 = @Form3007,
	Form3008 = @Form3008,
	Form3009 = @Form3009,
	Form3010 = @Form3010,
	BlueBinUserID = (select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Updater),
	LastUpdated = getdate()
where BlueBinTrainingID = @BlueBinTrainingID
	;
exec sp_InsertMasterLog @Updater,'Training','Training Record Updated',@BlueBinTrainingID
END
GO

grant exec on sp_EditBlueBinTraining to appusers
GO

