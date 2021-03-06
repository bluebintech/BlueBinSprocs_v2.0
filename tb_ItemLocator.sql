if exists (select * from dbo.sysobjects where id = object_id(N'tb_ItemLocator') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure tb_ItemLocator
GO

--exec tb_ItemLocator

CREATE PROCEDURE tb_ItemLocator

--WITH ENCRYPTION
AS
BEGIN
SET NOCOUNT ON

SELECT 
	a.ITEM as LawsonItemNumber,
	ISNULL(c.MANUF_NBR,'N/A') as ItemManufacturerNumber,
	case 
		when a.USER_FIELD3 is null or a.USER_FIELD3 = ''  then
		case	
			when b.ClinicalDescription is null or b.ClinicalDescription = '' then '*NEEDS*' else b.ClinicalDescription end
		else a.USER_FIELD3
		end as ClinicalDescription,
	a.LOCATION as LocationCode,
	a.NAME as LocationName,
	a.Cart,
	a.Row,
	a.Position
FROM 
(SELECT 
	ITEM,
	LOCATION,
	b.NAME,
	USER_FIELD3,
	CASE WHEN ISNUMERIC(left(PREFER_BIN,1))=1 then LEFT(PREFER_BIN,2) 
		else CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN LEFT(PREFER_BIN, 2) ELSE LEFT(PREFER_BIN, 1) END END as Cart,
	CASE WHEN ISNUMERIC(left(PREFER_BIN,1))=1 then SUBSTRING(PREFER_BIN, 3, 1) 
		else CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING(PREFER_BIN, 3, 1) ELSE SUBSTRING(PREFER_BIN, 2,1) END END as Row,
	CASE WHEN ISNUMERIC(left(PREFER_BIN,1))=1 then SUBSTRING(PREFER_BIN, 4, 2)
		else CASE WHEN PREFER_BIN LIKE '[A-Z][A-Z]%' THEN SUBSTRING (PREFER_BIN,4,2) ELSE SUBSTRING(PREFER_BIN, 3,2) END END as Position	
FROM ITEMLOC a 
INNER JOIN RQLOC b ON a.LOCATION = b.REQ_LOCATION 
WHERE LEFT(REQ_LOCATION, 2) IN (SELECT [ConfigValue] FROM   [bluebin].[Config] WHERE  [ConfigName] = 'REQ_LOCATION' AND Active = 1)) a
LEFT JOIN 
(SELECT 
	ITEM, 
	USER_FIELD3 as ClinicalDescription
FROM ITEMLOC 
WHERE LOCATION IN (SELECT [ConfigValue] FROM [bluebin].[Config] WHERE  [ConfigName] = 'LOCATION' AND Active = 1) AND LEN(LTRIM(USER_FIELD3)) > 0
) b
ON a.ITEM = b.ITEM

left join ITEMMAST c on a.ITEM = c.ITEM



END
GO
grant exec on tb_ItemLocator to public
GO



