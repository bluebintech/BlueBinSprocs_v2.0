if exists (select * from dbo.sysobjects where id = object_id(N'sp_SelectBlueBinTraining') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure sp_SelectBlueBinTraining
GO

--exec sp_SelectBlueBinTraining 'Butler'
CREATE PROCEDURE sp_SelectBlueBinTraining
@Name varchar (30)

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON
SELECT 
bbt.[BlueBinTrainingID],
bbt.[BlueBinResourceID], 
bbr.[LastName] + ', ' +bbr.[FirstName] as ResourceName, 
bbr.Title,
case when 
		bbt.[Form3000]='Trained' and bbt.[Form3001]='Trained' and bbt.[Form3002]='Trained' and 
		bbt.[Form3003]='Trained' and bbt.[Form3004]='Trained' and bbt.[Form3005]='Trained' and 
		bbt.[Form3006]='Trained' and bbt.[Form3007]='Trained' and bbt.[Form3008]='Trained' and 
		bbt.[Form3009]='Trained' and bbt.[Form3010] ='Trained' then 'Yes' Else 'No' end as FullyTrained,
	bbt.[Form3000],
		bbt.[Form3001],
			bbt.[Form3002],
				bbt.[Form3003],
					bbt.[Form3004],
						bbt.[Form3005],
							bbt.[Form3006],
								bbt.[Form3007],
									bbt.[Form3008],
										bbt.[Form3009],
											bbt.[Form3010],

ISNULL((bbu.[LastName] + ', ' +bbu.[FirstName]),'N/A') as Updater,
bbt.LastUpdated

FROM [bluebin].[BlueBinTraining] bbt
inner join [bluebin].[BlueBinResource] bbr on bbt.[BlueBinResourceID] = bbr.[BlueBinResourceID]
left join [bluebin].[BlueBinUser] bbu on bbt.[BlueBinUserID] = bbu.[BlueBinUserID]

WHERE 
bbt.Active = 1 and 
(bbr.[LastName] like '%' + @Name + '%' 
	OR bbr.[FirstName] like '%' + @Name + '%') 
	
ORDER BY bbr.[LastName]
END

GO
grant exec on sp_SelectBlueBinTraining to appusers
GO
