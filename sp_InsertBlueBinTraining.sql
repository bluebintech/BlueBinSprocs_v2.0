if exists (select * from dbo.sysobjects where id = object_id(N'sp_InsertBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_InsertBlueBinTraining
GO

--exec sp_InsertBlueBinTraining 1,'Yes','No','No','No','No','No','No','No','No','No','No','gbutler@bluebin.com'


CREATE PROCEDURE sp_InsertBlueBinTraining
@BlueBinResource int,--varchar(255), 
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
select * from bluebin.BlueBinResource

if not exists (select * from bluebin.BlueBinTraining where Active = 1 and BlueBinResourceID in (select BlueBinResourceID from bluebin.BlueBinResource where BlueBinResourceID  = @BlueBinResource))--
	BEGIN
	insert into [bluebin].[BlueBinTraining]
	select 
	@BlueBinResource,
	--(select BlueBinResourceID from bluebin.BlueBinResource where LastName + ', ' + FirstName = @BlueBinResource),
	@Form3000,
	@Form3001,
	@Form3002,
	@Form3003,
	@Form3004,
	@Form3005,
	@Form3006,
	@Form3007,
	@Form3008,
	@Form3009,
	@Form3010,
	1, --Default Active to Yes
	(select BlueBinUserID from bluebin.BlueBinUser where UserLogin = @Updater),
	getdate()

	;
	declare @BlueBinTrainingID int
	SET @BlueBinTrainingID = SCOPE_IDENTITY()
		exec sp_InsertMasterLog @Updater,'Training','New Training Record Entered',@BlueBinTrainingID
	END
END
GO

grant exec on sp_InsertBlueBinTraining to appusers
GO

