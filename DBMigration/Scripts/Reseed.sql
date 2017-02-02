-- Find all user table identity columns in the given schema (e.g. dbo) 
-- and reseed them to the given value (e.g. 1,000,000)

DECLARE @schema VARCHAR(128)
DECLARE @seed INT

SET @schema = 'dbo'
SET @seed = 1000000


DECLARE @statement NVARCHAR(MAX)
SET @statement = ''

SELECT 
	@statement = 
		@statement + 
		N'DBCC CHECKIDENT (''[' + s.name + '].[' + o.name + ']'', reseed, ' + CONVERT(NVARCHAR(15), @seed) + ');' 
		+ char(10)
	FROM 
		sys.identity_columns idc 
		JOIN sys.columns c 
			ON idc.object_id = c.object_id
			AND idc.column_id = c.column_id
		JOIN sys.objects o
			ON idc.object_id = o.object_id
		JOIN sys.schemas s
			ON o.schema_id = s.schema_id
	WHERE
		s.name = @schema
		AND o.[type] = 'U'

EXEC sp_executesql @statement
