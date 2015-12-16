if exists (select * from sysobjects where id = object_id(N'sp_GeneratePassword') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_GeneratePassword
GO
CREATE PROCEDURE sp_GeneratePassword
(
    @Length int
)

AS

declare @ch varchar (8000),@ch2 varchar (8000),@ch3 varchar (8000),@ch4 varchar (8000), @ps  varchar (10)

select @ps = '', @ch =
replicate('ABCDEFGHJKLMNPQURSUVWXYZ',8), @ch2 =replicate('0123456789',9), @ch3 =
replicate('abcdefghjkmnpqursuvwxyz',8), @ch4 =replicate('~!@#$%^&()_',6)

while len(@ps)<@length 
	begin 
set @ps=@ps+substring(@ch,convert(int,rand()*len(@ch)-1),1)
+substring(@ch3,convert(int,rand()*len(@ch2)-1),1)
+substring(@ch2,convert(int,rand()*len(@ch3)-1),1)
+substring(@ch4,convert(int,rand()*len(@ch4)-1),1) 
	end

select [Password] = left(@ps,@length)

GO
grant exec on sp_GeneratePassword to appusers
GO