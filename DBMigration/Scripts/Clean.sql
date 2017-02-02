DECLARE @schema VARCHAR(128)

SET @schema = 'dbo'

DECLARE @n char(1)
SET @n = char(10)

DECLARE @stmt nvarchar(max)
SET @stmt = ''

-- procedures
SELECT @stmt = @stmt + @n + 'drop procedure [' + schema_name([schema_id]) + '].[' + name + ']' FROM sys.procedures WHERE schema_name([schema_id]) = @schema

-- check constraints
SELECT @stmt = @stmt + @n + 'alter table [' + schema_name(t.[schema_id]) + '].[' + t.name + '] drop constraint [' + cc.name + ']' FROM sys.check_constraints cc JOIN sys.tables t ON cc.parent_object_id = t.object_id WHERE schema_name(t.[schema_id]) = @schema AND t.[type] = 'U'

-- functions
SELECT @stmt = @stmt + @n + 'drop function [' + schema_name([schema_id]) + '].[' + name + ']' FROM sys.objects WHERE type in ( 'FN', 'IF', 'TF', 'FS', 'FT' ) AND schema_name([schema_id]) = @schema

-- views
SELECT @stmt = @stmt + @n + 'drop view [' + schema_name([schema_id]) + '].[' + name + ']' FROM sys.views WHERE schema_name([schema_id]) = @schema

-- foreign keys
SELECT @stmt = @stmt + @n + 'alter table [' + schema_name(t.[schema_id]) + '].[' + t.name + '] drop constraint [' + fk.name + ']' FROM sys.foreign_keys fk JOIN sys.tables t ON fk.parent_object_id = t.object_id WHERE schema_name(t.[schema_id]) = @schema AND t.[type] = 'U'

-- tables
SELECT @stmt = @stmt + @n + 'drop table [' + schema_name([schema_id]) + '].[' + name + ']' FROM sys.tables WHERE schema_name([schema_id]) = @schema AND [type] = 'U'

-- user defined types
SELECT @stmt = @stmt + @n + 'drop type [' + schema_name([schema_id]) + '].[' + name + ']' FROM sys.types WHERE schema_name([schema_id]) = @schema AND is_user_defined = 1


EXEC sp_executesql @stmt

