/****** Object:  UserDefinedFunction [dbo].[uCommerce_ParseArrayToTable]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[uCommerce_ParseArrayToTable]
(
	@Array NVARCHAR(MAX), 		-- String to parse (ie: '1,2,6,4,12')
	@Separator CHAR(1) = ',',	-- Seperator to use, default to ',' (comma)
	@ReturnAsNumeric BIT = 0	-- If true, returns numeric values in stead of varchars
)
RETURNS @table TABLE
(
	[Id] INT IDENTITY(1, 1),
	stringvalue NVARCHAR(MAX),
	numericvalue INT
)
AS
BEGIN

	DECLARE @Separator_Position int 		-- This is used to locate each separator character
	DECLARE @Array_Value NVARCHAR(MAX) 	-- This holds each array value as it is returned

	-- For my loop to work I need an extra separator at the end.  I always look to the
	-- left of the separator character for each array value
	SET @Array = @Array + @Separator

	WHILE Patindex('%' + @Separator + '%' , @Array) <> 0 
	BEGIN			
		-- Patindex matches the a pattern against a string
		SELECT @Separator_position =  Patindex('%' + @Separator + '%' , @Array)
		SELECT @Array_value = Left(@Array, @Separator_Position - 1)

		-- This is where you process the values passed.
		-- Replace this select statement with your processing
		-- @Array_Value holds the value of this element of the array
		-- If the value is not numeric, insert as a string (using '')
		IF @ReturnAsNumeric = 1
			INSERT @table (numericvalue) VALUES (CONVERT(INT, @Array_Value))
		ELSE
			INSERT @table (stringvalue) VALUES (CONVERT(NVARCHAR(MAX), @Array_Value))

		-- This replaces what we just processed with an empty string
		SELECT @Array = Stuff(@Array, 1, @Separator_Position, '')

	END

	RETURN

END
GO
/****** Object:  Table [dbo].[cmsContent]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContent](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[nodeId] [int] NOT NULL,
	[contentType] [int] NOT NULL,
 CONSTRAINT [PK_cmsContent] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsContentType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContentType](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[nodeId] [int] NOT NULL,
	[alias] [nvarchar](255) NULL,
	[icon] [nvarchar](255) NULL,
	[thumbnail] [nvarchar](255) NOT NULL CONSTRAINT [DF_cmsContentType_thumbnail]  DEFAULT ('folder.png'),
	[description] [nvarchar](1500) NULL,
	[isContainer] [bit] NOT NULL CONSTRAINT [DF_cmsContentType_isContainer]  DEFAULT ('0'),
	[allowAtRoot] [bit] NOT NULL CONSTRAINT [DF_cmsContentType_allowAtRoot]  DEFAULT ('0'),
 CONSTRAINT [PK_cmsContentType] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsContentType2ContentType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContentType2ContentType](
	[parentContentTypeId] [int] NOT NULL,
	[childContentTypeId] [int] NOT NULL,
 CONSTRAINT [PK_cmsContentType2ContentType] PRIMARY KEY CLUSTERED 
(
	[parentContentTypeId] ASC,
	[childContentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsContentTypeAllowedContentType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContentTypeAllowedContentType](
	[Id] [int] NOT NULL,
	[AllowedId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL CONSTRAINT [df_cmsContentTypeAllowedContentType_sortOrder]  DEFAULT ('0'),
 CONSTRAINT [PK_cmsContentTypeAllowedContentType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[AllowedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsContentVersion]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContentVersion](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[ContentId] [int] NOT NULL,
	[VersionId] [uniqueidentifier] NOT NULL,
	[VersionDate] [datetime] NOT NULL CONSTRAINT [DF_cmsContentVersion_VersionDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_cmsContentVersion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsContentXml]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsContentXml](
	[nodeId] [int] NOT NULL,
	[xml] [ntext] NOT NULL,
 CONSTRAINT [PK_cmsContentXml] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsDataType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsDataType](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[nodeId] [int] NOT NULL,
	[propertyEditorAlias] [nvarchar](255) NOT NULL,
	[dbType] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_cmsDataType] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsDataTypePreValues]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsDataTypePreValues](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[datatypeNodeId] [int] NOT NULL,
	[value] [ntext] NULL,
	[sortorder] [int] NOT NULL,
	[alias] [nvarchar](50) NULL,
 CONSTRAINT [PK_cmsDataTypePreValues] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsDictionary]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsDictionary](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[id] [uniqueidentifier] NOT NULL,
	[parent] [uniqueidentifier] NULL,
	[key] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_cmsDictionary] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsDocument]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsDocument](
	[nodeId] [int] NOT NULL,
	[published] [bit] NOT NULL,
	[documentUser] [int] NOT NULL,
	[versionId] [uniqueidentifier] NOT NULL,
	[text] [nvarchar](255) NOT NULL,
	[releaseDate] [datetime] NULL,
	[expireDate] [datetime] NULL,
	[updateDate] [datetime] NOT NULL CONSTRAINT [DF_cmsDocument_updateDate]  DEFAULT (getdate()),
	[templateId] [int] NULL,
	[newest] [bit] NOT NULL CONSTRAINT [DF_cmsDocument_newest]  DEFAULT ('0'),
 CONSTRAINT [PK_cmsDocument] PRIMARY KEY CLUSTERED 
(
	[versionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsDocumentType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsDocumentType](
	[contentTypeNodeId] [int] NOT NULL,
	[templateNodeId] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL CONSTRAINT [DF_cmsDocumentType_IsDefault]  DEFAULT ('0'),
 CONSTRAINT [PK_cmsDocumentType] PRIMARY KEY CLUSTERED 
(
	[contentTypeNodeId] ASC,
	[templateNodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsLanguageText]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsLanguageText](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[languageId] [int] NOT NULL,
	[UniqueId] [uniqueidentifier] NOT NULL,
	[value] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_cmsLanguageText] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsMacro]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsMacro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[macroUseInEditor] [bit] NOT NULL,
	[macroRefreshRate] [int] NOT NULL,
	[macroAlias] [nvarchar](255) NOT NULL,
	[macroName] [nvarchar](255) NULL,
	[macroScriptType] [nvarchar](255) NULL,
	[macroScriptAssembly] [nvarchar](255) NULL,
	[macroXSLT] [nvarchar](255) NULL,
	[macroCacheByPage] [bit] NOT NULL,
	[macroCachePersonalized] [bit] NOT NULL,
	[macroDontRender] [bit] NOT NULL,
	[macroPython] [nvarchar](255) NULL,
 CONSTRAINT [PK_cmsMacro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsMacroProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsMacroProperty](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[editorAlias] [nvarchar](255) NOT NULL,
	[macro] [int] NOT NULL,
	[macroPropertySortOrder] [int] NOT NULL,
	[macroPropertyAlias] [nvarchar](50) NOT NULL,
	[macroPropertyName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_cmsMacroProperty] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsMember]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsMember](
	[nodeId] [int] NOT NULL,
	[Email] [nvarchar](1000) NOT NULL,
	[LoginName] [nvarchar](1000) NOT NULL,
	[Password] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_cmsMember] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsMember2MemberGroup]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsMember2MemberGroup](
	[Member] [int] NOT NULL,
	[MemberGroup] [int] NOT NULL,
 CONSTRAINT [PK_cmsMember2MemberGroup] PRIMARY KEY CLUSTERED 
(
	[Member] ASC,
	[MemberGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsMemberType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsMemberType](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[NodeId] [int] NOT NULL,
	[propertytypeId] [int] NOT NULL,
	[memberCanEdit] [bit] NOT NULL,
	[viewOnProfile] [bit] NOT NULL,
 CONSTRAINT [PK_cmsMemberType] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsPreviewXml]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsPreviewXml](
	[nodeId] [int] NOT NULL,
	[versionId] [uniqueidentifier] NOT NULL,
	[timestamp] [datetime] NOT NULL,
	[xml] [ntext] NOT NULL,
 CONSTRAINT [PK_cmsContentPreviewXml] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC,
	[versionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsPropertyData]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsPropertyData](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[contentNodeId] [int] NOT NULL,
	[versionId] [uniqueidentifier] NULL,
	[propertytypeid] [int] NOT NULL,
	[dataInt] [int] NULL,
	[dataDate] [datetime] NULL,
	[dataNvarchar] [nvarchar](500) NULL,
	[dataNtext] [ntext] NULL,
 CONSTRAINT [PK_cmsPropertyData] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsPropertyType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsPropertyType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dataTypeId] [int] NOT NULL,
	[contentTypeId] [int] NOT NULL,
	[propertyTypeGroupId] [int] NULL,
	[Alias] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[sortOrder] [int] NOT NULL CONSTRAINT [DF_cmsPropertyType_sortOrder]  DEFAULT ('0'),
	[mandatory] [bit] NOT NULL CONSTRAINT [DF_cmsPropertyType_mandatory]  DEFAULT ('0'),
	[validationRegExp] [nvarchar](255) NULL,
	[Description] [nvarchar](2000) NULL,
	[UniqueID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_cmsPropertyType_UniqueID]  DEFAULT (newid()),
 CONSTRAINT [PK_cmsPropertyType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsPropertyTypeGroup]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsPropertyTypeGroup](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parentGroupId] [int] NULL,
	[contenttypeNodeId] [int] NOT NULL,
	[text] [nvarchar](255) NOT NULL,
	[sortorder] [int] NOT NULL,
 CONSTRAINT [PK_cmsPropertyTypeGroup] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsStylesheet]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsStylesheet](
	[nodeId] [int] NOT NULL,
	[filename] [nvarchar](100) NOT NULL,
	[content] [ntext] NULL,
 CONSTRAINT [PK_cmsStylesheet] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsStylesheetProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsStylesheetProperty](
	[nodeId] [int] NOT NULL,
	[stylesheetPropertyEditor] [bit] NULL,
	[stylesheetPropertyAlias] [nvarchar](50) NULL,
	[stylesheetPropertyValue] [nvarchar](400) NULL,
 CONSTRAINT [PK_cmsStylesheetProperty] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsTagRelationship]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsTagRelationship](
	[nodeId] [int] NOT NULL,
	[tagId] [int] NOT NULL,
	[propertyTypeId] [int] NOT NULL,
 CONSTRAINT [PK_cmsTagRelationship] PRIMARY KEY CLUSTERED 
(
	[nodeId] ASC,
	[propertyTypeId] ASC,
	[tagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsTags]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsTags](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tag] [nvarchar](200) NULL,
	[ParentId] [int] NULL,
	[group] [nvarchar](100) NULL,
 CONSTRAINT [PK_cmsTags] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsTask]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsTask](
	[closed] [bit] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[taskTypeId] [int] NOT NULL,
	[nodeId] [int] NOT NULL,
	[parentUserId] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Comment] [nvarchar](500) NULL,
 CONSTRAINT [PK_cmsTask] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsTaskType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsTaskType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[alias] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_cmsTaskType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[cmsTemplate]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cmsTemplate](
	[pk] [int] IDENTITY(1,1) NOT NULL,
	[nodeId] [int] NOT NULL,
	[alias] [nvarchar](100) NULL,
	[design] [ntext] NOT NULL,
 CONSTRAINT [PK_cmsTemplate] PRIMARY KEY CLUSTERED 
(
	[pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Address]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Address](
	[AddressId] [int] IDENTITY(1,1) NOT NULL,
	[Line1] [nvarchar](512) NOT NULL,
	[Line2] [nvarchar](512) NULL,
	[PostalCode] [nvarchar](50) NOT NULL,
	[City] [nvarchar](512) NOT NULL,
	[State] [nvarchar](512) NULL,
	[CountryId] [int] NOT NULL,
	[Attention] [nvarchar](512) NULL,
	[CustomerId] [int] NOT NULL,
	[CompanyName] [nvarchar](512) NULL,
	[AddressName] [nvarchar](512) NOT NULL,
	[FirstName] [nvarchar](512) NULL,
	[LastName] [nvarchar](512) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[MobilePhoneNumber] [nvarchar](50) NULL,
 CONSTRAINT [uCommerce_PK_Address] PRIMARY KEY CLUSTERED 
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_AdminPage]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_AdminPage](
	[AdminPageId] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](256) NOT NULL,
	[ActiveTab] [nvarchar](256) NOT NULL CONSTRAINT [uCommerce_AdminPage_ActiveTab]  DEFAULT (''),
 CONSTRAINT [uCommerce_PK_AdminPage] PRIMARY KEY CLUSTERED 
(
	[AdminPageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_AdminTab]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_AdminTab](
	[AdminTabId] [int] IDENTITY(1,1) NOT NULL,
	[VirtualPath] [nvarchar](512) NOT NULL,
	[AdminPageId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[MultiLingual] [bit] NOT NULL CONSTRAINT [uCommerce_DF_AdminTab_MultiLingual]  DEFAULT ((0)),
	[ResouceKey] [nvarchar](256) NULL,
	[HasSaveButton] [bit] NOT NULL CONSTRAINT [uCommerce_DF_AdminTab_HasSaveButton]  DEFAULT ((1)),
	[HasDeleteButton] [bit] NOT NULL CONSTRAINT [uCommerce_DF_AdminTab_HasDeleteButton]  DEFAULT ((0)),
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [uCommerce_PK_AdminTab] PRIMARY KEY CLUSTERED 
(
	[AdminTabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_AmountOffOrderLinesAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_AmountOffOrderLinesAward](
	[AmountOffOrderLinesAwardId] [int] NOT NULL,
	[AmountOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_uCommerce_AmountOffOrderLinesAward] PRIMARY KEY CLUSTERED 
(
	[AmountOffOrderLinesAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_AmountOffOrderTotalAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_AmountOffOrderTotalAward](
	[AmountOffOrderTotalAwardId] [int] NOT NULL,
	[AmountOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_uCommerce_AmountOffOrderTotalAward_1] PRIMARY KEY CLUSTERED 
(
	[AmountOffOrderTotalAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_AmountOffUnitAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_AmountOffUnitAward](
	[AmountOffUnitAwardId] [int] NOT NULL,
	[AmountOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_uCommerce_AmountOffUnitAward] PRIMARY KEY CLUSTERED 
(
	[AmountOffUnitAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Award]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Award](
	[AwardId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignItemId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_uCommerce_Award] PRIMARY KEY CLUSTERED 
(
	[AwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Campaign]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Campaign](
	[CampaignId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](512) NULL,
	[StartsOn] [datetime] NOT NULL,
	[EndsOn] [datetime] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Priority] [int] NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_uCommerce_Campaign] PRIMARY KEY CLUSTERED 
(
	[CampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CampaignItem]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CampaignItem](
	[CampaignItemId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [int] NOT NULL,
	[DefinitionId] [int] NOT NULL,
	[Name] [nvarchar](512) NULL,
	[Enabled] [bit] NOT NULL,
	[Priority] [int] NULL,
	[AllowNextCampaignItems] [bit] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[AnyTargetAppliesAwards] [bit] NOT NULL DEFAULT ((0)),
	[AnyTargetAdvertises] [bit] NOT NULL DEFAULT ((1)),
 CONSTRAINT [PK_uCommerce_CampaignItem] PRIMARY KEY CLUSTERED 
(
	[CampaignItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CampaignItemProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CampaignItemProperty](
	[CampaignItemPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[DefinitionFieldId] [int] NOT NULL,
	[CultureCode] [nvarchar](60) NULL,
	[CampaignItemId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_CampaignItemProperty] PRIMARY KEY CLUSTERED 
(
	[CampaignItemPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Category]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Category](
	[CategoryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
	[ImageMediaId] [nvarchar](100) NULL,
	[DisplayOnSite] [bit] NOT NULL CONSTRAINT [uCommerce_DF_Category_DisplayOnSite]  DEFAULT ((1)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Category_CreatedDate]  DEFAULT (getdate()),
	[ParentCategoryId] [int] NULL,
	[ProductCatalogId] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_Category_Deleted]  DEFAULT ((0)),
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_Category_SortOrder]  DEFAULT ((0)),
	[CreatedBy] [nvarchar](255) NULL,
	[DefinitionId] [int] NOT NULL CONSTRAINT [DF_uCommerce_Category_DefinitionId]  DEFAULT ((1)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CategoryDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CategoryDescription](
	[CategoryDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[CategoryId] [int] NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[ContentId] [int] NULL,
	[RenderAsContent] [bit] NOT NULL CONSTRAINT [uCommerce_DF_CategoryDescription_RenderAsContent]  DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_CategoryDescription] PRIMARY KEY CLUSTERED 
(
	[CategoryDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CategoryProductRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CategoryProductRelation](
	[CategoryProductRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_CategoryProductRelation_SortOrder]  DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_CategoryProductRelation] PRIMARY KEY CLUSTERED 
(
	[CategoryProductRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CategoryProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CategoryProperty](
	[CategoryPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[DefinitionFieldId] [int] NOT NULL,
	[CultureCode] [nvarchar](60) NULL,
	[CategoryId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_CategoryProperty] PRIMARY KEY CLUSTERED 
(
	[CategoryPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_CategoryTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_CategoryTarget](
	[CategoryTargetId] [int] NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
	[CategoryGuid] [uniqueidentifier] NULL,
 CONSTRAINT [PK_uCommerce_CategoryTarget] PRIMARY KEY CLUSTERED 
(
	[CategoryTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Country]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Culture] [nvarchar](60) NOT NULL,
	[Deleted] [bit] NOT NULL DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Currency]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Currency](
	[CurrencyId] [int] IDENTITY(1,1) NOT NULL,
	[ISOCode] [nvarchar](50) NOT NULL,
	[ExchangeRate] [int] NOT NULL,
	[Deleted] [bit] NOT NULL DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Customer]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](512) NOT NULL,
	[LastName] [nvarchar](512) NOT NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[MobilePhoneNumber] [nvarchar](50) NULL,
	[MemberId] [nvarchar](255) NULL,
 CONSTRAINT [uCommerce_PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DataType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DataType](
	[DataTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](50) NOT NULL,
	[Nullable] [bit] NOT NULL,
	[ValidationExpression] [nvarchar](512) NOT NULL,
	[BuiltIn] [bit] NOT NULL CONSTRAINT [uCommerce_DF_DataType_BuiltIn]  DEFAULT ((0)),
	[DefinitionName] [nvarchar](512) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF__uCommerce__Delet__4A4E069C]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_DataType_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL DEFAULT (''),
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_DataType_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL DEFAULT (''),
 CONSTRAINT [uCommerce_PK_DataType] PRIMARY KEY CLUSTERED 
(
	[DataTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DataTypeEnum]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DataTypeEnum](
	[DataTypeEnumId] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeId] [int] NOT NULL,
	[Value] [nvarchar](1024) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [DF__uCommerce__Delet__4959E263]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[SortOrder] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_DataTypeEnum] PRIMARY KEY CLUSTERED 
(
	[DataTypeEnumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DataTypeEnumDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DataTypeEnumDescription](
	[DataTypeEnumDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeEnumId] [int] NOT NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[Description] [ntext] NULL,
 CONSTRAINT [uCommerce_PK_DataTypeEnumDescription] PRIMARY KEY CLUSTERED 
(
	[DataTypeEnumDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Definition]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Definition](
	[DefinitionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](512) NOT NULL,
	[DefinitionTypeId] [int] NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_Definition_SortOrder]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[BuiltIn] [bit] NOT NULL DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_Definition_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL DEFAULT (''),
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_Definition_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL DEFAULT (''),
 CONSTRAINT [PK_uCommerceDefinition] PRIMARY KEY CLUSTERED 
(
	[DefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DefinitionField]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DefinitionField](
	[DefinitionFieldId] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeId] [int] NOT NULL,
	[DefinitionId] [int] NOT NULL,
	[Name] [nvarchar](512) NOT NULL,
	[DisplayOnSite] [bit] NOT NULL,
	[Multilingual] [bit] NOT NULL,
	[RenderInEditor] [bit] NOT NULL,
	[Searchable] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_DefinitionField_SortOrder]  DEFAULT ((0)),
	[Deleted] [bit] NOT NULL,
	[BuiltIn] [bit] NOT NULL DEFAULT ((0)),
	[DefaultValue] [nvarchar](max) NULL,
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [PK_DefinitionField] PRIMARY KEY CLUSTERED 
(
	[DefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DefinitionFieldDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DefinitionFieldDescription](
	[DefinitionFieldDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[DefinitionFieldId] [int] NOT NULL,
 CONSTRAINT [PK_DefinitionFieldDescription] PRIMARY KEY CLUSTERED 
(
	[DefinitionFieldDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DefinitionRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DefinitionRelation](
	[DefinitionRelationId] [int] IDENTITY(1,1) NOT NULL,
	[DefinitionId] [int] NOT NULL,
	[ParentDefinitionId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_DefinitionRelation] PRIMARY KEY CLUSTERED 
(
	[DefinitionRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DefinitionType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DefinitionType](
	[DefinitionTypeId] [int] NOT NULL,
	[Name] [nvarchar](512) NOT NULL,
	[Deleted] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_DefinitionType_SortOrder]  DEFAULT ((0)),
 CONSTRAINT [PK_uCommerce_DefinitionType] PRIMARY KEY CLUSTERED 
(
	[DefinitionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DefinitionTypeDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DefinitionTypeDescription](
	[DefinitionTypeDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[DefinitionTypeId] [int] NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_DefinitionTypeDescription] PRIMARY KEY CLUSTERED 
(
	[DefinitionTypeDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Discount]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Discount](
	[DiscountId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[CampaignName] [nvarchar](512) NULL,
	[CampaignItemName] [nvarchar](512) NULL,
	[Description] [nvarchar](512) NULL,
	[AmountOffTotal] [money] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[ModifiedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_uCommerce_Discount] PRIMARY KEY CLUSTERED 
(
	[DiscountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DiscountSpecificOrderLineAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DiscountSpecificOrderLineAward](
	[DiscountSpecificOrderLineAwardId] [int] NOT NULL,
	[AmountOff] [decimal](18, 2) NOT NULL,
	[AmountType] [int] NOT NULL,
	[DiscountTarget] [int] NOT NULL,
	[Sku] [nvarchar](255) NULL,
	[VariantSku] [nvarchar](255) NULL,
 CONSTRAINT [PK_DiscountSpecificOrderLineAward] PRIMARY KEY CLUSTERED 
(
	[DiscountSpecificOrderLineAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_DynamicOrderPropertyTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_DynamicOrderPropertyTarget](
	[DynamicOrderPropertyTargetId] [int] NOT NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[CompareMode] [int] NOT NULL,
	[TargetOrderLine] [bit] NOT NULL,
 CONSTRAINT [PK_uCommerce_DynamicOrderPropertyTarget] PRIMARY KEY CLUSTERED 
(
	[DynamicOrderPropertyTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailContent]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailContent](
	[EmailContentId] [int] IDENTITY(1,1) NOT NULL,
	[EmailProfileId] [int] NOT NULL,
	[EmailTypeId] [int] NOT NULL,
	[CultureCode] [nvarchar](50) NOT NULL,
	[Subject] [ntext] NULL,
	[ContentId] [nvarchar](255) NULL,
 CONSTRAINT [uCommerce_PK_EmailContent] PRIMARY KEY CLUSTERED 
(
	[EmailContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailParameter]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailParameter](
	[EmailParameterId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[GlobalResourceKey] [nvarchar](50) NOT NULL,
	[QueryStringKey] [nvarchar](50) NOT NULL,
 CONSTRAINT [uCommerce_PK_EmailParameter] PRIMARY KEY CLUSTERED 
(
	[EmailParameterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailProfile]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailProfile](
	[EmailProfileId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_EmailProfile_Deleted]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_EmailProfile] PRIMARY KEY CLUSTERED 
(
	[EmailProfileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailProfileInformation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailProfileInformation](
	[EmailProfileInformationId] [int] IDENTITY(1,1) NOT NULL,
	[EmailProfileId] [int] NOT NULL,
	[EmailTypeId] [int] NOT NULL,
	[FromName] [nvarchar](512) NOT NULL,
	[FromAddress] [nvarchar](512) NOT NULL,
	[CcAddress] [nvarchar](512) NULL,
	[BccAddress] [nvarchar](512) NULL,
 CONSTRAINT [uCommerce_PK_EmailProfileInformation] PRIMARY KEY CLUSTERED 
(
	[EmailProfileInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailType](
	[EmailTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [ntext] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_EmailType_Deleted]  DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_EmailType] PRIMARY KEY CLUSTERED 
(
	[EmailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EmailTypeParameter]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EmailTypeParameter](
	[EmailTypeId] [int] NOT NULL,
	[EmailParameterId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_EmailTypeParameter] PRIMARY KEY CLUSTERED 
(
	[EmailTypeId] ASC,
	[EmailParameterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EntityUi]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EntityUi](
	[EntityUiId] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](512) NOT NULL,
	[VirtualPathUi] [nvarchar](512) NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_EntityUi] PRIMARY KEY CLUSTERED 
(
	[EntityUiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_EntityUiDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_EntityUiDescription](
	[EntityUiDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[EntityUiId] [int] NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_uCommerce_EntityUiDescription] PRIMARY KEY CLUSTERED 
(
	[EntityUiDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_FreeGiftAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_FreeGiftAward](
	[FreeGiftAwardId] [int] NOT NULL,
	[Sku] [nvarchar](max) NOT NULL,
	[VariantSku] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[FreeGiftAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderAddress]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderAddress](
	[OrderAddressId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](512) NOT NULL,
	[LastName] [nvarchar](512) NOT NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[MobilePhoneNumber] [nvarchar](50) NULL,
	[Line1] [nvarchar](512) NOT NULL,
	[Line2] [nvarchar](512) NULL,
	[PostalCode] [nvarchar](50) NOT NULL,
	[City] [nvarchar](512) NOT NULL,
	[State] [nvarchar](512) NULL,
	[CountryId] [int] NOT NULL,
	[Attention] [nvarchar](512) NULL,
	[CompanyName] [nvarchar](512) NULL,
	[AddressName] [nvarchar](512) NOT NULL,
	[OrderId] [int] NULL,
 CONSTRAINT [uCommerce_PK_OrderAddress] PRIMARY KEY CLUSTERED 
(
	[OrderAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderAmountTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderAmountTarget](
	[OrderAmountTargetId] [int] NOT NULL,
	[MinAmount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_OrderAmountTarget] PRIMARY KEY CLUSTERED 
(
	[OrderAmountTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderLine]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderLine](
	[OrderLineId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Sku] [nvarchar](512) NOT NULL,
	[ProductName] [nvarchar](512) NOT NULL,
	[Price] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_OrderLine_CreatedDate]  DEFAULT (getdate()),
	[Discount] [money] NOT NULL CONSTRAINT [uCommerce_DF_OrderLine_Rebate]  DEFAULT ((0)),
	[VAT] [money] NOT NULL CONSTRAINT [uCommerce_DF_OrderLine_Vat]  DEFAULT ((0)),
	[Total] [money] NULL,
	[VATRate] [money] NOT NULL,
	[VariantSku] [nvarchar](512) NULL,
	[ShipmentId] [int] NULL,
	[UnitDiscount] [money] NULL,
	[CreatedBy] [nvarchar](255) NULL,
 CONSTRAINT [uCommerce_PK_OrderLine] PRIMARY KEY CLUSTERED 
(
	[OrderLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderLineDiscountRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderLineDiscountRelation](
	[OrderLineDiscountRelationId] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[OrderLineId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_OrderLineDiscountRelation] PRIMARY KEY CLUSTERED 
(
	[OrderLineDiscountRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderNumberSerie]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderNumberSerie](
	[OrderNumberId] [int] IDENTITY(1,1) NOT NULL,
	[OrderNumberName] [nvarchar](128) NOT NULL,
	[Prefix] [nvarchar](50) NULL,
	[Postfix] [nvarchar](50) NULL,
	[Increment] [int] NOT NULL,
	[CurrentNumber] [int] NOT NULL,
	[Deleted] [bit] NOT NULL DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_OrderNumbers_1] PRIMARY KEY CLUSTERED 
(
	[OrderNumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderProperty](
	[OrderPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[OrderLineId] [int] NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_uCommerce_OrderProperty] PRIMARY KEY CLUSTERED 
(
	[OrderPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderStatus]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderStatus](
	[OrderStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Sort] [int] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_Sort]  DEFAULT ((0)),
	[RenderChildren] [bit] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_RenderChildren]  DEFAULT ((0)),
	[RenderInMenu] [bit] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_RenderInMenu]  DEFAULT ((1)),
	[NextOrderStatusId] [int] NULL,
	[ExternalId] [nvarchar](50) NULL,
	[IncludeInAuditTrail] [bit] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_IncludeInAuditTrail]  DEFAULT ((1)),
	[Order] [int] NULL,
	[AllowUpdate] [bit] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_AllowUpdate]  DEFAULT ((1)),
	[AlwaysAvailable] [bit] NOT NULL CONSTRAINT [uCommerce_DF_OrderStatus_AlwaysAvailable]  DEFAULT ((0)),
	[Pipeline] [nvarchar](128) NULL,
	[AllowOrderEdit] [bit] NOT NULL CONSTRAINT [uCommerce_OrderStatus_AllowOrderEdit]  DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_OrderStatus] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderStatusAudit]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderStatusAudit](
	[OrderStatusAuditId] [int] IDENTITY(1,1) NOT NULL,
	[NewOrderStatusId] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[OrderId] [int] NOT NULL,
	[Message] [nvarchar](max) NULL,
 CONSTRAINT [uCommerce_PK_OrderStatusAudit] PRIMARY KEY CLUSTERED 
(
	[OrderStatusAuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_OrderStatusDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_OrderStatusDescription](
	[OrderStatusId] [int] NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[Description] [ntext] NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
 CONSTRAINT [uCommerce_PK_OrderStatusDescription] PRIMARY KEY CLUSTERED 
(
	[OrderStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Payment]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Payment](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionId] [nvarchar](max) NULL,
	[PaymentMethodName] [nvarchar](50) NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Payment_Created]  DEFAULT (getdate()),
	[PaymentMethodId] [int] NOT NULL,
	[Fee] [money] NOT NULL CONSTRAINT [uCommerce_DF_Payment_Fee]  DEFAULT ((0)),
	[FeePercentage] [decimal](18, 4) NOT NULL CONSTRAINT [uCommerce_DF_Payment_FeePercentage]  DEFAULT ((0)),
	[PaymentStatusId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[OrderId] [int] NOT NULL,
	[FeeTotal] [money] NULL DEFAULT ((0)),
	[ReferenceId] [nvarchar](max) NULL,
 CONSTRAINT [uCommerce_PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentMethod]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentMethod](
	[PaymentMethodId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[FeePercent] [decimal](18, 4) NOT NULL CONSTRAINT [uCommerce_DF_Table_1_FeePercant]  DEFAULT ((0)),
	[ImageMediaId] [nvarchar](255) NULL,
	[PaymentMethodServiceName] [nvarchar](512) NULL,
	[Enabled] [bit] NOT NULL CONSTRAINT [uCommerce_DF_PaymentMethod_Enabled]  DEFAULT ((1)),
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_PaymentMethod_Deleted]  DEFAULT ((0)),
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[Pipeline] [nvarchar](128) NULL,
	[DefinitionId] [int] NULL,
 CONSTRAINT [uCommerce_PK_PaymentMethod] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentMethodCountry]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentMethodCountry](
	[PaymentMethodId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_PaymentMethodCountry] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodId] ASC,
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentMethodDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentMethodDescription](
	[PaymentMethodDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMethodId] [int] NOT NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[Description] [ntext] NULL,
 CONSTRAINT [uCommerce_PK_PaymentMethodDescription] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentMethodFee]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentMethodFee](
	[PaymentMethodFeeId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentMethodId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[PriceGroupId] [int] NOT NULL,
	[Fee] [money] NOT NULL,
 CONSTRAINT [uCommerce_PK_PaymentMethodFee] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodFeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentMethodProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentMethodProperty](
	[PaymentMethodPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[DefinitionFieldId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](60) NULL,
	[PaymentMethodId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_PaymentMethodProperty] PRIMARY KEY CLUSTERED 
(
	[PaymentMethodPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentProperty](
	[PaymentPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentId] [int] NOT NULL,
	[Key] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_uCommerce_PaymentProperty] PRIMARY KEY CLUSTERED 
(
	[PaymentPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PaymentStatus]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PaymentStatus](
	[PaymentStatusId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [uCommerce_PK_PaymentStatus] PRIMARY KEY CLUSTERED 
(
	[PaymentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PercentOffOrderLinesAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PercentOffOrderLinesAward](
	[PercentOffOrderLinesAwardId] [int] NOT NULL,
	[PercentOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_uCommerce_ProcentOffOrderLinesAward] PRIMARY KEY CLUSTERED 
(
	[PercentOffOrderLinesAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PercentOffOrderTotalAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PercentOffOrderTotalAward](
	[PercentOffOrderTotalAwardId] [int] NOT NULL,
	[PercentOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_PercentOffOrderTotalAward] PRIMARY KEY CLUSTERED 
(
	[PercentOffOrderTotalAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PercentOffShippingTotalAward]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PercentOffShippingTotalAward](
	[PercentOffShippingTotalAwardId] [int] NOT NULL,
	[PercentOff] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_uCommerce_PercentOffShippingAward] PRIMARY KEY CLUSTERED 
(
	[PercentOffShippingTotalAwardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Permission]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Permission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[RoleId] [int] NULL,
 CONSTRAINT [uCommerce_PK_Permission] PRIMARY KEY CLUSTERED 
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PriceGroup]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PriceGroup](
	[PriceGroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[VATRate] [decimal](18, 4) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_PriceGroup_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_PriceGroup_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_PriceGroup_Deleted]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_PriceGroup] PRIMARY KEY CLUSTERED 
(
	[PriceGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PriceGroupPrice]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PriceGroupPrice](
	[PriceGroupPriceId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Price] [money] NULL,
	[DiscountPrice] [money] NULL,
	[PriceGroupId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_PriceGroupPrice] PRIMARY KEY CLUSTERED 
(
	[PriceGroupPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PriceGroupTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PriceGroupTarget](
	[PriceGroupTargetId] [int] NOT NULL,
	[PriceGroupName] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[PriceGroupTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Product]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Product](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[ParentProductId] [int] NULL,
	[Sku] [nvarchar](30) NOT NULL,
	[VariantSku] [nvarchar](30) NULL,
	[Name] [nvarchar](512) NOT NULL,
	[DisplayOnSite] [bit] NOT NULL CONSTRAINT [uCommerce_DF_Product_DisplayOnSite]  DEFAULT ((1)),
	[ThumbnailImageMediaId] [nvarchar](100) NULL,
	[PrimaryImageMediaId] [nvarchar](100) NULL,
	[Weight] [decimal](18, 4) NOT NULL CONSTRAINT [uCommerce_DF_Product_Weight]  DEFAULT ((0)),
	[ProductDefinitionId] [int] NOT NULL,
	[AllowOrdering] [bit] NOT NULL CONSTRAINT [uCommerce_DF_Product_AllowOrdering]  DEFAULT ((1)),
	[ModifiedBy] [nvarchar](50) NULL,
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Product_LastModified]  DEFAULT (getdate()),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Product_CreatedDate]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NULL,
	[Rating] [float] NULL CONSTRAINT [DF_uCommerce_Product_AverageRating]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalog]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalog](
	[ProductCatalogId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCatalogGroupId] [int] NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
	[PriceGroupId] [int] NOT NULL,
	[ShowPricesIncludingVAT] [bit] NOT NULL CONSTRAINT [uCommerce_DF_Catalog_ShowPricesIncludingVAT]  DEFAULT ((1)),
	[IsVirtual] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_IsVirtual]  DEFAULT ((0)),
	[DisplayOnWebSite] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_DisplayOnWebSite]  DEFAULT ((0)),
	[LimitedAccess] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_LimitedAccess]  DEFAULT ((0)),
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_Deleted]  DEFAULT ((0)),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_CreatedOn]  DEFAULT (getdate()),
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_ModifiedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](512) NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_CreatedBy]  DEFAULT (N'(Unknown)'),
	[ModifiedBy] [nvarchar](512) NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalog_ModifiedBy]  DEFAULT (N'(Unknown)'),
	[SortOrder] [int] NOT NULL DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_Catalog] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogDescription](
	[ProductCatalogDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCatalogId] [int] NOT NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
 CONSTRAINT [uCommerce_PK_ProductCatalogDescription] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogGroup]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogGroup](
	[ProductCatalogGroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [ntext] NULL,
	[EmailProfileId] [int] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[DomainId] [nvarchar](255) NULL,
	[OrderNumberId] [int] NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalogGroup_Deleted]  DEFAULT ((0)),
	[CreateCustomersAsMembers] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductCatalogGroup_CreateCustomersAsMembers]  DEFAULT ((0)),
	[MemberGroupId] [nvarchar](255) NULL,
	[MemberTypeId] [nvarchar](255) NULL,
	[ProductReviewsRequireApproval] [bit] NOT NULL CONSTRAINT [DF_uCommerce_ProductCatalogGroup_ProductReviewsRequireApproval]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductCatalogGroup_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL DEFAULT (''),
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductCatalogGroup_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL DEFAULT (''),
 CONSTRAINT [uCommerce_PK_CatalogGroup] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogGroupCampaignRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogGroupCampaignRelation](
	[ProductCatalogGroupCampaignRelationId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignId] [int] NULL,
	[ProductCatalogGroupId] [int] NULL,
 CONSTRAINT [uCommerce_PK_ProductCatalogGroupCampaignRelation] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogGroupCampaignRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap](
	[ProductCatalogGroupId] [int] NOT NULL,
	[PaymentMethodId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ProductCatalogGroupPaymentMethodMap] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogGroupId] ASC,
	[PaymentMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap](
	[ProductCatalogGroupId] [int] NOT NULL,
	[ShippingMethodId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ProductCatalogGroupShippingMethodMap] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogGroupId] ASC,
	[ShippingMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogGroupTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogGroupTarget](
	[ProductCatalogGroupTargetId] [int] NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductCatalogGroupTarget] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogGroupTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogPriceGroupRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation](
	[ProductCatalogPriceGroupRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductCatalogId] [int] NOT NULL,
	[PriceGroupId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductCatalogPriceGroupRelation] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogPriceGroupRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductCatalogTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductCatalogTarget](
	[ProductCatalogTargetId] [int] NOT NULL,
	[Name] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_ProductCatalogTarget] PRIMARY KEY CLUSTERED 
(
	[ProductCatalogTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDefinition]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDefinition](
	[ProductDefinitionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductDefinition_Deleted]  DEFAULT ((0)),
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinition_SortOrder]  DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinition_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL DEFAULT (''),
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinition_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL DEFAULT (''),
 CONSTRAINT [uCommerce_PK_ProductDefinition] PRIMARY KEY CLUSTERED 
(
	[ProductDefinitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDefinitionField]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDefinitionField](
	[ProductDefinitionFieldId] [int] IDENTITY(1,1) NOT NULL,
	[DataTypeId] [int] NOT NULL,
	[ProductDefinitionId] [int] NOT NULL,
	[Name] [nvarchar](512) NOT NULL,
	[DisplayOnSite] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductDefinitionField_DisplayOnSite]  DEFAULT ((0)),
	[IsVariantProperty] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductDefinitionField_IsVariantProperty]  DEFAULT ((0)),
	[Multilingual] [bit] NOT NULL,
	[RenderInEditor] [bit] NOT NULL,
	[Searchable] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductDefinitionField_Searchable]  DEFAULT ((0)),
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ProductDefinitionField_Deleted]  DEFAULT ((0)),
	[SortOrder] [int] NOT NULL CONSTRAINT [DF_uCommerce_ProductDefinitionField_SortOrder]  DEFAULT ((0)),
	[Facet] [bit] NOT NULL DEFAULT ((0)),
	[Guid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
 CONSTRAINT [uCommerce_PK_ProductDefinitionField] PRIMARY KEY CLUSTERED 
(
	[ProductDefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDefinitionFieldDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDefinitionFieldDescription](
	[ProductDefinitionFieldDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
	[DisplayName] [nvarchar](255) NOT NULL,
	[ProductDefinitionFieldId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [uCommerce_PK_ProductDefinitionFieldDescription] PRIMARY KEY CLUSTERED 
(
	[ProductDefinitionFieldDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDefinitionRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDefinitionRelation](
	[ProductDefinitionRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductDefinitionId] [int] NOT NULL,
	[ParentProductDefinitionId] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductDefinitionRelation] PRIMARY KEY CLUSTERED 
(
	[ProductDefinitionRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDescription](
	[ProductDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[DisplayName] [nvarchar](512) NOT NULL,
	[ShortDescription] [nvarchar](max) NULL,
	[LongDescription] [nvarchar](max) NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
 CONSTRAINT [uCommerce_PK_ProductDescription] PRIMARY KEY CLUSTERED 
(
	[ProductDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductDescriptionProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductDescriptionProperty](
	[ProductDescriptionPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[ProductDescriptionId] [int] NOT NULL,
	[ProductDefinitionFieldId] [int] NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [uCommerce_PK_ProductDescriptionProperty] PRIMARY KEY CLUSTERED 
(
	[ProductDescriptionPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductProperty](
	[ProductPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ProductDefinitionFieldId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ProductProperty] PRIMARY KEY CLUSTERED 
(
	[ProductPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductRelation](
	[ProductRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[RelatedProductId] [int] NOT NULL,
	[ProductRelationTypeId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductRelation2] PRIMARY KEY CLUSTERED 
(
	[ProductRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductRelationType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductRelationType](
	[ProductRelationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductRelation_CreatedOn]  DEFAULT (getdate()),
	[CreatedBy] [nvarchar](50) NOT NULL,
	[ModifiedOn] [datetime] NOT NULL CONSTRAINT [DF_uCommerce_ProductRelation_ModifiedOn]  DEFAULT (getdate()),
	[ModifiedBy] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductRelation] PRIMARY KEY CLUSTERED 
(
	[ProductRelationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductReview]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductReview](
	[ProductReviewId] [int] IDENTITY(1,1) NOT NULL,
	[Rating] [int] NULL,
	[CustomerId] [int] NULL,
	[ProductCatalogGroupId] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[CultureCode] [nvarchar](60) NULL,
	[ReviewHeadline] [nvarchar](512) NULL,
	[ReviewText] [nvarchar](max) NULL,
	[ProductId] [int] NOT NULL,
	[Ip] [nvarchar](50) NOT NULL,
	[ProductReviewStatusId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductReview] PRIMARY KEY CLUSTERED 
(
	[ProductReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductReviewComment]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductReviewComment](
	[ProductReviewCommentId] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[CultureCode] [nvarchar](60) NULL,
	[Comment] [nvarchar](max) NULL,
	[Helpful] [bit] NOT NULL,
	[Unhelpful] [bit] NOT NULL,
	[Ip] [nvarchar](50) NOT NULL,
	[ProductReviewStatusId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductReviewComment] PRIMARY KEY CLUSTERED 
(
	[ProductReviewCommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductReviewStatus]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductReviewStatus](
	[ProductReviewStatusId] [int] NOT NULL,
	[Name] [nvarchar](1024) NOT NULL,
	[Deleted] [bit] NOT NULL,
 CONSTRAINT [PK_uCommerce_ProductReviewStatus] PRIMARY KEY CLUSTERED 
(
	[ProductReviewStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ProductTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ProductTarget](
	[ProductTargetId] [int] NOT NULL,
	[Skus] [nvarchar](max) NULL,
 CONSTRAINT [PK_uCommerce_ProductTarget] PRIMARY KEY CLUSTERED 
(
	[ProductTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_PurchaseOrder]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_PurchaseOrder](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderNumber] [nvarchar](50) NULL,
	[CustomerId] [int] NULL,
	[OrderStatusId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Order_CreatedDate]  DEFAULT (getdate()),
	[CompletedDate] [datetime] NULL,
	[CurrencyId] [int] NOT NULL,
	[ProductCatalogGroupId] [int] NOT NULL,
	[BillingAddressId] [int] NULL,
	[Note] [ntext] NULL,
	[BasketId] [uniqueidentifier] NOT NULL CONSTRAINT [uCommerce_DF_PurchaseOrder_BasketId]  DEFAULT (newid()),
	[VAT] [money] NULL,
	[OrderTotal] [money] NULL,
	[ShippingTotal] [money] NULL,
	[PaymentTotal] [money] NULL,
	[TaxTotal] [money] NULL,
	[SubTotal] [money] NULL,
	[OrderGuid] [uniqueidentifier] NOT NULL DEFAULT (newid()),
	[ModifiedOn] [datetime] NOT NULL DEFAULT (getdate()),
	[CultureCode] [nvarchar](60) NULL,
	[Discount] [money] NULL,
	[DiscountTotal] [money] NULL,
 CONSTRAINT [uCommerce_PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_QuantityTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_QuantityTarget](
	[QuantityTargetId] [int] NOT NULL,
	[MinQuantity] [int] NOT NULL,
	[TargetOrderLine] [bit] NOT NULL,
 CONSTRAINT [PK_uCommerce_QuantityTarget] PRIMARY KEY CLUSTERED 
(
	[QuantityTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Role]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[ProductCatalogGroupId] [int] NULL,
	[ProductCatalogId] [int] NULL,
	[CultureCode] [nvarchar](10) NULL,
	[PriceGroupId] [int] NULL,
	[RoleType] [int] NOT NULL,
	[ParentRoleId] [int] NULL,
 CONSTRAINT [uCommerce_PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Shipment]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Shipment](
	[ShipmentId] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentName] [nvarchar](128) NOT NULL,
	[CreatedOn] [datetime] NOT NULL CONSTRAINT [uCommerce_DF_Shipping_Created]  DEFAULT (getdate()),
	[ShipmentPrice] [money] NOT NULL CONSTRAINT [uCommerce_DF_Shipping_ShippingPrice]  DEFAULT ((0)),
	[ShippingMethodId] [int] NOT NULL,
	[ShipmentAddressId] [int] NULL,
	[DeliveryNote] [nvarchar](max) NULL,
	[OrderId] [int] NOT NULL,
	[TrackAndTrace] [nvarchar](512) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[Tax] [money] NOT NULL DEFAULT ((0)),
	[TaxRate] [money] NOT NULL DEFAULT ((0)),
	[ShipmentTotal] [money] NOT NULL DEFAULT ((0)),
	[ShipmentDiscount] [money] NULL,
 CONSTRAINT [uCommerce_PK_Shipping] PRIMARY KEY CLUSTERED 
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShipmentDiscountRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShipmentDiscountRelation](
	[ShipmentDiscountRelationId] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[DiscountId] [int] NOT NULL,
 CONSTRAINT [PK_uCommerce_ShipmentDiscountRelation] PRIMARY KEY CLUSTERED 
(
	[ShipmentDiscountRelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethod]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethod](
	[ShippingMethodId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](128) NOT NULL,
	[ImageMediaId] [nvarchar](255) NULL,
	[PaymentMethodId] [int] NULL,
	[ServiceName] [nvarchar](128) NULL,
	[Deleted] [bit] NOT NULL CONSTRAINT [uCommerce_DF_ShippingMethod_Deleted]  DEFAULT ((0)),
 CONSTRAINT [uCommerce_PK_ShippingMethod] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethodCountry]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethodCountry](
	[ShippingMethodId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ShippingMethodCountry] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodId] ASC,
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethodDescription]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethodDescription](
	[ShippingMethodDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[ShippingMethodId] [int] NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[DeliveryText] [nvarchar](512) NULL,
	[CultureCode] [nvarchar](60) NOT NULL,
 CONSTRAINT [uCommerce_PK_ShippingMethodDescription] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethodPaymentMethods]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethodPaymentMethods](
	[ShippingMethodId] [int] NOT NULL,
	[PaymentMethodId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ShippingMethodPaymentMethods] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodId] ASC,
	[PaymentMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethodPrice]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethodPrice](
	[ShippingMethodPriceId] [int] IDENTITY(1,1) NOT NULL,
	[ShippingMethodId] [int] NOT NULL,
	[PriceGroupId] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[CurrencyId] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_ShippingMethodPrice] PRIMARY KEY CLUSTERED 
(
	[ShippingMethodPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_ShippingMethodsTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_ShippingMethodsTarget](
	[ShippingMethodsTargetId] [int] NOT NULL,
	[ShippingMethodsIdsList] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ShippingMethodsTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_SystemVersion]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_SystemVersion](
	[SystemVersionId] [int] IDENTITY(1,1) NOT NULL,
	[SchemaVersion] [int] NOT NULL,
 CONSTRAINT [uCommerce_PK_SystemVersion] PRIMARY KEY CLUSTERED 
(
	[SystemVersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_Target]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_Target](
	[TargetId] [int] IDENTITY(1,1) NOT NULL,
	[CampaignItemId] [int] NOT NULL,
	[EnabledForDisplay] [bit] NOT NULL,
	[EnabledForApply] [bit] NOT NULL,
 CONSTRAINT [PK_uCommerce_Target] PRIMARY KEY CLUSTERED 
(
	[TargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_User]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[ExternalId] [nvarchar](255) NULL,
 CONSTRAINT [uCommerce_PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_UserGroup]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_UserGroup](
	[UserGroupId] [int] IDENTITY(1,1) NOT NULL,
	[ExternalId] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_UserGroupPermission]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_UserGroupPermission](
	[PermissionId] [int] IDENTITY(1,1) NOT NULL,
	[UserGroupId] [int] NULL,
	[RoleId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_UserWidgetSetting]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_UserWidgetSetting](
	[UserWidgetSettingId] [int] IDENTITY(1,1) NOT NULL,
	[Section] [nvarchar](max) NULL,
	[WidgetName] [nvarchar](max) NULL,
	[Width] [nvarchar](max) NULL,
	[Height] [nvarchar](max) NULL,
	[PositionX] [nvarchar](max) NULL,
	[PositionY] [nvarchar](max) NULL,
	[UserId] [int] NULL,
	[DisplayName] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserWidgetSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_UserWidgetSettingProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_UserWidgetSettingProperty](
	[UserWidgetSettingPropertyId] [int] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL,
	[UserWidgetSettingId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserWidgetSettingPropertyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_VoucherCode]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_VoucherCode](
	[VoucherCodeId] [int] IDENTITY(1,1) NOT NULL,
	[TargetId] [int] NOT NULL,
	[NumberUsed] [int] NOT NULL,
	[MaxUses] [int] NOT NULL,
	[Code] [nvarchar](512) NOT NULL,
 CONSTRAINT [PK_uCommerce_VoucherCode_1] PRIMARY KEY CLUSTERED 
(
	[VoucherCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[uCommerce_VoucherTarget]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[uCommerce_VoucherTarget](
	[VoucherTargetId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_uCommerce_SingleUseVoucher_1] PRIMARY KEY CLUSTERED 
(
	[VoucherTargetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoAccess]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoAccess](
	[id] [uniqueidentifier] NOT NULL,
	[nodeId] [int] NOT NULL,
	[loginNodeId] [int] NOT NULL,
	[noAccessNodeId] [int] NOT NULL,
	[createDate] [datetime] NOT NULL,
	[updateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_umbracoAccess] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoAccessRule]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoAccessRule](
	[id] [uniqueidentifier] NOT NULL,
	[accessId] [uniqueidentifier] NOT NULL,
	[ruleValue] [nvarchar](255) NOT NULL,
	[ruleType] [nvarchar](255) NOT NULL,
	[createDate] [datetime] NOT NULL,
	[updateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_umbracoAccessRule] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoCacheInstruction]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoCacheInstruction](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[utcStamp] [datetime] NOT NULL,
	[jsonInstruction] [ntext] NOT NULL,
	[originated] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_umbracoCacheInstruction] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoDomains]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoDomains](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[domainDefaultLanguage] [int] NULL,
	[domainRootStructureID] [int] NULL,
	[domainName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_umbracoDomains] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoExternalLogin]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoExternalLogin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[loginProvider] [nvarchar](4000) NOT NULL,
	[providerKey] [nvarchar](4000) NOT NULL,
	[createDate] [datetime] NOT NULL,
 CONSTRAINT [PK_umbracoExternalLogin] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoLanguage]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoLanguage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[languageISOCode] [nvarchar](10) NULL,
	[languageCultureName] [nvarchar](100) NULL,
 CONSTRAINT [PK_umbracoLanguage] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoLog]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userId] [int] NOT NULL,
	[NodeId] [int] NOT NULL,
	[Datestamp] [datetime] NOT NULL CONSTRAINT [DF_umbracoLog_Datestamp]  DEFAULT (getdate()),
	[logHeader] [nvarchar](50) NOT NULL,
	[logComment] [nvarchar](4000) NULL,
 CONSTRAINT [PK_umbracoLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoMigration]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoMigration](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[createDate] [datetime] NOT NULL CONSTRAINT [DF_umbracoMigration_createDate]  DEFAULT (getdate()),
	[version] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_umbracoMigration] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoNode]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoNode](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[trashed] [bit] NOT NULL CONSTRAINT [DF_umbracoNode_trashed]  DEFAULT ('0'),
	[parentID] [int] NOT NULL,
	[nodeUser] [int] NULL,
	[level] [int] NOT NULL,
	[path] [nvarchar](150) NOT NULL,
	[sortOrder] [int] NOT NULL,
	[uniqueID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_umbracoNode_uniqueID]  DEFAULT (newid()),
	[text] [nvarchar](255) NULL,
	[nodeObjectType] [uniqueidentifier] NULL,
	[createDate] [datetime] NOT NULL CONSTRAINT [DF_umbracoNode_createDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_structure] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoRelation](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[parentId] [int] NOT NULL,
	[childId] [int] NOT NULL,
	[relType] [int] NOT NULL,
	[datetime] [datetime] NOT NULL,
	[comment] [nvarchar](1000) NOT NULL,
 CONSTRAINT [PK_umbracoRelation] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoRelationType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoRelationType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dual] [bit] NOT NULL,
	[parentObjectType] [uniqueidentifier] NOT NULL,
	[childObjectType] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[alias] [nvarchar](100) NULL,
 CONSTRAINT [PK_umbracoRelationType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoServer]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoServer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[address] [nvarchar](500) NOT NULL,
	[computerName] [nvarchar](255) NOT NULL,
	[registeredDate] [datetime] NOT NULL CONSTRAINT [DF_umbracoServer_registeredDate]  DEFAULT (getdate()),
	[lastNotifiedDate] [datetime] NOT NULL,
	[isActive] [bit] NOT NULL,
	[isMaster] [bit] NOT NULL,
 CONSTRAINT [PK_umbracoServer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoUser]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoUser](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userDisabled] [bit] NOT NULL CONSTRAINT [DF_umbracoUser_userDisabled]  DEFAULT ('0'),
	[userNoConsole] [bit] NOT NULL CONSTRAINT [DF_umbracoUser_userNoConsole]  DEFAULT ('0'),
	[userType] [int] NOT NULL,
	[startStructureID] [int] NOT NULL,
	[startMediaID] [int] NULL,
	[userName] [nvarchar](255) NOT NULL,
	[userLogin] [nvarchar](125) NOT NULL,
	[userPassword] [nvarchar](500) NOT NULL,
	[userEmail] [nvarchar](255) NOT NULL,
	[userLanguage] [nvarchar](10) NULL,
	[securityStampToken] [nvarchar](255) NULL,
	[failedLoginAttempts] [int] NULL,
	[lastLockoutDate] [datetime] NULL,
	[lastPasswordChangeDate] [datetime] NULL,
	[lastLoginDate] [datetime] NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoUser2app]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoUser2app](
	[user] [int] NOT NULL,
	[app] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_user2app] PRIMARY KEY CLUSTERED 
(
	[user] ASC,
	[app] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoUser2NodeNotify]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoUser2NodeNotify](
	[userId] [int] NOT NULL,
	[nodeId] [int] NOT NULL,
	[action] [nchar](1) NOT NULL,
 CONSTRAINT [PK_umbracoUser2NodeNotify] PRIMARY KEY CLUSTERED 
(
	[userId] ASC,
	[nodeId] ASC,
	[action] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoUser2NodePermission]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoUser2NodePermission](
	[userId] [int] NOT NULL,
	[nodeId] [int] NOT NULL,
	[permission] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_umbracoUser2NodePermission] PRIMARY KEY CLUSTERED 
(
	[userId] ASC,
	[nodeId] ASC,
	[permission] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[umbracoUserType]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[umbracoUserType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userTypeAlias] [nvarchar](50) NULL,
	[userTypeName] [nvarchar](255) NOT NULL,
	[userTypeDefaultPermissions] [nvarchar](50) NULL,
 CONSTRAINT [PK_umbracoUserType] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[cmsContent] ON 

GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (1, 1081, 1053)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (2, 1092, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (3, 1093, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (4, 1094, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (5, 1095, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (6, 1096, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (7, 1097, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (8, 1098, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (9, 1099, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (10, 1100, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (11, 1101, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (12, 1102, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (13, 1103, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (14, 1104, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (15, 1105, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (16, 1106, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (17, 1107, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (18, 1108, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (19, 1109, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (20, 1110, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (21, 1111, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (22, 1112, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (23, 1113, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (24, 1114, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (25, 1115, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (26, 1116, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (27, 1117, 1055)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (28, 1118, 1056)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (29, 1119, 1082)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (30, 1120, 1083)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (31, 1121, 1084)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (32, 1122, 1057)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (33, 1123, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (34, 1124, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (35, 1125, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (36, 1126, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (37, 1127, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (38, 1128, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (39, 1129, 1057)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (40, 1130, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (41, 1131, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (42, 1132, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (43, 1133, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (44, 1134, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (45, 1135, 1058)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (46, 1136, 1060)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (47, 1137, 1059)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (48, 1138, 1061)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (49, 1139, 1062)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (50, 1140, 1063)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (51, 1141, 1067)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (52, 1142, 1066)
GO
INSERT [dbo].[cmsContent] ([pk], [nodeId], [contentType]) VALUES (53, 1143, 1068)
GO
SET IDENTITY_INSERT [dbo].[cmsContent] OFF
GO
SET IDENTITY_INSERT [dbo].[cmsContentType] ON 

GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (531, 1044, N'Member', N'icon-user', N'icon-user', NULL, 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (532, 1031, N'Folder', N'icon-folder', N'icon-folder', NULL, 0, 1)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (533, 1032, N'Image', N'icon-picture', N'icon-picture', NULL, 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (534, 1033, N'File', N'icon-document', N'icon-document', NULL, 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (535, 1053, N'Home', N'icon-store', N'folder.png', N'', 0, 1)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (536, 1054, N'Master', N'.sprTreeFolder', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (537, 1055, N'CategorySectionPage', N'icon-usb', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (538, 1056, N'HowToSubSectionPage', N'icon-umb-developer', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (539, 1057, N'ContentSectionPage', N'icon-window-popin', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (540, 1058, N'ContentSubSectionPage', N'icon-umb-developer', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (541, 1059, N'ArticleContent', N'icon-stacked-disks', N'folder.png', N'', 1, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (542, 1060, N'Content', N'.sprTreeFolder', N'folder.png', N'', 0, 1)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (543, 1061, N'HowToContent', N'icon-tools', N'folder.png', N'', 1, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (544, 1062, N'GalleryContent', N'icon-wallet', N'folder.png', N'', 1, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (545, 1063, N'TagLibrary', N'icon-sitemap', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (546, 1064, N'Footer', N'.sprTreeFolder', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (547, 1065, N'FooterPage', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (548, 1066, N'HowToPageLandscape', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (549, 1067, N'ArticlePageLandscape', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (550, 1068, N'GalleryPage', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (551, 1069, N'OpenGraphTags', N'.sprTreeFolder', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (552, 1082, N'GallerySubSectionPage', N'icon-umb-developer', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (553, 1083, N'ArticleSubSectionPage', N'icon-umb-developer', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (554, 1084, N'ProductListingPage', N'icon-shopping-basket', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (555, 1089, N'SeoTags', N'.sprTreeFolder', N'folder.png', NULL, 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (556, 1090, N'ProductDetailsPage', N'icon-tags', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (557, 1144, N'ArticlePagePotrait', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
INSERT [dbo].[cmsContentType] ([pk], [nodeId], [alias], [icon], [thumbnail], [description], [isContainer], [allowAtRoot]) VALUES (558, 1146, N'HowToPagePotrait', N'icon-umb-content', N'folder.png', N'', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[cmsContentType] OFF
GO
INSERT [dbo].[cmsContentType2ContentType] ([parentContentTypeId], [childContentTypeId]) VALUES (1069, 1054)
GO
INSERT [dbo].[cmsContentType2ContentType] ([parentContentTypeId], [childContentTypeId]) VALUES (1089, 1054)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1031, 1031, 0)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1031, 1032, 0)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1031, 1033, 0)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1053, 1055, 3)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1053, 1057, 4)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1053, 1064, 5)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1055, 1056, 6)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1055, 1082, 5)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1055, 1083, 4)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1055, 1084, 7)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1057, 1058, 1)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1059, 1067, 2)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1059, 1144, 3)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1060, 1059, 4)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1060, 1061, 6)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1060, 1062, 5)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1060, 1063, 7)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1061, 1066, 2)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1061, 1146, 3)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1062, 1068, 1)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1064, 1065, 1)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1066, 1066, 1)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1084, 1090, 1)
GO
INSERT [dbo].[cmsContentTypeAllowedContentType] ([Id], [AllowedId], [SortOrder]) VALUES (1146, 1066, 1)
GO
SET IDENTITY_INSERT [dbo].[cmsContentVersion] ON 

GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (1, 1081, N'8576e544-2349-4c1e-a5cd-dd69aea9e76e', CAST(N'2015-12-09 16:14:43.727' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (2, 1092, N'7a13c305-d7f3-48e0-b5e5-d2f847dd87b3', CAST(N'2015-12-09 16:21:33.380' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (3, 1093, N'2a802e49-f5f7-4849-8f34-5fe45ffb029d', CAST(N'2015-12-09 16:21:43.073' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (4, 1094, N'a2608153-f3db-4203-826c-4e132d22222c', CAST(N'2015-12-09 16:21:54.250' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (5, 1095, N'7c727744-666d-4a03-bdf8-ca364b8f4758', CAST(N'2015-12-09 16:22:07.247' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (6, 1096, N'467a4111-5908-4918-b6d2-fd45d7098432', CAST(N'2015-12-09 16:22:20.717' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (7, 1095, N'776e3f76-07b6-4e8d-8a01-d8f71d209851', CAST(N'2015-12-09 16:22:36.980' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (8, 1097, N'3c0a3ee7-03da-4898-ae81-53f88b7811e7', CAST(N'2015-12-09 16:22:45.823' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (9, 1098, N'4f846530-0c81-405c-bd4f-77ccbd3db6ce', CAST(N'2015-12-09 16:22:45.857' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (10, 1099, N'655b85aa-d32d-45dd-bf3d-64e2092aa96f', CAST(N'2015-12-09 16:22:45.867' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (11, 1100, N'453ca8b2-f39c-4f89-ba3b-c65d9e34823b', CAST(N'2015-12-09 16:22:45.880' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (12, 1101, N'3c56832d-2125-4be4-a571-9e438c754ec1', CAST(N'2015-12-09 16:22:45.893' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (13, 1097, N'5fcdcf4b-ab07-400b-b50a-67759c441abf', CAST(N'2015-12-09 16:22:57.413' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (14, 1098, N'186f7f33-9000-4ba0-bf98-f1fac49c9efe', CAST(N'2015-12-09 16:23:04.370' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (15, 1099, N'4411ffcb-cb30-47e1-a728-3ef1ac0ec7b1', CAST(N'2015-12-09 16:23:06.150' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (16, 1100, N'd1c89a45-ecc7-440c-b5e6-04baedd23ebf', CAST(N'2015-12-09 16:23:08.133' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (17, 1101, N'e7328b93-98c0-453b-95b3-56522a652277', CAST(N'2015-12-09 16:23:09.977' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (18, 1102, N'011e44c3-e00f-48a3-913a-aa1f6f603b70', CAST(N'2015-12-09 16:23:30.410' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (19, 1103, N'ab189718-031f-4c3c-bbdc-28119a94bc75', CAST(N'2015-12-09 16:23:30.493' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (20, 1104, N'0b3eecab-e0e2-4a9b-bf3b-a1df6f7c5265', CAST(N'2015-12-09 16:23:30.500' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (21, 1105, N'12e8306a-3116-4910-984d-54cb6ec8afe1', CAST(N'2015-12-09 16:23:30.533' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (22, 1106, N'78591e6f-179d-4930-9a90-b65756780003', CAST(N'2015-12-09 16:23:30.540' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (23, 1102, N'f0c5424b-9b6a-4005-ad51-4af55d545fef', CAST(N'2015-12-09 16:23:43.143' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (24, 1103, N'9f700e94-efc5-46fa-bc92-70302204942a', CAST(N'2015-12-09 16:23:46.473' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (25, 1104, N'eae6e44b-f9ce-4686-8ea8-821b3893bedb', CAST(N'2015-12-09 16:23:48.203' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (26, 1105, N'06171021-7367-4fb4-803a-c56a972911b8', CAST(N'2015-12-09 16:23:49.937' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (27, 1106, N'950a7709-b7dc-431f-bb1e-3427247b79fd', CAST(N'2015-12-09 16:23:51.777' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (28, 1107, N'f141c529-d433-49a1-8137-ed5ea0515f32', CAST(N'2015-12-09 16:23:56.703' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (29, 1108, N'395aa6e1-387e-4d83-9e54-5381d93fc54f', CAST(N'2015-12-09 16:23:56.720' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (30, 1109, N'223b4cc1-7906-4fad-88e9-3cd319731db5', CAST(N'2015-12-09 16:23:56.733' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (31, 1110, N'8d71f9c3-5499-4692-a99a-122c4316652f', CAST(N'2015-12-09 16:23:56.743' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (32, 1111, N'1fd8a0c9-191d-4fc1-a326-bc940a769025', CAST(N'2015-12-09 16:23:56.753' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (33, 1107, N'9f26ea94-2e0f-407c-8ea7-d7955d1a2cf7', CAST(N'2015-12-09 16:24:17.207' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (34, 1112, N'8ae5d928-a94b-480f-aa22-8a3b852be43e', CAST(N'2015-12-09 16:24:25.493' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (35, 1113, N'7d91a149-bfe4-443c-b075-8f348923e002', CAST(N'2015-12-09 16:24:25.513' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (36, 1114, N'01a7dd28-abff-4154-8cf8-b87e593e5e73', CAST(N'2015-12-09 16:24:25.530' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (37, 1115, N'9ccc0261-7956-4c34-9510-19e49dc0d25d', CAST(N'2015-12-09 16:24:25.540' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (38, 1116, N'c9b08817-0fd9-4ce9-b593-34470d7feace', CAST(N'2015-12-09 16:24:25.553' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (39, 1107, N'3e1336b4-19e8-41e1-bb2d-4800ff5c52e1', CAST(N'2015-12-09 16:24:32.603' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (40, 1112, N'1f42d6cc-0db8-4f5c-acf7-53908721be43', CAST(N'2015-12-09 16:24:50.150' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (41, 1117, N'1dd259ec-3a48-4bf6-90f1-74aee24a4d13', CAST(N'2015-12-09 16:25:00.947' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (42, 1118, N'ecaf95fb-7166-461d-9dc0-ce4977cffc15', CAST(N'2015-12-09 16:25:00.963' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (43, 1119, N'6f8b6dd7-3949-4ca6-b977-0e051600f385', CAST(N'2015-12-09 16:25:00.970' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (44, 1120, N'acda9e90-94d7-4ad9-9cb6-baf60100bbb1', CAST(N'2015-12-09 16:25:00.997' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (45, 1121, N'01b9a553-f9a3-4063-8afa-66558ee0447f', CAST(N'2015-12-09 16:25:01.007' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (46, 1117, N'4a62a16c-1350-4c7c-a083-454e6a04820f', CAST(N'2015-12-09 16:25:08.493' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (47, 1108, N'292140f8-3f3c-4cfe-9a99-8c077d3b1d5a', CAST(N'2015-12-09 16:25:14.610' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (48, 1109, N'f5540734-1ccc-4a62-8e98-80abf383bf85', CAST(N'2015-12-09 16:25:18.150' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (49, 1110, N'7d04928f-317e-496b-8eec-cddebc1d98fc', CAST(N'2015-12-09 16:25:20.303' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (50, 1111, N'442e4554-f7f0-48f7-b34c-a35ea0ecaf25', CAST(N'2015-12-09 16:25:22.250' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (51, 1113, N'50b4dc44-c38a-4816-a119-b084e96292a1', CAST(N'2015-12-09 16:25:25.243' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (52, 1114, N'1ca807ac-f87d-4505-8f20-a1e47719ff44', CAST(N'2015-12-09 16:25:27.090' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (53, 1115, N'baddfc46-61d1-49a5-bc90-a1e309c9c8a5', CAST(N'2015-12-09 16:25:28.777' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (54, 1116, N'f5a5f3cc-0e8f-467e-8d2e-c5c0a2bd680f', CAST(N'2015-12-09 16:25:30.687' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (55, 1118, N'ef54b576-6b38-4166-b164-cdce1bcd59b3', CAST(N'2015-12-09 16:25:34.243' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (56, 1119, N'34d427ec-cba6-46ee-b631-5bc3ffb05e8f', CAST(N'2015-12-09 16:25:36.337' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (57, 1120, N'622a2e28-4c5b-4866-a435-9f0ec680fae5', CAST(N'2015-12-09 16:25:38.247' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (58, 1121, N'5522621f-ccd0-4d8c-9033-de60e5347295', CAST(N'2015-12-09 16:25:40.937' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (59, 1122, N'9eda020f-a4eb-4e4e-8064-7e8bf314a2c2', CAST(N'2015-12-09 16:26:13.127' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (60, 1123, N'829b68e6-5935-44b2-86a5-a65eff400964', CAST(N'2015-12-09 16:26:22.397' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (61, 1124, N'cc485388-a6e8-468a-b0e6-7f73c2c70682', CAST(N'2015-12-09 16:26:34.443' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (62, 1125, N'7e5d6fc6-0931-49e0-b6f0-c70b1ef7f9a5', CAST(N'2015-12-09 16:26:47.887' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (63, 1126, N'a3084abc-30b2-4a3d-b1f5-316a04bf0bb9', CAST(N'2015-12-09 16:26:56.687' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (64, 1127, N'fed8da3c-b11b-4612-8518-d53cc73feacf', CAST(N'2015-12-09 16:27:03.970' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (65, 1128, N'a4330e7c-fbb0-487a-9742-7f3c9113e4bd', CAST(N'2015-12-09 16:27:16.590' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (66, 1129, N'e51ab736-ed41-4621-9eb4-66824950b407', CAST(N'2015-12-09 16:27:51.053' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (67, 1130, N'2ddf6d05-3f71-440c-b2e7-bb91a2e145fb', CAST(N'2015-12-09 16:27:51.070' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (68, 1131, N'c530acbc-f8e7-4cc3-8f8d-92af857355a3', CAST(N'2015-12-09 16:27:51.083' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (69, 1132, N'0f3b733b-0805-4c3a-b8b9-67c21e40d674', CAST(N'2015-12-09 16:27:51.093' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (70, 1133, N'c79b51da-3d51-45d7-a957-449d8601bef5', CAST(N'2015-12-09 16:27:51.107' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (71, 1134, N'a6b0b810-fe1b-485e-a8ab-fa661aaa5147', CAST(N'2015-12-09 16:27:51.117' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (72, 1135, N'f39ad2cc-7cbd-473b-a990-f308491efc8c', CAST(N'2015-12-09 16:27:51.127' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (73, 1129, N'ccd2d1a8-a57b-4908-8e02-b5f08f376859', CAST(N'2015-12-09 16:28:00.983' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (74, 1130, N'517a9faf-caa5-4204-a273-0f4ce52f59f3', CAST(N'2015-12-09 16:28:04.817' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (75, 1131, N'1e070309-cc8f-4330-9d08-e5c9ee48ea0e', CAST(N'2015-12-09 16:28:06.573' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (76, 1132, N'64b75058-7961-4860-abb9-8a01d5e363e0', CAST(N'2015-12-09 16:28:08.163' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (77, 1133, N'812b7f15-bbfb-4b27-83d0-038577480c9c', CAST(N'2015-12-09 16:28:09.810' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (78, 1134, N'5f462bdd-8e88-47a7-b1c5-16cb5d585a88', CAST(N'2015-12-09 16:28:11.427' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (79, 1135, N'd3115a65-44c3-475d-ad7b-ba61fe689245', CAST(N'2015-12-09 16:28:13.253' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (80, 1136, N'936b347d-d293-4114-b223-372f027e2521', CAST(N'2015-12-09 16:29:23.943' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (81, 1137, N'0eda9b37-cfae-48c9-b39c-08a5761d724a', CAST(N'2015-12-09 16:29:36.463' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (82, 1138, N'69cbdb69-3829-4d34-9f93-ebe0d6c423b3', CAST(N'2015-12-09 16:29:46.123' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (83, 1139, N'daefc1eb-95f5-48ea-a6f4-a03e6b58dde9', CAST(N'2015-12-09 16:29:54.083' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (84, 1140, N'8e6881a7-a3dd-44bf-ad38-9aed5c6f6c5c', CAST(N'2015-12-09 16:30:03.357' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (85, 1141, N'c22a958a-c265-47e9-8023-8ebda6f8c20a', CAST(N'2015-12-09 16:30:21.673' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (86, 1142, N'9bbf94a6-934f-426d-8eb4-726ad273b9f4', CAST(N'2015-12-09 16:30:34.367' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (87, 1143, N'89eb14a6-afa8-4008-9319-19b0f7992588', CAST(N'2015-12-09 16:30:46.560' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (88, 1142, N'b216eb1c-a34d-4ad0-9cad-92f85a25481c', CAST(N'2015-12-09 16:31:10.303' AS DateTime))
GO
INSERT [dbo].[cmsContentVersion] ([id], [ContentId], [VersionId], [VersionDate]) VALUES (89, 1081, N'e6bdc063-4c8a-47ce-9e1d-d75c1f5cc417', CAST(N'2015-12-09 16:32:38.880' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[cmsContentVersion] OFF
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1081, N'<Home id="1081" key="d5bbd0a4-2ff3-40c6-a2e1-6055cd6533f2" parentID="-1" level="1" creatorID="0" sortOrder="0" createDate="2015-12-09T16:14:43" updateDate="2015-12-09T16:32:38" nodeName="Home" urlName="home" path="-1,1081" isDoc="" nodeType="1053" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1071" nodeTypeAlias="Home" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1092, N'<CategorySectionPage id="1092" key="8e298837-8fa8-43b5-a160-75f530bfc520" parentID="1081" level="2" creatorID="0" sortOrder="0" createDate="2015-12-09T16:21:33" updateDate="2015-12-09T16:21:33" nodeName="Hair" urlName="hair" path="-1,1081,1092" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1093, N'<HowToSubSectionPage id="1093" key="72baa200-98dd-4ca0-b6f1-8388bb5516c4" parentID="1092" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:21:43" updateDate="2015-12-09T16:21:43" nodeName="How-to" urlName="how-to" path="-1,1081,1092,1093" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1094, N'<GallerySubSectionPage id="1094" key="e92458c3-320a-40ae-9d0f-3e588fcda0ce" parentID="1092" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:21:54" updateDate="2015-12-09T16:21:54" nodeName="Gallery" urlName="gallery" path="-1,1081,1092,1094" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1095, N'<ArticleSubSectionPage id="1095" key="b9611d65-763e-4a7a-8b0c-29fbb15e60f2" parentID="1092" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:07" updateDate="2015-12-09T16:22:36" nodeName="Article" urlName="article" path="-1,1081,1092,1095" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1096, N'<ProductListingPage id="1096" key="9ad43271-23f8-4910-b266-d41d41a13d44" parentID="1092" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:22:20" updateDate="2015-12-09T16:22:20" nodeName="Product" urlName="product" path="-1,1081,1092,1096" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1097, N'<CategorySectionPage id="1097" key="ce143a6e-d5ba-400e-bbb0-5c2211cbc78a" parentID="1081" level="2" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:57" nodeName="Make-up" urlName="make-up" path="-1,1081,1097" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1098, N'<HowToSubSectionPage id="1098" key="cab8bc03-9a59-4131-9858-d7da4f381738" parentID="1097" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:04" nodeName="How-to" urlName="how-to" path="-1,1081,1097,1098" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1099, N'<GallerySubSectionPage id="1099" key="40868dec-a50b-4219-a759-14ceddda1ecb" parentID="1097" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:06" nodeName="Gallery" urlName="gallery" path="-1,1081,1097,1099" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1100, N'<ArticleSubSectionPage id="1100" key="832f1cb7-3ec7-48ab-91c3-effa0d238ad7" parentID="1097" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:08" nodeName="Article" urlName="article" path="-1,1081,1097,1100" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1101, N'<ProductListingPage id="1101" key="f3a2bc9a-ba61-45e3-b113-cf8fc7425641" parentID="1097" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:09" nodeName="Product" urlName="product" path="-1,1081,1097,1101" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1102, N'<CategorySectionPage id="1102" key="c8263eac-dd9d-4b36-9707-44263333c340" parentID="1081" level="2" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:43" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1102" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1103, N'<HowToSubSectionPage id="1103" key="196feb81-fa87-48db-8d6c-a12f1ac557a4" parentID="1102" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:46" nodeName="How-to" urlName="how-to" path="-1,1081,1102,1103" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1104, N'<GallerySubSectionPage id="1104" key="cfe8d6e0-b9b8-4f8a-b951-e265f0dd4775" parentID="1102" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:48" nodeName="Gallery" urlName="gallery" path="-1,1081,1102,1104" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1105, N'<ArticleSubSectionPage id="1105" key="93b2e2d2-26d7-485a-9cbb-f8a1002c679f" parentID="1102" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:49" nodeName="Article" urlName="article" path="-1,1081,1102,1105" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1106, N'<ProductListingPage id="1106" key="877f0f4b-0dac-4857-9b36-123dcbca8c3e" parentID="1102" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:51" nodeName="Product" urlName="product" path="-1,1081,1102,1106" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1107, N'<CategorySectionPage id="1107" key="50e824b9-6152-446f-b4b5-20a8a98d817f" parentID="1081" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:24:32" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1107" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1108, N'<HowToSubSectionPage id="1108" key="12d33b49-f77a-4e3a-8bd9-6f9cbfb3b22f" parentID="1107" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:14" nodeName="How-to" urlName="how-to" path="-1,1081,1107,1108" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1109, N'<GallerySubSectionPage id="1109" key="cc4cc5b7-3394-4280-bf57-3ac2432645cb" parentID="1107" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:18" nodeName="Gallery" urlName="gallery" path="-1,1081,1107,1109" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1110, N'<ArticleSubSectionPage id="1110" key="cdbe6a8d-87b7-499a-93bc-00a160258aa5" parentID="1107" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:20" nodeName="Article" urlName="article" path="-1,1081,1107,1110" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1111, N'<ProductListingPage id="1111" key="8ac00ae5-c772-419d-9f3a-b46ca5934e31" parentID="1107" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:22" nodeName="Product" urlName="product" path="-1,1081,1107,1111" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1112, N'<CategorySectionPage id="1112" key="509626d8-9202-4a2b-9c73-1929ed51dfa2" parentID="1081" level="2" creatorID="0" sortOrder="4" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:50" nodeName="Face" urlName="face" path="-1,1081,1112" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1113, N'<HowToSubSectionPage id="1113" key="8a1e1784-60d9-43ce-8144-ede0952bdb87" parentID="1112" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:25" nodeName="How-to" urlName="how-to" path="-1,1081,1112,1113" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1114, N'<GallerySubSectionPage id="1114" key="e8b1063d-566e-4991-94c1-2735535ba4f6" parentID="1112" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:27" nodeName="Gallery" urlName="gallery" path="-1,1081,1112,1114" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1115, N'<ArticleSubSectionPage id="1115" key="0f7a81ce-eb88-4288-b6b8-fb3a0caa5a34" parentID="1112" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:28" nodeName="Article" urlName="article" path="-1,1081,1112,1115" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1116, N'<ProductListingPage id="1116" key="b2418050-4d3f-4bca-95f8-47735425eea5" parentID="1112" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:30" nodeName="Product" urlName="product" path="-1,1081,1112,1116" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1117, N'<CategorySectionPage id="1117" key="720c4d12-0048-4108-a924-f181f52d6d5f" parentID="1081" level="2" creatorID="0" sortOrder="5" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:08" nodeName="For Him" urlName="for-him" path="-1,1081,1117" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1118, N'<HowToSubSectionPage id="1118" key="f1b26b77-9907-4ebe-9887-6ec30e5ae912" parentID="1117" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:34" nodeName="How-to" urlName="how-to" path="-1,1081,1117,1118" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1119, N'<GallerySubSectionPage id="1119" key="c57e8d47-e1cd-4d60-9d21-d433f3bf1be3" parentID="1117" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:36" nodeName="Gallery" urlName="gallery" path="-1,1081,1117,1119" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1120, N'<ArticleSubSectionPage id="1120" key="52f046b2-c7d0-4bdc-83dd-ac56d121bf9d" parentID="1117" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:38" nodeName="Article" urlName="article" path="-1,1081,1117,1120" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1121, N'<ProductListingPage id="1121" key="c1c66a52-0c0b-4d92-bddb-be78b6950bb7" parentID="1117" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:25:01" updateDate="2015-12-09T16:25:40" nodeName="Product" urlName="product" path="-1,1081,1117,1121" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1122, N'<ContentSectionPage id="1122" key="aca7630d-e4ec-4e83-b718-39b76c0e4efe" parentID="1081" level="2" creatorID="0" sortOrder="6" createDate="2015-12-09T16:26:13" updateDate="2015-12-09T16:26:13" nodeName="How-to" urlName="how-to" path="-1,1081,1122" isDoc="" nodeType="1057" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1074" nodeTypeAlias="ContentSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1123, N'<ContentSubSectionPage id="1123" key="f2c83498-121d-41aa-b8ce-d19a6b9dfc06" parentID="1122" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:26:22" updateDate="2015-12-09T16:26:22" nodeName="Hair" urlName="hair" path="-1,1081,1122,1123" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1124, N'<ContentSubSectionPage id="1124" key="8b049680-20b1-4463-b21c-31cc7db4072e" parentID="1122" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:26:34" updateDate="2015-12-09T16:26:34" nodeName="Make-up" urlName="make-up" path="-1,1081,1122,1124" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1125, N'<ContentSubSectionPage id="1125" key="e8ef15f0-5c7d-4593-aa30-ca4a1b06832e" parentID="1122" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:26:47" updateDate="2015-12-09T16:26:47" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1122,1125" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1126, N'<ContentSubSectionPage id="1126" key="20d9a250-8c50-4454-9e95-3aa0fe47074d" parentID="1122" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:26:56" updateDate="2015-12-09T16:26:56" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1122,1126" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1127, N'<ContentSubSectionPage id="1127" key="683e4c4f-2544-4f74-b57a-6d982f82194b" parentID="1122" level="3" creatorID="0" sortOrder="4" createDate="2015-12-09T16:27:03" updateDate="2015-12-09T16:27:03" nodeName="Face" urlName="face" path="-1,1081,1122,1127" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1128, N'<ContentSubSectionPage id="1128" key="c9757dbc-8277-4d5b-9988-3d9448a6a571" parentID="1122" level="3" creatorID="0" sortOrder="5" createDate="2015-12-09T16:27:16" updateDate="2015-12-09T16:27:16" nodeName="For Him" urlName="for-him" path="-1,1081,1122,1128" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1129, N'<ContentSectionPage id="1129" key="194de80b-bf93-4ce9-9746-fa67a7d35a3a" parentID="1081" level="2" creatorID="0" sortOrder="7" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:00" nodeName="Insider" urlName="insider" path="-1,1081,1129" isDoc="" nodeType="1057" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1074" nodeTypeAlias="ContentSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1130, N'<ContentSubSectionPage id="1130" key="68f3b665-3f08-4dac-a336-29a060db8711" parentID="1129" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:04" nodeName="Hair" urlName="hair" path="-1,1081,1129,1130" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1131, N'<ContentSubSectionPage id="1131" key="9ae16fca-e9b9-4de5-9d29-73ab33272097" parentID="1129" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:06" nodeName="Make-up" urlName="make-up" path="-1,1081,1129,1131" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1132, N'<ContentSubSectionPage id="1132" key="fc53025b-0202-4550-bd27-9ac8d53c7350" parentID="1129" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:08" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1129,1132" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1133, N'<ContentSubSectionPage id="1133" key="4ac5b6e0-513d-43fc-80d2-309c372e80eb" parentID="1129" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:09" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1129,1133" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1134, N'<ContentSubSectionPage id="1134" key="0fb926fa-d9fe-4f48-a096-519683f01a62" parentID="1129" level="3" creatorID="0" sortOrder="4" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:11" nodeName="Face" urlName="face" path="-1,1081,1129,1134" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1135, N'<ContentSubSectionPage id="1135" key="0be1b907-2f50-43d1-9e9a-8d6e4bbc6cc1" parentID="1129" level="3" creatorID="0" sortOrder="5" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:13" nodeName="For Him" urlName="for-him" path="-1,1081,1129,1135" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1136, N'<Content id="1136" key="d0462c9e-c136-4ada-86e9-072a3a2d7b67" parentID="-1" level="1" creatorID="0" sortOrder="1" createDate="2015-12-09T16:29:23" updateDate="2015-12-09T16:29:23" nodeName="Content" urlName="content" path="-1,1136" isDoc="" nodeType="1060" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="Content" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1137, N'<ArticleContent id="1137" key="6f5a37ab-2d66-4760-a549-09bb8ea44aa6" parentID="1136" level="2" creatorID="0" sortOrder="0" createDate="2015-12-09T16:29:36" updateDate="2015-12-09T16:29:36" nodeName="Article Content" urlName="article-content" path="-1,1136,1137" isDoc="" nodeType="1059" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="ArticleContent" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1138, N'<HowToContent id="1138" key="873d3e6e-4730-4d9c-8159-94181ab6eb4f" parentID="1136" level="2" creatorID="0" sortOrder="1" createDate="2015-12-09T16:29:46" updateDate="2015-12-09T16:29:46" nodeName="How-to Content" urlName="how-to-content" path="-1,1136,1138" isDoc="" nodeType="1061" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="HowToContent" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1139, N'<GalleryContent id="1139" key="784c9387-af67-4d3a-aa57-5142850ef4da" parentID="1136" level="2" creatorID="0" sortOrder="2" createDate="2015-12-09T16:29:54" updateDate="2015-12-09T16:29:54" nodeName="Gallery Content" urlName="gallery-content" path="-1,1136,1139" isDoc="" nodeType="1062" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="GalleryContent" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1140, N'<TagLibrary id="1140" key="94691748-86b0-41c5-a04f-2597a697a494" parentID="1136" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:30:03" updateDate="2015-12-09T16:30:03" nodeName="Tag Library" urlName="tag-library" path="-1,1136,1140" isDoc="" nodeType="1063" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="TagLibrary" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1141, N'<ArticlePageLandscape id="1141" key="f8e764e4-2ef1-4656-a247-ccec6da6e277" parentID="1137" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:13" updateDate="2015-12-09T16:30:21" nodeName="Demo Article" urlName="demo-article" path="-1,1136,1137,1141" isDoc="" nodeType="1067" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1080" nodeTypeAlias="ArticlePageLandscape" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1142, N'<HowToPageLandscape id="1142" key="236ce569-7f70-49bd-8591-84d73ce570f5" parentID="1138" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:34" updateDate="2015-12-09T16:31:10" nodeName="Demo how to page" urlName="demo-how-to-page" path="-1,1136,1138,1142" isDoc="" nodeType="1066" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1078" nodeTypeAlias="HowToPageLandscape" />')
GO
INSERT [dbo].[cmsContentXml] ([nodeId], [xml]) VALUES (1143, N'<GalleryPage id="1143" key="38e211ef-7d6a-4a49-8af4-bf9f77b1bd01" parentID="1139" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:46" updateDate="2015-12-09T16:30:46" nodeName="Demo Gallery page" urlName="demo-gallery-page" path="-1,1136,1139,1143" isDoc="" nodeType="1068" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1079" nodeTypeAlias="GalleryPage" />')
GO
SET IDENTITY_INSERT [dbo].[cmsDataType] ON 

GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (-28, -97, N'Umbraco.ListView', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (-27, -96, N'Umbraco.ListView', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (-26, -95, N'Umbraco.ListView', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (1, -49, N'Umbraco.TrueFalse', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (2, -51, N'Umbraco.Integer', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (3, -87, N'Umbraco.TinyMCEv3', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (4, -88, N'Umbraco.Textbox', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (5, -89, N'Umbraco.TextboxMultiple', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (6, -90, N'Umbraco.UploadField', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (7, -92, N'Umbraco.NoEdit', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (8, -36, N'Umbraco.DateTime', N'Date')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (9, -37, N'Umbraco.ColorPickerAlias', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (10, -38, N'Umbraco.FolderBrowser', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (11, -39, N'Umbraco.DropDownMultiple', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (12, -40, N'Umbraco.RadioButtonList', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (13, -41, N'Umbraco.Date', N'Date')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (14, -42, N'Umbraco.DropDown', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (15, -43, N'Umbraco.CheckBoxList', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (16, 1034, N'Umbraco.ContentPickerAlias', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (17, 1035, N'Umbraco.MediaPicker', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (18, 1036, N'Umbraco.MemberPicker', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (21, 1040, N'Umbraco.RelatedLinks', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (22, 1041, N'Umbraco.Tags', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (24, 1043, N'Umbraco.ImageCropper', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (25, 1045, N'Umbraco.MultipleMediaPicker', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (26, 1046, N'Umbraco.MultiNodeTreePicker', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (27, 1047, N'Umbraco.RadioButtonList', N'Integer')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (28, 1048, N'Umbraco.DropDown', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (29, 1049, N'Imulus.Archetype', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (30, 1050, N'Umbraco.MultiNodeTreePicker', N'Nvarchar')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (31, 1051, N'Imulus.Archetype', N'Ntext')
GO
INSERT [dbo].[cmsDataType] ([pk], [nodeId], [propertyEditorAlias], [dbType]) VALUES (32, 1052, N'Umbraco.MultiNodeTreePicker', N'Nvarchar')
GO
SET IDENTITY_INSERT [dbo].[cmsDataType] OFF
GO
SET IDENTITY_INSERT [dbo].[cmsDataTypePreValues] ON 

GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (-4, -97, N'[{"alias":"email","isSystem":1},{"alias":"username","isSystem":1},{"alias":"updateDate","header":"Last edited","isSystem":1}]', 4, N'includeProperties')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (-3, -97, N'asc', 3, N'orderDirection')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (-2, -97, N'Name', 2, N'orderBy')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (-1, -97, N'10', 1, N'pageSize')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (3, -87, N',code,undo,redo,cut,copy,mcepasteword,stylepicker,bold,italic,bullist,numlist,outdent,indent,mcelink,unlink,mceinsertanchor,mceimage,umbracomacro,mceinserttable,umbracoembed,mcecharmap,|1|1,2,3,|0|500,400|1049,|true|', 0, N'')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (4, 1041, N'default', 0, N'group')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (5, 1045, N'1', 0, N'multiPicker')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (6, 1046, N'{
  "type": "content"
}', 1, N'startNode')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (7, 1046, NULL, 2, N'filter')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (8, 1046, NULL, 3, N'minNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (9, 1046, NULL, 4, N'maxNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (10, 1046, N'0', 5, N'showOpenButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (11, 1046, N'1', 6, N'showEditButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (12, 1046, N'0', 7, N'showPathOnHover')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (13, 1047, N'Manual Selection', 1, N'0')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (14, 1047, N'Select by Type', 2, N'1')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (15, 1047, N'Select by Tag', 3, N'2')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (16, 1048, N'How To', 1, N'0')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (17, 1048, N'Gallery', 2, N'1')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (18, 1048, N'Insider', 3, N'2')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (19, 1048, N'Product', 4, N'3')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (20, 1048, N'TV', 5, N'4')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (29, 1049, N'{
  "showAdvancedOptions": false,
  "startWithAddButton": false,
  "hideFieldsetToolbar": false,
  "enableMultipleFieldsets": false,
  "hideFieldsetControls": false,
  "hidePropertyLabel": false,
  "maxFieldsets": null,
  "enableCollapsing": true,
  "enableCloning": false,
  "enableDisabling": true,
  "enableDeepDatatypeRequests": false,
  "fieldsets": [
    {
      "alias": "magazineCarouselItem",
      "remove": false,
      "collapse": false,
      "labelTemplate": "",
      "icon": "",
      "label": "Magazine Carousel Item",
      "properties": [
        {
          "alias": "carouselItemTitle",
          "remove": false,
          "collapse": true,
          "label": "Carousel Item Title",
          "helpText": "",
          "dataTypeGuid": "0cc0eba1-9960-42c9-bf9b-60e150b429ae",
          "value": "",
          "required": true,
          "aliasIsDirty": true
        },
        {
          "alias": "carouselItemImage",
          "remove": false,
          "collapse": true,
          "label": "Carousel Item Image",
          "helpText": "",
          "dataTypeGuid": "7e3962cc-ce20-4ffc-b661-5897a894ba7e",
          "value": "",
          "required": true,
          "aliasIsDirty": true
        },
        {
          "alias": "carouselItemUrl",
          "remove": false,
          "collapse": true,
          "label": "Carousel Item Url",
          "helpText": "",
          "dataTypeGuid": "0cc0eba1-9960-42c9-bf9b-60e150b429ae",
          "value": "",
          "required": true,
          "aliasIsDirty": true
        },
        {
          "alias": "carouselItemDescription",
          "remove": false,
          "collapse": true,
          "label": "Carousel Item Description",
          "helpText": "",
          "dataTypeGuid": "c6bac0dd-4ab9-45b1-8e30-e4b619ee5da3",
          "value": "",
          "aliasIsDirty": true
        }
      ],
      "group": null,
      "aliasIsDirty": true
    }
  ],
  "fieldsetGroups": []
}', 1, N'archetypeConfig')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (30, 1049, NULL, 2, N'hideLabel')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (31, 1050, N'{
  "type": "content"
}', 1, N'startNode')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (32, 1050, NULL, 2, N'filter')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (33, 1050, N'3', 3, N'minNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (34, 1050, N'8', 4, N'maxNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (35, 1050, N'0', 5, N'showOpenButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (36, 1050, N'0', 6, N'showEditButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (37, 1050, N'0', 7, N'showPathOnHover')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (48, 1051, N'{
  "showAdvancedOptions": false,
  "startWithAddButton": false,
  "hideFieldsetToolbar": false,
  "enableMultipleFieldsets": false,
  "hideFieldsetControls": false,
  "hidePropertyLabel": false,
  "maxFieldsets": null,
  "enableCollapsing": true,
  "enableCloning": false,
  "enableDisabling": true,
  "enableDeepDatatypeRequests": false,
  "fieldsets": [
    {
      "alias": "flexibleContentPicker",
      "remove": false,
      "collapse": false,
      "labelTemplate": "",
      "icon": "",
      "label": "Flexible Content Picker",
      "properties": [
        {
          "alias": "selectPicker",
          "remove": false,
          "collapse": true,
          "label": "Select Picker",
          "helpText": "Must choose one of the content picker and select a relevant picker values below",
          "dataTypeGuid": "fcd011b4-50c0-4448-8b52-bf2f0f2e0036",
          "value": "",
          "required": true,
          "aliasIsDirty": true
        },
        {
          "alias": "manualSelection",
          "remove": false,
          "collapse": true,
          "label": "Manual Selection",
          "helpText": "Manual Picker: Select items from the node picker",
          "dataTypeGuid": "7b5665c7-fba4-444a-8402-b03dcdc21161",
          "value": "",
          "aliasIsDirty": true
        },
        {
          "alias": "selectByType",
          "remove": false,
          "collapse": true,
          "label": "Select by Type",
          "helpText": "Content Type picker: select relevant type to retrieve items associated with it",
          "dataTypeGuid": "8fe6579e-0802-4657-bf03-24f0ef8fdb46",
          "value": "",
          "aliasIsDirty": true
        },
        {
          "alias": "selectByTag",
          "remove": false,
          "collapse": true,
          "label": "Select by Tag",
          "helpText": "Type the tags to search for the documents.",
          "dataTypeGuid": "b6b73142-b9c1-4bf8-a16d-e1c23320b549",
          "value": "",
          "aliasIsDirty": true
        },
        {
          "alias": "minLimit",
          "remove": false,
          "collapse": true,
          "label": "Min Limit",
          "helpText": "",
          "dataTypeGuid": "2e6d3631-066e-44b8-aec4-96f09099b2b5",
          "value": "1",
          "aliasIsDirty": true
        },
        {
          "alias": "maxLimit",
          "remove": false,
          "collapse": false,
          "label": "Max Limit",
          "helpText": "",
          "dataTypeGuid": "2e6d3631-066e-44b8-aec4-96f09099b2b5",
          "value": "7"
        }
      ],
      "group": null,
      "aliasIsDirty": true
    }
  ],
  "fieldsetGroups": []
}', 1, N'archetypeConfig')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (49, 1051, NULL, 2, N'hideLabel')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (50, 1052, N'{
  "type": "content"
}', 1, N'startNode')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (51, 1052, NULL, 2, N'filter')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (52, 1052, N'6', 3, N'minNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (53, 1052, N'6', 4, N'maxNumber')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (54, 1052, N'0', 5, N'showOpenButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (55, 1052, N'1', 6, N'showEditButton')
GO
INSERT [dbo].[cmsDataTypePreValues] ([id], [datatypeNodeId], [value], [sortorder], [alias]) VALUES (56, 1052, N'0', 7, N'showPathOnHover')
GO
SET IDENTITY_INSERT [dbo].[cmsDataTypePreValues] OFF
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1133, 1, 0, N'812b7f15-bbfb-4b27-83d0-038577480c9c', N'Fragrance', NULL, NULL, CAST(N'2015-12-09 16:28:09.810' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1100, 1, 0, N'd1c89a45-ecc7-440c-b5e6-04baedd23ebf', N'Article', NULL, NULL, CAST(N'2015-12-09 16:23:08.133' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1137, 1, 0, N'0eda9b37-cfae-48c9-b39c-08a5761d724a', N'Article Content', NULL, NULL, CAST(N'2015-12-09 16:29:36.463' AS DateTime), NULL, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1119, 0, 0, N'6f8b6dd7-3949-4ca6-b977-0e051600f385', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:25:00.970' AS DateTime), 1087, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1130, 1, 0, N'517a9faf-caa5-4204-a273-0f4ce52f59f3', N'Hair', NULL, NULL, CAST(N'2015-12-09 16:28:04.817' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1110, 0, 0, N'8d71f9c3-5499-4692-a99a-122c4316652f', N'Article', NULL, NULL, CAST(N'2015-12-09 16:23:56.743' AS DateTime), 1086, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1134, 1, 0, N'5f462bdd-8e88-47a7-b1c5-16cb5d585a88', N'Face', NULL, NULL, CAST(N'2015-12-09 16:28:11.427' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1143, 1, 0, N'89eb14a6-afa8-4008-9319-19b0f7992588', N'Demo Gallery page', NULL, NULL, CAST(N'2015-12-09 16:30:46.560' AS DateTime), 1079, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1115, 0, 0, N'9ccc0261-7956-4c34-9510-19e49dc0d25d', N'Article', NULL, NULL, CAST(N'2015-12-09 16:24:25.540' AS DateTime), 1086, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1103, 0, 0, N'ab189718-031f-4c3c-bbdc-28119a94bc75', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:23:30.493' AS DateTime), 1085, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1126, 1, 0, N'a3084abc-30b2-4a3d-b1f5-316a04bf0bb9', N'Fragrance', NULL, NULL, CAST(N'2015-12-09 16:26:56.687' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1106, 1, 0, N'950a7709-b7dc-431f-bb1e-3427247b79fd', N'Product', NULL, NULL, CAST(N'2015-12-09 16:23:51.777' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1116, 0, 0, N'c9b08817-0fd9-4ce9-b593-34470d7feace', N'Product', NULL, NULL, CAST(N'2015-12-09 16:24:25.553' AS DateTime), 1088, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1136, 1, 0, N'936b347d-d293-4114-b223-372f027e2521', N'Content', NULL, NULL, CAST(N'2015-12-09 16:29:23.943' AS DateTime), NULL, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1109, 0, 0, N'223b4cc1-7906-4fad-88e9-3cd319731db5', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:23:56.733' AS DateTime), 1087, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1099, 1, 0, N'4411ffcb-cb30-47e1-a728-3ef1ac0ec7b1', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:23:06.150' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1133, 0, 0, N'c79b51da-3d51-45d7-a957-449d8601bef5', N'Fragrance', NULL, NULL, CAST(N'2015-12-09 16:27:51.107' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1117, 1, 0, N'4a62a16c-1350-4c7c-a083-454e6a04820f', N'For Him', NULL, NULL, CAST(N'2015-12-09 16:25:08.493' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1107, 1, 0, N'3e1336b4-19e8-41e1-bb2d-4800ff5c52e1', N'Fragrance', NULL, NULL, CAST(N'2015-12-09 16:24:32.603' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1102, 1, 0, N'f0c5424b-9b6a-4005-ad51-4af55d545fef', N'Body & Health', NULL, NULL, CAST(N'2015-12-09 16:23:43.143' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1094, 1, 0, N'a2608153-f3db-4203-826c-4e132d22222c', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:21:54.250' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1108, 0, 0, N'395aa6e1-387e-4d83-9e54-5381d93fc54f', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:23:56.720' AS DateTime), 1085, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1112, 1, 0, N'1f42d6cc-0db8-4f5c-acf7-53908721be43', N'Face', NULL, NULL, CAST(N'2015-12-09 16:24:50.150' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1097, 0, 0, N'3c0a3ee7-03da-4898-ae81-53f88b7811e7', N'Hair (1)', NULL, NULL, CAST(N'2015-12-09 16:22:45.823' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1105, 0, 0, N'12e8306a-3116-4910-984d-54cb6ec8afe1', N'Article', NULL, NULL, CAST(N'2015-12-09 16:23:30.533' AS DateTime), 1086, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1101, 1, 0, N'e7328b93-98c0-453b-95b3-56522a652277', N'Product', NULL, NULL, CAST(N'2015-12-09 16:23:09.977' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1119, 1, 0, N'34d427ec-cba6-46ee-b631-5bc3ffb05e8f', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:25:36.337' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1093, 1, 0, N'2a802e49-f5f7-4849-8f34-5fe45ffb029d', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:21:43.073' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1099, 0, 0, N'655b85aa-d32d-45dd-bf3d-64e2092aa96f', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:22:45.867' AS DateTime), 1087, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1121, 0, 0, N'01b9a553-f9a3-4063-8afa-66558ee0447f', N'Product', NULL, NULL, CAST(N'2015-12-09 16:25:01.007' AS DateTime), 1088, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1129, 0, 0, N'e51ab736-ed41-4621-9eb4-66824950b407', N'How-to (1)', NULL, NULL, CAST(N'2015-12-09 16:27:51.053' AS DateTime), 1074, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1097, 1, 0, N'5fcdcf4b-ab07-400b-b50a-67759c441abf', N'Make-up', NULL, NULL, CAST(N'2015-12-09 16:22:57.413' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1132, 0, 0, N'0f3b733b-0805-4c3a-b8b9-67c21e40d674', N'Body & Health', NULL, NULL, CAST(N'2015-12-09 16:27:51.093' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1103, 1, 0, N'9f700e94-efc5-46fa-bc92-70302204942a', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:23:46.473' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1142, 0, 0, N'9bbf94a6-934f-426d-8eb4-726ad273b9f4', N'Demo how to page', NULL, NULL, CAST(N'2015-12-09 16:30:34.367' AS DateTime), NULL, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1117, 0, 0, N'1dd259ec-3a48-4bf6-90f1-74aee24a4d13', N'Body & Health (1)', NULL, NULL, CAST(N'2015-12-09 16:25:00.947' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1098, 0, 0, N'4f846530-0c81-405c-bd4f-77ccbd3db6ce', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:22:45.857' AS DateTime), 1085, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1122, 1, 0, N'9eda020f-a4eb-4e4e-8064-7e8bf314a2c2', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:26:13.127' AS DateTime), 1074, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1128, 1, 0, N'a4330e7c-fbb0-487a-9742-7f3c9113e4bd', N'For Him', NULL, NULL, CAST(N'2015-12-09 16:27:16.590' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1124, 1, 0, N'cc485388-a6e8-468a-b0e6-7f73c2c70682', N'Make-up', NULL, NULL, CAST(N'2015-12-09 16:26:34.443' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1109, 1, 0, N'f5540734-1ccc-4a62-8e98-80abf383bf85', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:25:18.150' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1104, 1, 0, N'eae6e44b-f9ce-4686-8ea8-821b3893bedb', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:23:48.203' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1132, 1, 0, N'64b75058-7961-4860-abb9-8a01d5e363e0', N'Body & Health', NULL, NULL, CAST(N'2015-12-09 16:28:08.163' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1112, 0, 0, N'8ae5d928-a94b-480f-aa22-8a3b852be43e', N'Face (1)', NULL, NULL, CAST(N'2015-12-09 16:24:25.493' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1108, 1, 0, N'292140f8-3f3c-4cfe-9a99-8c077d3b1d5a', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:25:14.610' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1141, 1, 0, N'c22a958a-c265-47e9-8023-8ebda6f8c20a', N'Demo Article', NULL, NULL, CAST(N'2015-12-09 16:30:21.673' AS DateTime), 1080, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1113, 0, 0, N'7d91a149-bfe4-443c-b075-8f348923e002', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:24:25.513' AS DateTime), 1085, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1131, 0, 0, N'c530acbc-f8e7-4cc3-8f8d-92af857355a3', N'Make-up', NULL, NULL, CAST(N'2015-12-09 16:27:51.083' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1142, 1, 0, N'b216eb1c-a34d-4ad0-9cad-92f85a25481c', N'Demo how to page', NULL, NULL, CAST(N'2015-12-09 16:31:10.303' AS DateTime), 1078, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1140, 1, 0, N'8e6881a7-a3dd-44bf-ad38-9aed5c6f6c5c', N'Tag Library', NULL, NULL, CAST(N'2015-12-09 16:30:03.357' AS DateTime), NULL, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1101, 0, 0, N'3c56832d-2125-4be4-a571-9e438c754ec1', N'Product', NULL, NULL, CAST(N'2015-12-09 16:22:45.893' AS DateTime), 1088, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1120, 1, 0, N'622a2e28-4c5b-4866-a435-9f0ec680fae5', N'Article', NULL, NULL, CAST(N'2015-12-09 16:25:38.247' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1139, 1, 0, N'daefc1eb-95f5-48ea-a6f4-a03e6b58dde9', N'Gallery Content', NULL, NULL, CAST(N'2015-12-09 16:29:54.083' AS DateTime), NULL, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1104, 0, 0, N'0b3eecab-e0e2-4a9b-bf3b-a1df6f7c5265', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:23:30.500' AS DateTime), 1087, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1115, 1, 0, N'baddfc46-61d1-49a5-bc90-a1e309c9c8a5', N'Article', NULL, NULL, CAST(N'2015-12-09 16:25:28.777' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1114, 1, 0, N'1ca807ac-f87d-4505-8f20-a1e47719ff44', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:25:27.090' AS DateTime), 1087, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1111, 1, 0, N'442e4554-f7f0-48f7-b34c-a35ea0ecaf25', N'Product', NULL, NULL, CAST(N'2015-12-09 16:25:22.250' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1123, 1, 0, N'829b68e6-5935-44b2-86a5-a65eff400964', N'Hair', NULL, NULL, CAST(N'2015-12-09 16:26:22.397' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1102, 0, 0, N'011e44c3-e00f-48a3-913a-aa1f6f603b70', N'Make-up (1)', NULL, NULL, CAST(N'2015-12-09 16:23:30.410' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1113, 1, 0, N'50b4dc44-c38a-4816-a119-b084e96292a1', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:25:25.243' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1129, 1, 0, N'ccd2d1a8-a57b-4908-8e02-b5f08f376859', N'Insider', NULL, NULL, CAST(N'2015-12-09 16:28:00.983' AS DateTime), 1074, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1106, 0, 0, N'78591e6f-179d-4930-9a90-b65756780003', N'Product', NULL, NULL, CAST(N'2015-12-09 16:23:30.540' AS DateTime), 1088, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1114, 0, 0, N'01a7dd28-abff-4154-8cf8-b87e593e5e73', N'Gallery', NULL, NULL, CAST(N'2015-12-09 16:24:25.530' AS DateTime), 1087, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1135, 1, 0, N'd3115a65-44c3-475d-ad7b-ba61fe689245', N'For Him', NULL, NULL, CAST(N'2015-12-09 16:28:13.253' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1120, 0, 0, N'acda9e90-94d7-4ad9-9cb6-baf60100bbb1', N'Article', NULL, NULL, CAST(N'2015-12-09 16:25:00.997' AS DateTime), 1086, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1130, 0, 0, N'2ddf6d05-3f71-440c-b2e7-bb91a2e145fb', N'Hair', NULL, NULL, CAST(N'2015-12-09 16:27:51.070' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1111, 0, 0, N'1fd8a0c9-191d-4fc1-a326-bc940a769025', N'Product', NULL, NULL, CAST(N'2015-12-09 16:23:56.753' AS DateTime), 1088, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1105, 1, 0, N'06171021-7367-4fb4-803a-c56a972911b8', N'Article', NULL, NULL, CAST(N'2015-12-09 16:23:49.937' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1116, 1, 0, N'f5a5f3cc-0e8f-467e-8d2e-c5c0a2bd680f', N'Product', NULL, NULL, CAST(N'2015-12-09 16:25:30.687' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1100, 0, 0, N'453ca8b2-f39c-4f89-ba3b-c65d9e34823b', N'Article', NULL, NULL, CAST(N'2015-12-09 16:22:45.880' AS DateTime), 1086, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1125, 1, 0, N'7e5d6fc6-0931-49e0-b6f0-c70b1ef7f9a5', N'Body & Health', NULL, NULL, CAST(N'2015-12-09 16:26:47.887' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1095, 0, 0, N'7c727744-666d-4a03-bdf8-ca364b8f4758', N'Article', NULL, NULL, CAST(N'2015-12-09 16:22:07.247' AS DateTime), NULL, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1118, 1, 0, N'ef54b576-6b38-4166-b164-cdce1bcd59b3', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:25:34.243' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1110, 1, 0, N'7d04928f-317e-496b-8eec-cddebc1d98fc', N'Article', NULL, NULL, CAST(N'2015-12-09 16:25:20.303' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1118, 0, 0, N'ecaf95fb-7166-461d-9dc0-ce4977cffc15', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:25:00.963' AS DateTime), 1085, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1092, 1, 0, N'7a13c305-d7f3-48e0-b5e5-d2f847dd87b3', N'Hair', NULL, NULL, CAST(N'2015-12-09 16:21:33.380' AS DateTime), 1072, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1127, 1, 0, N'fed8da3c-b11b-4612-8518-d53cc73feacf', N'Face', NULL, NULL, CAST(N'2015-12-09 16:27:03.970' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1081, 1, 0, N'e6bdc063-4c8a-47ce-9e1d-d75c1f5cc417', N'Home', NULL, NULL, CAST(N'2015-12-09 16:32:38.880' AS DateTime), 1071, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1107, 0, 0, N'9f26ea94-2e0f-407c-8ea7-d7955d1a2cf7', N'Face', NULL, NULL, CAST(N'2015-12-09 16:24:17.207' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1095, 1, 0, N'776e3f76-07b6-4e8d-8a01-d8f71d209851', N'Article', NULL, NULL, CAST(N'2015-12-09 16:22:36.980' AS DateTime), 1086, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1081, 0, 0, N'8576e544-2349-4c1e-a5cd-dd69aea9e76e', N'Home', NULL, NULL, CAST(N'2015-12-09 16:14:43.727' AS DateTime), NULL, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1121, 1, 0, N'5522621f-ccd0-4d8c-9033-de60e5347295', N'Product', NULL, NULL, CAST(N'2015-12-09 16:25:40.937' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1131, 1, 0, N'1e070309-cc8f-4330-9d08-e5c9ee48ea0e', N'Make-up', NULL, NULL, CAST(N'2015-12-09 16:28:06.573' AS DateTime), 1073, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1138, 1, 0, N'69cbdb69-3829-4d34-9f93-ebe0d6c423b3', N'How-to Content', NULL, NULL, CAST(N'2015-12-09 16:29:46.123' AS DateTime), NULL, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1107, 0, 0, N'f141c529-d433-49a1-8137-ed5ea0515f32', N'Body & Health (1)', NULL, NULL, CAST(N'2015-12-09 16:23:56.703' AS DateTime), 1072, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1098, 1, 0, N'186f7f33-9000-4ba0-bf98-f1fac49c9efe', N'How-to', NULL, NULL, CAST(N'2015-12-09 16:23:04.370' AS DateTime), 1085, 1)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1135, 0, 0, N'f39ad2cc-7cbd-473b-a990-f308491efc8c', N'For Him', NULL, NULL, CAST(N'2015-12-09 16:27:51.127' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1134, 0, 0, N'a6b0b810-fe1b-485e-a8ab-fa661aaa5147', N'Face', NULL, NULL, CAST(N'2015-12-09 16:27:51.117' AS DateTime), 1073, 0)
GO
INSERT [dbo].[cmsDocument] ([nodeId], [published], [documentUser], [versionId], [text], [releaseDate], [expireDate], [updateDate], [templateId], [newest]) VALUES (1096, 1, 0, N'467a4111-5908-4918-b6d2-fd45d7098432', N'Product', NULL, NULL, CAST(N'2015-12-09 16:22:20.717' AS DateTime), 1088, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1053, 1071, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1054, 1070, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1055, 1072, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1056, 1085, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1057, 1074, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1058, 1073, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1065, 1077, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1066, 1078, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1067, 1080, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1068, 1079, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1082, 1087, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1083, 1086, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1084, 1088, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1090, 1091, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1144, 1145, 1)
GO
INSERT [dbo].[cmsDocumentType] ([contentTypeNodeId], [templateNodeId], [IsDefault]) VALUES (1146, 1147, 1)
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1081, N'e6bdc063-4c8a-47ce-9e1d-d75c1f5cc417', CAST(N'2015-12-09 16:32:38.883' AS DateTime), N'<Home id="1081" key="d5bbd0a4-2ff3-40c6-a2e1-6055cd6533f2" parentID="-1" level="1" creatorID="0" sortOrder="0" createDate="2015-12-09T16:14:43" updateDate="2015-12-09T16:32:38" nodeName="Home" urlName="home" path="-1,1081" isDoc="" nodeType="1053" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1071" nodeTypeAlias="Home" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1081, N'8576e544-2349-4c1e-a5cd-dd69aea9e76e', CAST(N'2015-12-09 16:14:43.747' AS DateTime), N'<Home id="1081" key="d5bbd0a4-2ff3-40c6-a2e1-6055cd6533f2" parentID="-1" level="1" creatorID="0" sortOrder="0" createDate="2015-12-09T16:14:43" updateDate="2015-12-09T16:14:43" nodeName="Home" urlName="home" path="-1,1081" isDoc="" nodeType="1053" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="Home" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1092, N'7a13c305-d7f3-48e0-b5e5-d2f847dd87b3', CAST(N'2015-12-09 16:21:33.383' AS DateTime), N'<CategorySectionPage id="1092" key="8e298837-8fa8-43b5-a160-75f530bfc520" parentID="1081" level="2" creatorID="0" sortOrder="0" createDate="2015-12-09T16:21:33" updateDate="2015-12-09T16:21:33" nodeName="Hair" urlName="hair" path="-1,1081,1092" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1093, N'2a802e49-f5f7-4849-8f34-5fe45ffb029d', CAST(N'2015-12-09 16:21:43.080' AS DateTime), N'<HowToSubSectionPage id="1093" key="72baa200-98dd-4ca0-b6f1-8388bb5516c4" parentID="1092" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:21:43" updateDate="2015-12-09T16:21:43" nodeName="How-to" urlName="how-to" path="-1,1081,1092,1093" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1094, N'a2608153-f3db-4203-826c-4e132d22222c', CAST(N'2015-12-09 16:21:54.257' AS DateTime), N'<GallerySubSectionPage id="1094" key="e92458c3-320a-40ae-9d0f-3e588fcda0ce" parentID="1092" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:21:54" updateDate="2015-12-09T16:21:54" nodeName="Gallery" urlName="gallery" path="-1,1081,1092,1094" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1095, N'7c727744-666d-4a03-bdf8-ca364b8f4758', CAST(N'2015-12-09 16:22:07.247' AS DateTime), N'<ArticleSubSectionPage id="1095" key="b9611d65-763e-4a7a-8b0c-29fbb15e60f2" parentID="1092" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:07" updateDate="2015-12-09T16:22:07" nodeName="Article" urlName="article" path="-1,1081,1092,1095" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1095, N'776e3f76-07b6-4e8d-8a01-d8f71d209851', CAST(N'2015-12-09 16:22:36.993' AS DateTime), N'<ArticleSubSectionPage id="1095" key="b9611d65-763e-4a7a-8b0c-29fbb15e60f2" parentID="1092" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:07" updateDate="2015-12-09T16:22:36" nodeName="Article" urlName="article" path="-1,1081,1092,1095" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1096, N'467a4111-5908-4918-b6d2-fd45d7098432', CAST(N'2015-12-09 16:22:20.720' AS DateTime), N'<ProductListingPage id="1096" key="9ad43271-23f8-4910-b266-d41d41a13d44" parentID="1092" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:22:20" updateDate="2015-12-09T16:22:20" nodeName="Product" urlName="product" path="-1,1081,1092,1096" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1097, N'3c0a3ee7-03da-4898-ae81-53f88b7811e7', CAST(N'2015-12-09 16:22:45.833' AS DateTime), N'<CategorySectionPage id="1097" key="ce143a6e-d5ba-400e-bbb0-5c2211cbc78a" parentID="1081" level="2" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:45" nodeName="Hair (1)" urlName="hair-1" path="-1,1081,1097" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1097, N'5fcdcf4b-ab07-400b-b50a-67759c441abf', CAST(N'2015-12-09 16:22:57.423' AS DateTime), N'<CategorySectionPage id="1097" key="ce143a6e-d5ba-400e-bbb0-5c2211cbc78a" parentID="1081" level="2" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:57" nodeName="Make-up" urlName="make-up" path="-1,1081,1097" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1098, N'4f846530-0c81-405c-bd4f-77ccbd3db6ce', CAST(N'2015-12-09 16:22:45.860' AS DateTime), N'<HowToSubSectionPage id="1098" key="cab8bc03-9a59-4131-9858-d7da4f381738" parentID="1097" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:45" nodeName="How-to" urlName="how-to" path="-1,1081,1097,1098" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1098, N'186f7f33-9000-4ba0-bf98-f1fac49c9efe', CAST(N'2015-12-09 16:23:04.380' AS DateTime), N'<HowToSubSectionPage id="1098" key="cab8bc03-9a59-4131-9858-d7da4f381738" parentID="1097" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:04" nodeName="How-to" urlName="how-to" path="-1,1081,1097,1098" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1099, N'4411ffcb-cb30-47e1-a728-3ef1ac0ec7b1', CAST(N'2015-12-09 16:23:06.157' AS DateTime), N'<GallerySubSectionPage id="1099" key="40868dec-a50b-4219-a759-14ceddda1ecb" parentID="1097" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:06" nodeName="Gallery" urlName="gallery" path="-1,1081,1097,1099" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1099, N'655b85aa-d32d-45dd-bf3d-64e2092aa96f', CAST(N'2015-12-09 16:22:45.873' AS DateTime), N'<GallerySubSectionPage id="1099" key="40868dec-a50b-4219-a759-14ceddda1ecb" parentID="1097" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:45" nodeName="Gallery" urlName="gallery" path="-1,1081,1097,1099" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1100, N'd1c89a45-ecc7-440c-b5e6-04baedd23ebf', CAST(N'2015-12-09 16:23:08.143' AS DateTime), N'<ArticleSubSectionPage id="1100" key="832f1cb7-3ec7-48ab-91c3-effa0d238ad7" parentID="1097" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:08" nodeName="Article" urlName="article" path="-1,1081,1097,1100" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1100, N'453ca8b2-f39c-4f89-ba3b-c65d9e34823b', CAST(N'2015-12-09 16:22:45.887' AS DateTime), N'<ArticleSubSectionPage id="1100" key="832f1cb7-3ec7-48ab-91c3-effa0d238ad7" parentID="1097" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:45" nodeName="Article" urlName="article" path="-1,1081,1097,1100" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1101, N'e7328b93-98c0-453b-95b3-56522a652277', CAST(N'2015-12-09 16:23:09.980' AS DateTime), N'<ProductListingPage id="1101" key="f3a2bc9a-ba61-45e3-b113-cf8fc7425641" parentID="1097" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:23:09" nodeName="Product" urlName="product" path="-1,1081,1097,1101" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1101, N'3c56832d-2125-4be4-a571-9e438c754ec1', CAST(N'2015-12-09 16:22:45.900' AS DateTime), N'<ProductListingPage id="1101" key="f3a2bc9a-ba61-45e3-b113-cf8fc7425641" parentID="1097" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:22:45" updateDate="2015-12-09T16:22:45" nodeName="Product" urlName="product" path="-1,1081,1097,1101" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1102, N'f0c5424b-9b6a-4005-ad51-4af55d545fef', CAST(N'2015-12-09 16:23:43.150' AS DateTime), N'<CategorySectionPage id="1102" key="c8263eac-dd9d-4b36-9707-44263333c340" parentID="1081" level="2" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:43" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1102" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1102, N'011e44c3-e00f-48a3-913a-aa1f6f603b70', CAST(N'2015-12-09 16:23:30.417' AS DateTime), N'<CategorySectionPage id="1102" key="c8263eac-dd9d-4b36-9707-44263333c340" parentID="1081" level="2" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:30" nodeName="Make-up (1)" urlName="make-up-1" path="-1,1081,1102" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1103, N'ab189718-031f-4c3c-bbdc-28119a94bc75', CAST(N'2015-12-09 16:23:30.497' AS DateTime), N'<HowToSubSectionPage id="1103" key="196feb81-fa87-48db-8d6c-a12f1ac557a4" parentID="1102" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:30" nodeName="How-to" urlName="how-to" path="-1,1081,1102,1103" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1103, N'9f700e94-efc5-46fa-bc92-70302204942a', CAST(N'2015-12-09 16:23:46.487' AS DateTime), N'<HowToSubSectionPage id="1103" key="196feb81-fa87-48db-8d6c-a12f1ac557a4" parentID="1102" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:46" nodeName="How-to" urlName="how-to" path="-1,1081,1102,1103" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1104, N'eae6e44b-f9ce-4686-8ea8-821b3893bedb', CAST(N'2015-12-09 16:23:48.217' AS DateTime), N'<GallerySubSectionPage id="1104" key="cfe8d6e0-b9b8-4f8a-b951-e265f0dd4775" parentID="1102" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:48" nodeName="Gallery" urlName="gallery" path="-1,1081,1102,1104" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1104, N'0b3eecab-e0e2-4a9b-bf3b-a1df6f7c5265', CAST(N'2015-12-09 16:23:30.507' AS DateTime), N'<GallerySubSectionPage id="1104" key="cfe8d6e0-b9b8-4f8a-b951-e265f0dd4775" parentID="1102" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:30" nodeName="Gallery" urlName="gallery" path="-1,1081,1102,1104" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1105, N'12e8306a-3116-4910-984d-54cb6ec8afe1', CAST(N'2015-12-09 16:23:30.537' AS DateTime), N'<ArticleSubSectionPage id="1105" key="93b2e2d2-26d7-485a-9cbb-f8a1002c679f" parentID="1102" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:30" nodeName="Article" urlName="article" path="-1,1081,1102,1105" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1105, N'06171021-7367-4fb4-803a-c56a972911b8', CAST(N'2015-12-09 16:23:49.947' AS DateTime), N'<ArticleSubSectionPage id="1105" key="93b2e2d2-26d7-485a-9cbb-f8a1002c679f" parentID="1102" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:49" nodeName="Article" urlName="article" path="-1,1081,1102,1105" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1106, N'950a7709-b7dc-431f-bb1e-3427247b79fd', CAST(N'2015-12-09 16:23:51.790' AS DateTime), N'<ProductListingPage id="1106" key="877f0f4b-0dac-4857-9b36-123dcbca8c3e" parentID="1102" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:51" nodeName="Product" urlName="product" path="-1,1081,1102,1106" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1106, N'78591e6f-179d-4930-9a90-b65756780003', CAST(N'2015-12-09 16:23:30.543' AS DateTime), N'<ProductListingPage id="1106" key="877f0f4b-0dac-4857-9b36-123dcbca8c3e" parentID="1102" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:30" updateDate="2015-12-09T16:23:30" nodeName="Product" urlName="product" path="-1,1081,1102,1106" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1107, N'3e1336b4-19e8-41e1-bb2d-4800ff5c52e1', CAST(N'2015-12-09 16:24:32.610' AS DateTime), N'<CategorySectionPage id="1107" key="50e824b9-6152-446f-b4b5-20a8a98d817f" parentID="1081" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:24:32" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1107" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1107, N'9f26ea94-2e0f-407c-8ea7-d7955d1a2cf7', CAST(N'2015-12-09 16:24:17.213' AS DateTime), N'<CategorySectionPage id="1107" key="50e824b9-6152-446f-b4b5-20a8a98d817f" parentID="1081" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:24:17" nodeName="Face" urlName="face" path="-1,1081,1107" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1107, N'f141c529-d433-49a1-8137-ed5ea0515f32', CAST(N'2015-12-09 16:23:56.713' AS DateTime), N'<CategorySectionPage id="1107" key="50e824b9-6152-446f-b4b5-20a8a98d817f" parentID="1081" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:23:56" nodeName="Body &amp; Health (1)" urlName="body-health-1" path="-1,1081,1107" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1108, N'395aa6e1-387e-4d83-9e54-5381d93fc54f', CAST(N'2015-12-09 16:23:56.727' AS DateTime), N'<HowToSubSectionPage id="1108" key="12d33b49-f77a-4e3a-8bd9-6f9cbfb3b22f" parentID="1107" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:23:56" nodeName="How-to" urlName="how-to" path="-1,1081,1107,1108" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1108, N'292140f8-3f3c-4cfe-9a99-8c077d3b1d5a', CAST(N'2015-12-09 16:25:14.613' AS DateTime), N'<HowToSubSectionPage id="1108" key="12d33b49-f77a-4e3a-8bd9-6f9cbfb3b22f" parentID="1107" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:14" nodeName="How-to" urlName="how-to" path="-1,1081,1107,1108" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1109, N'223b4cc1-7906-4fad-88e9-3cd319731db5', CAST(N'2015-12-09 16:23:56.737' AS DateTime), N'<GallerySubSectionPage id="1109" key="cc4cc5b7-3394-4280-bf57-3ac2432645cb" parentID="1107" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:23:56" nodeName="Gallery" urlName="gallery" path="-1,1081,1107,1109" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1109, N'f5540734-1ccc-4a62-8e98-80abf383bf85', CAST(N'2015-12-09 16:25:18.160' AS DateTime), N'<GallerySubSectionPage id="1109" key="cc4cc5b7-3394-4280-bf57-3ac2432645cb" parentID="1107" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:18" nodeName="Gallery" urlName="gallery" path="-1,1081,1107,1109" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1110, N'8d71f9c3-5499-4692-a99a-122c4316652f', CAST(N'2015-12-09 16:23:56.747' AS DateTime), N'<ArticleSubSectionPage id="1110" key="cdbe6a8d-87b7-499a-93bc-00a160258aa5" parentID="1107" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:23:56" nodeName="Article" urlName="article" path="-1,1081,1107,1110" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1110, N'7d04928f-317e-496b-8eec-cddebc1d98fc', CAST(N'2015-12-09 16:25:20.307' AS DateTime), N'<ArticleSubSectionPage id="1110" key="cdbe6a8d-87b7-499a-93bc-00a160258aa5" parentID="1107" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:20" nodeName="Article" urlName="article" path="-1,1081,1107,1110" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1111, N'442e4554-f7f0-48f7-b34c-a35ea0ecaf25', CAST(N'2015-12-09 16:25:22.263' AS DateTime), N'<ProductListingPage id="1111" key="8ac00ae5-c772-419d-9f3a-b46ca5934e31" parentID="1107" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:25:22" nodeName="Product" urlName="product" path="-1,1081,1107,1111" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1111, N'1fd8a0c9-191d-4fc1-a326-bc940a769025', CAST(N'2015-12-09 16:23:56.757' AS DateTime), N'<ProductListingPage id="1111" key="8ac00ae5-c772-419d-9f3a-b46ca5934e31" parentID="1107" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:23:56" updateDate="2015-12-09T16:23:56" nodeName="Product" urlName="product" path="-1,1081,1107,1111" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1112, N'1f42d6cc-0db8-4f5c-acf7-53908721be43', CAST(N'2015-12-09 16:24:50.153' AS DateTime), N'<CategorySectionPage id="1112" key="509626d8-9202-4a2b-9c73-1929ed51dfa2" parentID="1081" level="2" creatorID="0" sortOrder="4" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:50" nodeName="Face" urlName="face" path="-1,1081,1112" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1112, N'8ae5d928-a94b-480f-aa22-8a3b852be43e', CAST(N'2015-12-09 16:24:25.507' AS DateTime), N'<CategorySectionPage id="1112" key="509626d8-9202-4a2b-9c73-1929ed51dfa2" parentID="1081" level="2" creatorID="0" sortOrder="4" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:25" nodeName="Face (1)" urlName="face-1" path="-1,1081,1112" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1113, N'7d91a149-bfe4-443c-b075-8f348923e002', CAST(N'2015-12-09 16:24:25.520' AS DateTime), N'<HowToSubSectionPage id="1113" key="8a1e1784-60d9-43ce-8144-ede0952bdb87" parentID="1112" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:25" nodeName="How-to" urlName="how-to" path="-1,1081,1112,1113" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1113, N'50b4dc44-c38a-4816-a119-b084e96292a1', CAST(N'2015-12-09 16:25:25.257' AS DateTime), N'<HowToSubSectionPage id="1113" key="8a1e1784-60d9-43ce-8144-ede0952bdb87" parentID="1112" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:25" nodeName="How-to" urlName="how-to" path="-1,1081,1112,1113" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1114, N'1ca807ac-f87d-4505-8f20-a1e47719ff44', CAST(N'2015-12-09 16:25:27.100' AS DateTime), N'<GallerySubSectionPage id="1114" key="e8b1063d-566e-4991-94c1-2735535ba4f6" parentID="1112" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:27" nodeName="Gallery" urlName="gallery" path="-1,1081,1112,1114" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1114, N'01a7dd28-abff-4154-8cf8-b87e593e5e73', CAST(N'2015-12-09 16:24:25.533' AS DateTime), N'<GallerySubSectionPage id="1114" key="e8b1063d-566e-4991-94c1-2735535ba4f6" parentID="1112" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:25" nodeName="Gallery" urlName="gallery" path="-1,1081,1112,1114" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1115, N'9ccc0261-7956-4c34-9510-19e49dc0d25d', CAST(N'2015-12-09 16:24:25.547' AS DateTime), N'<ArticleSubSectionPage id="1115" key="0f7a81ce-eb88-4288-b6b8-fb3a0caa5a34" parentID="1112" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:25" nodeName="Article" urlName="article" path="-1,1081,1112,1115" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1115, N'baddfc46-61d1-49a5-bc90-a1e309c9c8a5', CAST(N'2015-12-09 16:25:28.790' AS DateTime), N'<ArticleSubSectionPage id="1115" key="0f7a81ce-eb88-4288-b6b8-fb3a0caa5a34" parentID="1112" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:28" nodeName="Article" urlName="article" path="-1,1081,1112,1115" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1116, N'c9b08817-0fd9-4ce9-b593-34470d7feace', CAST(N'2015-12-09 16:24:25.557' AS DateTime), N'<ProductListingPage id="1116" key="b2418050-4d3f-4bca-95f8-47735425eea5" parentID="1112" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:24:25" nodeName="Product" urlName="product" path="-1,1081,1112,1116" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1116, N'f5a5f3cc-0e8f-467e-8d2e-c5c0a2bd680f', CAST(N'2015-12-09 16:25:30.697' AS DateTime), N'<ProductListingPage id="1116" key="b2418050-4d3f-4bca-95f8-47735425eea5" parentID="1112" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:24:25" updateDate="2015-12-09T16:25:30" nodeName="Product" urlName="product" path="-1,1081,1112,1116" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1117, N'4a62a16c-1350-4c7c-a083-454e6a04820f', CAST(N'2015-12-09 16:25:08.503' AS DateTime), N'<CategorySectionPage id="1117" key="720c4d12-0048-4108-a924-f181f52d6d5f" parentID="1081" level="2" creatorID="0" sortOrder="5" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:08" nodeName="For Him" urlName="for-him" path="-1,1081,1117" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1117, N'1dd259ec-3a48-4bf6-90f1-74aee24a4d13', CAST(N'2015-12-09 16:25:00.957' AS DateTime), N'<CategorySectionPage id="1117" key="720c4d12-0048-4108-a924-f181f52d6d5f" parentID="1081" level="2" creatorID="0" sortOrder="5" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:00" nodeName="Body &amp; Health (1)" urlName="body-health-1" path="-1,1081,1117" isDoc="" nodeType="1055" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1072" nodeTypeAlias="CategorySectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1118, N'ef54b576-6b38-4166-b164-cdce1bcd59b3', CAST(N'2015-12-09 16:25:34.250' AS DateTime), N'<HowToSubSectionPage id="1118" key="f1b26b77-9907-4ebe-9887-6ec30e5ae912" parentID="1117" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:34" nodeName="How-to" urlName="how-to" path="-1,1081,1117,1118" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1118, N'ecaf95fb-7166-461d-9dc0-ce4977cffc15', CAST(N'2015-12-09 16:25:00.967' AS DateTime), N'<HowToSubSectionPage id="1118" key="f1b26b77-9907-4ebe-9887-6ec30e5ae912" parentID="1117" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:00" nodeName="How-to" urlName="how-to" path="-1,1081,1117,1118" isDoc="" nodeType="1056" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1085" nodeTypeAlias="HowToSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1119, N'6f8b6dd7-3949-4ca6-b977-0e051600f385', CAST(N'2015-12-09 16:25:00.990' AS DateTime), N'<GallerySubSectionPage id="1119" key="c57e8d47-e1cd-4d60-9d21-d433f3bf1be3" parentID="1117" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:00" nodeName="Gallery" urlName="gallery" path="-1,1081,1117,1119" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1119, N'34d427ec-cba6-46ee-b631-5bc3ffb05e8f', CAST(N'2015-12-09 16:25:36.343' AS DateTime), N'<GallerySubSectionPage id="1119" key="c57e8d47-e1cd-4d60-9d21-d433f3bf1be3" parentID="1117" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:36" nodeName="Gallery" urlName="gallery" path="-1,1081,1117,1119" isDoc="" nodeType="1082" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1087" nodeTypeAlias="GallerySubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1120, N'622a2e28-4c5b-4866-a435-9f0ec680fae5', CAST(N'2015-12-09 16:25:38.257' AS DateTime), N'<ArticleSubSectionPage id="1120" key="52f046b2-c7d0-4bdc-83dd-ac56d121bf9d" parentID="1117" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:38" nodeName="Article" urlName="article" path="-1,1081,1117,1120" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1120, N'acda9e90-94d7-4ad9-9cb6-baf60100bbb1', CAST(N'2015-12-09 16:25:01.000' AS DateTime), N'<ArticleSubSectionPage id="1120" key="52f046b2-c7d0-4bdc-83dd-ac56d121bf9d" parentID="1117" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:25:00" updateDate="2015-12-09T16:25:00" nodeName="Article" urlName="article" path="-1,1081,1117,1120" isDoc="" nodeType="1083" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1086" nodeTypeAlias="ArticleSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1121, N'01b9a553-f9a3-4063-8afa-66558ee0447f', CAST(N'2015-12-09 16:25:01.010' AS DateTime), N'<ProductListingPage id="1121" key="c1c66a52-0c0b-4d92-bddb-be78b6950bb7" parentID="1117" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:25:01" updateDate="2015-12-09T16:25:01" nodeName="Product" urlName="product" path="-1,1081,1117,1121" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1121, N'5522621f-ccd0-4d8c-9033-de60e5347295', CAST(N'2015-12-09 16:25:40.950' AS DateTime), N'<ProductListingPage id="1121" key="c1c66a52-0c0b-4d92-bddb-be78b6950bb7" parentID="1117" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:25:01" updateDate="2015-12-09T16:25:40" nodeName="Product" urlName="product" path="-1,1081,1117,1121" isDoc="" nodeType="1084" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1088" nodeTypeAlias="ProductListingPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1122, N'9eda020f-a4eb-4e4e-8064-7e8bf314a2c2', CAST(N'2015-12-09 16:26:13.133' AS DateTime), N'<ContentSectionPage id="1122" key="aca7630d-e4ec-4e83-b718-39b76c0e4efe" parentID="1081" level="2" creatorID="0" sortOrder="6" createDate="2015-12-09T16:26:13" updateDate="2015-12-09T16:26:13" nodeName="How-to" urlName="how-to" path="-1,1081,1122" isDoc="" nodeType="1057" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1074" nodeTypeAlias="ContentSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1123, N'829b68e6-5935-44b2-86a5-a65eff400964', CAST(N'2015-12-09 16:26:22.403' AS DateTime), N'<ContentSubSectionPage id="1123" key="f2c83498-121d-41aa-b8ce-d19a6b9dfc06" parentID="1122" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:26:22" updateDate="2015-12-09T16:26:22" nodeName="Hair" urlName="hair" path="-1,1081,1122,1123" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1124, N'cc485388-a6e8-468a-b0e6-7f73c2c70682', CAST(N'2015-12-09 16:26:34.447' AS DateTime), N'<ContentSubSectionPage id="1124" key="8b049680-20b1-4463-b21c-31cc7db4072e" parentID="1122" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:26:34" updateDate="2015-12-09T16:26:34" nodeName="Make-up" urlName="make-up" path="-1,1081,1122,1124" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1125, N'7e5d6fc6-0931-49e0-b6f0-c70b1ef7f9a5', CAST(N'2015-12-09 16:26:47.890' AS DateTime), N'<ContentSubSectionPage id="1125" key="e8ef15f0-5c7d-4593-aa30-ca4a1b06832e" parentID="1122" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:26:47" updateDate="2015-12-09T16:26:47" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1122,1125" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1126, N'a3084abc-30b2-4a3d-b1f5-316a04bf0bb9', CAST(N'2015-12-09 16:26:56.690' AS DateTime), N'<ContentSubSectionPage id="1126" key="20d9a250-8c50-4454-9e95-3aa0fe47074d" parentID="1122" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:26:56" updateDate="2015-12-09T16:26:56" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1122,1126" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1127, N'fed8da3c-b11b-4612-8518-d53cc73feacf', CAST(N'2015-12-09 16:27:03.973' AS DateTime), N'<ContentSubSectionPage id="1127" key="683e4c4f-2544-4f74-b57a-6d982f82194b" parentID="1122" level="3" creatorID="0" sortOrder="4" createDate="2015-12-09T16:27:03" updateDate="2015-12-09T16:27:03" nodeName="Face" urlName="face" path="-1,1081,1122,1127" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1128, N'a4330e7c-fbb0-487a-9742-7f3c9113e4bd', CAST(N'2015-12-09 16:27:16.593' AS DateTime), N'<ContentSubSectionPage id="1128" key="c9757dbc-8277-4d5b-9988-3d9448a6a571" parentID="1122" level="3" creatorID="0" sortOrder="5" createDate="2015-12-09T16:27:16" updateDate="2015-12-09T16:27:16" nodeName="For Him" urlName="for-him" path="-1,1081,1122,1128" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1129, N'e51ab736-ed41-4621-9eb4-66824950b407', CAST(N'2015-12-09 16:27:51.063' AS DateTime), N'<ContentSectionPage id="1129" key="194de80b-bf93-4ce9-9746-fa67a7d35a3a" parentID="1081" level="2" creatorID="0" sortOrder="7" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="How-to (1)" urlName="how-to-1" path="-1,1081,1129" isDoc="" nodeType="1057" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1074" nodeTypeAlias="ContentSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1129, N'ccd2d1a8-a57b-4908-8e02-b5f08f376859', CAST(N'2015-12-09 16:28:00.990' AS DateTime), N'<ContentSectionPage id="1129" key="194de80b-bf93-4ce9-9746-fa67a7d35a3a" parentID="1081" level="2" creatorID="0" sortOrder="7" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:00" nodeName="Insider" urlName="insider" path="-1,1081,1129" isDoc="" nodeType="1057" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1074" nodeTypeAlias="ContentSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1130, N'517a9faf-caa5-4204-a273-0f4ce52f59f3', CAST(N'2015-12-09 16:28:04.823' AS DateTime), N'<ContentSubSectionPage id="1130" key="68f3b665-3f08-4dac-a336-29a060db8711" parentID="1129" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:04" nodeName="Hair" urlName="hair" path="-1,1081,1129,1130" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1130, N'2ddf6d05-3f71-440c-b2e7-bb91a2e145fb', CAST(N'2015-12-09 16:27:51.077' AS DateTime), N'<ContentSubSectionPage id="1130" key="68f3b665-3f08-4dac-a336-29a060db8711" parentID="1129" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="Hair" urlName="hair" path="-1,1081,1129,1130" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1131, N'c530acbc-f8e7-4cc3-8f8d-92af857355a3', CAST(N'2015-12-09 16:27:51.087' AS DateTime), N'<ContentSubSectionPage id="1131" key="9ae16fca-e9b9-4de5-9d29-73ab33272097" parentID="1129" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="Make-up" urlName="make-up" path="-1,1081,1129,1131" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1131, N'1e070309-cc8f-4330-9d08-e5c9ee48ea0e', CAST(N'2015-12-09 16:28:06.590' AS DateTime), N'<ContentSubSectionPage id="1131" key="9ae16fca-e9b9-4de5-9d29-73ab33272097" parentID="1129" level="3" creatorID="0" sortOrder="1" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:06" nodeName="Make-up" urlName="make-up" path="-1,1081,1129,1131" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1132, N'0f3b733b-0805-4c3a-b8b9-67c21e40d674', CAST(N'2015-12-09 16:27:51.100' AS DateTime), N'<ContentSubSectionPage id="1132" key="fc53025b-0202-4550-bd27-9ac8d53c7350" parentID="1129" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1129,1132" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1132, N'64b75058-7961-4860-abb9-8a01d5e363e0', CAST(N'2015-12-09 16:28:08.177' AS DateTime), N'<ContentSubSectionPage id="1132" key="fc53025b-0202-4550-bd27-9ac8d53c7350" parentID="1129" level="3" creatorID="0" sortOrder="2" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:08" nodeName="Body &amp; Health" urlName="body-health" path="-1,1081,1129,1132" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1133, N'812b7f15-bbfb-4b27-83d0-038577480c9c', CAST(N'2015-12-09 16:28:09.820' AS DateTime), N'<ContentSubSectionPage id="1133" key="4ac5b6e0-513d-43fc-80d2-309c372e80eb" parentID="1129" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:09" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1129,1133" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1133, N'c79b51da-3d51-45d7-a957-449d8601bef5', CAST(N'2015-12-09 16:27:51.110' AS DateTime), N'<ContentSubSectionPage id="1133" key="4ac5b6e0-513d-43fc-80d2-309c372e80eb" parentID="1129" level="3" creatorID="0" sortOrder="3" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="Fragrance" urlName="fragrance" path="-1,1081,1129,1133" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1134, N'5f462bdd-8e88-47a7-b1c5-16cb5d585a88', CAST(N'2015-12-09 16:28:11.433' AS DateTime), N'<ContentSubSectionPage id="1134" key="0fb926fa-d9fe-4f48-a096-519683f01a62" parentID="1129" level="3" creatorID="0" sortOrder="4" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:11" nodeName="Face" urlName="face" path="-1,1081,1129,1134" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1134, N'a6b0b810-fe1b-485e-a8ab-fa661aaa5147', CAST(N'2015-12-09 16:27:51.123' AS DateTime), N'<ContentSubSectionPage id="1134" key="0fb926fa-d9fe-4f48-a096-519683f01a62" parentID="1129" level="3" creatorID="0" sortOrder="4" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="Face" urlName="face" path="-1,1081,1129,1134" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1135, N'd3115a65-44c3-475d-ad7b-ba61fe689245', CAST(N'2015-12-09 16:28:15.020' AS DateTime), N'<ContentSubSectionPage id="1135" key="0be1b907-2f50-43d1-9e9a-8d6e4bbc6cc1" parentID="1129" level="3" creatorID="0" sortOrder="5" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:28:13" nodeName="For Him" urlName="for-him" path="-1,1081,1129,1135" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1135, N'f39ad2cc-7cbd-473b-a990-f308491efc8c', CAST(N'2015-12-09 16:27:51.130' AS DateTime), N'<ContentSubSectionPage id="1135" key="0be1b907-2f50-43d1-9e9a-8d6e4bbc6cc1" parentID="1129" level="3" creatorID="0" sortOrder="5" createDate="2015-12-09T16:27:51" updateDate="2015-12-09T16:27:51" nodeName="For Him" urlName="for-him" path="-1,1081,1129,1135" isDoc="" nodeType="1058" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1073" nodeTypeAlias="ContentSubSectionPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1136, N'936b347d-d293-4114-b223-372f027e2521', CAST(N'2015-12-09 16:29:23.953' AS DateTime), N'<Content id="1136" key="d0462c9e-c136-4ada-86e9-072a3a2d7b67" parentID="-1" level="1" creatorID="0" sortOrder="1" createDate="2015-12-09T16:29:23" updateDate="2015-12-09T16:29:23" nodeName="Content" urlName="content" path="-1,1136" isDoc="" nodeType="1060" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="Content" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1137, N'0eda9b37-cfae-48c9-b39c-08a5761d724a', CAST(N'2015-12-09 16:29:36.470' AS DateTime), N'<ArticleContent id="1137" key="6f5a37ab-2d66-4760-a549-09bb8ea44aa6" parentID="1136" level="2" creatorID="0" sortOrder="0" createDate="2015-12-09T16:29:36" updateDate="2015-12-09T16:29:36" nodeName="Article Content" urlName="article-content" path="-1,1136,1137" isDoc="" nodeType="1059" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="ArticleContent" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1138, N'69cbdb69-3829-4d34-9f93-ebe0d6c423b3', CAST(N'2015-12-09 16:29:46.130' AS DateTime), N'<HowToContent id="1138" key="873d3e6e-4730-4d9c-8159-94181ab6eb4f" parentID="1136" level="2" creatorID="0" sortOrder="1" createDate="2015-12-09T16:29:46" updateDate="2015-12-09T16:29:46" nodeName="How-to Content" urlName="how-to-content" path="-1,1136,1138" isDoc="" nodeType="1061" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="HowToContent" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1139, N'daefc1eb-95f5-48ea-a6f4-a03e6b58dde9', CAST(N'2015-12-09 16:29:54.087' AS DateTime), N'<GalleryContent id="1139" key="784c9387-af67-4d3a-aa57-5142850ef4da" parentID="1136" level="2" creatorID="0" sortOrder="2" createDate="2015-12-09T16:29:54" updateDate="2015-12-09T16:29:54" nodeName="Gallery Content" urlName="gallery-content" path="-1,1136,1139" isDoc="" nodeType="1062" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="GalleryContent" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1140, N'8e6881a7-a3dd-44bf-ad38-9aed5c6f6c5c', CAST(N'2015-12-09 16:30:03.367' AS DateTime), N'<TagLibrary id="1140" key="94691748-86b0-41c5-a04f-2597a697a494" parentID="1136" level="2" creatorID="0" sortOrder="3" createDate="2015-12-09T16:30:03" updateDate="2015-12-09T16:30:03" nodeName="Tag Library" urlName="tag-library" path="-1,1136,1140" isDoc="" nodeType="1063" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="TagLibrary" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1141, N'c22a958a-c265-47e9-8023-8ebda6f8c20a', CAST(N'2015-12-09 16:30:21.687' AS DateTime), N'<ArticlePage id="1141" key="f8e764e4-2ef1-4656-a247-ccec6da6e277" parentID="1137" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:13" updateDate="2015-12-09T16:30:21" nodeName="Demo Article" urlName="demo-article" path="-1,1136,1137,1141" isDoc="" nodeType="1067" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1080" nodeTypeAlias="ArticlePage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1142, N'9bbf94a6-934f-426d-8eb4-726ad273b9f4', CAST(N'2015-12-09 16:30:34.373' AS DateTime), N'<HowToPage id="1142" key="236ce569-7f70-49bd-8591-84d73ce570f5" parentID="1138" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:34" updateDate="2015-12-09T16:30:34" nodeName="Demo how to page" urlName="demo-how-to-page" path="-1,1136,1138,1142" isDoc="" nodeType="1066" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="0" nodeTypeAlias="HowToPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1142, N'b216eb1c-a34d-4ad0-9cad-92f85a25481c', CAST(N'2015-12-09 16:31:10.310' AS DateTime), N'<HowToPage id="1142" key="236ce569-7f70-49bd-8591-84d73ce570f5" parentID="1138" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:34" updateDate="2015-12-09T16:31:10" nodeName="Demo how to page" urlName="demo-how-to-page" path="-1,1136,1138,1142" isDoc="" nodeType="1066" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1078" nodeTypeAlias="HowToPage" />')
GO
INSERT [dbo].[cmsPreviewXml] ([nodeId], [versionId], [timestamp], [xml]) VALUES (1143, N'89eb14a6-afa8-4008-9319-19b0f7992588', CAST(N'2015-12-09 16:30:46.563' AS DateTime), N'<GalleryPage id="1143" key="38e211ef-7d6a-4a49-8af4-bf9f77b1bd01" parentID="1139" level="3" creatorID="0" sortOrder="0" createDate="2015-12-09T16:30:46" updateDate="2015-12-09T16:30:46" nodeName="Demo Gallery page" urlName="demo-gallery-page" path="-1,1136,1139,1143" isDoc="" nodeType="1068" creatorName="Pacific Magazine" writerName="Pacific Magazine" writerID="0" template="1079" nodeTypeAlias="GalleryPage" />')
GO
SET IDENTITY_INSERT [dbo].[cmsPropertyType] ON 

GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (6, -90, 1032, 3, N'umbracoFile', N'Upload image', 0, 0, NULL, NULL, N'00000006-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (7, -92, 1032, 3, N'umbracoWidth', N'Width', 0, 0, NULL, NULL, N'00000007-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (8, -92, 1032, 3, N'umbracoHeight', N'Height', 0, 0, NULL, NULL, N'00000008-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (9, -92, 1032, 3, N'umbracoBytes', N'Size', 0, 0, NULL, NULL, N'00000009-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (10, -92, 1032, 3, N'umbracoExtension', N'Type', 0, 0, NULL, NULL, N'0000000a-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (24, -90, 1033, 4, N'umbracoFile', N'Upload file', 0, 0, NULL, NULL, N'00000018-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (25, -92, 1033, 4, N'umbracoExtension', N'Type', 0, 0, NULL, NULL, N'00000019-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (26, -92, 1033, 4, N'umbracoBytes', N'Size', 0, 0, NULL, NULL, N'0000001a-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (27, -38, 1031, 5, N'contents', N'Contents:', 0, 0, NULL, NULL, N'0000001b-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (28, -89, 1044, 11, N'umbracoMemberComments', N'Comments', 0, 0, NULL, NULL, N'0000001c-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (29, -92, 1044, 11, N'umbracoMemberFailedPasswordAttempts', N'Failed Password Attempts', 1, 0, NULL, NULL, N'0000001d-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (30, -49, 1044, 11, N'umbracoMemberApproved', N'Is Approved', 2, 0, NULL, NULL, N'0000001e-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (31, -49, 1044, 11, N'umbracoMemberLockedOut', N'Is Locked Out', 3, 0, NULL, NULL, N'0000001f-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (32, -92, 1044, 11, N'umbracoMemberLastLockoutDate', N'Last Lockout Date', 4, 0, NULL, NULL, N'00000020-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (33, -92, 1044, 11, N'umbracoMemberLastLogin', N'Last Login Date', 5, 0, NULL, NULL, N'00000021-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (34, -92, 1044, 11, N'umbracoMemberLastPasswordChangeDate', N'Last Password Change Date', 6, 0, NULL, NULL, N'00000022-0000-0000-0000-000000000000')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (35, -92, 1069, 12, N'standard', N'Standard', 0, 0, N'', N'', N'8fb7d9a9-2643-400c-bdba-902d5cfe9168')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (36, -88, 1069, 12, N'stitle', N's:title', 1, 0, N'', N'', N'edd79381-2f05-4d6e-bfc8-9fa8592b6f21')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (37, -88, 1069, 12, N'ogtitle', N'og:title', 2, 0, N'', N'', N'76ead6c5-7397-4e6a-a347-e1bbe5d37fbb')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (38, -88, 1069, 12, N'twitterdescription', N'twitter:description', 3, 0, N'', N'', N'a6f3d923-9fc4-4cc3-a81a-ca61624b2551')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (39, -88, 1069, 12, N'fbadmins', N'fb:admins', 4, 0, N'', N'', N'049df570-d700-4f20-a07d-71cc5be412f5')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (40, -88, 1069, 12, N'ogimage', N'og:image', 5, 0, N'', N'', N'a9db5aca-c7f2-455f-b776-669bce55b2b3')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (41, -88, 1069, 12, N'ogdescription', N'og:description', 6, 0, N'', N'', N'243dcdf2-1449-401d-97b4-0bd81990d340')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (42, -88, 1069, 12, N'twittercard', N'twitter:card', 7, 0, N'', N'', N'6a3ee947-1b3b-43f4-a2e5-f493378adfb5')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (43, -88, 1069, 12, N'twitterimage', N'twitter:image', 8, 0, N'', N'', N'7f72f67f-e9dd-4541-9ec4-3a5148697cee')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (44, -92, 1069, 12, N'fackbookopengraph', N'Fackbook&OpenGraph', 9, 0, N'', N'', N'66d21e63-2670-4938-9465-e3a0018cd0de')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (45, -88, 1069, 12, N'twittertitle', N'twitter:title', 10, 0, N'', N'', N'ba3ac392-6a97-47d4-a7d8-5af8fb3e9250')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (46, -88, 1069, 12, N'ogurl', N'og:url', 11, 0, N'', N'', N'2fafc3b0-cdaf-4131-a71c-13bac0a6c9d2')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (47, -88, 1069, 12, N'ogtype', N'og:type', 12, 0, N'', N'', N'ad4b4c2c-0db2-4b90-b927-4b7a881be752')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (48, -88, 1069, 12, N'sdescription', N's:description', 13, 0, N'', N'', N'7521802e-40bd-415b-96f0-628968b01efc')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (49, -92, 1069, 12, N'twitter', N'Twitter', 14, 0, N'', N'', N'702119c9-7e82-4018-bd14-4024bde4b355')
GO
INSERT [dbo].[cmsPropertyType] ([id], [dataTypeId], [contentTypeId], [propertyTypeGroupId], [Alias], [Name], [sortOrder], [mandatory], [validationRegExp], [Description], [UniqueID]) VALUES (50, -88, 1069, 12, N'twitterurl', N'twitter:url', 15, 0, N'', N'', N'4fb73ef5-1f27-4fb9-a0c9-62eb8437f7fb')
GO
SET IDENTITY_INSERT [dbo].[cmsPropertyType] OFF
GO
SET IDENTITY_INSERT [dbo].[cmsPropertyTypeGroup] ON 

GO
INSERT [dbo].[cmsPropertyTypeGroup] ([id], [parentGroupId], [contenttypeNodeId], [text], [sortorder]) VALUES (3, NULL, 1032, N'Image', 1)
GO
INSERT [dbo].[cmsPropertyTypeGroup] ([id], [parentGroupId], [contenttypeNodeId], [text], [sortorder]) VALUES (4, NULL, 1033, N'File', 1)
GO
INSERT [dbo].[cmsPropertyTypeGroup] ([id], [parentGroupId], [contenttypeNodeId], [text], [sortorder]) VALUES (5, NULL, 1031, N'Contents', 1)
GO
INSERT [dbo].[cmsPropertyTypeGroup] ([id], [parentGroupId], [contenttypeNodeId], [text], [sortorder]) VALUES (11, NULL, 1044, N'Membership', 1)
GO
INSERT [dbo].[cmsPropertyTypeGroup] ([id], [parentGroupId], [contenttypeNodeId], [text], [sortorder]) VALUES (12, NULL, 1069, N'Metadata Tab', 102)
GO
SET IDENTITY_INSERT [dbo].[cmsPropertyTypeGroup] OFF
GO
SET IDENTITY_INSERT [dbo].[cmsTaskType] ON 

GO
INSERT [dbo].[cmsTaskType] ([id], [alias]) VALUES (1, N'toTranslate')
GO
SET IDENTITY_INSERT [dbo].[cmsTaskType] OFF
GO
SET IDENTITY_INSERT [dbo].[cmsTemplate] ON 

GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (1, 1070, N'Master', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = null;
}

@RenderBody();')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (2, 1071, N'Home', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}

Hello World ')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (3, 1072, N'CategorySectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (4, 1073, N'ContentSubSectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (5, 1074, N'ContentSectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (8, 1077, N'FooterPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (9, 1078, N'HowToPageLandscape', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (10, 1079, N'GalleryPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (11, 1080, N'ArticlePageLandscape', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (12, 1085, N'HowToSubSectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (13, 1086, N'ArticleSubSectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (14, 1087, N'GallerySubSectionPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (15, 1088, N'ProductListingPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (16, 1091, N'ProductDetailsPage', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (17, 1145, N'ArticlePagePotrait', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
INSERT [dbo].[cmsTemplate] ([pk], [nodeId], [alias], [design]) VALUES (18, 1147, N'HowToPagePotrait', N'@inherits Umbraco.Web.Mvc.UmbracoTemplatePage
@{
    Layout = "Master.cshtml";
}')
GO
SET IDENTITY_INSERT [dbo].[cmsTemplate] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Address] ON 

GO
INSERT [dbo].[uCommerce_Address] ([AddressId], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CustomerId], [CompanyName], [AddressName], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber]) VALUES (46, N'Ny Banegårdsgade 55', N'', N'8000', N'Århus C', N'', 6, N'', 66, N'uCommerce', N'Billing', N'Lasse', N'Eskildsen', N'lasse.eskildsen@uCommerce.dk', N'61997779', N'')
GO
INSERT [dbo].[uCommerce_Address] ([AddressId], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CustomerId], [CompanyName], [AddressName], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber]) VALUES (47, N'Somewhere', N'', N'9000', N'Mytown', N'', 6, N'', 67, N'SomeCompany', N'Billing', N'Joe', N'Developer', N'', N'', N'')
GO
INSERT [dbo].[uCommerce_Address] ([AddressId], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CustomerId], [CompanyName], [AddressName], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber]) VALUES (48, N'kj', N'ælk', N'jælk', N'ælkj', N'', 6, N'ælkj', 68, N'jæl', N'Billing', N'ælkj', N'ælk', N'leskil99@gmail.com', N'', N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Address] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_AdminPage] ON 

GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (1, N'editproduct_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (2, N'editproductcataloggroup_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (3, N'editproductcatalog_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (4, N'editcategory_aspx', N'EditCategoryProducts.ascx')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (5, N'editorder_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (6, N'editproductdefinition_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (7, N'editproductdefinitionfield_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (8, N'editshippingmethod_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (9, N'editpaymentmethod_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (10, N'editemailprofile_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (11, N'editemailtype_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (12, N'editemailprofiletype_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (13, N'editpricegroup_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (14, N'editdatatype_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (15, N'editdatatypeenum_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (16, N'editvariantdescription_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (17, N'editcountry_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (18, N'editcurrency_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (19, N'editordernumberserie_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (20, N'viewordergroup_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (21, N'search_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (22, N'orderanalytics_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (23, N'productanalytics_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (24, N'editproductrelationtype_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (25, N'searchproduct_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (26, N'editdefinition_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (27, N'editdefinitionfield_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (28, N'editcampaign_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (29, N'editcampaignitem_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (30, N'edituseraccess_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (31, N'Error_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (32, N'searchsettings_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (33, N'EditDefinitionsOverview_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (34, N'editusergroupaccess_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (35, N'OrdersStartPage_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (36, N'StoresStartPage_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (37, N'MarketingStartPage_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (38, N'AnalyticsStartPage_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (39, N'SettingsStartPage_aspx', N'')
GO
INSERT [dbo].[uCommerce_AdminPage] ([AdminPageId], [FullName], [ActiveTab]) VALUES (40, N'StartPage_aspx', N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_AdminPage] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_AdminTab] ON 

GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (1, N'EditProductBaseProperties.ascx', 1, 1, 0, N'Common', 1, 1, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (3, N'EditProductVariants.ascx', 1, 2, 0, N'Variants', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (4, N'EditProductCatalogs.ascx', 1, 5, 0, N'Catalogs', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (6, N'EditProductDescription.ascx', 1, 8, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (7, N'EditProductCatalogGroup.ascx', 2, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (9, N'EditProductCatalogBaseProperties.ascx', 3, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (10, N'EditProductCatalogAccess.ascx', 3, 2, 0, N'Access', 1, 0, 0)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (11, N'EditProductCatalogDescription.ascx', 3, 3, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (12, N'EditCategoryBaseProperties.ascx', 4, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (13, N'EditCategoryMedia.ascx', 4, 2, 0, N'Media', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (14, N'EditCategoryDescription.ascx', 4, 4, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (15, N'EditCategoryProducts.ascx', 4, 3, 0, N'Products', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (16, N'EditProductMedia.ascx', 1, 4, 0, N'Media', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (17, N'EditProductPricing.ascx', 1, 3, 0, N'Pricing', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (18, N'EditOrderOverview.ascx', 5, 1, 0, N'Overview', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (19, N'EditOrderAudit.ascx', 5, 3, 0, N'Audit', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (21, N'EditProductDefinitionBaseProperties.ascx', 6, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (22, N'EditProductDefinitionFieldBaseProperties.ascx', 7, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (23, N'EditProductDefinitionFieldDescription.ascx', 7, 2, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (24, N'EditShippingMethodBaseProperties.ascx', 8, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (26, N'EditShippingMethodAvailability.ascx', 8, 2, 0, N'Availability', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (27, N'EditShippingMethodPrices.ascx', 8, 3, 0, N'Pricing', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (28, N'EditShippingMethodDescription.ascx', 8, 4, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (29, N'EditPaymentMethodBaseProperties.ascx', 9, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (30, N'EditPaymentMethodPricing.ascx', 9, 3, 0, N'Pricing', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (31, N'EditPaymentMethodAvailability.ascx', 9, 2, 0, N'Availability', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (32, N'EditPaymentMethodDescription.ascx', 9, 4, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (33, N'EditEmailProfileBaseProperties.ascx', 10, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (35, N'EditEmailTypeBaseProperties.ascx', 11, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (36, N'EditEmailTypeParameters.ascx', 11, 2, 0, N'Parameters', 1, 0, 0)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (37, N'EditEmailProfileContent.ascx', 12, 2, 1, N'Content', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (38, N'EditEmailProfileTypeInformation.ascx', 12, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (39, N'EditPriceGroupBaseProperties.ascx', 13, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (40, N'EditDataTypeBaseProperties.ascx', 14, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (41, N'EditDataTypeEnumBaseProperties.ascx', 15, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (42, N'EditDataTypeEnumDescription.ascx', 15, 2, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (43, N'../EditProductDescription.ascx', 16, 1, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (44, N'EditCountryBaseProperties.ascx', 17, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (45, N'EditCurrencyBaseProperties.ascx', 18, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (46, N'EditOrderNumberSerieBaseProperties.ascx', 19, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (47, N'ViewOrderGroupOrders.ascx', 20, 1, 0, N'Common', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (48, N'SearchOrders.ascx', 21, 1, 0, N'Common', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (49, N'SalesTotals.ascx', 22, 1, 0, N'SalesTotals', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (50, N'ProductTop10.ascx', 23, 1, 0, N'ProductTop10', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (51, N'EditOrderShipments.ascx', 5, 2, 0, N'Shipping', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (52, N'EditProductRelationTypeBaseProperties.ascx', 24, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (53, N'EditProductRelations.ascx', 1, 6, 0, N'Relations', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (54, N'SearchProducts.ascx', 25, 1, 0, N'Search', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (55, N'EditProductReview.ascx', 1, 7, 0, N'Reviews', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (56, N'EditProductReviewGroup.ascx', 2, 2, 0, N'PendingReviews', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (57, N'EditDefinitionBaseProperties.ascx', 26, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (58, N'EditDefinitionFieldDescription.ascx', 27, 2, 1, N'Description', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (59, N'EditDefinitionFieldBaseProperties.ascx', 27, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (60, N'EditCampaignOverview.ascx', 28, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (61, N'EditCampaignItemOverview.ascx', 29, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (62, N'EditCampaignItemAd.ascx', 29, 2, 0, N'Ad', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (63, N'EditCampaignItemMultilingualAd.ascx', 29, 3, 1, N'Ad', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (64, N'EditOrderDiscounts.ascx', 5, 1, 0, N'Discounts', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (65, N'EditUserRoles.ascx', 30, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (66, N'ErrorDescription.ascx', 31, 0, 0, N'Error', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (67, N'IndexFromScratch.ascx', 32, 1, 0, N'Common', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (68, N'EditOrderPayments.ascx', 5, 3, 0, N'Payments', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (69, N'EditDefinitionsOverview.ascx', 33, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (70, N'EditUserGroupRoles.ascx', 34, 1, 0, N'Common', 1, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (71, N'OrdersStartPageWidgets.ascx', 35, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (72, N'StoresStartPageWidgets.ascx', 36, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (73, N'MarketingStartPageWidgets.ascx', 37, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (74, N'AnalyticsStartPageWidgets.ascx', 38, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (75, N'SettingsStartPageWidgets.ascx', 39, 1, 0, N'Overview', 0, 0, 1)
GO
INSERT [dbo].[uCommerce_AdminTab] ([AdminTabId], [VirtualPath], [AdminPageId], [SortOrder], [MultiLingual], [ResouceKey], [HasSaveButton], [HasDeleteButton], [Enabled]) VALUES (76, N'StartPageWidgets.ascx', 40, 1, 0, N'Overview', 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_AdminTab] OFF
GO
INSERT [dbo].[uCommerce_AmountOffOrderTotalAward] ([AmountOffOrderTotalAwardId], [AmountOff]) VALUES (3, CAST(200.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[uCommerce_AmountOffOrderTotalAward] ([AmountOffOrderTotalAwardId], [AmountOff]) VALUES (4, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[uCommerce_AmountOffUnitAward] ([AmountOffUnitAwardId], [AmountOff]) VALUES (2, CAST(100.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[uCommerce_AmountOffUnitAward] ([AmountOffUnitAwardId], [AmountOff]) VALUES (5, CAST(100.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Award] ON 

GO
INSERT [dbo].[uCommerce_Award] ([AwardId], [CampaignItemId], [Name]) VALUES (2, 3, N'')
GO
INSERT [dbo].[uCommerce_Award] ([AwardId], [CampaignItemId], [Name]) VALUES (3, 4, N'')
GO
INSERT [dbo].[uCommerce_Award] ([AwardId], [CampaignItemId], [Name]) VALUES (4, 5, N'')
GO
INSERT [dbo].[uCommerce_Award] ([AwardId], [CampaignItemId], [Name]) VALUES (5, 6, N'')
GO
INSERT [dbo].[uCommerce_Award] ([AwardId], [CampaignItemId], [Name]) VALUES (6, 7, N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Award] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Campaign] ON 

GO
INSERT [dbo].[uCommerce_Campaign] ([CampaignId], [Name], [StartsOn], [EndsOn], [Enabled], [Priority], [Deleted], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (2, N'Default Campaign', CAST(N'2015-12-08 19:14:13.820' AS DateTime), CAST(N'2016-01-08 19:14:13.820' AS DateTime), 1, 1, 0, NULL, NULL, CAST(N'2015-12-08 19:14:13.820' AS DateTime), CAST(N'2015-12-08 19:14:13.820' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Campaign] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CampaignItem] ON 

GO
INSERT [dbo].[uCommerce_CampaignItem] ([CampaignItemId], [CampaignId], [DefinitionId], [Name], [Enabled], [Priority], [AllowNextCampaignItems], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn], [Deleted], [AnyTargetAppliesAwards], [AnyTargetAdvertises]) VALUES (3, 2, 2, N'Discounted unit price', 1, 1, 1, N'admin', N'admin', CAST(N'2015-12-09 19:14:13.823' AS DateTime), CAST(N'2015-12-09 19:14:13.823' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[uCommerce_CampaignItem] ([CampaignItemId], [CampaignId], [DefinitionId], [Name], [Enabled], [Priority], [AllowNextCampaignItems], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn], [Deleted], [AnyTargetAppliesAwards], [AnyTargetAdvertises]) VALUES (4, 2, 2, N'Bundle discount', 1, 2, 1, N'admin', N'admin', CAST(N'2015-12-09 19:14:13.823' AS DateTime), CAST(N'2015-12-09 19:14:13.823' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[uCommerce_CampaignItem] ([CampaignItemId], [CampaignId], [DefinitionId], [Name], [Enabled], [Priority], [AllowNextCampaignItems], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn], [Deleted], [AnyTargetAppliesAwards], [AnyTargetAdvertises]) VALUES (5, 2, 2, N'100€ voucher', 1, 3, 1, N'admin', N'admin', CAST(N'2015-12-09 19:14:13.823' AS DateTime), CAST(N'2015-12-09 19:14:13.823' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[uCommerce_CampaignItem] ([CampaignItemId], [CampaignId], [DefinitionId], [Name], [Enabled], [Priority], [AllowNextCampaignItems], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn], [Deleted], [AnyTargetAppliesAwards], [AnyTargetAdvertises]) VALUES (6, 2, 2, N'100€ voucher for specific product', 1, 4, 1, N'admin', N'admin', CAST(N'2015-12-09 19:14:13.823' AS DateTime), CAST(N'2015-12-09 19:14:13.823' AS DateTime), 0, 0, 1)
GO
INSERT [dbo].[uCommerce_CampaignItem] ([CampaignItemId], [CampaignId], [DefinitionId], [Name], [Enabled], [Priority], [AllowNextCampaignItems], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn], [Deleted], [AnyTargetAppliesAwards], [AnyTargetAdvertises]) VALUES (7, 2, 2, N'Free shipping for orders over 400€', 1, 5, 1, N'admin', N'admin', CAST(N'2015-12-09 19:14:13.823' AS DateTime), CAST(N'2015-12-09 19:14:13.823' AS DateTime), 0, 0, 1)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CampaignItem] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Category] ON 

GO
INSERT [dbo].[uCommerce_Category] ([CategoryId], [Name], [ImageMediaId], [DisplayOnSite], [CreatedOn], [ParentCategoryId], [ProductCatalogId], [ModifiedOn], [ModifiedBy], [Deleted], [SortOrder], [CreatedBy], [DefinitionId], [Guid]) VALUES (67, N'Software', NULL, 1, CAST(N'2009-08-30 14:49:15.400' AS DateTime), NULL, 23, CAST(N'2009-08-30 14:49:15.407' AS DateTime), N'uCommerce', 0, 0, NULL, 1, N'd6ab55d3-c2e4-4183-8f8d-fea8d53f8ff9')
GO
INSERT [dbo].[uCommerce_Category] ([CategoryId], [Name], [ImageMediaId], [DisplayOnSite], [CreatedOn], [ParentCategoryId], [ProductCatalogId], [ModifiedOn], [ModifiedBy], [Deleted], [SortOrder], [CreatedBy], [DefinitionId], [Guid]) VALUES (68, N'Support', NULL, 1, CAST(N'2009-08-30 14:49:41.187' AS DateTime), NULL, 23, CAST(N'2009-08-30 14:49:41.187' AS DateTime), N'uCommerce', 0, 0, NULL, 1, N'3c25b645-248f-4e59-b851-5a92c0325f93')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Category] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CategoryDescription] ON 

GO
INSERT [dbo].[uCommerce_CategoryDescription] ([CategoryDescriptionId], [CategoryId], [DisplayName], [Description], [CultureCode], [ContentId], [RenderAsContent]) VALUES (86, 67, N'Software', N'', N'en-US', NULL, 0)
GO
INSERT [dbo].[uCommerce_CategoryDescription] ([CategoryDescriptionId], [CategoryId], [DisplayName], [Description], [CultureCode], [ContentId], [RenderAsContent]) VALUES (87, 67, N'Software', N'', N'da-DK', NULL, 0)
GO
INSERT [dbo].[uCommerce_CategoryDescription] ([CategoryDescriptionId], [CategoryId], [DisplayName], [Description], [CultureCode], [ContentId], [RenderAsContent]) VALUES (88, 68, N'Support', N'', N'en-US', NULL, 0)
GO
INSERT [dbo].[uCommerce_CategoryDescription] ([CategoryDescriptionId], [CategoryId], [DisplayName], [Description], [CultureCode], [ContentId], [RenderAsContent]) VALUES (89, 68, N'Support', N'', N'da-DK', NULL, 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CategoryDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CategoryProductRelation] ON 

GO
INSERT [dbo].[uCommerce_CategoryProductRelation] ([CategoryProductRelationId], [ProductId], [CategoryId], [SortOrder]) VALUES (1, 97, 67, 0)
GO
INSERT [dbo].[uCommerce_CategoryProductRelation] ([CategoryProductRelationId], [ProductId], [CategoryId], [SortOrder]) VALUES (2, 101, 68, 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_CategoryProductRelation] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Country] ON 

GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (6, N'Denmark', N'da-DK', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (7, N'USA', N'en-US', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (8, N'United States', N'en-us', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (9, N'Great Britain', N'en-GB', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (10, N'United Kingdom', N'en-GB', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (11, N'Germany', N'de-DE', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (12, N'Sweden', N'sv-SE', 0)
GO
INSERT [dbo].[uCommerce_Country] ([CountryId], [Name], [Culture], [Deleted]) VALUES (13, N'Norway', N'nb-NO', 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Country] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Currency] ON 

GO
INSERT [dbo].[uCommerce_Currency] ([CurrencyId], [ISOCode], [ExchangeRate], [Deleted], [Guid]) VALUES (5, N'EUR', 100, 0, N'4f0d915b-fafe-4f47-8c95-6bb294422641')
GO
INSERT [dbo].[uCommerce_Currency] ([CurrencyId], [ISOCode], [ExchangeRate], [Deleted], [Guid]) VALUES (6, N'GBP', 88, 0, N'9d58216b-f689-4dfc-93e0-09b8bc212e21')
GO
INSERT [dbo].[uCommerce_Currency] ([CurrencyId], [ISOCode], [ExchangeRate], [Deleted], [Guid]) VALUES (7, N'USD', 143, 0, N'c6ddab0a-6ad5-4179-bc6a-f54cfeff4240')
GO
INSERT [dbo].[uCommerce_Currency] ([CurrencyId], [ISOCode], [ExchangeRate], [Deleted], [Guid]) VALUES (8, N'DKK', 744, 0, N'87338de2-56b0-460d-9d1f-2d3f620c31f1')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Currency] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Customer] ON 

GO
INSERT [dbo].[uCommerce_Customer] ([CustomerId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [MemberId]) VALUES (66, N'Lasse', N'Eskildsen', N'lasse.eskildsen@uCommerce.dk', N'61997779', N'', NULL)
GO
INSERT [dbo].[uCommerce_Customer] ([CustomerId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [MemberId]) VALUES (67, N'Joe', N'Developer', N'', N'', N'', N'1125')
GO
INSERT [dbo].[uCommerce_Customer] ([CustomerId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [MemberId]) VALUES (68, N'ælkj', N'ælk', N'leskil99@gmail.com', N'', N'', N'1122')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataType] ON 

GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'ShortText', 1, N'', 1, N'ShortText', 0, N'1a6acc5b-efa8-4f63-ae90-69bfb39f5b10', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'LongText', 1, N'', 1, N'LongText', 0, N'c1be2775-6768-48a2-8cb4-6817dc9fa4bf', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, N'Number', 1, N'^-?[0-9]+((\.|,)[0-9]{1,20})?$', 1, N'Number', 0, N'bfc4c1d2-8001-4b07-842b-b5288fead4a9', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (6, N'Boolean', 0, N'', 1, N'Boolean', 0, N'c1a4b1f5-8a59-4cd6-af0b-f291c1fce8da', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (8, N'Image', 1, N'', 1, N'Media', 0, N'cc5afbab-c56b-4f5c-a7d1-17f73fec150b', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (13, N'License', 0, N'', 0, N'Enum', 0, N'70d80767-3bd0-45f9-988c-fc418d54d7a2', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (14, N'SupportCoupons', 0, N'', 0, N'Enum', 0, N'18fe048c-8c34-4671-8408-eaa5a112c646', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (15, N'DatePicker', 1, N'', 1, N'Date', 0, N'e9086851-cfe4-40c9-a849-962ee6fe16de', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (16, N'RichText', 1, N'', 1, N'RichText', 0, N'1c7bc424-eccb-44aa-908f-0e0f792a132d', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (17, N'Content', 1, N'', 1, N'Content', 0, N'd5b2d6dd-0e3c-4d89-9c3a-3ac11329acf7', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (18, N'DateTimePicker', 1, N'', 1, N'DateTime', 0, N'7d22e987-a983-482c-95f7-6ee3528a2367', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_DataType] ([DataTypeId], [TypeName], [Nullable], [ValidationExpression], [BuiltIn], [DefinitionName], [Deleted], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (19, N'GlobalCollectPaymentProducts', 1, N'', 0, N'EnumMultiSelect', 1, N'1c12dc7d-24a1-4568-a12a-92f95b80d0d6', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataType] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataTypeEnum] ON 

GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (13, 13, N'Dev', 0, N'f735bd4c-eff9-4b95-94af-e040b70e2eec', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (14, 13, N'Eval', 0, N'a01fd04c-e210-4fbf-976d-46fc6dba7c60', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (15, 13, N'Live', 0, N'a1945744-aac8-48aa-8ab0-0b3c6198d4e8', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (16, 14, N'5', 0, N'ec36a611-493b-48eb-a333-a46d5ddea863', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (17, 14, N'10', 0, N'a4186e95-a04c-4902-8ca7-988dbfbfe6c7', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (18, 14, N'15', 0, N'c9be3957-92b1-4d95-b0bd-4effe01c6d99', 0)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (19, 19, N'2', 0, N'046a576d-e07a-40e7-98ab-c013a7ffdb10', 101)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (20, 19, N'134', 0, N'37d4174f-5a90-46fc-9fc4-a2c9b517c54e', 102)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (21, 19, N'140', 0, N'bb8be991-f274-453e-a6ac-aa124977a6a8', 103)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (22, 19, N'146', 0, N'555b73da-6734-498f-8868-6f9f89c9fa80', 104)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (23, 19, N'135', 0, N'14985cad-e4e3-4f52-a305-b7300987f99e', 105)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (24, 19, N'130', 0, N'3e397776-92a0-41f7-9e49-54dd7dcf8497', 106)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (25, 19, N'141', 0, N'21d2f64d-d6d5-46e0-ba67-b69a5411b755', 107)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (26, 19, N'123', 0, N'ca644d8f-2a7e-415c-aa73-ef523f54f0ff', 108)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (27, 19, N'132', 0, N'03bbc873-d9fe-4a96-90b7-18ea825ba3ba', 109)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (28, 19, N'128', 0, N'd73fd5d4-5578-427e-b49c-58eb4ed8039e', 110)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (29, 19, N'147', 0, N'9c55d1b4-eb73-40ef-804e-86257af70031', 111)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (30, 19, N'148', 0, N'71a48d20-86a3-4383-8cb4-006d3df57b54', 112)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (31, 19, N'139', 0, N'ea7a5db4-1c65-4e6a-a269-24b887f4e860', 113)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (32, 19, N'125', 0, N'c39613e6-2a76-49a4-b1de-e11933e899d6', 114)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (33, 19, N'124', 0, N'f77e366c-b893-4fc2-a023-5436f67f8036', 115)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (34, 19, N'117', 0, N'd3c9a666-de7c-4345-b7ea-faf882975a8d', 116)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (35, 19, N'142', 0, N'56533d0e-c263-4bf8-8f30-0c4f4ac40710', 117)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (36, 19, N'3', 0, N'fe66b8a5-0d97-4c2c-8ed9-0f826fbf763f', 118)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (37, 19, N'119', 0, N'67e6b8b5-798b-4fbb-aca8-7899b3beee74', 119)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (38, 19, N'136', 0, N'4abdce08-7e81-41e5-9e11-be255351deb7', 120)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (39, 19, N'145', 0, N'ae8e1050-fa0d-450d-84ac-cc502a3ad683', 121)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (40, 19, N'137', 0, N'4ee6c937-d7f6-45b7-b187-dac0c5b22aa9', 122)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (41, 19, N'144', 0, N'6fc75415-69f9-416f-a302-8e4b7ab0242c', 123)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (42, 19, N'149', 0, N'84741857-c384-4965-838b-138f8dcc7711', 124)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (43, 19, N'1', 0, N'7205a005-2021-46c8-8982-aad96c54660b', 125)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (44, 19, N'114', 0, N'802c7b67-633f-4496-aaf8-0bdbba249005', 126)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (45, 19, N'111', 0, N'05ab7670-5f5a-4760-997d-5fb8b9ca7fd5', 127)
GO
INSERT [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId], [DataTypeId], [Value], [Deleted], [Guid], [SortOrder]) VALUES (46, 19, N'122', 0, N'349b0454-9d32-46ce-82ad-d809522055fc', 128)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataTypeEnum] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataTypeEnumDescription] ON 

GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (26, 13, N'en-US', N'Developer', N'Developer license')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (27, 13, N'da-DK', N'Udvikler', N'Udvikler licens')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (28, 14, N'en-US', N'Evaluation', N'30-day evaluation')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (29, 14, N'da-DK', N'Evaluering', N'30-dages evaluering')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (30, 15, N'en-US', N'Go Live', N'License for live sites')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (31, 15, N'da-DK', N'Go Live', N'Til live websites')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (32, 16, N'en-US', N'5 coupons', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (33, 16, N'da-DK', N'5 klip', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (34, 17, N'en-US', N'10 Coupons', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (35, 17, N'da-DK', N'10 klip', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (36, 18, N'en-US', N'15 Coupons', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (37, 18, N'da-DK', N'15 klip', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (38, 19, N'en-US', N'American Express', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (39, 20, N'en-US', N'American Express Prepaid', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (40, 21, N'en-US', N'Argencard', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (41, 22, N'en-US', N'Aura', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (42, 23, N'en-US', N'Cabal', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (43, 24, N'en-US', N'Carte Bancaire', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (44, 25, N'en-US', N'Consumax', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (45, 26, N'en-US', N'Dankort', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (46, 27, N'en-US', N'Diners Club', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (47, 28, N'en-US', N'Discover', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (48, 29, N'en-US', N'ELO', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (49, 30, N'en-US', N'Hipercard', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (50, 31, N'en-US', N'Italcred', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (51, 32, N'en-US', N'JCB', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (52, 33, N'en-US', N'Laser', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (53, 34, N'en-US', N'Maestro', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (54, 35, N'en-US', N'Mas', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (55, 36, N'en-US', N'MasterCard', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (56, 37, N'en-US', N'MasterCard Debit', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (57, 38, N'en-US', N'Naranja', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (58, 39, N'en-US', N'Nativa', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (59, 40, N'en-US', N'Nevada', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (60, 41, N'en-US', N'Pyme Nacion', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (61, 42, N'en-US', N'Tarjeta Shopping', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (62, 43, N'en-US', N'Visa', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (63, 44, N'en-US', N'Visa Debit', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (64, 45, N'en-US', N'Visa Delta', N'')
GO
INSERT [dbo].[uCommerce_DataTypeEnumDescription] ([DataTypeEnumDescriptionId], [DataTypeEnumId], [CultureCode], [DisplayName], [Description]) VALUES (65, 46, N'en-US', N'Visa Electron', N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DataTypeEnumDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Definition] ON 

GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'Default Category Definition', 1, N'Default category definition', 0, 0, N'5b8a2997-16fd-47f1-a8bf-de79e96a943d', 0, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'Default Campaign Item', 3, N'Default campaign item', 0, 1, N'8a31939c-3d5e-4b59-b096-e159b97a4163', 0, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, N'Global Collect', 4, N'Configuration for Global Collect', 0, 0, N'7523dc62-640f-4006-a507-19451909e90b', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (4, N'Adyen', 4, N'Configuration for Adyen', 0, 0, N'c94644e4-f213-48a6-98eb-741aca16155f', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (5, N'Authorize.Net', 4, N'Configuration for Authorize.Net', 0, 0, N'12be466e-19c0-469c-b448-96394eac1060', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (6, N'Braintree Payments', 4, N'Configuration for Braintree Payments', 0, 0, N'884d451b-5bb5-4a35-8259-d2225f6e548d', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (7, N'DIBS', 4, N'Configuration for DIBS', 0, 0, N'34786d0a-9406-4922-af64-c6bfff8c8275', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (8, N'ePay', 4, N'Configuration for ePay', 0, 0, N'e2f5e714-3f04-405f-8bb7-6db53c1f4572', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (9, N'eWAY', 4, N'Configuration for eWAY', 0, 0, N'c94644e4-f213-48a6-98eb-741aca16155f', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (10, N'MultiSafepay', 4, N'Configuration for MultiSafepay', 0, 0, N'9007f882-38d8-4a8c-94bd-c25c80a8060b', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (11, N'Netaxept', 4, N'Configuration for Netaxept', 0, 0, N'9ef69c1a-b167-422a-90bb-8c011f6fec51', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (12, N'Ogone', 4, N'Configuration for Ogone', 0, 0, N'8a920308-15f1-48dc-a460-6d6cc21c194b', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (13, N'Payer', 4, N'Configuration for Payer', 0, 0, N'37b2c39e-1d64-41c0-a240-662e519acb4c', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (14, N'PayEx', 4, N'Configuration for PayEx', 0, 0, N'e549e6d5-2b8f-4ec8-ba85-3b52354efb39', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (15, N'PayPal Express', 4, N'Configuration for PayPal Express', 0, 0, N'd9c97ead-62a6-47c8-acef-1d3ae8b52deb', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (16, N'PayPal Subscriptions', 4, N'Configuration for PayPal Subscriptions', 0, 0, N'3b726615-12f7-4c5d-a0ba-23ad8b80e9f3', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (17, N'Quickpay', 4, N'Configuration for Quickpay', 0, 0, N'3ae8a622-8259-4b68-9171-1d8696a8f41a', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (18, N'Secure Trading', 4, N'Configuration for Secure Trading', 0, 0, N'445ddeff-81bc-4227-91f5-390ff75e3392', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (19, N'Ideal (Ing Bank)', 4, N'Configuration for Ideal (Ing Bank)', 0, 0, N'c94644e4-f213-48a6-98eb-741aca16155f', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (20, N'SagePay', 4, N'Configuration for SagePay', 0, 0, N'ff8f0349-dae8-431e-9492-84a28a61cc88', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (21, N'Schibsted', 4, N'Configuration for Schibsted', 0, 0, N'c94644e4-f213-48a6-98eb-741aca16155f', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (22, N'WorldPay', 4, N'Configuration for WorldPay', 0, 0, N'9ca9f168-e945-4eb0-b863-3e7fd44ff54f', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_Definition] ([DefinitionId], [Name], [DefinitionTypeId], [Description], [Deleted], [SortOrder], [Guid], [BuiltIn], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (23, N'SagePayV3', 4, N'Configuration for SagePayV3', 0, 0, N'65e69cb6-b82b-46ce-a9d8-298844c24c1a', 1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Definition] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DefinitionField] ON 

GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (1, 3, 3, N'MerchantId', 1, 0, 1, 0, 1, 0, 1, N'1', N'71d51424-f302-40c3-b19d-82af71e1997d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (2, 6, 3, N'Live', 1, 0, 1, 0, 1, 0, 1, N'false', N'53c378e1-1b0b-4152-901e-19cb1809c182')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (3, 1, 3, N'SecurityCheck', 1, 0, 1, 0, 1, 0, 1, N'IpCheck', N'76e9e439-f0bf-4aa5-95f9-b0e01d07cee6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (4, 3, 3, N'DefaultPaymentProductId', 1, 0, 1, 0, 1, 0, 1, N'123', N'b20c1eb7-98f5-4c55-a31e-eab3000f3154')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (5, 1, 3, N'DefaultCountry', 1, 0, 1, 0, 1, 0, 1, N'GB', N'c5dbb5c6-2c20-4aeb-a27d-6b4ffd429a2d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (6, 6, 3, N'InstantCapture', 1, 0, 1, 0, 1, 0, 1, N'false', N'df06456c-0d2c-43b8-845f-d4e0456e5391')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (7, 1, 3, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'ef11ce80-6d6f-40cf-b349-de034d17f754')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (8, 1, 3, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'/shop/checkout/orderconfirmation.aspx', N'd2d66c1b-d1f7-44ee-a602-b06ba1db1fe4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (9, 1, 3, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'/shop/checkout/cancel.aspx', N'4e9a07c3-0566-4147-b4ba-cfe3651333fb')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (10, 6, 4, N'Live', 1, 0, 1, 0, 1, 0, 1, N'false', N'ec33a971-5942-4884-bc1d-1300306eb6fb')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (11, 1, 4, N'FlowSelection', 1, 0, 1, 0, 1, 0, 1, N'OnePage', N'444cd73d-10fe-4ea8-8a99-3236ed875535')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (12, 1, 4, N'SkinCode', 1, 0, 1, 0, 1, 0, 1, N'Your skin code', N'f87f8dbe-a8bf-46e2-894e-b99a02ef6178')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (13, 1, 4, N'MerchantAccount', 1, 0, 1, 0, 1, 0, 1, N'merchantAccount', N'07df2d25-ef04-4d06-a4ac-daa81933cb55')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (14, 1, 4, N'AllowedMethods', 1, 0, 1, 0, 1, 0, 1, N'', N'a6505d26-eab6-4f56-87b3-05fcd4c8c1fd')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (15, 1, 4, N'BlockedMethods', 1, 0, 1, 0, 1, 0, 1, N'', N'2c122126-ea00-43ac-a2b6-5716b6a91eb3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (16, 1, 4, N'HmacSharedSecret', 1, 0, 1, 0, 1, 0, 1, N'HMAC Key (URL encoded)', N'3775270a-d643-4e9c-8a59-1ce4721e2afc')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (17, 3, 4, N'ShipBeforeDatePlusDays', 1, 0, 1, 0, 1, 0, 1, N'1', N'ed511dce-d016-40b0-b895-3f310e982df4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (18, 3, 4, N'ShipBeforeDatePlusHours', 1, 0, 1, 0, 1, 0, 1, N'0', N'4a1d67d2-4cf9-47e6-ae2b-9c45c49ac751')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (19, 3, 4, N'ShipBeforeDatePlusMinutes', 1, 0, 1, 0, 1, 0, 1, N'0', N'4d175cfa-d137-43f4-8471-1a6f6a6af861')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (20, 3, 4, N'SessionValidityPlusMinutes', 1, 0, 1, 0, 1, 0, 1, N'60', N'a992c97b-5df1-4970-b9a3-da9040c07c2f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (21, 3, 4, N'Offset', 1, 0, 1, 0, 1, 0, 1, N'0', N'79a09d7d-675e-4468-8b74-6063791eacf6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (22, 6, 4, N'OfferEmail', 1, 0, 1, 0, 1, 0, 1, N'false', N'2c2e9547-4b48-470a-a5a9-c3f5fdf91c27')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (23, 1, 4, N'BrandCode', 1, 0, 1, 0, 1, 0, 1, N'', N'eae005ec-4b3b-4956-a74e-d9373e46d9b1')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (24, 1, 4, N'ResultUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'9f4ea1d9-8590-4d2f-b53d-6dd5392ff8a3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (25, 1, 4, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.my-store.com/Cart/Confirmation.aspx', N'e23adff5-fb9f-4a57-82fd-c30aaa840643')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (26, 1, 4, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.my-store.com/Cart/Cancel.aspx', N'1d476310-cbac-409c-b471-1eb76f0d803f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (27, 1, 4, N'WebServiceUsername', 1, 0, 1, 0, 1, 0, 1, N'Web service username', N'0ded596b-5287-42dc-ae28-00916944abec')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (28, 1, 4, N'WebServicePassword', 1, 0, 1, 0, 1, 0, 1, N'Web service password', N'cdd950ff-241e-4479-a85c-78bc3677be9c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (29, 6, 4, N'UseRecurringContract', 1, 0, 1, 0, 1, 0, 1, N'false', N'0f1edbc9-9e2e-4fa7-8ef8-62e64ed6eb7a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (30, 6, 5, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'False', N'1c0b12ac-b418-41f8-a86c-03684fcf56f8')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (31, 1, 5, N'ApiLogin', 1, 0, 1, 0, 1, 0, 1, N'yourApiLogin', N'7dcb49be-d37f-4f46-a68f-3f201b6d1767')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (32, 1, 5, N'TransactionKey', 1, 0, 1, 0, 1, 0, 1, N'yourTransactionKey', N'c84122b5-676f-435a-a156-3e495b73edca')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (33, 1, 5, N'Md5Hash', 1, 0, 1, 0, 1, 0, 1, N'yourMd5Hash', N'fd7de2d7-e01a-4b63-9682-795476e0fb8a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (34, 1, 5, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'cba9a0e2-e6d2-42a2-b38c-74326847fc14')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (35, 1, 5, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://myonlinestore.com/shop.aspx', N'bab80871-825d-4e5a-8aca-d5c0d7fc978e')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (36, 1, 5, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://myonlinestore.com/shop.aspx', N'f2a0e6d9-65f8-4f87-9713-0a8712071d4a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (37, 1, 5, N'PayType', 1, 0, 1, 0, 1, 0, 1, N'CC', N'49f8fa41-790f-4bf6-b030-a2455225e8cd')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (38, 6, 5, N'SandboxMode', 1, 0, 1, 0, 1, 0, 1, N'True', N'e5dcf8aa-a34e-40ad-b0eb-96bc3481e086')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (39, 6, 5, N'InstantAcquire', 1, 0, 1, 0, 1, 0, 1, N'False', N'8c471c49-69fc-4dac-aacc-32535b356f59')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (40, 6, 5, N'ItemizeReceipt', 1, 0, 1, 0, 1, 0, 1, N'False', N'e23190f4-6db4-4350-8d44-c0cbec858fa4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (41, 1, 5, N'LogoUrl', 1, 0, 1, 0, 1, 0, 1, N'', N'c0fe879b-4340-419d-851e-964a33f20476')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (42, 6, 6, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'True', N'a3ca8625-f9db-417a-b8d2-813c3013218a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (43, 1, 6, N'MerchantId', 1, 0, 1, 0, 1, 0, 1, N'merchant Id', N'62d96950-d49e-46d7-96dd-3aa7e49b70b9')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (44, 1, 6, N'PublicKey', 1, 0, 1, 0, 1, 0, 1, N'public key', N'7735fa6f-59a7-44a0-88b7-05dc7dc33341')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (45, 1, 6, N'PrivateKey', 1, 0, 1, 0, 1, 0, 1, N'private key', N'f36eec38-80a5-4746-9cc3-4e4debb34d15')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (46, 1, 6, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'e0bef35d-fab0-4874-aad3-4f5bb9b6c083')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (47, 1, 6, N'PaymentFormUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'0f33115e-8889-4606-842f-192d18c49368')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (48, 1, 6, N'PaymentFormTemplate', 1, 0, 1, 0, 1, 0, 1, N'Example form available at \ucommerce\Configuration\Payments\BraintreePaymentForm.htm', N'd1b8c00d-1e90-43b5-9baf-648c7fd83b59')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (49, 1, 6, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://myonlinestore.com/accept.aspx', N'9cb90d3a-f581-40b1-8082-56f02dada9ca')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (50, 1, 6, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://myonlinestore.com/shop.aspx', N'5ae3f427-c4ca-4230-b5ec-175992dc70f6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (51, 6, 7, N'UseMd5', 1, 0, 1, 0, 1, 0, 1, N'True', N'e30f6e87-85ca-49d4-9af7-38333359e0d6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (52, 6, 7, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'false', N'1c70baf4-d9cd-4c19-a7a7-8bfde952b999')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (53, 1, 7, N'Merchant', 1, 0, 1, 0, 1, 0, 1, N'Merchant id as specifed by DIBS', N'40c39c75-6641-460d-a3e8-be0065ad1c84')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (54, 1, 7, N'Login', 1, 0, 1, 0, 1, 0, 1, N'apiuser', N'504dd222-35a9-42a6-8734-0e5d2484f569')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (55, 1, 7, N'Password', 1, 0, 1, 0, 1, 0, 1, N'apipassword', N'01bb9551-e746-4a4e-8820-97c3107c4001')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (56, 1, 7, N'Key1', 1, 0, 1, 0, 1, 0, 1, N'Key as configured in DIBS', N'41fb6f56-52b8-40a6-8edc-864e0c5b6cf1')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (57, 1, 7, N'Key2', 1, 0, 1, 0, 1, 0, 1, N'Key as configured in DIBS', N'd43a814c-e8a9-49a3-8a02-1e84a25183d2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (58, 1, 7, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'93b82b09-e680-4e23-9ba9-84f7b9a78916')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (59, 1, 7, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'96dc8efc-3416-44fb-ac7b-1f28cd16bf33')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (60, 1, 7, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'9c2c20fc-56b7-4c96-9e78-b0e99aa1505e')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (61, 1, 7, N'Decorator', 1, 0, 1, 0, 1, 0, 1, N'', N'bd15b782-4b8b-4e6d-8830-38c22ec45683')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (62, 6, 7, N'CalculateFee', 1, 0, 1, 0, 1, 0, 1, N'false', N'9bf61e5e-b308-49b0-b7bb-17d41db95332')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (63, 1, 7, N'PayType', 1, 0, 1, 0, 1, 0, 1, N'ALL_CARDS', N'e747902f-4a35-4a13-8051-cd425fd184d2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (64, 1, 8, N'Key', 1, 0, 1, 0, 1, 0, 1, N'MD5 key as configured in ePay', N'6417d9c2-bcd3-4ba3-a162-3a49c563abb2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (65, 1, 8, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'97880ee6-b44a-4ec3-9ce7-650a8f846ccc')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (66, 1, 8, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'0da316de-0e15-48b6-a77f-31b4d03e0704')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (67, 1, 8, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'659d580b-29d2-44b3-a75c-b1c798a40eda')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (68, 1, 8, N'Pwd', 1, 0, 1, 0, 1, 0, 1, N'API password', N'99c9ff7e-380a-4a14-92de-952d5c2f4ba0')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (69, 1, 8, N'MerchantNumber', 1, 0, 1, 0, 1, 0, 1, N'0', N'd1f2df18-d4c3-46bc-93bc-33b041f1660f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (70, 6, 8, N'InstantAcquire', 1, 0, 1, 0, 1, 0, 1, N'False', N'e7926abb-ff98-47d6-8332-dd494d0fdc00')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (71, 6, 8, N'OwnReceipt', 1, 0, 1, 0, 1, 0, 1, N'True', N'e5de0616-28d7-41ee-83d3-64daaf3aa6b3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (72, 6, 8, N'UseMd5', 1, 0, 1, 0, 1, 0, 1, N'True', N'108c442f-0d2d-48d7-83a4-3f3c78adfe2e')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (73, 6, 8, N'SplitPayment', 1, 0, 1, 0, 1, 0, 1, N'False', N'c772d989-e6a9-43cb-97a2-2948c673bb5f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (74, 1, 9, N'CustomerId', 1, 0, 1, 0, 1, 0, 1, N'Your Customer Id', N'2afa8930-6ee5-44e1-b4b1-a20d04e532e4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (75, 1, 9, N'UserName', 1, 0, 1, 0, 1, 0, 1, N'Your Username', N'9b5e326b-80c9-4c80-881f-6d319f949d08')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (76, 1, 9, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'46f66702-1cb0-4a61-a858-eef5517a83d3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (77, 1, 9, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?Cancel=true', N'fbf9af3d-d70e-4358-950e-a07718910258')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (78, 1, 9, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?Accept=true', N'630ff0af-0376-476b-bc52-12d32a8b2c1c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (79, 6, 10, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'True', N'7e026ba4-020e-4ced-883a-4246c1231240')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (80, 1, 10, N'AccountId', 1, 0, 1, 0, 1, 0, 1, N'yourAccountID', N'19adf69a-ebb9-4fb7-b1e9-69dd36657bc0')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (81, 1, 10, N'SiteId', 1, 0, 1, 0, 1, 0, 1, N'yourSiteID', N'1768105e-d281-43ff-847a-316bf8dbf7fd')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (82, 1, 10, N'SiteSecurityCode', 1, 0, 1, 0, 1, 0, 1, N'yourSiteSecureCode', N'1785ab01-94f4-4480-98c5-9efd5904735d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (83, 1, 10, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'6237037a-ae5a-4b5d-a2df-97f4194ec77c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (84, 1, 10, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/checkout/orderconfirmation.aspx', N'f9d5702f-0bd1-4c7c-9995-5b06f57bbcdc')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (85, 1, 10, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/checkout/cancel.aspx', N'46bf79d2-ec2f-44c2-b354-b81651525bc4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (86, 6, 11, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'True', N'82463a31-1734-4503-89ca-5373fd59c7f8')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (87, 1, 11, N'MerchantId', 1, 0, 1, 0, 1, 0, 1, N'Merchant ID as specified by Netaxept', N'21feca8a-60a1-46f6-8c65-d726550bb251')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (88, 1, 11, N'Password', 1, 0, 1, 0, 1, 0, 1, N'API password', N'd953d01a-3322-40dc-b216-e53aaefbc510')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (89, 1, 11, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'e6e0052a-296c-4e09-a5c7-eb21535c90ad')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (90, 1, 11, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/orderconfirmation.aspx', N'977bbf46-87d5-43be-aa4e-501ab399a213')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (91, 1, 11, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/cancel.aspx', N'f0dfac8f-abda-4104-b8df-71ea8b95c4f6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (92, 1, 11, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/decline.aspx', N'004fd167-0a2c-4896-b737-d1729cc7cdf1')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (93, 1, 11, N'AvailablePaymentOptions', 1, 0, 1, 0, 1, 0, 1, N'MasterCard,Visa,Dankort', N'654e75f3-bfd6-4f29-97f9-b1d6fc228c95')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (94, 6, 11, N'SinglePageView', 1, 0, 1, 0, 1, 0, 1, N'True', N'036e18e5-359d-4abb-a532-cdb9bc77c894')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (95, 6, 11, N'Force3DSecure', 1, 0, 1, 0, 1, 0, 1, N'False', N'cc328e3b-a12d-4a9f-9cb9-de72d8e63645')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (96, 1, 12, N'PspId', 1, 0, 1, 0, 1, 0, 1, N'yourPspId', N'abcd7238-13ac-4888-9e4b-73b84d2b2cb5')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (97, 1, 12, N'UserId', 1, 0, 1, 0, 1, 0, 1, N'yourUserId', N'da35266c-3744-4c2f-99fc-30ab05b9eb4a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (98, 1, 12, N'Password', 1, 0, 1, 0, 1, 0, 1, N'yoursecretpassword', N'b7eaccf9-98ad-4966-815a-c53b515365f6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (99, 1, 12, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'419d9425-bd81-415d-843a-845afd5158e3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (100, 1, 12, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/cancel.aspx', N'cb3b3e1d-872c-45b5-be69-7a771585e714')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (101, 1, 12, N'BackUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/preview.aspx', N'f10605d5-38b1-4c3d-b22f-a7d2ba3a02fa')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (102, 1, 12, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/decline.aspx', N'5508fa65-e64a-4e70-8812-25cf167ce06b')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (103, 1, 12, N'ExceptionUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/error.aspx', N'c06fbf89-c603-402e-9d76-47e64b3779ca')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (104, 1, 12, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'736ba649-1815-4d9d-8627-1c9e03c062c2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (105, 1, 12, N'ShaSignIn', 1, 0, 1, 0, 1, 0, 1, N'yourShaSignIn', N'21ad21a5-9a25-4056-aba7-a53e1e7da1ef')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (106, 1, 12, N'ShaSignOut', 1, 0, 1, 0, 1, 0, 1, N'yourShaSignOut', N'f0c508fc-4092-4bf0-9ca3-7e32070d6910')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (107, 6, 12, N'InstantAcquire', 1, 0, 1, 0, 1, 0, 1, N'false', N'a4b3bffb-8aed-4778-a2fc-40ae71532ccf')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (108, 6, 12, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'true', N'cfc7f7bc-f8f3-4942-83b2-1b1526395374')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (109, 1, 13, N'AgentId', 1, 0, 1, 0, 1, 0, 1, N'the agentId', N'351a7eb9-b031-4728-b3af-726536caa17f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (110, 1, 13, N'Key1', 1, 0, 1, 0, 1, 0, 1, N'key1 used for encryption', N'fd2e97d0-b86e-4cd1-b06d-7bdafb76a3a9')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (111, 1, 13, N'Key2', 1, 0, 1, 0, 1, 0, 1, N'key2 used for encryption', N'5e350082-72c5-405f-a7b6-fb5bc48c02da')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (112, 6, 13, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'True', N'69894a0c-8fe2-44ab-bc63-55a73bfa6e9d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (113, 1, 13, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'553ccb35-7d6e-472b-a64d-5e8c4838e09f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (114, 1, 13, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'e1c559bd-2493-4c89-b196-66bb06cf317a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (115, 1, 13, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'f8127836-5540-486d-9172-19a9273cd1e6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (116, 6, 14, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'false', N'9dc5febf-6da1-4cf5-8dbf-eabcd86903b9')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (117, 3, 14, N'AccountNumber', 1, 0, 1, 0, 1, 0, 1, N'1', N'109a84a4-ac3b-4c5e-a6e0-74a3b662f279')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (118, 1, 14, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'3442c514-bcfc-4d8b-ad8f-2139ceffb9f5')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (119, 1, 14, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'b506f532-e944-4bea-b4e3-bf0d4ccaa978')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (120, 1, 14, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'6f0c800e-b0e4-4618-ac39-c2d67be3ce28')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (121, 1, 14, N'Key', 1, 0, 1, 0, 1, 0, 1, N'Key used for encryption', N'88f135c7-d567-4c5a-a879-2821483289e3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (122, 1, 15, N'ApiUsername', 1, 0, 1, 0, 1, 0, 1, N'api username', N'6c219c3a-2de5-4508-b9a6-d575d25e37df')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (123, 1, 15, N'ApiPassword', 1, 0, 1, 0, 1, 0, 1, N'password', N'653c4e60-c429-475a-a044-bd87ae10f4e3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (124, 1, 15, N'ApiSignature', 1, 0, 1, 0, 1, 0, 1, N'the api signature', N'94e3ccfc-0810-4064-b90d-26fc65cdb7d6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (125, 6, 15, N'Sandbox', 1, 0, 1, 0, 1, 0, 1, N'True', N'1b452d40-5b17-4ddc-a08e-7c5ae6d16a1d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (126, 1, 15, N'NotifyUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'0a71a614-8714-4e09-8f88-ac4f7516a59e')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (127, 1, 15, N'PaymentAction', 1, 0, 1, 0, 1, 0, 1, N'Authorization', N'b29aeef8-40ac-49b7-9511-6238103df7f1')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (128, 1, 15, N'Return', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/orderconfirmation.aspx', N'a1962199-73eb-418a-b863-d5d2f0aaf8ab')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (129, 1, 15, N'CancelReturn', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/Cancel.aspx', N'a7608db4-f902-4868-bc83-fb3b28224f93')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (130, 1, 16, N'ApiUsername', 1, 0, 1, 0, 1, 0, 1, N'api username', N'fd39dfb1-cfd4-483d-aa98-c395b699c8c5')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (131, 1, 16, N'ApiPassword', 1, 0, 1, 0, 1, 0, 1, N'password', N'53827a70-10b8-4fb8-a317-e004f902c81d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (132, 1, 16, N'ApiSignature', 1, 0, 1, 0, 1, 0, 1, N'the api signature', N'a930e041-8f58-461b-bc0b-9a2e269b4d88')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (133, 6, 16, N'Sandbox', 1, 0, 1, 0, 1, 0, 1, N'True', N'154de85f-cc32-45a5-bd6e-4690e3bc8eda')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (134, 1, 16, N'ReturnMethod', 1, 0, 1, 0, 1, 0, 1, N'PostMethod', N'f111a18d-9775-4a6d-8caa-9d4ab6b3b02d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (135, 1, 16, N'Business', 1, 0, 1, 0, 1, 0, 1, N'Account as specified by PayPal', N'ba1c931a-b762-48c5-84da-67a7747e964f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (136, 1, 16, N'NotifyUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'20f1cbe6-cc01-4c39-a690-6dfe79de61f8')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (137, 1, 16, N'PaymentAction', 1, 0, 1, 0, 1, 0, 1, N'Authorization', N'cf0d9540-9039-4496-baac-55663985476b')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (138, 1, 16, N'PrivateCertificatePath', 1, 0, 1, 0, 1, 0, 1, N'~/UCommerce/Configuration/my_pkcs12.p12', N'212de3b7-f806-4cf4-81a8-5c5173b9d69d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (139, 1, 16, N'PublicPayPalCertificatePath', 1, 0, 1, 0, 1, 0, 1, N'~/UCommerce/Configuration/paypal_cert.pem', N'35d2d49d-96ae-474b-a2dd-734d8a33b196')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (140, 1, 16, N'PrivateCertificatePassword', 1, 0, 1, 0, 1, 0, 1, N'password', N'52402679-d088-4d2a-84d0-154bcc1445b6')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (141, 6, 16, N'UseEncryption', 1, 0, 1, 0, 1, 0, 1, N'True', N'3f725e94-86c4-4cfd-869c-5ab7c746828c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (142, 1, 16, N'Return', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/orderconfirmation.aspx', N'14ba84d7-0e77-46b0-9fcc-e17bd903d343')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (143, 1, 16, N'CancelReturn', 1, 0, 1, 0, 1, 0, 1, N'http://www.yoursite.com/shop/checkout/Cancel.aspx', N'83826e96-54d6-4aa7-9ca8-8c6953af0005')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (144, 6, 17, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'true', N'd808fa70-b980-4033-838d-2f70c9823b32')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (145, 6, 17, N'InstantAcquire', 1, 0, 1, 0, 1, 0, 1, N'false', N'3f6c888f-a766-403c-8a95-4d34024a8aa4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (146, 1, 17, N'ApiKey', 1, 0, 1, 0, 1, 0, 1, N'api key', N'243241f1-3eb9-4913-88a8-4bdd68149c48')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (147, 1, 17, N'Md5secret', 1, 0, 1, 0, 1, 0, 1, N'key used for encryption', N'3199ceb8-c490-414a-b6f7-c494c4150053')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (148, 1, 17, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'489fe4b3-5396-4f07-9af0-87766323e705')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (149, 1, 17, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Accept.aspx', N'62df77ee-0f82-47af-8c7d-995f35b5bb09')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (150, 1, 17, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'6257a6d3-3c44-45de-b2fd-b3fb24a04bee')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (151, 1, 17, N'Merchant', 1, 0, 1, 0, 1, 0, 1, N'12345678', N'bbb0dc42-23b8-4a36-8523-e5e1068208c8')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (152, 1, 18, N'Sitereference', 1, 0, 1, 0, 1, 0, 1, N'your unique secure trading site reference', N'0c8c6dcd-be88-4de8-a789-80f7f1e6bf8c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (153, 1, 18, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'myonlineshop.com/orderconfirmationPage', N'2d19da94-c888-42fd-b384-e97a16d47855')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (154, 1, 18, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'myonlineshop.com/declineUrl', N'c29a4aa6-1ac7-4fc9-8ce6-f73dbd58f674')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (155, 1, 18, N'Key', 1, 0, 1, 0, 1, 0, 1, N'your key used for md5 hash', N'e0d88962-f34f-4b70-891d-0b52341be6ae')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (156, 6, 18, N'InstantCapture', 1, 0, 1, 0, 1, 0, 1, N'True', N'96073542-f62f-4b01-8533-80babea4164d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (157, 1, 18, N'WebServiceAlias', 1, 0, 1, 0, 1, 0, 1, N'alias used for webservice', N'586eb847-ccfd-405a-b1ce-ed7d0ec1bf05')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (158, 1, 18, N'WebServicePassword', 1, 0, 1, 0, 1, 0, 1, N'http://myonlinestore.com/accept.aspx', N'b959b8a4-2aee-448f-89b2-ba3cdabd8a5c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (159, 1, 19, N'SubId', 1, 0, 1, 0, 1, 0, 1, N'0', N'e673a1ad-66bc-400e-86bb-6e4a18ee896f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (160, 1, 19, N'MerchantId', 1, 0, 1, 0, 1, 0, 1, N'Your Merchant Id', N'46c8323f-ba0a-45ad-8da7-a1b75d169a25')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (161, 1, 19, N'SecretKey', 1, 0, 1, 0, 1, 0, 1, N'Your Secret key', N'b5c7a616-6579-4110-b823-8aecc6daa95a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (162, 1, 19, N'Language', 1, 0, 1, 0, 1, 0, 1, N'nl', N'7bce8ca7-c36f-4275-a16b-23707ee0bd49')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (163, 6, 19, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'true', N'c30299e0-e7cb-4f85-922e-24c83a332900')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (164, 1, 19, N'ErrorUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?Error=true', N'0a040aab-ed8f-4e2a-a144-9d2257d3d035')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (165, 1, 19, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?Cancel=true', N'f767a0f3-205b-4964-9077-2ee8e51fb226')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (166, 1, 19, N'SuccessUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?Accept=true', N'9d110d95-2b08-4a1d-b00a-cfe2611d648b')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (167, 6, 20, N'Debug', 1, 0, 1, 0, 1, 0, 1, N'true', N'f6c84364-7682-43a3-9f36-e3664bfe5517')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (168, 1, 20, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'SIMULATOR', N'f8aa63ab-551c-4d80-86c1-d5ca40446d5c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (169, 1, 20, N'Vendor', 1, 0, 1, 0, 1, 0, 1, N'Vendor name', N'beb73b19-ac0b-4317-8ce2-6d44fd76b471')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (170, 1, 20, N'TxType', 1, 0, 1, 0, 1, 0, 1, N'AUTHENTICATE', N'3122bbc6-eafe-4e98-bad4-8189781b9537')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (171, 1, 20, N'SuccessUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/success.aspx', N'ec1e38fe-e075-48e2-84e9-ba187950e53d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (172, 1, 20, N'AbortUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/abort.aspx', N'ac71383b-96cc-44e3-80ad-75a64aa00036')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (173, 1, 20, N'FailureUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/failure.aspx', N'ce835b47-366b-4af4-b72a-4bf22e2fa695')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (174, 1, 20, N'NotificationUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'5ae9f132-4eda-4b7c-beaf-6474d23f3bf8')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (175, 1, 21, N'ClientId', 1, 0, 1, 0, 1, 0, 1, N'Your client id', N'3595f366-611b-49f5-8c1c-973246ae74b3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (176, 1, 21, N'ClientSecret', 1, 0, 1, 0, 1, 0, 1, N'Your client secret', N'62931c23-4893-4029-8957-f37b3dd4079f')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (177, 1, 21, N'SignatureSecret', 1, 0, 1, 0, 1, 0, 1, N'Your signature secret', N'2046a1c8-f15e-4e4a-8a46-6422e5235456')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (178, 1, 21, N'CallbackUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'd65ed94d-257e-4350-b670-c76d1a8f43a2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (179, 1, 21, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?accept=true', N'1c49c109-6196-41a3-94e3-a00797b93973')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (180, 1, 21, N'CancelUrl', 1, 0, 1, 0, 1, 0, 1, N'/cart/Confirmation.aspx?cancel=true', N'8f322e42-7a5d-4e1d-b976-0d43435d54a4')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (181, 6, 21, N'AutoCapture', 1, 0, 1, 0, 1, 0, 1, N'false', N'1981a8ad-b33e-45f6-a685-0699002f102d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (182, 1, 21, N'PaymentOptions', 1, 0, 1, 0, 1, 0, 1, N'2', N'd9938e56-e760-468d-b110-28502d84a7d2')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (183, 1, 21, N'Title', 1, 0, 1, 0, 1, 0, 1, N'Title', N'619a4c73-6498-4f72-83dc-de9a0ed45a33')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (184, 1, 21, N'IncludeOrderProperties', 1, 0, 1, 0, 1, 0, 1, N'clientItemReference', N'5fc971eb-b649-4a09-ac3d-0d8d7972f109')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (185, 6, 21, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'true', N'61a80c47-12b7-4ee8-ac7a-92fff8fd7677')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (186, 6, 22, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'False', N'60f1d853-d14c-4cbc-a2e7-e4af650adb07')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (187, 1, 22, N'InstId', 1, 0, 1, 0, 1, 0, 1, N'Installation Id', N'97417c54-da0a-431b-97c4-ae129236bf4a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (188, 1, 22, N'Callback', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'ec08d39d-9536-42ab-970b-d89c7048092c')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (189, 1, 22, N'CallbackPW', 1, 0, 1, 0, 1, 0, 1, N'callback password', N'cb975efa-4d0f-45ef-a61a-fb99afa9a689')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (190, 1, 22, N'RemoteInstId', 1, 0, 1, 0, 1, 0, 1, N'Remote Admin Installation Id', N'6b45a7d3-3639-45d0-94b4-edafed28bddc')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (191, 1, 22, N'AuthPW', 1, 0, 1, 0, 1, 0, 1, N'Remote admin password', N'8a11bdad-e9a0-4784-83ec-1b7fba787750')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (192, 6, 22, N'InstantCapture', 1, 0, 1, 0, 1, 0, 1, N'False', N'df79c56c-cd76-4f1b-93b3-d5b90c4c0528')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (193, 1, 22, N'Key', 1, 0, 1, 0, 1, 0, 1, N'custom key', N'532a4e75-f6fc-4bd5-a83e-c654d1a485e3')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (194, 1, 22, N'Signature', 1, 0, 1, 0, 1, 0, 1, N'custom key', N'fe10a68d-d112-4622-9220-5bcdb38e50a0')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (195, 1, 22, N'AcceptUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/orderconfirmation.aspx', N'ed893f3c-4e7e-4877-99bc-770a324c2f9a')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (196, 1, 22, N'DeclineUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'0355abb7-612e-4a62-9b7a-53744d30c165')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (197, 19, 3, N'Force3DSecureForThesePaymentProducts', 1, 0, 1, 0, 1, 0, 1, N'', N'3012a1cd-44ad-4945-af07-dcf732962c59')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (198, 6, 23, N'TestMode', 1, 0, 1, 0, 1, 0, 1, N'true', N'5f67f271-d503-4db1-8b37-1122d65ec202')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (199, 1, 23, N'Vendor', 1, 0, 1, 0, 1, 0, 1, N'MyVendorName', N'4cd5f6ef-0e03-4384-bd01-8944eaad3f9d')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (200, 1, 23, N'TxType', 1, 0, 1, 0, 1, 0, 1, N'AUTHENTICATE', N'ca55f78c-29c5-452b-91fa-2619ddfbfd00')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (201, 1, 23, N'SuccessUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Accept.aspx', N'10a0b61d-6151-4c3a-ac7e-2ac4b3b4beab')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (202, 1, 23, N'AbortUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'032dd2bf-6f97-47f5-ba1e-a09b235b8d7e')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (203, 1, 23, N'FailureUrl', 1, 0, 1, 0, 1, 0, 1, N'http://www.myonlinestore.com/shop/checkout/Cancel.aspx', N'660e5c9c-95dc-4c3a-a43c-f59b88108cf0')
GO
INSERT [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId], [DataTypeId], [DefinitionId], [Name], [DisplayOnSite], [Multilingual], [RenderInEditor], [Searchable], [SortOrder], [Deleted], [BuiltIn], [DefaultValue], [Guid]) VALUES (204, 1, 23, N'NotificationUrl', 1, 0, 1, 0, 1, 0, 1, N'(auto)', N'7caa2cdb-45e2-40b3-a671-93491b7054f3')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DefinitionField] OFF
GO
INSERT [dbo].[uCommerce_DefinitionType] ([DefinitionTypeId], [Name], [Deleted], [SortOrder]) VALUES (1, N'Category', 0, 0)
GO
INSERT [dbo].[uCommerce_DefinitionType] ([DefinitionTypeId], [Name], [Deleted], [SortOrder]) VALUES (3, N'CampaignItem', 0, 3)
GO
INSERT [dbo].[uCommerce_DefinitionType] ([DefinitionTypeId], [Name], [Deleted], [SortOrder]) VALUES (4, N'PaymentMethod', 0, 100)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DefinitionTypeDescription] ON 

GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (1, 1, N'Category Definitions', NULL, N'en-US')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (2, 1, N'Kategoridefinitioner', NULL, N'da-DK')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (3, 1, N'Kategoriedefinitionen', NULL, N'de-DE')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (4, 3, N'Campaign Item Definitions', NULL, N'en-US')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (5, 3, N'Kampagne aktivitet definitioner', NULL, N'da-DK')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (6, 3, N'Kampagne Aktivität Definitionen', NULL, N'de-DE')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (7, 4, N'Payment Method Definitions', NULL, N'en-US')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (8, 4, N'Betalingsmetode definitioner', NULL, N'da-DK')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (9, 4, N'Betalningsmetod definitioner', NULL, N'sv-SE')
GO
INSERT [dbo].[uCommerce_DefinitionTypeDescription] ([DefinitionTypeDescriptionId], [DefinitionTypeId], [DisplayName], [Description], [CultureCode]) VALUES (10, 4, N'Zahlungsmethode Definitionen', NULL, N'de-DE')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_DefinitionTypeDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailContent] ON 

GO
INSERT [dbo].[uCommerce_EmailContent] ([EmailContentId], [EmailProfileId], [EmailTypeId], [CultureCode], [Subject], [ContentId]) VALUES (7, 5, 4, N'en-US', N'Order Confirmation', N'1130')
GO
INSERT [dbo].[uCommerce_EmailContent] ([EmailContentId], [EmailProfileId], [EmailTypeId], [CultureCode], [Subject], [ContentId]) VALUES (8, 5, 4, N'da-DK', N'Ordrebekræftelse', N'1130')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailContent] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailParameter] ON 

GO
INSERT [dbo].[uCommerce_EmailParameter] ([EmailParameterId], [Name], [GlobalResourceKey], [QueryStringKey]) VALUES (1, N'Order ID', N'OrderIDParameter', N'OrderId')
GO
INSERT [dbo].[uCommerce_EmailParameter] ([EmailParameterId], [Name], [GlobalResourceKey], [QueryStringKey]) VALUES (2, N'Customer ID', N'CustomerIDParameter', N'CustomerId')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailParameter] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailProfile] ON 

GO
INSERT [dbo].[uCommerce_EmailProfile] ([EmailProfileId], [Name], [ModifiedOn], [ModifiedBy], [CreatedOn], [CreatedBy], [Deleted], [Guid]) VALUES (5, N'Default', CAST(N'2009-08-30 13:30:32.177' AS DateTime), N'uCommerce', CAST(N'2009-08-30 13:30:32.177' AS DateTime), N'uCommerce', 0, N'f0ae1550-207e-4f12-b052-f2c52fa5f966')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailProfile] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailProfileInformation] ON 

GO
INSERT [dbo].[uCommerce_EmailProfileInformation] ([EmailProfileInformationId], [EmailProfileId], [EmailTypeId], [FromName], [FromAddress], [CcAddress], [BccAddress]) VALUES (1, 5, 4, N'uCommerce Demo Shop', N'demo@uCommerce.dk', N'', N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailProfileInformation] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailType] ON 

GO
INSERT [dbo].[uCommerce_EmailType] ([EmailTypeId], [Name], [Description], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [Deleted]) VALUES (4, N'OrderConfirmation', N'E-mail which will be sent to the customer after checkout.', CAST(N'2009-08-30 13:25:05.257' AS DateTime), N'uCommerce', CAST(N'2009-08-30 13:25:05.260' AS DateTime), N'uCommerce', 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EmailType] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EntityUi] ON 

GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (1, N'UCommerce.EntitiesV2.VoucherTarget, UCommerce', N'Targets/VoucherUi.ascx', 5)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (2, N'UCommerce.EntitiesV2.AmountOffOrderTotalAward, UCommerce', N'Awards/AmountOffOrderTotalUi.ascx', 7)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (3, N'UCommerce.EntitiesV2.ProductTarget, UCommerce', N'Targets/ProductUi.ascx', 4)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (4, N'UCommerce.EntitiesV2.AmountOffOrderLinesAward, UCommerce', N'Awards/AmountOffOrderLinesUi.ascx', 8)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (5, N'UCommerce.EntitiesV2.OrderAmountTarget, UCommerce', N'Targets/OrderAmountUi.ascx', 6)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (6, N'UCommerce.EntitiesV2.AmountOffUnitAward, UCommerce', N'Awards/AmountOffUnitUi.ascx', 9)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (7, N'UCommerce.EntitiesV2.CategoryTarget, UCommerce', N'Targets/CategoryUi.ascx', 3)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (8, N'UCommerce.EntitiesV2.ProductCatalogTarget, UCommerce', N'Targets/ProductCatalogUi.ascx', 2)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (9, N'UCommerce.EntitiesV2.ProductCatalogGroupTarget, UCommerce', N'Targets/ProductCatalogGroupUi.ascx', 1)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (10, N'UCommerce.EntitiesV2.PercentOffOrderLinesAward, UCommerce', N'Awards/PercentOffOrderLinesUi.ascx', 10)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (12, N'UCommerce.EntitiesV2.PercentOffOrderTotalAward, UCommerce', N'Awards/PercentOffOrderTotalUi.ascx', 11)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (13, N'UCommerce.EntitiesV2.PercentOffShippingTotalAward, UCommerce', N'Awards/PercentOffShippingTotalUi.ascx', 12)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (14, N'UCommerce.EntitiesV2.QuantityTarget, UCommerce', N'Targets/QuantityUi.ascx', 7)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (15, N'UCommerce.EntitiesV2.DiscountSpecificOrderLineAward, UCommerce', N'Awards/DiscountSpecificOrderLineUi.ascx', 13)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (16, N'UCommerce.EntitiesV2.DynamicOrderPropertyTarget, UCommerce', N'Targets/DynamicOrderPropertyUi.ascx', 14)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (17, N'UCommerce.EntitiesV2.PriceGroupTarget, UCommerce', N'Targets/PriceGroupUi.ascx', 15)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (18, N'UCommerce.EntitiesV2.FreeGiftAward, UCommerce', N'Awards/FreeGiftAwardUi.ascx', 5)
GO
INSERT [dbo].[uCommerce_EntityUi] ([EntityUiId], [Type], [VirtualPathUi], [SortOrder]) VALUES (19, N'UCommerce.EntitiesV2.ShippingMethodsTarget, UCommerce', N'Targets/ShippingMethodsUi.ascx', 16)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EntityUi] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EntityUiDescription] ON 

GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (1, 1, N'Promocode', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (3, 1, N'Rabatkupon', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (4, 2, N'Amount off order total', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (5, 2, N'Rabat på hele ordren', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (6, 3, N'Products', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (7, 3, N'Produkter', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (8, 4, N'Amount off order line total', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (9, 4, N'Rabat på hele ordrelinien', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (10, 5, N'Buy for more than', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (11, 5, N'Køb samlet for mere end', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (18, 6, N'Amount off unit price', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (20, 6, N'Rabat på enhedsprisen', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (21, 7, N'Category', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (23, 7, N'Kategori', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (24, 8, N'Product catalog', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (26, 8, N'Produktkatalog', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (27, 9, N'Product catalog group', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (28, 9, N'Produktkatalog gruppe', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (30, 10, N'Percentage off order line', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (31, 10, N'Procentrabat på hele ordrelinie', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (33, 12, N'Percentage off order', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (34, 12, N'Procentrabat på hele ordren', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (37, 13, N'Procentrabat på levering', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (38, 13, N'Percentage off shipping total', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (39, 1, N'[Voucher]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (40, 2, N'[Amount off order total]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (41, 3, N'Produkts', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (42, 4, N'[Amount off order line total]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (43, 6, N'[Amount off unit price]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (44, 7, N'Kategorie', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (45, 8, N'[Produktkatalog]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (46, 9, N'Katalog-Gruppe', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (47, 10, N'[Percentage off order line]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (48, 12, N'[Percentage off order]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (49, 13, N'[Percentage off shipping total]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (50, 5, N'[Buy for more than]', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (51, 14, N'Buy more than', N'Buy a greater or equal quantity of a product', N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (52, 14, N'Køb flere end', N'Køb flere end eller det samme antal', N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (53, 14, N'Kaufen mehr als', N'Kaufen mehr als', N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (54, 14, N'Köpa mer än', N'Köpa mer än', N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (55, 15, N'Rabat på specifik ordrelinie', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (56, 15, N'Discount specific order line', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (57, 15, N'Rabatt-bezogene Auftragsposition', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (58, 15, N'Rabatt specifika orderrad', NULL, N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (59, 16, N'Dynamisk ordre egenskab', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (60, 16, N'Dynamic order property', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (61, 16, N'Dynamische Auftrag Eigenschaft', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (62, 16, N'Dynamisk order egendom', NULL, N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (63, 17, N'Price group', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (64, 17, N'Prisgrupp', NULL, N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (65, 17, N'Prisgruppe', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (66, 17, N'Preisgruppe', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (67, 18, N'Free gift', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (68, 18, N'Gratis gåva', NULL, N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (69, 18, N'Gratis gave', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (70, 18, N'Geschenk', NULL, N'de')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (71, 19, N'Shipping Methods', NULL, N'en')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (72, 19, N'Fraktmetoder', NULL, N'sv')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (73, 19, N'Leveringsmetoder', NULL, N'da')
GO
INSERT [dbo].[uCommerce_EntityUiDescription] ([EntityUiDescriptionId], [EntityUiId], [DisplayName], [Description], [CultureCode]) VALUES (74, 19, N'Lieferarten', NULL, N'de')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_EntityUiDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderAddress] ON 

GO
INSERT [dbo].[uCommerce_OrderAddress] ([OrderAddressId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CompanyName], [AddressName], [OrderId]) VALUES (46, N'Lasse', N'Eskildsen', N'lasse.eskildsen@uCommerce.dk', N'61997779', N'', N'Ny Banegårdsgade 55', N'', N'8000', N'Århus C', N'', 6, N'', N'uCommerce', N'Billing', 165)
GO
INSERT [dbo].[uCommerce_OrderAddress] ([OrderAddressId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CompanyName], [AddressName], [OrderId]) VALUES (47, N'Joe', N'Developer', N'', N'', N'', N'Somewhere', N'', N'9000', N'Mytown', N'', 6, N'', N'SomeCompany', N'Billing', 167)
GO
INSERT [dbo].[uCommerce_OrderAddress] ([OrderAddressId], [FirstName], [LastName], [EmailAddress], [PhoneNumber], [MobilePhoneNumber], [Line1], [Line2], [PostalCode], [City], [State], [CountryId], [Attention], [CompanyName], [AddressName], [OrderId]) VALUES (48, N'ælkj', N'ælk', N'leskil99@gmail.com', N'', N'', N'kj', N'ælk', N'jælk', N'ælkj', N'', 6, N'ælkj', N'jæl', N'Billing', 169)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderAddress] OFF
GO
INSERT [dbo].[uCommerce_OrderAmountTarget] ([OrderAmountTargetId], [MinAmount]) VALUES (12, CAST(400.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderLine] ON 

GO
INSERT [dbo].[uCommerce_OrderLine] ([OrderLineId], [OrderId], [Sku], [ProductName], [Price], [Quantity], [CreatedOn], [Discount], [VAT], [Total], [VATRate], [VariantSku], [ShipmentId], [UnitDiscount], [CreatedBy]) VALUES (173, 165, N'100-000-001-003', N'Go-Live', 3495.0000, 1, CAST(N'2009-08-30 15:49:19.800' AS DateTime), 0.0000, 524.2500, 4019.2500, 0.1500, NULL, 1, NULL, NULL)
GO
INSERT [dbo].[uCommerce_OrderLine] ([OrderLineId], [OrderId], [Sku], [ProductName], [Price], [Quantity], [CreatedOn], [Discount], [VAT], [Total], [VATRate], [VariantSku], [ShipmentId], [UnitDiscount], [CreatedBy]) VALUES (174, 165, N'100-000-001-001', N'Developer Edition', 0.0000, 1, CAST(N'2009-08-30 15:49:41.060' AS DateTime), 0.0000, 0.0000, 0.0000, 0.1500, NULL, 1, NULL, NULL)
GO
INSERT [dbo].[uCommerce_OrderLine] ([OrderLineId], [OrderId], [Sku], [ProductName], [Price], [Quantity], [CreatedOn], [Discount], [VAT], [Total], [VATRate], [VariantSku], [ShipmentId], [UnitDiscount], [CreatedBy]) VALUES (175, 165, N'200-000-001-002', N'10 Coupons', 150.0000, 1, CAST(N'2009-08-30 15:58:34.750' AS DateTime), 0.0000, 22.5000, 172.5000, 0.1500, NULL, 1, NULL, NULL)
GO
INSERT [dbo].[uCommerce_OrderLine] ([OrderLineId], [OrderId], [Sku], [ProductName], [Price], [Quantity], [CreatedOn], [Discount], [VAT], [Total], [VATRate], [VariantSku], [ShipmentId], [UnitDiscount], [CreatedBy]) VALUES (176, 167, N'100-000-001-001', N'Developer Edition', 0.0000, 1, CAST(N'2009-08-30 16:10:58.257' AS DateTime), 0.0000, 0.0000, 0.0000, 0.1500, NULL, 2, NULL, NULL)
GO
INSERT [dbo].[uCommerce_OrderLine] ([OrderLineId], [OrderId], [Sku], [ProductName], [Price], [Quantity], [CreatedOn], [Discount], [VAT], [Total], [VATRate], [VariantSku], [ShipmentId], [UnitDiscount], [CreatedBy]) VALUES (177, 169, N'100-000-001-001', N'Developer Edition', 0.0000, 1, CAST(N'2009-09-03 19:57:35.470' AS DateTime), 0.0000, 0.0000, 0.0000, 0.1500, NULL, 3, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderLine] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderNumberSerie] ON 

GO
INSERT [dbo].[uCommerce_OrderNumberSerie] ([OrderNumberId], [OrderNumberName], [Prefix], [Postfix], [Increment], [CurrentNumber], [Deleted], [Guid]) VALUES (3, N'Default', N'WEB-', N'', 1, 3, 0, N'979600e2-07db-44af-ae19-e965ea171ba0')
GO
INSERT [dbo].[uCommerce_OrderNumberSerie] ([OrderNumberId], [OrderNumberName], [Prefix], [Postfix], [Increment], [CurrentNumber], [Deleted], [Guid]) VALUES (4, N'Default Payment Reference', N'Reference-', NULL, 1, 1, 0, N'c240972a-5f77-4e59-9e14-5f243dc38819')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderNumberSerie] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderStatus] ON 

GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (1, N'Basket', 5, 0, 0, NULL, NULL, 1, NULL, 1, 0, NULL, 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (2, N'New order', 2, 0, 1, 3, NULL, 1, NULL, 1, 0, NULL, 1)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (3, N'Completed order', 3, 0, 1, 5, NULL, 1, NULL, 1, 0, N'ToCompletedOrder', 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (5, N'Invoiced', 5, 0, 1, 6, NULL, 1, NULL, 1, 0, NULL, 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (6, N'Paid', 6, 0, 1, NULL, NULL, 1, NULL, 0, 0, NULL, 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (7, N'Cancelled', 7, 0, 1, NULL, NULL, 1, NULL, 1, 1, N'ToCancelled', 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (1000000, N'Requires attention', 3, 0, 1, 3, NULL, 1, NULL, 1, 0, NULL, 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (1000001, N'Manually cancelled', 10, 0, 1, NULL, NULL, 1, NULL, 1, 0, NULL, 0)
GO
INSERT [dbo].[uCommerce_OrderStatus] ([OrderStatusId], [Name], [Sort], [RenderChildren], [RenderInMenu], [NextOrderStatusId], [ExternalId], [IncludeInAuditTrail], [Order], [AllowUpdate], [AlwaysAvailable], [Pipeline], [AllowOrderEdit]) VALUES (1000002, N'Processing', 200, 0, 0, NULL, NULL, 1, NULL, 1, 0, N'Processing', 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderStatus] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderStatusAudit] ON 

GO
INSERT [dbo].[uCommerce_OrderStatusAudit] ([OrderStatusAuditId], [NewOrderStatusId], [CreatedOn], [CreatedBy], [OrderId], [Message]) VALUES (72, 2, CAST(N'2009-08-30 16:13:41.057' AS DateTime), N'uCommerce', 167, NULL)
GO
INSERT [dbo].[uCommerce_OrderStatusAudit] ([OrderStatusAuditId], [NewOrderStatusId], [CreatedOn], [CreatedBy], [OrderId], [Message]) VALUES (73, 2, CAST(N'2009-09-03 20:14:05.640' AS DateTime), N'uCommerce', 169, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_OrderStatusAudit] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Payment] ON 

GO
INSERT [dbo].[uCommerce_Payment] ([PaymentId], [TransactionId], [PaymentMethodName], [Created], [PaymentMethodId], [Fee], [FeePercentage], [PaymentStatusId], [Amount], [OrderId], [FeeTotal], [ReferenceId]) VALUES (4, N'true', N'Account', CAST(N'2009-08-30 16:05:22.687' AS DateTime), 6, 0.0000, CAST(0.0000 AS Decimal(18, 4)), 1, 0.0000, 165, 0.0000, NULL)
GO
INSERT [dbo].[uCommerce_Payment] ([PaymentId], [TransactionId], [PaymentMethodName], [Created], [PaymentMethodId], [Fee], [FeePercentage], [PaymentStatusId], [Amount], [OrderId], [FeeTotal], [ReferenceId]) VALUES (5, N'true', N'Account', CAST(N'2009-08-30 16:13:15.703' AS DateTime), 6, 0.0000, CAST(0.0000 AS Decimal(18, 4)), 1, 0.0000, 167, 0.0000, NULL)
GO
INSERT [dbo].[uCommerce_Payment] ([PaymentId], [TransactionId], [PaymentMethodName], [Created], [PaymentMethodId], [Fee], [FeePercentage], [PaymentStatusId], [Amount], [OrderId], [FeeTotal], [ReferenceId]) VALUES (6, N'true', N'Account', CAST(N'2009-09-03 20:01:04.373' AS DateTime), 6, 0.0000, CAST(0.0000 AS Decimal(18, 4)), 1, 0.0000, 169, 0.0000, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Payment] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethod] ON 

GO
INSERT [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId], [Name], [FeePercent], [ImageMediaId], [PaymentMethodServiceName], [Enabled], [Deleted], [ModifiedOn], [ModifiedBy], [Pipeline], [DefinitionId]) VALUES (6, N'Account', CAST(0.0000 AS Decimal(18, 4)), NULL, NULL, 1, 0, CAST(N'2009-08-30 17:38:53.590' AS DateTime), N'uCommerce', N'Checkout', NULL)
GO
INSERT [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId], [Name], [FeePercent], [ImageMediaId], [PaymentMethodServiceName], [Enabled], [Deleted], [ModifiedOn], [ModifiedBy], [Pipeline], [DefinitionId]) VALUES (7, N'Invoice', CAST(0.0000 AS Decimal(18, 4)), NULL, NULL, 1, 0, CAST(N'2009-08-30 17:41:26.363' AS DateTime), N'uCommerce', N'Checkout', NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethod] OFF
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 6)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 7)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 8)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 9)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 10)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 11)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 12)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (6, 13)
GO
INSERT [dbo].[uCommerce_PaymentMethodCountry] ([PaymentMethodId], [CountryId]) VALUES (7, 6)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethodDescription] ON 

GO
INSERT [dbo].[uCommerce_PaymentMethodDescription] ([PaymentMethodDescriptionId], [PaymentMethodId], [CultureCode], [DisplayName], [Description]) VALUES (1, 6, N'en-US', N'Account', N'')
GO
INSERT [dbo].[uCommerce_PaymentMethodDescription] ([PaymentMethodDescriptionId], [PaymentMethodId], [CultureCode], [DisplayName], [Description]) VALUES (2, 6, N'da-DK', N'Konto', N'')
GO
INSERT [dbo].[uCommerce_PaymentMethodDescription] ([PaymentMethodDescriptionId], [PaymentMethodId], [CultureCode], [DisplayName], [Description]) VALUES (3, 7, N'en-US', N'Invoice', N'')
GO
INSERT [dbo].[uCommerce_PaymentMethodDescription] ([PaymentMethodDescriptionId], [PaymentMethodId], [CultureCode], [DisplayName], [Description]) VALUES (4, 7, N'da-DK', N'Faktura', N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethodDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethodFee] ON 

GO
INSERT [dbo].[uCommerce_PaymentMethodFee] ([PaymentMethodFeeId], [PaymentMethodId], [CurrencyId], [PriceGroupId], [Fee]) VALUES (1, 6, 5, 6, 0.0000)
GO
INSERT [dbo].[uCommerce_PaymentMethodFee] ([PaymentMethodFeeId], [PaymentMethodId], [CurrencyId], [PriceGroupId], [Fee]) VALUES (2, 7, 5, 6, 10.0000)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PaymentMethodFee] OFF
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (1, N'New')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000001, N'Pending Authorization')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000002, N'Authorized')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000003, N'Acquired')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000004, N'Cancelled')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000005, N'Refunded')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000006, N'Complete')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000008, N'Declined')
GO
INSERT [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId], [Name]) VALUES (10000009, N'Acquire failed')
GO
INSERT [dbo].[uCommerce_PercentOffShippingTotalAward] ([PercentOffShippingTotalAwardId], [PercentOff]) VALUES (6, CAST(100.00 AS Decimal(18, 2)))
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PriceGroup] ON 

GO
INSERT [dbo].[uCommerce_PriceGroup] ([PriceGroupId], [Name], [CurrencyId], [VATRate], [Description], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [Deleted], [Guid]) VALUES (6, N'EUR 15 pct', 5, CAST(0.1500 AS Decimal(18, 4)), N'Default VAT', CAST(N'2009-08-30 13:50:01.670' AS DateTime), N'uCommerce', CAST(N'2009-08-30 13:50:53.180' AS DateTime), N'uCommerce', 0, N'81da377f-40d4-4d08-b700-494fe6811ace')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PriceGroup] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PriceGroupPrice] ON 

GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (84, 97, 3495.0000, NULL, 6)
GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (85, 98, 0.0000, NULL, 6)
GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (86, 101, 100.0000, NULL, 6)
GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (87, 102, 100.0000, NULL, 6)
GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (88, 103, 150.0000, NULL, 6)
GO
INSERT [dbo].[uCommerce_PriceGroupPrice] ([PriceGroupPriceId], [ProductId], [Price], [DiscountPrice], [PriceGroupId]) VALUES (89, 104, 200.0000, NULL, 6)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PriceGroupPrice] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Product] ON 

GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (97, NULL, N'100-000-001', NULL, N'uCommerce', 1, N'1097', N'1097', CAST(0.0000 AS Decimal(18, 4)), 19, 1, N'uCommerce', CAST(N'2009-08-30 15:49:35.173' AS DateTime), CAST(N'2009-08-30 14:56:42.823' AS DateTime), NULL, NULL, N'e76bb627-b701-413c-8b16-b3696210c01d')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (98, 97, N'100-000-001', N'001', N'Developer', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 19, 0, N'uCommerce', CAST(N'2009-08-30 15:49:35.267' AS DateTime), CAST(N'2009-08-30 14:58:45.753' AS DateTime), NULL, NULL, N'5fb58a5d-e167-4cbd-9ebd-f0ab5f35d932')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (99, 97, N'100-000-001', N'002', N'Evaluation', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 19, 0, N'uCommerce', CAST(N'2009-08-30 15:49:35.387' AS DateTime), CAST(N'2009-08-30 15:12:02.267' AS DateTime), NULL, NULL, N'03fc4d15-b367-482f-a872-201cd1ed987a')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (100, 97, N'100-000-001', N'003', N'Go-Live', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 19, 0, N'uCommerce', CAST(N'2009-08-30 15:49:35.613' AS DateTime), CAST(N'2009-08-30 15:12:16.380' AS DateTime), NULL, NULL, N'd60ca047-e428-4e66-ba97-f18708872044')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (101, NULL, N'200-000-001', NULL, N'Support', 1, N'1097', N'1097', CAST(0.0000 AS Decimal(18, 4)), 20, 1, N'uCommerce', CAST(N'2009-08-30 15:56:46.450' AS DateTime), CAST(N'2009-08-30 15:56:18.303' AS DateTime), NULL, NULL, N'68dc45bc-012b-4fe1-aa99-ca6f1a084af8')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (102, 101, N'200-000-001', N'001', N'5', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 20, 0, N'uCommerce', CAST(N'2009-08-30 15:56:54.460' AS DateTime), CAST(N'2009-08-30 15:56:30.553' AS DateTime), NULL, NULL, N'9ba9a78a-4ae7-486f-aaad-c17b8340f521')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (103, 101, N'200-000-001', N'002', N'10', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 20, 0, N'uCommerce', CAST(N'2009-08-30 15:57:01.810' AS DateTime), CAST(N'2009-08-30 15:56:38.610' AS DateTime), NULL, NULL, N'd9633304-341d-4b61-851a-cb0006cf41b0')
GO
INSERT [dbo].[uCommerce_Product] ([ProductId], [ParentProductId], [Sku], [VariantSku], [Name], [DisplayOnSite], [ThumbnailImageMediaId], [PrimaryImageMediaId], [Weight], [ProductDefinitionId], [AllowOrdering], [ModifiedBy], [ModifiedOn], [CreatedOn], [CreatedBy], [Rating], [Guid]) VALUES (104, 101, N'200-000-001', N'003', N'15', 0, NULL, NULL, CAST(0.0000 AS Decimal(18, 4)), 20, 0, N'uCommerce', CAST(N'2009-08-30 15:57:06.297' AS DateTime), CAST(N'2009-08-30 15:56:46.863' AS DateTime), NULL, NULL, N'b684367a-2f86-4e49-b1b7-22e6ad8ed9d9')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Product] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalog] ON 

GO
INSERT [dbo].[uCommerce_ProductCatalog] ([ProductCatalogId], [ProductCatalogGroupId], [Name], [PriceGroupId], [ShowPricesIncludingVAT], [IsVirtual], [DisplayOnWebSite], [LimitedAccess], [Deleted], [CreatedOn], [ModifiedOn], [CreatedBy], [ModifiedBy], [SortOrder], [Guid]) VALUES (23, 13, N'uCommerce', 6, 0, 0, 0, 0, 0, CAST(N'2009-08-30 14:43:41.543' AS DateTime), CAST(N'2009-08-30 15:19:50.163' AS DateTime), N'uCommerce', N'uCommerce', 0, N'5ea7dd5a-6f64-4253-b2c8-1c4de674b748')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalog] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalogDescription] ON 

GO
INSERT [dbo].[uCommerce_ProductCatalogDescription] ([ProductCatalogDescriptionId], [ProductCatalogId], [CultureCode], [DisplayName]) VALUES (42, 23, N'en-US', N'uCommerce')
GO
INSERT [dbo].[uCommerce_ProductCatalogDescription] ([ProductCatalogDescriptionId], [ProductCatalogId], [CultureCode], [DisplayName]) VALUES (43, 23, N'da-DK', N'uCommerce')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalogDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalogGroup] ON 

GO
INSERT [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId], [Name], [Description], [EmailProfileId], [CurrencyId], [DomainId], [OrderNumberId], [Deleted], [CreateCustomersAsMembers], [MemberGroupId], [MemberTypeId], [ProductReviewsRequireApproval], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (13, N'uCommerce.dk', N'', 5, 5, NULL, 3, 0, 0, N'0', N'0', 0, N'd81c4fc4-1a13-4d7f-87f7-a52b7d80ca9a', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.780' AS DateTime), N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductCatalogGroup] OFF
GO
INSERT [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap] ([ProductCatalogGroupId], [PaymentMethodId]) VALUES (13, 6)
GO
INSERT [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap] ([ProductCatalogGroupId], [PaymentMethodId]) VALUES (13, 7)
GO
INSERT [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap] ([ProductCatalogGroupId], [ShippingMethodId]) VALUES (13, 8)
GO
INSERT [dbo].[uCommerce_ProductCatalogGroupTarget] ([ProductCatalogGroupTargetId], [Name]) VALUES (6, N'uCommerce.dk')
GO
INSERT [dbo].[uCommerce_ProductCatalogGroupTarget] ([ProductCatalogGroupTargetId], [Name]) VALUES (13, N'uCommerce.dk')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinition] ON 

GO
INSERT [dbo].[uCommerce_ProductDefinition] ([ProductDefinitionId], [Name], [Description], [Deleted], [SortOrder], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (19, N'Software', N'', 0, 0, N'57378916-246a-445d-a8c4-4f65ac5f33bb', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.777' AS DateTime), N'')
GO
INSERT [dbo].[uCommerce_ProductDefinition] ([ProductDefinitionId], [Name], [Description], [Deleted], [SortOrder], [Guid], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (20, N'Support', N'', 0, 0, N'ff7f19df-ee5c-49af-a617-570df66ca20a', CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'', CAST(N'2015-12-09 19:14:14.777' AS DateTime), N'')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinition] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinitionField] ON 

GO
INSERT [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId], [DataTypeId], [ProductDefinitionId], [Name], [DisplayOnSite], [IsVariantProperty], [Multilingual], [RenderInEditor], [Searchable], [Deleted], [SortOrder], [Facet], [Guid]) VALUES (37, 6, 19, N'Downloadable', 1, 1, 0, 1, 0, 0, 0, 0, N'a5dc187a-fbf3-4c4a-a45f-a7ab55f28114')
GO
INSERT [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId], [DataTypeId], [ProductDefinitionId], [Name], [DisplayOnSite], [IsVariantProperty], [Multilingual], [RenderInEditor], [Searchable], [Deleted], [SortOrder], [Facet], [Guid]) VALUES (38, 13, 19, N'License', 1, 1, 0, 1, 0, 0, 0, 0, N'b04dc0cb-7fdf-44d3-a044-d1057ea75230')
GO
INSERT [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId], [DataTypeId], [ProductDefinitionId], [Name], [DisplayOnSite], [IsVariantProperty], [Multilingual], [RenderInEditor], [Searchable], [Deleted], [SortOrder], [Facet], [Guid]) VALUES (39, 14, 20, N'Coupons', 1, 1, 0, 1, 0, 0, 0, 0, N'9a3afe2e-b96b-4d77-baea-a46f1f1fe56b')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinitionField] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ON 

GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (55, N'en-US', N'Downloadable', 37, NULL)
GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (56, N'da-DK', N'Kan downloades', 37, NULL)
GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (57, N'en-US', N'License', 38, NULL)
GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (58, N'da-DK', N'Licens', 38, NULL)
GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (59, N'en-US', N'No. of coupons', 39, NULL)
GO
INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] ([ProductDefinitionFieldDescriptionId], [CultureCode], [DisplayName], [ProductDefinitionFieldId], [Description]) VALUES (60, N'da-DK', N'Antal klip', 39, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDefinitionFieldDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDescription] ON 

GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (61, 97, N'uCommerce 1.0 RTM', N'uCommerce is a full featured e-commerce platform with content management features powered by Umbraco. Everything you need to build a killer e-commerce solution for your clients!', N'uCommerce is fully integrated with the content management system Umbraco, which provides not only the frontend renderendering enabling you to create beautifully designed stores, but also the back office capabilities where you configure and cuztomize the store to your liking.

uCommerce_ foundations provide the basis for an e-commerce solution. Each foundation addresses a specific need for providing a full e-commerce solution to your clients. foundations in the box include a Catalog Foundation, a Transactions Foundation, and an Analytics Foundation.

Each of the foundations within uCommerce_ are fully configurable right in Umbraco. No need to switch between a multitude of tools to manage your stores. It''s all available as you would expect in one convenient location.', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (62, 97, N'uCommerce 1.0 RTM', N'uCommerce is a full featured e-commerce platform with content management features powered by Umbraco. Everything you need to build a killer e-commerce solution for your clients!', N'uCommerce is fully integrated with the content management system Umbraco, which provides not only the frontend renderendering enabling you to create beautifully designed stores, but also the back office capabilities where you configure and cuztomize the store to your liking.
', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (63, 98, N'Developer Edition', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (64, 98, N'Udviklingsversion', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (65, 99, N'30 Days Evaluation', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (66, 99, N'30 daee evaluering', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (67, 100, N'Go-Live', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (68, 100, N'Go-Live', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (69, 101, N'Support', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (70, 101, N'Support', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (71, 102, N'5 Coupons', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (72, 102, N'5 klip', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (73, 103, N'10 Coupons', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (74, 103, N'10 klip', N'', N'', N'da-DK')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (75, 104, N'15 Coupons', N'', N'', N'en-US')
GO
INSERT [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId], [ProductId], [DisplayName], [ShortDescription], [LongDescription], [CultureCode]) VALUES (76, 104, N'15 klip', N'', N'', N'da-DK')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductDescription] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductProperty] ON 

GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (777, N'on', 37, 98)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (778, N'Dev', 38, 98)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (779, N'on', 37, 99)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (780, N'Eval', 38, 99)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (781, N'on', 37, 100)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (782, N'Live', 38, 100)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (783, N'5', 39, 102)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (784, N'10', 39, 103)
GO
INSERT [dbo].[uCommerce_ProductProperty] ([ProductPropertyId], [Value], [ProductDefinitionFieldId], [ProductId]) VALUES (785, N'15', 39, 104)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductProperty] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductRelationType] ON 

GO
INSERT [dbo].[uCommerce_ProductRelationType] ([ProductRelationTypeId], [Name], [Description], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'Default', N'Relations between products', CAST(N'2010-01-01 00:00:00.000' AS DateTime), N'Administrator', CAST(N'2010-01-01 00:00:00.000' AS DateTime), N'Administrator')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ProductRelationType] OFF
GO
INSERT [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId], [Name], [Deleted]) VALUES (1000, N'New', 0)
GO
INSERT [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId], [Name], [Deleted]) VALUES (2000, N'Approved', 0)
GO
INSERT [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId], [Name], [Deleted]) VALUES (3000, N'Unapproved', 0)
GO
INSERT [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId], [Name], [Deleted]) VALUES (4000, N'ReportedAsAbuse', 0)
GO
INSERT [dbo].[uCommerce_ProductTarget] ([ProductTargetId], [Skus]) VALUES (3, N'100-000-001')
GO
INSERT [dbo].[uCommerce_ProductTarget] ([ProductTargetId], [Skus]) VALUES (4, N'100-000-001')
GO
INSERT [dbo].[uCommerce_ProductTarget] ([ProductTargetId], [Skus]) VALUES (7, N'200-000-001')
GO
INSERT [dbo].[uCommerce_ProductTarget] ([ProductTargetId], [Skus]) VALUES (8, N'100-000-001')
GO
INSERT [dbo].[uCommerce_ProductTarget] ([ProductTargetId], [Skus]) VALUES (11, N'100-000-001')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PurchaseOrder] ON 

GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (165, N'WEB-1', 66, 2, CAST(N'2009-08-30 15:49:19.273' AS DateTime), CAST(N'2009-08-30 16:05:38.777' AS DateTime), 5, 13, 46, NULL, N'7f5f78a2-bc53-4eec-8314-210185dc8b98', 546.7500, 4191.7500, 0.0000, 0.0000, NULL, 4191.7500, N'edaeb646-14f9-4470-9d23-a5d341db15ad', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (166, NULL, NULL, 1, CAST(N'2009-08-30 15:49:19.273' AS DateTime), NULL, 5, 13, NULL, NULL, N'7f5f78a2-bc53-4eec-8314-210185dc8b98', NULL, NULL, NULL, NULL, NULL, NULL, N'f67bfee2-8e23-4dcf-8bcb-49bf1b025e58', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (167, N'WEB-2', 67, 2, CAST(N'2009-08-30 16:10:57.700' AS DateTime), CAST(N'2009-08-30 16:13:20.237' AS DateTime), 5, 13, 47, NULL, N'06461b7f-fb70-4c12-a71d-7b4716816821', 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0.0000, N'4631d8f8-2054-4f6c-9c55-1a34b939bf00', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (168, NULL, NULL, 1, CAST(N'2009-08-30 16:10:57.700' AS DateTime), NULL, 5, 13, NULL, NULL, N'06461b7f-fb70-4c12-a71d-7b4716816821', NULL, NULL, NULL, NULL, NULL, NULL, N'6256cd31-45e6-43b9-aa81-1bf071ec3486', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (169, N'WEB-3', 68, 2, CAST(N'2009-09-03 19:57:34.813' AS DateTime), CAST(N'2009-09-03 20:14:05.283' AS DateTime), 5, 13, 48, NULL, N'e6352adb-083b-4959-95fb-aff4d013ce44', 0.0000, 0.0000, 0.0000, 0.0000, NULL, 0.0000, N'6d683000-85b3-4132-9c7c-9d556b383b2a', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
INSERT [dbo].[uCommerce_PurchaseOrder] ([OrderId], [OrderNumber], [CustomerId], [OrderStatusId], [CreatedDate], [CompletedDate], [CurrencyId], [ProductCatalogGroupId], [BillingAddressId], [Note], [BasketId], [VAT], [OrderTotal], [ShippingTotal], [PaymentTotal], [TaxTotal], [SubTotal], [OrderGuid], [ModifiedOn], [CultureCode], [Discount], [DiscountTotal]) VALUES (170, NULL, NULL, 1, CAST(N'2009-09-03 19:57:34.813' AS DateTime), NULL, 5, 13, NULL, NULL, N'e6352adb-083b-4959-95fb-aff4d013ce44', NULL, NULL, NULL, NULL, NULL, NULL, N'0a78d0d0-1be0-4273-8bb4-026a9b6f56ad', CAST(N'2015-12-09 19:14:13.607' AS DateTime), NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_PurchaseOrder] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Shipment] ON 

GO
INSERT [dbo].[uCommerce_Shipment] ([ShipmentId], [ShipmentName], [CreatedOn], [ShipmentPrice], [ShippingMethodId], [ShipmentAddressId], [DeliveryNote], [OrderId], [TrackAndTrace], [CreatedBy], [Tax], [TaxRate], [ShipmentTotal], [ShipmentDiscount]) VALUES (1, N'Download', CAST(N'2009-08-30 16:00:38.247' AS DateTime), 0.0000, 8, 46, N'Download', 165, NULL, NULL, 0.0000, 0.0000, 0.0000, NULL)
GO
INSERT [dbo].[uCommerce_Shipment] ([ShipmentId], [ShipmentName], [CreatedOn], [ShipmentPrice], [ShippingMethodId], [ShipmentAddressId], [DeliveryNote], [OrderId], [TrackAndTrace], [CreatedBy], [Tax], [TaxRate], [ShipmentTotal], [ShipmentDiscount]) VALUES (2, N'Download', CAST(N'2009-08-30 16:13:12.197' AS DateTime), 0.0000, 8, 46, N'Download', 167, NULL, NULL, 0.0000, 0.0000, 0.0000, NULL)
GO
INSERT [dbo].[uCommerce_Shipment] ([ShipmentId], [ShipmentName], [CreatedOn], [ShipmentPrice], [ShippingMethodId], [ShipmentAddressId], [DeliveryNote], [OrderId], [TrackAndTrace], [CreatedBy], [Tax], [TaxRate], [ShipmentTotal], [ShipmentDiscount]) VALUES (3, N'Download', CAST(N'2009-09-03 20:00:58.067' AS DateTime), 0.0000, 8, 46, N'Download', 169, NULL, NULL, 0.0000, 0.0000, 0.0000, NULL)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Shipment] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethod] ON 

GO
INSERT [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId], [Name], [ImageMediaId], [PaymentMethodId], [ServiceName], [Deleted]) VALUES (8, N'Download', NULL, NULL, N'SinglePriceService', 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethod] OFF
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 6)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 7)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 8)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 9)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 10)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 11)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 12)
GO
INSERT [dbo].[uCommerce_ShippingMethodCountry] ([ShippingMethodId], [CountryId]) VALUES (8, 13)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethodDescription] ON 

GO
INSERT [dbo].[uCommerce_ShippingMethodDescription] ([ShippingMethodDescriptionId], [ShippingMethodId], [DisplayName], [Description], [DeliveryText], [CultureCode]) VALUES (1, 8, N'Download', N'Recieve download link after download.', N'Download', N'en-US')
GO
INSERT [dbo].[uCommerce_ShippingMethodDescription] ([ShippingMethodDescriptionId], [ShippingMethodId], [DisplayName], [Description], [DeliveryText], [CultureCode]) VALUES (2, 8, N'Download', N'Modtag download link efter betaling.', N'Download', N'da-DK')
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethodDescription] OFF
GO
INSERT [dbo].[uCommerce_ShippingMethodPaymentMethods] ([ShippingMethodId], [PaymentMethodId]) VALUES (8, 6)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethodPrice] ON 

GO
INSERT [dbo].[uCommerce_ShippingMethodPrice] ([ShippingMethodPriceId], [ShippingMethodId], [PriceGroupId], [Price], [CurrencyId]) VALUES (1, 8, 6, 0.0000, 5)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_ShippingMethodPrice] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_SystemVersion] ON 

GO
INSERT [dbo].[uCommerce_SystemVersion] ([SystemVersionId], [SchemaVersion]) VALUES (1, 141)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_SystemVersion] OFF
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Target] ON 

GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (3, 3, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (4, 3, 1, 0)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (6, 4, 1, 0)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (7, 4, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (8, 4, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (9, 5, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (10, 6, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (11, 6, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (12, 7, 0, 1)
GO
INSERT [dbo].[uCommerce_Target] ([TargetId], [CampaignItemId], [EnabledForDisplay], [EnabledForApply]) VALUES (13, 7, 1, 0)
GO
SET IDENTITY_INSERT [dbo].[uCommerce_Target] OFF
GO
INSERT [dbo].[uCommerce_VoucherTarget] ([VoucherTargetId], [Name]) VALUES (9, N'')
GO
INSERT [dbo].[uCommerce_VoucherTarget] ([VoucherTargetId], [Name]) VALUES (10, N'')
GO
SET IDENTITY_INSERT [dbo].[umbracoCacheInstruction] ON 

GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (1, CAST(N'2015-12-09 04:55:04.290' AS DateTime), N'[{"RefreshType":0,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D5] 77615C68AFDF4ADD8E660C2C66996600')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (2, CAST(N'2015-12-09 04:57:43.117' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"7b5665c7-fba4-444a-8402-b03dcdc21161\",\"Id\":1046}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (3, CAST(N'2015-12-09 04:58:51.787' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"fcd011b4-50c0-4448-8b52-bf2f0f2e0036\",\"Id\":1047}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (4, CAST(N'2015-12-09 04:59:24.453' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"8fe6579e-0802-4657-bf03-24f0ef8fdb46\",\"Id\":1048}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (5, CAST(N'2015-12-09 05:00:11.797' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"81e76660-7791-4940-9267-31bf5952ca3a\",\"Id\":1049}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (6, CAST(N'2015-12-09 05:00:33.087' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"81e76660-7791-4940-9267-31bf5952ca3a\",\"Id\":1049}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (7, CAST(N'2015-12-09 05:00:45.733' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"81e76660-7791-4940-9267-31bf5952ca3a\",\"Id\":1049}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (8, CAST(N'2015-12-09 05:01:02.970' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"81e76660-7791-4940-9267-31bf5952ca3a\",\"Id\":1049}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (9, CAST(N'2015-12-09 05:01:17.583' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"81e76660-7791-4940-9267-31bf5952ca3a\",\"Id\":1049}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (10, CAST(N'2015-12-09 05:01:40.743' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"2915005d-734c-4df6-8fd9-54b1f659e4c2\",\"Id\":1050}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (11, CAST(N'2015-12-09 05:02:18.543' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (12, CAST(N'2015-12-09 05:02:37.260' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (13, CAST(N'2015-12-09 05:02:58.980' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (14, CAST(N'2015-12-09 05:03:19.897' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (15, CAST(N'2015-12-09 05:03:35.517' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (16, CAST(N'2015-12-09 05:03:52.500' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"773333b3-1b0f-4e8f-8dc6-f83c6af883de\",\"Id\":1051}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (17, CAST(N'2015-12-09 05:04:35.700' AS DateTime), N'[{"RefreshType":4,"RefresherId":"35b16c25-a17e-45d7-bc8f-edab1dcc28d2","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"UniqueId\":\"6f09ae4a-c00e-4214-a351-3b138aa1fd3d\",\"Id\":1052}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (18, CAST(N'2015-12-09 05:05:53.490' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (19, CAST(N'2015-12-09 05:06:02.637' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Master\",\"Id\":1054,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (20, CAST(N'2015-12-09 05:06:43.977' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"CategorySectionPage\",\"Id\":1055,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (21, CAST(N'2015-12-09 05:06:55.070' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToSubSectionPage\",\"Id\":1056,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (22, CAST(N'2015-12-09 05:07:07.043' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSectionPage\",\"Id\":1057,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (23, CAST(N'2015-12-09 05:07:18.130' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSubSectionPage\",\"Id\":1058,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (24, CAST(N'2015-12-09 05:07:34.723' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleContent\",\"Id\":1059,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (25, CAST(N'2015-12-09 05:07:43.827' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Content\",\"Id\":1060,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (26, CAST(N'2015-12-09 05:07:56.113' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (27, CAST(N'2015-12-09 05:08:02.820' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryContent\",\"Id\":1062,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (28, CAST(N'2015-12-09 05:08:16.527' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Content\",\"Id\":1060,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (29, CAST(N'2015-12-09 05:08:25.410' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"TagLibrary\",\"Id\":1063,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (30, CAST(N'2015-12-09 05:08:30.920' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Content\",\"Id\":1060,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (31, CAST(N'2015-12-09 05:08:43.120' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (32, CAST(N'2015-12-09 05:08:59.217' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Footer\",\"Id\":1064,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (33, CAST(N'2015-12-09 05:09:06.463' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"FooterPage\",\"Id\":1065,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (34, CAST(N'2015-12-09 05:09:11.573' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Footer\",\"Id\":1064,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (35, CAST(N'2015-12-09 05:09:17.427' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (36, CAST(N'2015-12-09 05:09:24.333' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (37, CAST(N'2015-12-09 05:09:29.930' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Content\",\"Id\":1060,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (38, CAST(N'2015-12-09 05:10:03.423' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPage\",\"Id\":1066,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (39, CAST(N'2015-12-09 05:10:09.160' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (40, CAST(N'2015-12-09 05:10:21.210' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePage\",\"Id\":1067,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (41, CAST(N'2015-12-09 05:10:30.263' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleContent\",\"Id\":1059,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (42, CAST(N'2015-12-09 05:10:33.810' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleContent\",\"Id\":1059,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (43, CAST(N'2015-12-09 05:10:41.910' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (44, CAST(N'2015-12-09 05:10:51.793' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryPage\",\"Id\":1068,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (45, CAST(N'2015-12-09 05:11:01.477' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryContent\",\"Id\":1062,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (46, CAST(N'2015-12-09 05:11:27.943' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"OpenGraphTags\",\"Id\":1069,\"PropertyTypeIds\":[35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (47, CAST(N'2015-12-09 05:11:48.480' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1070]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (48, CAST(N'2015-12-09 05:11:54.760' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (49, CAST(N'2015-12-09 05:12:03.973' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1072]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (50, CAST(N'2015-12-09 05:12:11.483' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1073]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (51, CAST(N'2015-12-09 05:12:18.333' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1074]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (52, CAST(N'2015-12-09 05:12:40.610' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1075]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (53, CAST(N'2015-12-09 05:13:03.397' AS DateTime), N'[{"RefreshType":5,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":1075,"JsonIds":null,"JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (54, CAST(N'2015-12-09 05:13:22.463' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1076]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (55, CAST(N'2015-12-09 05:13:40.677' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1077]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (56, CAST(N'2015-12-09 05:13:58.597' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1078]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (57, CAST(N'2015-12-09 05:14:09.293' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1079]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (58, CAST(N'2015-12-09 05:14:19.123' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1080]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (59, CAST(N'2015-12-09 05:14:43.910' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1081]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (60, CAST(N'2015-12-09 05:15:02.330' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePage\",\"Id\":1067,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (61, CAST(N'2015-12-09 05:15:11.183' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"CategorySectionPage\",\"Id\":1055,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (62, CAST(N'2015-12-09 05:15:36.027' AS DateTime), N'[{"RefreshType":5,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":1076,"JsonIds":null,"JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (63, CAST(N'2015-12-09 05:15:46.380' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSectionPage\",\"Id\":1057,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (64, CAST(N'2015-12-09 05:15:51.950' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSubSectionPage\",\"Id\":1058,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (65, CAST(N'2015-12-09 05:15:59.150' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSectionPage\",\"Id\":1057,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (66, CAST(N'2015-12-09 05:16:37.983' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GallerySubSectionPage\",\"Id\":1082,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (67, CAST(N'2015-12-09 05:16:59.883' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleSubSectionPage\",\"Id\":1083,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (68, CAST(N'2015-12-09 05:17:10.067' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductListingPage\",\"Id\":1084,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (69, CAST(N'2015-12-09 05:17:18.917' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1085]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (70, CAST(N'2015-12-09 05:17:24.843' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1086]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (71, CAST(N'2015-12-09 05:17:30.687' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1087]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (72, CAST(N'2015-12-09 05:17:37.077' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1088]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (73, CAST(N'2015-12-09 05:17:54.303' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"CategorySectionPage\",\"Id\":1055,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (74, CAST(N'2015-12-09 05:18:33.773' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"FooterPage\",\"Id\":1065,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (75, CAST(N'2015-12-09 05:18:50.043' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryPage\",\"Id\":1068,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (76, CAST(N'2015-12-09 05:18:59.090' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GallerySubSectionPage\",\"Id\":1082,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (77, CAST(N'2015-12-09 05:19:11.000' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (78, CAST(N'2015-12-09 05:19:33.037' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPage\",\"Id\":1066,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (79, CAST(N'2015-12-09 05:19:42.303' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToSubSectionPage\",\"Id\":1056,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (80, CAST(N'2015-12-09 05:19:53.977' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Master\",\"Id\":1054,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (81, CAST(N'2015-12-09 05:20:08.190' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Master\",\"Id\":1054,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (82, CAST(N'2015-12-09 05:20:17.297' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"SeoTags\",\"Id\":1089,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (83, CAST(N'2015-12-09 05:20:24.437' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Master\",\"Id\":1054,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (84, CAST(N'2015-12-09 05:20:44.417' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductDetailsPage\",\"Id\":1090,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (85, CAST(N'2015-12-09 05:21:01.450' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductListingPage\",\"Id\":1084,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (86, CAST(N'2015-12-09 05:21:08.460' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1091]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (87, CAST(N'2015-12-09 05:21:15.750' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductDetailsPage\",\"Id\":1090,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (88, CAST(N'2015-12-09 05:21:33.460' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1092]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (89, CAST(N'2015-12-09 05:21:43.157' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1093]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (90, CAST(N'2015-12-09 05:21:54.370' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1094]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (91, CAST(N'2015-12-09 05:22:07.350' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1095]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (92, CAST(N'2015-12-09 05:22:20.810' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1096]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (93, CAST(N'2015-12-09 05:22:30.733' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleSubSectionPage\",\"Id\":1083,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (94, CAST(N'2015-12-09 05:22:37.107' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1095]","JsonPayload":null},{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1095]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (95, CAST(N'2015-12-09 05:22:45.910' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1098]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1099]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1100]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1101]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1097]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (96, CAST(N'2015-12-09 05:22:57.520' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1097]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (97, CAST(N'2015-12-09 05:23:04.463' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1098]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (98, CAST(N'2015-12-09 05:23:06.227' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1099]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (99, CAST(N'2015-12-09 05:23:08.227' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1100]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (100, CAST(N'2015-12-09 05:23:10.067' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1101]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (101, CAST(N'2015-12-09 05:23:22.797' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1070]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (102, CAST(N'2015-12-09 05:23:30.550' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1103]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1104]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1105]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1106]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1102]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (103, CAST(N'2015-12-09 05:23:43.230' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1102]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (104, CAST(N'2015-12-09 05:23:46.587' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1103]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (105, CAST(N'2015-12-09 05:23:48.310' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1104]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (106, CAST(N'2015-12-09 05:23:50.043' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1105]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (107, CAST(N'2015-12-09 05:23:51.890' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1106]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (108, CAST(N'2015-12-09 05:23:56.770' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1108]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1109]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1110]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1111]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1107]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (109, CAST(N'2015-12-09 05:24:17.287' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1107]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (110, CAST(N'2015-12-09 05:24:25.563' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1113]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1114]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1115]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1116]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1112]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (111, CAST(N'2015-12-09 05:24:32.660' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1107]","JsonPayload":null},{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1107]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (112, CAST(N'2015-12-09 05:24:50.247' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1112]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (113, CAST(N'2015-12-09 05:25:01.020' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1118]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1119]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1120]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1121]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1117]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (114, CAST(N'2015-12-09 05:25:08.583' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1117]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (115, CAST(N'2015-12-09 05:25:14.720' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1108]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (116, CAST(N'2015-12-09 05:25:18.250' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1109]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (117, CAST(N'2015-12-09 05:25:20.393' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1110]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (118, CAST(N'2015-12-09 05:25:22.383' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1111]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (119, CAST(N'2015-12-09 05:25:25.350' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1113]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (120, CAST(N'2015-12-09 05:25:27.200' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1114]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (121, CAST(N'2015-12-09 05:25:28.913' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1115]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (122, CAST(N'2015-12-09 05:25:30.817' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1116]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (123, CAST(N'2015-12-09 05:25:34.333' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1118]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (124, CAST(N'2015-12-09 05:25:36.433' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1119]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (125, CAST(N'2015-12-09 05:25:38.363' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1120]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (126, CAST(N'2015-12-09 05:25:41.030' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1121]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (127, CAST(N'2015-12-09 05:26:13.213' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1122]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (128, CAST(N'2015-12-09 05:26:22.503' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1123]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (129, CAST(N'2015-12-09 05:26:34.530' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1124]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (130, CAST(N'2015-12-09 05:26:48.020' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1125]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (131, CAST(N'2015-12-09 05:26:56.797' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1126]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (132, CAST(N'2015-12-09 05:27:04.060' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1127]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (133, CAST(N'2015-12-09 05:27:16.687' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1128]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (134, CAST(N'2015-12-09 05:27:51.140' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1130]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1131]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1132]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1133]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1134]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1135]","JsonPayload":null},{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1129]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (135, CAST(N'2015-12-09 05:28:01.080' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1129]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (136, CAST(N'2015-12-09 05:28:04.950' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1130]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (137, CAST(N'2015-12-09 05:28:06.693' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1131]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (138, CAST(N'2015-12-09 05:28:08.293' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1132]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (139, CAST(N'2015-12-09 05:28:09.907' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1133]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (140, CAST(N'2015-12-09 05:28:11.523' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1134]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (141, CAST(N'2015-12-09 05:28:13.357' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1135]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (142, CAST(N'2015-12-09 05:28:15.077' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1135]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (143, CAST(N'2015-12-09 05:29:24.037' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1136]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (144, CAST(N'2015-12-09 05:29:36.557' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1137]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (145, CAST(N'2015-12-09 05:29:46.243' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1138]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (146, CAST(N'2015-12-09 05:29:54.183' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1139]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (147, CAST(N'2015-12-09 05:30:03.477' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1140]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (148, CAST(N'2015-12-09 05:30:13.573' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1141]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (149, CAST(N'2015-12-09 05:30:21.790' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1141]","JsonPayload":null},{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1141]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (150, CAST(N'2015-12-09 05:30:34.507' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1142]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (151, CAST(N'2015-12-09 05:30:46.647' AS DateTime), N'[{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1143]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (152, CAST(N'2015-12-09 05:31:01.427' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPage\",\"Id\":1066,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (153, CAST(N'2015-12-09 05:31:10.387' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1142]","JsonPayload":null},{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1142]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (154, CAST(N'2015-12-09 05:32:03.953' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (155, CAST(N'2015-12-09 05:32:05.590' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (156, CAST(N'2015-12-09 05:32:17.370' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (157, CAST(N'2015-12-09 05:32:24.607' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (158, CAST(N'2015-12-09 05:32:38.953' AS DateTime), N'[{"RefreshType":3,"RefresherId":"55698352-dfc5-4dbe-96bd-a4a0f6f77145","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1081]","JsonPayload":null},{"RefreshType":3,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1081]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P12968/D8] 3E875D93DF994836AB253FDA2B99F615')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (159, CAST(N'2015-12-09 07:44:05.687' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePageLandscape\",\"Id\":1067,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (160, CAST(N'2015-12-09 07:44:20.270' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1080]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (161, CAST(N'2015-12-09 07:44:36.417' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePagePotrait\",\"Id\":1144,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (162, CAST(N'2015-12-09 07:45:09.890' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1145]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (163, CAST(N'2015-12-09 07:45:24.053' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePagePotrait\",\"Id\":1144,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (164, CAST(N'2015-12-09 07:45:37.810' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleContent\",\"Id\":1059,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (165, CAST(N'2015-12-09 07:45:59.460' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPageLandscape\",\"Id\":1066,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":true,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (166, CAST(N'2015-12-09 07:46:09.277' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1078]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (167, CAST(N'2015-12-09 07:46:24.427' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPagePotrait\",\"Id\":1146,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":true}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (168, CAST(N'2015-12-09 07:46:39.393' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1147]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (169, CAST(N'2015-12-09 07:46:48.370' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPagePotrait\",\"Id\":1146,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (170, CAST(N'2015-12-09 07:46:55.807' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (171, CAST(N'2015-12-09 07:46:57.233' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (172, CAST(N'2015-12-09 07:47:19.690' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleContent\",\"Id\":1059,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (173, CAST(N'2015-12-09 07:47:39.013' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePageLandscape\",\"Id\":1067,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (174, CAST(N'2015-12-09 07:47:49.303' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticlePagePotrait\",\"Id\":1144,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (175, CAST(N'2015-12-09 07:47:56.370' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ArticleSubSectionPage\",\"Id\":1083,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (176, CAST(N'2015-12-09 07:48:03.580' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"CategorySectionPage\",\"Id\":1055,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (177, CAST(N'2015-12-09 07:48:33.330' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSectionPage\",\"Id\":1057,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (178, CAST(N'2015-12-09 07:48:49.507' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ContentSubSectionPage\",\"Id\":1058,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (179, CAST(N'2015-12-09 07:48:58.323' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"FooterPage\",\"Id\":1065,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (180, CAST(N'2015-12-09 07:49:13.860' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GallerySubSectionPage\",\"Id\":1082,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (181, CAST(N'2015-12-09 07:49:21.760' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryPage\",\"Id\":1068,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (182, CAST(N'2015-12-09 07:49:32.410' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryContent\",\"Id\":1062,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (183, CAST(N'2015-12-09 07:49:39.210' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"GalleryContent\",\"Id\":1062,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (184, CAST(N'2015-12-09 07:50:00.863' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"Home\",\"Id\":1053,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (185, CAST(N'2015-12-09 07:50:09.203' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToContent\",\"Id\":1061,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (186, CAST(N'2015-12-09 07:50:21.320' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPageLandscape\",\"Id\":1066,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (187, CAST(N'2015-12-09 07:50:28.833' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToPagePotrait\",\"Id\":1146,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (188, CAST(N'2015-12-09 07:50:37.410' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"HowToSubSectionPage\",\"Id\":1056,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (189, CAST(N'2015-12-09 07:50:57.270' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductDetailsPage\",\"Id\":1090,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (190, CAST(N'2015-12-09 07:51:06.873' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductListingPage\",\"Id\":1084,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (191, CAST(N'2015-12-09 07:51:15.843' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"TagLibrary\",\"Id\":1063,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (192, CAST(N'2015-12-09 07:51:25.173' AS DateTime), N'[{"RefreshType":4,"RefresherId":"6902e22c-9c10-483c-91f3-66b7cae9e2f5","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":"[{\"Alias\":\"ProductListingPage\",\"Id\":1084,\"PropertyTypeIds\":[],\"Type\":\"IContentType\",\"AliasChanged\":false,\"PropertyRemoved\":false,\"DescendantPayloads\":[],\"WasDeleted\":false,\"IsNew\":false}]"}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (193, CAST(N'2015-12-09 07:52:09.463' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (194, CAST(N'2015-12-09 07:52:10.827' AS DateTime), N'[{"RefreshType":3,"RefresherId":"dd12b6a0-14b9-46e8-8800-c154f74047c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":"[1071]","JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P14776/D2] 9F676D850B674EFFA3CCF6C157D80E1F')
GO
INSERT [dbo].[umbracoCacheInstruction] ([id], [utcStamp], [jsonInstruction], [originated]) VALUES (195, CAST(N'2015-12-09 08:14:15.920' AS DateTime), N'[{"RefreshType":0,"RefresherId":"b15f34a1-bc1d-4f8b-8369-3222728ab4c8","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":null},{"RefreshType":0,"RefresherId":"0ac6c028-9860-4ea4-958d-14d39f45886e","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":null},{"RefreshType":0,"RefresherId":"27ab3022-3dfa-47b6-9119-5945bc88fd66","GuidId":"00000000-0000-0000-0000-000000000000","IntId":0,"JsonIds":null,"JsonPayload":null}]', N'SYDPC064//LM/W3SVC/55/ROOT [P15072/D5] 0D1E00707D3E456DA5037D0A6FBB2ECD')
GO
SET IDENTITY_INSERT [dbo].[umbracoCacheInstruction] OFF
GO
SET IDENTITY_INSERT [dbo].[umbracoLanguage] ON 

GO
INSERT [dbo].[umbracoLanguage] ([id], [languageISOCode], [languageCultureName]) VALUES (1, N'en-US', N'en-US')
GO
SET IDENTITY_INSERT [dbo].[umbracoLanguage] OFF
GO
SET IDENTITY_INSERT [dbo].[umbracoLog] ON 

GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (1, 0, -1, CAST(N'2015-12-09 15:54:57.537' AS DateTime), N'PackagerInstall', N'Package ''Archetype'' installed. Package guid: ')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (2, 0, -1, CAST(N'2015-12-09 15:55:04.247' AS DateTime), N'Save', N'Save ContentTypes performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (3, 0, 1046, CAST(N'2015-12-09 15:57:43.070' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (4, 0, 1047, CAST(N'2015-12-09 15:58:51.773' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (5, 0, 1048, CAST(N'2015-12-09 15:59:24.450' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (6, 0, 1049, CAST(N'2015-12-09 16:00:11.793' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (7, 0, 1049, CAST(N'2015-12-09 16:00:33.083' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (8, 0, 1049, CAST(N'2015-12-09 16:00:45.727' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (9, 0, 1049, CAST(N'2015-12-09 16:01:02.963' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (10, 0, 1049, CAST(N'2015-12-09 16:01:17.580' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (11, 0, 1050, CAST(N'2015-12-09 16:01:40.737' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (12, 0, 1051, CAST(N'2015-12-09 16:02:18.537' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (13, 0, 1051, CAST(N'2015-12-09 16:02:37.237' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (14, 0, 1051, CAST(N'2015-12-09 16:02:58.977' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (15, 0, 1051, CAST(N'2015-12-09 16:03:19.890' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (16, 0, 1051, CAST(N'2015-12-09 16:03:35.513' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (17, 0, 1051, CAST(N'2015-12-09 16:03:52.493' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (18, 0, 1052, CAST(N'2015-12-09 16:04:35.697' AS DateTime), N'Save', N'Save DataTypeDefinition performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (19, 0, 1053, CAST(N'2015-12-09 16:05:53.483' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (20, 0, 1054, CAST(N'2015-12-09 16:06:02.627' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (21, 0, 1055, CAST(N'2015-12-09 16:06:43.970' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (22, 0, 1056, CAST(N'2015-12-09 16:06:55.060' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (23, 0, 1057, CAST(N'2015-12-09 16:07:07.033' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (24, 0, 1058, CAST(N'2015-12-09 16:07:18.120' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (25, 0, 1059, CAST(N'2015-12-09 16:07:34.717' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (26, 0, 1060, CAST(N'2015-12-09 16:07:43.817' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (27, 0, 1061, CAST(N'2015-12-09 16:07:56.103' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (28, 0, 1062, CAST(N'2015-12-09 16:08:02.810' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (29, 0, 1060, CAST(N'2015-12-09 16:08:16.513' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (30, 0, 1063, CAST(N'2015-12-09 16:08:25.403' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (31, 0, 1060, CAST(N'2015-12-09 16:08:30.700' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (32, 0, 1053, CAST(N'2015-12-09 16:08:43.110' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (33, 0, 1064, CAST(N'2015-12-09 16:08:59.210' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (34, 0, 1065, CAST(N'2015-12-09 16:09:06.457' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (35, 0, 1064, CAST(N'2015-12-09 16:09:11.560' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (36, 0, 1053, CAST(N'2015-12-09 16:09:17.417' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (37, 0, 1053, CAST(N'2015-12-09 16:09:24.323' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (38, 0, 1060, CAST(N'2015-12-09 16:09:29.917' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (39, 0, 1066, CAST(N'2015-12-09 16:10:03.420' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (40, 0, 1061, CAST(N'2015-12-09 16:10:09.147' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (41, 0, 1067, CAST(N'2015-12-09 16:10:21.200' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (42, 0, 1059, CAST(N'2015-12-09 16:10:30.250' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (43, 0, 1059, CAST(N'2015-12-09 16:10:33.797' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (44, 0, 1061, CAST(N'2015-12-09 16:10:41.900' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (45, 0, 1068, CAST(N'2015-12-09 16:10:51.787' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (46, 0, 1062, CAST(N'2015-12-09 16:11:01.463' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (47, 0, -1, CAST(N'2015-12-09 16:11:27.937' AS DateTime), N'Save', N'Save ContentTypes performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (48, 0, 1070, CAST(N'2015-12-09 16:11:48.473' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (49, 0, 1071, CAST(N'2015-12-09 16:11:54.753' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (50, 0, 1072, CAST(N'2015-12-09 16:12:03.963' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (51, 0, 1073, CAST(N'2015-12-09 16:12:11.470' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (52, 0, 1074, CAST(N'2015-12-09 16:12:18.323' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (53, 0, 1075, CAST(N'2015-12-09 16:12:40.607' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (54, 0, 1075, CAST(N'2015-12-09 16:13:03.393' AS DateTime), N'Delete', N'Delete Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (55, 0, 1076, CAST(N'2015-12-09 16:13:22.453' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (56, 0, 1077, CAST(N'2015-12-09 16:13:40.670' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (57, 0, 1078, CAST(N'2015-12-09 16:13:58.590' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (58, 0, 1079, CAST(N'2015-12-09 16:14:09.287' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (59, 0, 1080, CAST(N'2015-12-09 16:14:19.110' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (60, 0, 0, CAST(N'2015-12-09 16:14:35.743' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (61, 0, 1081, CAST(N'2015-12-09 16:14:43.813' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (62, 0, 1067, CAST(N'2015-12-09 16:15:02.003' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (63, 0, 1055, CAST(N'2015-12-09 16:15:10.940' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (64, 0, 1076, CAST(N'2015-12-09 16:15:36.027' AS DateTime), N'Delete', N'Delete Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (65, 0, 1057, CAST(N'2015-12-09 16:15:46.367' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (66, 0, 1058, CAST(N'2015-12-09 16:15:51.940' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (67, 0, 1057, CAST(N'2015-12-09 16:15:59.137' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (68, 0, 1082, CAST(N'2015-12-09 16:16:37.977' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (69, 0, 1083, CAST(N'2015-12-09 16:16:59.877' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (70, 0, 1084, CAST(N'2015-12-09 16:17:10.057' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (71, 0, 1085, CAST(N'2015-12-09 16:17:18.907' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (72, 0, 1086, CAST(N'2015-12-09 16:17:24.833' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (73, 0, 1087, CAST(N'2015-12-09 16:17:30.680' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (74, 0, 1088, CAST(N'2015-12-09 16:17:37.067' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (75, 0, 1055, CAST(N'2015-12-09 16:17:53.993' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (76, 0, 1065, CAST(N'2015-12-09 16:18:33.537' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (77, 0, 1068, CAST(N'2015-12-09 16:18:49.767' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (78, 0, 1082, CAST(N'2015-12-09 16:18:58.773' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (79, 0, 1053, CAST(N'2015-12-09 16:19:10.747' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (80, 0, 1066, CAST(N'2015-12-09 16:19:32.793' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (81, 0, 1056, CAST(N'2015-12-09 16:19:42.277' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (82, 0, 1054, CAST(N'2015-12-09 16:19:53.963' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (83, 0, 1054, CAST(N'2015-12-09 16:20:07.710' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (84, 0, 1089, CAST(N'2015-12-09 16:20:17.290' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (85, 0, 1054, CAST(N'2015-12-09 16:20:23.923' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (86, 0, 1090, CAST(N'2015-12-09 16:20:44.413' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (87, 0, 1084, CAST(N'2015-12-09 16:21:01.177' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (88, 0, 1091, CAST(N'2015-12-09 16:21:08.450' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (89, 0, 1090, CAST(N'2015-12-09 16:21:15.730' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (90, 0, 0, CAST(N'2015-12-09 16:21:25.057' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (91, 0, 1092, CAST(N'2015-12-09 16:21:33.397' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (92, 0, 0, CAST(N'2015-12-09 16:21:37.493' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (93, 0, 1093, CAST(N'2015-12-09 16:21:43.093' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (94, 0, 0, CAST(N'2015-12-09 16:21:48.757' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (95, 0, 1094, CAST(N'2015-12-09 16:21:54.287' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (96, 0, 0, CAST(N'2015-12-09 16:21:58.833' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (97, 0, 1095, CAST(N'2015-12-09 16:22:07.263' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (98, 0, 0, CAST(N'2015-12-09 16:22:11.730' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (99, 0, 1096, CAST(N'2015-12-09 16:22:20.737' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (100, 0, 1083, CAST(N'2015-12-09 16:22:30.470' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (101, 0, 1095, CAST(N'2015-12-09 16:22:37.017' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (102, 0, 1093, CAST(N'2015-12-09 16:22:45.867' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (103, 0, 1094, CAST(N'2015-12-09 16:22:45.880' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (104, 0, 1095, CAST(N'2015-12-09 16:22:45.893' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (105, 0, 1096, CAST(N'2015-12-09 16:22:45.903' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (106, 0, 1092, CAST(N'2015-12-09 16:22:45.907' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (107, 0, 1097, CAST(N'2015-12-09 16:22:57.477' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (108, 0, 1098, CAST(N'2015-12-09 16:23:04.400' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (109, 0, 1099, CAST(N'2015-12-09 16:23:06.170' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (110, 0, 1100, CAST(N'2015-12-09 16:23:08.160' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (111, 0, 1101, CAST(N'2015-12-09 16:23:10.000' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (112, 0, 1070, CAST(N'2015-12-09 16:23:22.790' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (113, 0, 1098, CAST(N'2015-12-09 16:23:30.500' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (114, 0, 1099, CAST(N'2015-12-09 16:23:30.533' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (115, 0, 1100, CAST(N'2015-12-09 16:23:30.537' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (116, 0, 1101, CAST(N'2015-12-09 16:23:30.547' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (117, 0, 1097, CAST(N'2015-12-09 16:23:30.550' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (118, 0, 1102, CAST(N'2015-12-09 16:23:43.190' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (119, 0, 1103, CAST(N'2015-12-09 16:23:46.510' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (120, 0, 1104, CAST(N'2015-12-09 16:23:48.247' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (121, 0, 1105, CAST(N'2015-12-09 16:23:49.990' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (122, 0, 1106, CAST(N'2015-12-09 16:23:51.820' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (123, 0, 1103, CAST(N'2015-12-09 16:23:56.730' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (124, 0, 1104, CAST(N'2015-12-09 16:23:56.743' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (125, 0, 1105, CAST(N'2015-12-09 16:23:56.753' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (126, 0, 1106, CAST(N'2015-12-09 16:23:56.767' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (127, 0, 1102, CAST(N'2015-12-09 16:23:56.770' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (128, 0, 1107, CAST(N'2015-12-09 16:24:17.247' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (129, 0, 1108, CAST(N'2015-12-09 16:24:25.527' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (130, 0, 1109, CAST(N'2015-12-09 16:24:25.540' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (131, 0, 1110, CAST(N'2015-12-09 16:24:25.550' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (132, 0, 1111, CAST(N'2015-12-09 16:24:25.560' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (133, 0, 1107, CAST(N'2015-12-09 16:24:25.563' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (134, 0, 1107, CAST(N'2015-12-09 16:24:32.620' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (135, 0, 1112, CAST(N'2015-12-09 16:24:50.200' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (136, 0, 1103, CAST(N'2015-12-09 16:25:00.970' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (137, 0, 1104, CAST(N'2015-12-09 16:25:00.997' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (138, 0, 1105, CAST(N'2015-12-09 16:25:01.007' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (139, 0, 1106, CAST(N'2015-12-09 16:25:01.013' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (140, 0, 1102, CAST(N'2015-12-09 16:25:01.017' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (141, 0, 1117, CAST(N'2015-12-09 16:25:08.540' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (142, 0, 1108, CAST(N'2015-12-09 16:25:14.637' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (143, 0, 1109, CAST(N'2015-12-09 16:25:18.187' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (144, 0, 1110, CAST(N'2015-12-09 16:25:20.343' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (145, 0, 1111, CAST(N'2015-12-09 16:25:22.293' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (146, 0, 1113, CAST(N'2015-12-09 16:25:25.277' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (147, 0, 1114, CAST(N'2015-12-09 16:25:27.127' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (148, 0, 1115, CAST(N'2015-12-09 16:25:28.813' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (149, 0, 1116, CAST(N'2015-12-09 16:25:30.743' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (150, 0, 1118, CAST(N'2015-12-09 16:25:34.267' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (151, 0, 1119, CAST(N'2015-12-09 16:25:36.363' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (152, 0, 1120, CAST(N'2015-12-09 16:25:38.280' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (153, 0, 1121, CAST(N'2015-12-09 16:25:40.970' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (154, 0, 0, CAST(N'2015-12-09 16:25:50.203' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (155, 0, 1122, CAST(N'2015-12-09 16:26:13.163' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (156, 0, 0, CAST(N'2015-12-09 16:26:16.580' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (157, 0, 1123, CAST(N'2015-12-09 16:26:22.427' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (158, 0, 0, CAST(N'2015-12-09 16:26:27.313' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (159, 0, 1124, CAST(N'2015-12-09 16:26:34.463' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (160, 0, 0, CAST(N'2015-12-09 16:26:37.770' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (161, 0, 1125, CAST(N'2015-12-09 16:26:47.927' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (162, 0, 0, CAST(N'2015-12-09 16:26:50.777' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (163, 0, 1126, CAST(N'2015-12-09 16:26:56.713' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (164, 0, 0, CAST(N'2015-12-09 16:26:59.433' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (165, 0, 1127, CAST(N'2015-12-09 16:27:03.993' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (166, 0, 0, CAST(N'2015-12-09 16:27:07.127' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (167, 0, 1128, CAST(N'2015-12-09 16:27:16.627' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (168, 0, 1123, CAST(N'2015-12-09 16:27:51.080' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (169, 0, 1124, CAST(N'2015-12-09 16:27:51.093' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (170, 0, 1125, CAST(N'2015-12-09 16:27:51.107' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (171, 0, 1126, CAST(N'2015-12-09 16:27:51.117' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (172, 0, 1127, CAST(N'2015-12-09 16:27:51.127' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (173, 0, 1128, CAST(N'2015-12-09 16:27:51.133' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (174, 0, 1122, CAST(N'2015-12-09 16:27:51.137' AS DateTime), N'Copy', N'Copy Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (175, 0, 1129, CAST(N'2015-12-09 16:28:01.027' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (176, 0, 1130, CAST(N'2015-12-09 16:28:04.857' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (177, 0, 1131, CAST(N'2015-12-09 16:28:06.620' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (178, 0, 1132, CAST(N'2015-12-09 16:28:08.207' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (179, 0, 1133, CAST(N'2015-12-09 16:28:09.843' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (180, 0, 1134, CAST(N'2015-12-09 16:28:11.463' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (181, 0, 1135, CAST(N'2015-12-09 16:28:13.283' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (182, 0, 1135, CAST(N'2015-12-09 16:28:15.033' AS DateTime), N'Save', N'Save Content performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (183, 0, 0, CAST(N'2015-12-09 16:29:17.570' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (184, 0, 1136, CAST(N'2015-12-09 16:29:23.973' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (185, 0, 0, CAST(N'2015-12-09 16:29:28.933' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (186, 0, 1137, CAST(N'2015-12-09 16:29:36.487' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (187, 0, 0, CAST(N'2015-12-09 16:29:40.597' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (188, 0, 1138, CAST(N'2015-12-09 16:29:46.160' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (189, 0, 0, CAST(N'2015-12-09 16:29:49.347' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (190, 0, 1139, CAST(N'2015-12-09 16:29:54.107' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (191, 0, 0, CAST(N'2015-12-09 16:29:58.463' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (192, 0, 1140, CAST(N'2015-12-09 16:30:03.400' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (193, 0, 0, CAST(N'2015-12-09 16:30:06.207' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (194, 0, 1141, CAST(N'2015-12-09 16:30:13.507' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (195, 0, 1141, CAST(N'2015-12-09 16:30:21.730' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (196, 0, 0, CAST(N'2015-12-09 16:30:27.737' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (197, 0, 1142, CAST(N'2015-12-09 16:30:34.417' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (198, 0, 0, CAST(N'2015-12-09 16:30:40.117' AS DateTime), N'New', N'Content '''' was created')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (199, 0, 1143, CAST(N'2015-12-09 16:30:46.587' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (200, 0, 1066, CAST(N'2015-12-09 16:31:01.167' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (201, 0, 1142, CAST(N'2015-12-09 16:31:10.333' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (202, 0, 1071, CAST(N'2015-12-09 16:32:03.950' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (203, 0, 1071, CAST(N'2015-12-09 16:32:05.587' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (204, 0, 1071, CAST(N'2015-12-09 16:32:17.367' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (205, 0, 1071, CAST(N'2015-12-09 16:32:24.603' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (206, 0, 1081, CAST(N'2015-12-09 16:32:38.910' AS DateTime), N'Publish', N'Save and Publish performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (207, 0, -1, CAST(N'2015-12-09 18:44:05.370' AS DateTime), N'Publish', N'ContentService.RebuildXmlStructures completed, the xml has been regenerated in the database')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (208, 0, 1067, CAST(N'2015-12-09 18:44:05.423' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (209, 0, 1080, CAST(N'2015-12-09 18:44:20.263' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (210, 0, 1144, CAST(N'2015-12-09 18:44:36.400' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (211, 0, 1145, CAST(N'2015-12-09 18:45:09.883' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (212, 0, 1144, CAST(N'2015-12-09 18:45:23.803' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (213, 0, 1059, CAST(N'2015-12-09 18:45:37.790' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (214, 0, -1, CAST(N'2015-12-09 18:45:59.193' AS DateTime), N'Publish', N'ContentService.RebuildXmlStructures completed, the xml has been regenerated in the database')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (215, 0, 1066, CAST(N'2015-12-09 18:45:59.203' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (216, 0, 1078, CAST(N'2015-12-09 18:46:09.277' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (217, 0, 1146, CAST(N'2015-12-09 18:46:24.417' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (218, 0, 1147, CAST(N'2015-12-09 18:46:39.387' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (219, 0, 1146, CAST(N'2015-12-09 18:46:48.093' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (220, 0, 1061, CAST(N'2015-12-09 18:46:55.793' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (221, 0, 1061, CAST(N'2015-12-09 18:46:57.217' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (222, 0, 1059, CAST(N'2015-12-09 18:47:19.670' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (223, 0, 1067, CAST(N'2015-12-09 18:47:39.000' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (224, 0, 1144, CAST(N'2015-12-09 18:47:49.287' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (225, 0, 1083, CAST(N'2015-12-09 18:47:56.333' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (226, 0, 1055, CAST(N'2015-12-09 18:48:03.567' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (227, 0, 1057, CAST(N'2015-12-09 18:48:33.060' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (228, 0, 1058, CAST(N'2015-12-09 18:48:49.487' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (229, 0, 1065, CAST(N'2015-12-09 18:48:58.053' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (230, 0, 1082, CAST(N'2015-12-09 18:49:13.613' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (231, 0, 1068, CAST(N'2015-12-09 18:49:21.730' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (232, 0, 1062, CAST(N'2015-12-09 18:49:32.160' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (233, 0, 1062, CAST(N'2015-12-09 18:49:39.193' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (234, 0, 1053, CAST(N'2015-12-09 18:50:00.557' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (235, 0, 1061, CAST(N'2015-12-09 18:50:09.187' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (236, 0, 1066, CAST(N'2015-12-09 18:50:21.300' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (237, 0, 1146, CAST(N'2015-12-09 18:50:28.820' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (238, 0, 1056, CAST(N'2015-12-09 18:50:37.123' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (239, 0, 1090, CAST(N'2015-12-09 18:50:57.253' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (240, 0, 1084, CAST(N'2015-12-09 18:51:06.600' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (241, 0, 1063, CAST(N'2015-12-09 18:51:15.827' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (242, 0, 1084, CAST(N'2015-12-09 18:51:24.907' AS DateTime), N'Save', N'Save ContentType performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (243, 0, 1071, CAST(N'2015-12-09 18:52:09.437' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (244, 0, 1071, CAST(N'2015-12-09 18:52:10.827' AS DateTime), N'Save', N'Save Template performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (245, 0, -1, CAST(N'2015-12-09 19:13:30.890' AS DateTime), N'PackagerInstall', N'Package ''uCommerce 6.9.0.15323'' installed. Package guid: ')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (246, 0, -1, CAST(N'2015-12-09 19:13:39.793' AS DateTime), N'Save', N'Save ContentTypes performed by user')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (247, 0, -1, CAST(N'2015-12-09 19:14:12.257' AS DateTime), N'System', N'Starting migrations for ''uCommerceDB''')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (248, 0, -1, CAST(N'2015-12-09 19:14:12.297' AS DateTime), N'System', N'Current schema version is ''-1''')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (249, 0, -1, CAST(N'2015-12-09 19:14:12.300' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.001.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (250, 0, -1, CAST(N'2015-12-09 19:14:13.400' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.001.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (251, 0, -1, CAST(N'2015-12-09 19:14:13.400' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.002.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (252, 0, -1, CAST(N'2015-12-09 19:14:13.400' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.002.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (253, 0, -1, CAST(N'2015-12-09 19:14:13.400' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.003.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (254, 0, -1, CAST(N'2015-12-09 19:14:13.403' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.004.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (255, 0, -1, CAST(N'2015-12-09 19:14:13.403' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.003.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (256, 0, -1, CAST(N'2015-12-09 19:14:13.407' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.004.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (257, 0, -1, CAST(N'2015-12-09 19:14:13.410' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.005.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (258, 0, -1, CAST(N'2015-12-09 19:14:13.417' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.006.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (259, 0, -1, CAST(N'2015-12-09 19:14:13.417' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.005.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (260, 0, -1, CAST(N'2015-12-09 19:14:13.427' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.007.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (261, 0, -1, CAST(N'2015-12-09 19:14:13.427' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.006.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (262, 0, -1, CAST(N'2015-12-09 19:14:13.433' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.008.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (263, 0, -1, CAST(N'2015-12-09 19:14:13.433' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.007.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (264, 0, -1, CAST(N'2015-12-09 19:14:13.440' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.009.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (265, 0, -1, CAST(N'2015-12-09 19:14:13.440' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.008.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (266, 0, -1, CAST(N'2015-12-09 19:14:13.453' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.010.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (267, 0, -1, CAST(N'2015-12-09 19:14:13.453' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.009.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (268, 0, -1, CAST(N'2015-12-09 19:14:13.460' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.010.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (269, 0, -1, CAST(N'2015-12-09 19:14:13.460' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.011.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (270, 0, -1, CAST(N'2015-12-09 19:14:13.470' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.011.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (271, 0, -1, CAST(N'2015-12-09 19:14:13.470' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.012.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (272, 0, -1, CAST(N'2015-12-09 19:14:13.477' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.013.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (273, 0, -1, CAST(N'2015-12-09 19:14:13.477' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.012.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (274, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.013.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (275, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.014.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (276, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.014.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (277, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.015.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (278, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.015.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (279, 0, -1, CAST(N'2015-12-09 19:14:13.480' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.016.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (280, 0, -1, CAST(N'2015-12-09 19:14:13.483' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.017.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (281, 0, -1, CAST(N'2015-12-09 19:14:13.483' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.016.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (282, 0, -1, CAST(N'2015-12-09 19:14:13.490' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.017.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (283, 0, -1, CAST(N'2015-12-09 19:14:13.490' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.018.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (284, 0, -1, CAST(N'2015-12-09 19:14:13.503' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.018.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (285, 0, -1, CAST(N'2015-12-09 19:14:13.503' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.019.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (286, 0, -1, CAST(N'2015-12-09 19:14:13.503' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.019.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (287, 0, -1, CAST(N'2015-12-09 19:14:13.503' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.020.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (288, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.020.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (289, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.021.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (290, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.021.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (291, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.022.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (292, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.023.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (293, 0, -1, CAST(N'2015-12-09 19:14:13.507' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.022.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (294, 0, -1, CAST(N'2015-12-09 19:14:13.513' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.023.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (295, 0, -1, CAST(N'2015-12-09 19:14:13.513' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.024.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (296, 0, -1, CAST(N'2015-12-09 19:14:13.517' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.024.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (297, 0, -1, CAST(N'2015-12-09 19:14:13.517' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.025.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (298, 0, -1, CAST(N'2015-12-09 19:14:13.517' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.025.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (299, 0, -1, CAST(N'2015-12-09 19:14:13.517' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.026.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (300, 0, -1, CAST(N'2015-12-09 19:14:13.520' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.027.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (301, 0, -1, CAST(N'2015-12-09 19:14:13.520' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.026.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (302, 0, -1, CAST(N'2015-12-09 19:14:13.530' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.027.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (303, 0, -1, CAST(N'2015-12-09 19:14:13.530' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.028.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (304, 0, -1, CAST(N'2015-12-09 19:14:13.533' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.029.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (305, 0, -1, CAST(N'2015-12-09 19:14:13.533' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.028.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (306, 0, -1, CAST(N'2015-12-09 19:14:13.540' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.030.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (307, 0, -1, CAST(N'2015-12-09 19:14:13.540' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.029.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (308, 0, -1, CAST(N'2015-12-09 19:14:13.540' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.030.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (309, 0, -1, CAST(N'2015-12-09 19:14:13.540' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.031.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (310, 0, -1, CAST(N'2015-12-09 19:14:13.543' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.031.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (311, 0, -1, CAST(N'2015-12-09 19:14:13.543' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.032.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (312, 0, -1, CAST(N'2015-12-09 19:14:13.560' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.032.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (313, 0, -1, CAST(N'2015-12-09 19:14:13.560' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.033.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (314, 0, -1, CAST(N'2015-12-09 19:14:13.563' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.034.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (315, 0, -1, CAST(N'2015-12-09 19:14:13.563' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.033.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (316, 0, -1, CAST(N'2015-12-09 19:14:13.580' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.035.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (317, 0, -1, CAST(N'2015-12-09 19:14:13.580' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.034.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (318, 0, -1, CAST(N'2015-12-09 19:14:13.590' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.036.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (319, 0, -1, CAST(N'2015-12-09 19:14:13.590' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.035.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (320, 0, -1, CAST(N'2015-12-09 19:14:13.597' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.037.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (321, 0, -1, CAST(N'2015-12-09 19:14:13.597' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.036.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (322, 0, -1, CAST(N'2015-12-09 19:14:13.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.037.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (323, 0, -1, CAST(N'2015-12-09 19:14:13.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.038.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (324, 0, -1, CAST(N'2015-12-09 19:14:13.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.038.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (325, 0, -1, CAST(N'2015-12-09 19:14:13.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.039.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (326, 0, -1, CAST(N'2015-12-09 19:14:13.607' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.039.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (327, 0, -1, CAST(N'2015-12-09 19:14:13.607' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.040.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (328, 0, -1, CAST(N'2015-12-09 19:14:13.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.040.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (329, 0, -1, CAST(N'2015-12-09 19:14:13.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.041.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (330, 0, -1, CAST(N'2015-12-09 19:14:13.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.041.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (331, 0, -1, CAST(N'2015-12-09 19:14:13.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.042.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (332, 0, -1, CAST(N'2015-12-09 19:14:13.620' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.042.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (333, 0, -1, CAST(N'2015-12-09 19:14:13.620' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.043.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (334, 0, -1, CAST(N'2015-12-09 19:14:13.740' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.044.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (335, 0, -1, CAST(N'2015-12-09 19:14:13.743' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.043.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (336, 0, -1, CAST(N'2015-12-09 19:14:13.747' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.045.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (337, 0, -1, CAST(N'2015-12-09 19:14:13.747' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.044.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (338, 0, -1, CAST(N'2015-12-09 19:14:13.803' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.045.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (339, 0, -1, CAST(N'2015-12-09 19:14:13.803' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.046.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (340, 0, -1, CAST(N'2015-12-09 19:14:13.813' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.047.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (341, 0, -1, CAST(N'2015-12-09 19:14:13.813' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.046.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (342, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.048.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (343, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.047.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (344, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.048.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (345, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.049.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (346, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.049.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (347, 0, -1, CAST(N'2015-12-09 19:14:13.827' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.050.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (348, 0, -1, CAST(N'2015-12-09 19:14:13.830' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.051.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (349, 0, -1, CAST(N'2015-12-09 19:14:13.830' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.050.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (350, 0, -1, CAST(N'2015-12-09 19:14:13.833' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.052.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (351, 0, -1, CAST(N'2015-12-09 19:14:13.833' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.051.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (352, 0, -1, CAST(N'2015-12-09 19:14:13.837' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.052.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (353, 0, -1, CAST(N'2015-12-09 19:14:13.837' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.053.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (354, 0, -1, CAST(N'2015-12-09 19:14:13.840' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.053.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (355, 0, -1, CAST(N'2015-12-09 19:14:13.840' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.054.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (356, 0, -1, CAST(N'2015-12-09 19:14:13.843' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.054.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (357, 0, -1, CAST(N'2015-12-09 19:14:13.843' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.055.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (358, 0, -1, CAST(N'2015-12-09 19:14:13.843' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.055.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (359, 0, -1, CAST(N'2015-12-09 19:14:13.843' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.056.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (360, 0, -1, CAST(N'2015-12-09 19:14:13.850' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.057.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (361, 0, -1, CAST(N'2015-12-09 19:14:13.850' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.056.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (362, 0, -1, CAST(N'2015-12-09 19:14:13.947' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.058.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (363, 0, -1, CAST(N'2015-12-09 19:14:13.947' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.057.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (364, 0, -1, CAST(N'2015-12-09 19:14:13.950' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.058.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (365, 0, -1, CAST(N'2015-12-09 19:14:13.950' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.059.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (366, 0, -1, CAST(N'2015-12-09 19:14:13.960' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.060.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (367, 0, -1, CAST(N'2015-12-09 19:14:13.960' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.059.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (368, 0, -1, CAST(N'2015-12-09 19:14:13.963' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.060.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (369, 0, -1, CAST(N'2015-12-09 19:14:13.963' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.061.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (370, 0, -1, CAST(N'2015-12-09 19:14:13.967' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.061.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (371, 0, -1, CAST(N'2015-12-09 19:14:13.967' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.062.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (372, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.062.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (373, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.063.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (374, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.063.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (375, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.064.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (376, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.064.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (377, 0, -1, CAST(N'2015-12-09 19:14:13.970' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.065.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (378, 0, -1, CAST(N'2015-12-09 19:14:13.973' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.065.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (379, 0, -1, CAST(N'2015-12-09 19:14:13.973' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.066.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (380, 0, -1, CAST(N'2015-12-09 19:14:13.973' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.066.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (381, 0, -1, CAST(N'2015-12-09 19:14:13.973' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.067.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (382, 0, -1, CAST(N'2015-12-09 19:14:13.977' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.067.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (383, 0, -1, CAST(N'2015-12-09 19:14:13.977' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.068.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (384, 0, -1, CAST(N'2015-12-09 19:14:13.977' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.069.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (385, 0, -1, CAST(N'2015-12-09 19:14:13.977' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.068.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (386, 0, -1, CAST(N'2015-12-09 19:14:13.980' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.070.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (387, 0, -1, CAST(N'2015-12-09 19:14:13.980' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.069.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (388, 0, -1, CAST(N'2015-12-09 19:14:13.983' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.070.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (389, 0, -1, CAST(N'2015-12-09 19:14:13.983' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.071.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (390, 0, -1, CAST(N'2015-12-09 19:14:13.997' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.071.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (391, 0, -1, CAST(N'2015-12-09 19:14:13.997' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.072.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (392, 0, -1, CAST(N'2015-12-09 19:14:14.000' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.073.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (393, 0, -1, CAST(N'2015-12-09 19:14:14.000' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.072.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (394, 0, -1, CAST(N'2015-12-09 19:14:14.010' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.074.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (395, 0, -1, CAST(N'2015-12-09 19:14:14.010' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.073.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (396, 0, -1, CAST(N'2015-12-09 19:14:14.010' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.075.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (397, 0, -1, CAST(N'2015-12-09 19:14:14.010' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.074.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (398, 0, -1, CAST(N'2015-12-09 19:14:14.037' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.075.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (399, 0, -1, CAST(N'2015-12-09 19:14:14.037' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.076.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (400, 0, -1, CAST(N'2015-12-09 19:14:14.063' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.077.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (401, 0, -1, CAST(N'2015-12-09 19:14:14.067' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.076.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (402, 0, -1, CAST(N'2015-12-09 19:14:14.093' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.078.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (403, 0, -1, CAST(N'2015-12-09 19:14:14.093' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.077.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (404, 0, -1, CAST(N'2015-12-09 19:14:14.123' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.078.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (405, 0, -1, CAST(N'2015-12-09 19:14:14.123' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.079.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (406, 0, -1, CAST(N'2015-12-09 19:14:14.180' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.080.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (407, 0, -1, CAST(N'2015-12-09 19:14:14.180' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.079.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (408, 0, -1, CAST(N'2015-12-09 19:14:14.210' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.080.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (409, 0, -1, CAST(N'2015-12-09 19:14:14.210' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.081.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (410, 0, -1, CAST(N'2015-12-09 19:14:14.213' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.082.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (411, 0, -1, CAST(N'2015-12-09 19:14:14.213' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.081.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (412, 0, -1, CAST(N'2015-12-09 19:14:14.240' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.083.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (413, 0, -1, CAST(N'2015-12-09 19:14:14.240' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.082.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (414, 0, -1, CAST(N'2015-12-09 19:14:14.250' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.084.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (415, 0, -1, CAST(N'2015-12-09 19:14:14.250' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.083.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (416, 0, -1, CAST(N'2015-12-09 19:14:14.250' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.084.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (417, 0, -1, CAST(N'2015-12-09 19:14:14.250' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.085.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (418, 0, -1, CAST(N'2015-12-09 19:14:14.257' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.085.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (419, 0, -1, CAST(N'2015-12-09 19:14:14.257' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.086.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (420, 0, -1, CAST(N'2015-12-09 19:14:14.280' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.087.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (421, 0, -1, CAST(N'2015-12-09 19:14:14.280' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.086.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (422, 0, -1, CAST(N'2015-12-09 19:14:14.290' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.088.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (423, 0, -1, CAST(N'2015-12-09 19:14:14.290' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.087.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (424, 0, -1, CAST(N'2015-12-09 19:14:14.320' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.089.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (425, 0, -1, CAST(N'2015-12-09 19:14:14.320' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.088.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (426, 0, -1, CAST(N'2015-12-09 19:14:14.323' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.089.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (427, 0, -1, CAST(N'2015-12-09 19:14:14.323' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.090.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (428, 0, -1, CAST(N'2015-12-09 19:14:14.323' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.091.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (429, 0, -1, CAST(N'2015-12-09 19:14:14.323' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.090.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (430, 0, -1, CAST(N'2015-12-09 19:14:14.330' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.091.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (431, 0, -1, CAST(N'2015-12-09 19:14:14.330' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.092.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (432, 0, -1, CAST(N'2015-12-09 19:14:14.340' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.092.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (433, 0, -1, CAST(N'2015-12-09 19:14:14.340' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.093.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (434, 0, -1, CAST(N'2015-12-09 19:14:14.353' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.093.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (435, 0, -1, CAST(N'2015-12-09 19:14:14.353' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.094.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (436, 0, -1, CAST(N'2015-12-09 19:14:14.353' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.094.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (437, 0, -1, CAST(N'2015-12-09 19:14:14.353' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.095.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (438, 0, -1, CAST(N'2015-12-09 19:14:14.360' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.096.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (439, 0, -1, CAST(N'2015-12-09 19:14:14.360' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.095.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (440, 0, -1, CAST(N'2015-12-09 19:14:14.363' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.096.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (441, 0, -1, CAST(N'2015-12-09 19:14:14.363' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.097.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (442, 0, -1, CAST(N'2015-12-09 19:14:14.367' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.098.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (443, 0, -1, CAST(N'2015-12-09 19:14:14.367' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.097.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (444, 0, -1, CAST(N'2015-12-09 19:14:14.373' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.098.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (445, 0, -1, CAST(N'2015-12-09 19:14:14.373' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.099.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (446, 0, -1, CAST(N'2015-12-09 19:14:14.377' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.100.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (447, 0, -1, CAST(N'2015-12-09 19:14:14.377' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.099.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (448, 0, -1, CAST(N'2015-12-09 19:14:14.380' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.101.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (449, 0, -1, CAST(N'2015-12-09 19:14:14.380' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.100.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (450, 0, -1, CAST(N'2015-12-09 19:14:14.383' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.101.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (451, 0, -1, CAST(N'2015-12-09 19:14:14.383' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.102.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (452, 0, -1, CAST(N'2015-12-09 19:14:14.410' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.102.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (453, 0, -1, CAST(N'2015-12-09 19:14:14.410' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.103.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (454, 0, -1, CAST(N'2015-12-09 19:14:14.430' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.104.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (455, 0, -1, CAST(N'2015-12-09 19:14:14.430' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.103.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (456, 0, -1, CAST(N'2015-12-09 19:14:14.440' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.104.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (457, 0, -1, CAST(N'2015-12-09 19:14:14.440' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.105.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (458, 0, -1, CAST(N'2015-12-09 19:14:14.443' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.105.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (459, 0, -1, CAST(N'2015-12-09 19:14:14.443' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.106.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (460, 0, -1, CAST(N'2015-12-09 19:14:14.463' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.106.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (461, 0, -1, CAST(N'2015-12-09 19:14:14.463' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.107.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (462, 0, -1, CAST(N'2015-12-09 19:14:14.463' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.107.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (463, 0, -1, CAST(N'2015-12-09 19:14:14.463' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.108.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (464, 0, -1, CAST(N'2015-12-09 19:14:14.477' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.109.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (465, 0, -1, CAST(N'2015-12-09 19:14:14.477' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.108.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (466, 0, -1, CAST(N'2015-12-09 19:14:14.487' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.110.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (467, 0, -1, CAST(N'2015-12-09 19:14:14.487' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.109.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (468, 0, -1, CAST(N'2015-12-09 19:14:14.500' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.111.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (469, 0, -1, CAST(N'2015-12-09 19:14:14.500' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.110.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (470, 0, -1, CAST(N'2015-12-09 19:14:14.513' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.111.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (471, 0, -1, CAST(N'2015-12-09 19:14:14.513' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.112.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (472, 0, -1, CAST(N'2015-12-09 19:14:14.520' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.112.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (473, 0, -1, CAST(N'2015-12-09 19:14:14.520' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.113.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (474, 0, -1, CAST(N'2015-12-09 19:14:14.527' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.114.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (475, 0, -1, CAST(N'2015-12-09 19:14:14.527' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.113.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (476, 0, -1, CAST(N'2015-12-09 19:14:14.537' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.114.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (477, 0, -1, CAST(N'2015-12-09 19:14:14.537' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.115.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (478, 0, -1, CAST(N'2015-12-09 19:14:14.550' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.116.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (479, 0, -1, CAST(N'2015-12-09 19:14:14.550' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.115.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (480, 0, -1, CAST(N'2015-12-09 19:14:14.560' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.117.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (481, 0, -1, CAST(N'2015-12-09 19:14:14.560' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.116.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (482, 0, -1, CAST(N'2015-12-09 19:14:14.570' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.118.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (483, 0, -1, CAST(N'2015-12-09 19:14:14.570' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.117.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (484, 0, -1, CAST(N'2015-12-09 19:14:14.577' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.119.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (485, 0, -1, CAST(N'2015-12-09 19:14:14.577' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.118.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (486, 0, -1, CAST(N'2015-12-09 19:14:14.590' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.119.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (487, 0, -1, CAST(N'2015-12-09 19:14:14.590' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.120.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (488, 0, -1, CAST(N'2015-12-09 19:14:14.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.121.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (489, 0, -1, CAST(N'2015-12-09 19:14:14.600' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.120.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (490, 0, -1, CAST(N'2015-12-09 19:14:14.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.122.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (491, 0, -1, CAST(N'2015-12-09 19:14:14.610' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.121.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (492, 0, -1, CAST(N'2015-12-09 19:14:14.620' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.123.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (493, 0, -1, CAST(N'2015-12-09 19:14:14.620' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.122.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (494, 0, -1, CAST(N'2015-12-09 19:14:14.630' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.123.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (495, 0, -1, CAST(N'2015-12-09 19:14:14.630' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.124.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (496, 0, -1, CAST(N'2015-12-09 19:14:14.640' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.124.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (497, 0, -1, CAST(N'2015-12-09 19:14:14.640' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.125.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (498, 0, -1, CAST(N'2015-12-09 19:14:14.653' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.125.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (499, 0, -1, CAST(N'2015-12-09 19:14:14.653' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.126.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (500, 0, -1, CAST(N'2015-12-09 19:14:14.657' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.127.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (501, 0, -1, CAST(N'2015-12-09 19:14:14.657' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.126.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (502, 0, -1, CAST(N'2015-12-09 19:14:14.693' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.128.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (503, 0, -1, CAST(N'2015-12-09 19:14:14.693' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.127.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (504, 0, -1, CAST(N'2015-12-09 19:14:14.730' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.129.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (505, 0, -1, CAST(N'2015-12-09 19:14:14.730' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.128.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (506, 0, -1, CAST(N'2015-12-09 19:14:14.737' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.130.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (507, 0, -1, CAST(N'2015-12-09 19:14:14.737' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.129.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (508, 0, -1, CAST(N'2015-12-09 19:14:14.740' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.131.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (509, 0, -1, CAST(N'2015-12-09 19:14:14.740' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.130.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (510, 0, -1, CAST(N'2015-12-09 19:14:14.740' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.131.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (511, 0, -1, CAST(N'2015-12-09 19:14:14.740' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.132.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (512, 0, -1, CAST(N'2015-12-09 19:14:14.743' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.133.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (513, 0, -1, CAST(N'2015-12-09 19:14:14.743' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.132.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (514, 0, -1, CAST(N'2015-12-09 19:14:14.743' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.134.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (515, 0, -1, CAST(N'2015-12-09 19:14:14.743' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.133.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (516, 0, -1, CAST(N'2015-12-09 19:14:14.747' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.135.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (517, 0, -1, CAST(N'2015-12-09 19:14:14.747' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.134.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (518, 0, -1, CAST(N'2015-12-09 19:14:14.753' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.136.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (519, 0, -1, CAST(N'2015-12-09 19:14:14.753' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.135.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (520, 0, -1, CAST(N'2015-12-09 19:14:14.757' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.136.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (521, 0, -1, CAST(N'2015-12-09 19:14:14.757' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.137.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (522, 0, -1, CAST(N'2015-12-09 19:14:14.767' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.137.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (523, 0, -1, CAST(N'2015-12-09 19:14:14.767' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.138.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (524, 0, -1, CAST(N'2015-12-09 19:14:14.770' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.138.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (525, 0, -1, CAST(N'2015-12-09 19:14:14.770' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.139.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (526, 0, -1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.139.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (527, 0, -1, CAST(N'2015-12-09 19:14:14.773' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.140.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (528, 0, -1, CAST(N'2015-12-09 19:14:14.783' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.140.sql applied successfully.')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (529, 0, -1, CAST(N'2015-12-09 19:14:14.783' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.141.sql starting...')
GO
INSERT [dbo].[umbracoLog] ([id], [userId], [NodeId], [Datestamp], [logHeader], [logComment]) VALUES (530, 0, -1, CAST(N'2015-12-09 19:14:14.813' AS DateTime), N'System', N'uCommerce database migration C:\Study\BL_7.3.4\src\PacDig.BeautyLove.Cms\umbraco\ucommerce\install\uCommerceDB.141.sql applied successfully.')
GO
SET IDENTITY_INSERT [dbo].[umbracoLog] OFF
GO
SET IDENTITY_INSERT [dbo].[umbracoMigration] ON 

GO
INSERT [dbo].[umbracoMigration] ([id], [name], [createDate], [version]) VALUES (1, N'Umbraco', CAST(N'2015-12-09 15:50:49.540' AS DateTime), N'7.3.4')
GO
SET IDENTITY_INSERT [dbo].[umbracoMigration] OFF
GO
SET IDENTITY_INSERT [dbo].[umbracoNode] ON 

GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-97, 0, -1, 0, 1, N'-1,-97', 2, N'aa2c52a0-ce87-4e65-a47c-7df09358585d', N'List View - Members', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-96, 0, -1, 0, 1, N'-1,-96', 2, N'3a0156c4-3b8c-4803-bdc1-6871faa83fff', N'List View - Media', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-95, 0, -1, 0, 1, N'-1,-95', 2, N'c0808dd3-8133-4e4b-8ce8-e2bea84a96a4', N'List View - Content', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-92, 0, -1, 0, 1, N'-1,-92', 35, N'f0bc4bfb-b499-40d6-ba86-058885a5178c', N'Label', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.140' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-90, 0, -1, 0, 1, N'-1,-90', 34, N'84c6b441-31df-4ffe-b67e-67d5bc3ae65a', N'Upload', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-89, 0, -1, 0, 1, N'-1,-89', 33, N'c6bac0dd-4ab9-45b1-8e30-e4b619ee5da3', N'Textarea', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-88, 0, -1, 0, 1, N'-1,-88', 32, N'0cc0eba1-9960-42c9-bf9b-60e150b429ae', N'Textstring', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-87, 0, -1, 0, 1, N'-1,-87', 4, N'ca90c950-0aff-4e72-b976-a30b1ac57dad', N'Richtext editor', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-51, 0, -1, 0, 1, N'-1,-51', 2, N'2e6d3631-066e-44b8-aec4-96f09099b2b5', N'Numeric', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-49, 0, -1, 0, 1, N'-1,-49', 2, N'92897bc6-a5f3-4ffe-ae27-f2e7e33dda49', N'True/false', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-43, 0, -1, 0, 1, N'-1,-43', 2, N'fbaf13a8-4036-41f2-93a3-974f678c312a', N'Checkbox list', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-42, 0, -1, 0, 1, N'-1,-42', 2, N'0b6a45e7-44ba-430d-9da5-4e46060b9e03', N'Dropdown', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.143' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-41, 0, -1, 0, 1, N'-1,-41', 2, N'5046194e-4237-453c-a547-15db3a07c4e1', N'Date Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.147' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-40, 0, -1, 0, 1, N'-1,-40', 2, N'bb5f57c9-ce2b-4bb9-b697-4caca783a805', N'Radiobox', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.147' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-39, 0, -1, 0, 1, N'-1,-39', 2, N'f38f0ac7-1d27-439c-9f3f-089cd8825a53', N'Dropdown multiple', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.147' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-38, 0, -1, 0, 1, N'-1,-38', 2, N'fd9f1447-6c61-4a7c-9595-5aa39147d318', N'Folder Browser', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.147' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-37, 0, -1, 0, 1, N'-1,-37', 2, N'0225af17-b302-49cb-9176-b9f35cab9c17', N'Approved Color', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.147' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-36, 0, -1, 0, 1, N'-1,-36', 2, N'e4d66c0f-b935-4200-81f0-025f7256b89a', N'Date Picker with time', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-21, 0, -1, 0, 0, N'-1,-21', 0, N'bf7c7cbc-952f-4518-97a2-69e9c7b33842', N'Recycle Bin', N'cf3d8e34-1c1c-41e9-ae56-878b57b32113', CAST(N'2015-12-09 15:50:49.140' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-20, 0, -1, 0, 0, N'-1,-20', 0, N'0f582a79-1e41-4cf0-bfa0-76340651891a', N'Recycle Bin', N'01bb7ff2-24dc-4c0c-95a2-c24ef72bbac8', CAST(N'2015-12-09 15:50:49.140' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (-1, 0, -1, 0, 0, N'-1', 0, N'916724a5-173d-4619-b97e-b9de133dd6f5', N'SYSTEM DATA: umbraco master root', N'ea7d8624-4cfe-4578-a871-24aa946bf34d', CAST(N'2015-12-09 15:50:49.137' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1031, 0, -1, 0, 1, N'-1,1031', 2, N'f38bd2d7-65d0-48e6-95dc-87ce06ec2d3d', N'Folder', N'4ea4382b-2f5a-4c2b-9587-ae9b3cf3602e', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1032, 0, -1, 0, 1, N'-1,1032', 2, N'cc07b313-0843-4aa8-bbda-871c8da728c8', N'Image', N'4ea4382b-2f5a-4c2b-9587-ae9b3cf3602e', CAST(N'2015-12-09 15:50:49.150' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1033, 0, -1, 0, 1, N'-1,1033', 2, N'4c52d8ab-54e6-40cd-999c-7a5f24903e4d', N'File', N'4ea4382b-2f5a-4c2b-9587-ae9b3cf3602e', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1034, 0, -1, 0, 1, N'-1,1034', 2, N'a6857c73-d6e9-480c-b6e6-f15f6ad11125', N'Content Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1035, 0, -1, 0, 1, N'-1,1035', 2, N'93929b9a-93a2-4e2a-b239-d99334440a59', N'Media Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1036, 0, -1, 0, 1, N'-1,1036', 2, N'2b24165f-9782-4aa3-b459-1de4a4d21f60', N'Member Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1040, 0, -1, 0, 1, N'-1,1040', 2, N'21e798da-e06e-4eda-a511-ed257f78d4fa', N'Related Links', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1041, 0, -1, 0, 1, N'-1,1041', 2, N'b6b73142-b9c1-4bf8-a16d-e1c23320b549', N'Tags', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1043, 0, -1, 0, 1, N'-1,1043', 2, N'1df9f033-e6d4-451f-b8d2-e0cbc50a836f', N'Image Cropper', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1044, 0, -1, 0, 1, N'-1,1044', 0, N'd59be02f-1df9-4228-aa1e-01917d806cda', N'Member', N'9b5416fb-e72f-45a9-a07b-5a9a2709ce43', CAST(N'2015-12-09 15:50:49.153' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1045, 0, -1, 0, 1, N'-1,1045', 2, N'7e3962cc-ce20-4ffc-b661-5897a894ba7e', N'Multiple Media Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:50:49.157' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1046, 0, -1, 0, 1, N'-1,1046', 25, N'7b5665c7-fba4-444a-8402-b03dcdc21161', N'Multinode Treepicker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:57:43.017' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1047, 0, -1, 0, 1, N'-1,1047', 26, N'fcd011b4-50c0-4448-8b52-bf2f0f2e0036', N'bl-Radio ContentPicker Selection', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:58:51.753' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1048, 0, -1, 0, 1, N'-1,1048', 27, N'8fe6579e-0802-4657-bf03-24f0ef8fdb46', N'bl-SectionType Dropdown', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 15:59:24.440' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1049, 0, -1, 0, 1, N'-1,1049', 28, N'81e76660-7791-4940-9267-31bf5952ca3a', N'bl-MagazineCarousel', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 16:00:11.783' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1050, 0, -1, 0, 1, N'-1,1050', 29, N'2915005d-734c-4df6-8fd9-54b1f659e4c2', N'bl-HeroCarousel Multinode Treepicker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 16:01:40.723' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1051, 0, -1, 0, 1, N'-1,1051', 30, N'773333b3-1b0f-4e8f-8dc6-f83c6af883de', N'bl-Flexible Content Picker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 16:02:18.527' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1052, 0, -1, 0, 1, N'-1,1052', 31, N'6f09ae4a-c00e-4214-a351-3b138aa1fd3d', N'bl-SnapShots Multinode Treepicker', N'30a2a501-1978-4ddb-a57b-f7efed43ba3c', CAST(N'2015-12-09 16:04:35.677' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1053, 0, -1, 0, 1, N'-1,1053', 0, N'9860e26c-2ff4-435f-9af7-e97f93f85ae2', N'Home', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:05:53.443' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1054, 0, -1, 0, 1, N'-1,1054', 1, N'0354312a-b9df-434d-a455-bb682df23236', N'Master', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:06:02.610' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1055, 0, -1, 0, 1, N'-1,1055', 2, N'9bdb268a-1743-41c8-bb11-22a0fa877671', N'Category Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:06:43.963' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1056, 0, -1, 0, 1, N'-1,1056', 3, N'b4a95abf-a64b-4087-b2b8-48fcddd3c7ce', N'How To Sub Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:06:55.043' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1057, 0, -1, 0, 1, N'-1,1057', 4, N'24292d14-7d07-4d3e-97ee-cde57dea55db', N'Content Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:07:07.023' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1058, 0, -1, 0, 1, N'-1,1058', 5, N'be7ff890-dc12-4d93-8b8c-69929eb9716d', N'Content Sub Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:07:18.107' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1059, 0, -1, 0, 1, N'-1,1059', 6, N'a1c915a5-3c23-43d8-bb87-4cf90352f9db', N'Article Content', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:07:34.710' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1060, 0, -1, 0, 1, N'-1,1060', 7, N'83ce4467-98a0-4a9c-9b64-fa3518e2a442', N'Content', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:07:43.810' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1061, 0, -1, 0, 1, N'-1,1061', 8, N'a4424757-b8b7-4d69-8ea3-5c79b90c4537', N'How To Content', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:07:56.093' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1062, 0, -1, 0, 1, N'-1,1062', 9, N'd64d6b3d-6fe8-4d19-9401-c5e56c84fd58', N'Gallery Content', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:08:02.793' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1063, 0, -1, 0, 1, N'-1,1063', 10, N'cc38b565-6122-47b6-9eec-d2c5a54d4306', N'Tag Library', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:08:25.387' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1064, 0, -1, 0, 1, N'-1,1064', 11, N'f8e580c0-deba-42c0-84aa-9ab5f168c418', N'Footer Node ', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:08:59.203' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1065, 0, -1, 0, 1, N'-1,1065', 12, N'300083f4-3ed2-404e-8e1e-015c7b0555e3', N'Footer Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:09:06.450' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1066, 0, -1, 0, 1, N'-1,1066', 13, N'987fa7ff-21d4-4036-a6a5-dc9afd3e7f74', N'How to Page Landscape', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:10:03.413' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1067, 0, -1, 0, 1, N'-1,1067', 14, N'6439ae0d-ccea-46a1-93d3-08af840b36ea', N'Article Page Landscape', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:10:21.183' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1068, 0, -1, 0, 1, N'-1,1068', 15, N'996ad4a7-a38b-4c81-b624-030055c2dc47', N'Gallery Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:10:51.780' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1069, 0, -1, 0, 1, N'-1,1069', 16, N'87b5d895-48c2-40fb-b946-203467d88ca2', N'Open Graph Tags', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:11:27.910' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1070, 0, -1, NULL, 1, N'-1,1070', 0, N'cfab856c-37d4-47c6-8846-c176326bf009', N'Master', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:11:48.447' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1071, 0, 1070, NULL, 1, N'-1,1070,1071', 0, N'5481f759-602f-4c64-99c1-e8241de7fb91', N'Home', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:11:54.747' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1072, 0, 1070, NULL, 1, N'-1,1070,1072', 0, N'ba05a114-bf6d-4e00-8f9e-da9847d78660', N'Category Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:12:03.953' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1073, 0, 1070, NULL, 1, N'-1,1070,1073', 0, N'fc2946da-6aa4-4728-a802-9409149b16a0', N'Content Sub Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:12:11.460' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1074, 0, 1070, NULL, 1, N'-1,1070,1074', 0, N'418c57f4-6385-49f2-87f1-0099871225ac', N'Content Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:12:18.313' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1077, 0, 1070, NULL, 1, N'-1,1070,1077', 0, N'e2b7229e-e713-4a77-83d5-10482f1ed0a6', N'Footer Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:13:40.660' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1078, 0, 1070, NULL, 1, N'-1,1070,1078', 0, N'f025cc50-3f84-44d1-af77-6d833f765f37', N'How To Page Landscape', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:13:58.583' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1079, 0, 1070, NULL, 1, N'-1,1070,1079', 0, N'45667093-fcbe-4a46-9f01-32ea86801863', N'Gallery Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:14:09.283' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1080, 0, 1070, NULL, 1, N'-1,1070,1080', 0, N'68da3bee-9f9a-45a5-b0ae-aa4af0500868', N'Article Page Landscape', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:14:19.100' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1081, 0, -1, 0, 1, N'-1,1081', 0, N'd5bbd0a4-2ff3-40c6-a2e1-6055cd6533f2', N'Home', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:14:43.727' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1082, 0, -1, 0, 1, N'-1,1082', 17, N'7486f33c-ba99-465e-93b5-5f733274831d', N'Gallery Sub Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:16:37.970' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1083, 0, -1, 0, 1, N'-1,1083', 18, N'fdf2e68c-77b9-495d-9740-da125aff50f7', N'Article Sub Section Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:16:59.867' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1084, 0, -1, 0, 1, N'-1,1084', 19, N'cd445304-39e5-4754-89a2-2cb3b1eda943', N'Product Listing Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:17:10.040' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1085, 0, 1070, NULL, 1, N'-1,1070,1085', 0, N'073fd264-c564-444f-9e92-692d8378da32', N'How To Sub Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:17:18.877' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1086, 0, 1070, NULL, 1, N'-1,1070,1086', 0, N'7a7948fc-92f5-4594-8184-ac818711e2e0', N'Article Sub Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:17:24.827' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1087, 0, 1070, NULL, 1, N'-1,1070,1087', 0, N'1e87d638-d726-4b1e-9a84-3e4ba8c168ae', N'Gallery Sub Section Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:17:30.667' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1088, 0, 1070, NULL, 1, N'-1,1070,1088', 0, N'ea5968c8-09d0-4dcb-ba69-2b408867d663', N'Product Listing Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:17:37.057' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1089, 0, -1, 0, 1, N'-1,1089', 20, N'9fe506c6-d0b4-4d65-90de-b843b8b1fd89', N'SEO Tags', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:20:17.277' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1090, 0, -1, 0, 1, N'-1,1090', 21, N'7e3f75ad-18f1-44a0-96c9-2d6e7de54b73', N'Product Details Page', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 16:20:44.403' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1091, 0, 1070, NULL, 1, N'-1,1070,1091', 0, N'6ddddba1-5dc9-4638-8471-a30693f63948', N'Product Details Page', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 16:21:08.443' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1092, 0, 1081, 0, 2, N'-1,1081,1092', 0, N'8e298837-8fa8-43b5-a160-75f530bfc520', N'Hair', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:21:33.380' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1093, 0, 1092, 0, 3, N'-1,1081,1092,1093', 0, N'72baa200-98dd-4ca0-b6f1-8388bb5516c4', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:21:43.073' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1094, 0, 1092, 0, 3, N'-1,1081,1092,1094', 1, N'e92458c3-320a-40ae-9d0f-3e588fcda0ce', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:21:54.250' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1095, 0, 1092, 0, 3, N'-1,1081,1092,1095', 2, N'b9611d65-763e-4a7a-8b0c-29fbb15e60f2', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:07.247' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1096, 0, 1092, 0, 3, N'-1,1081,1092,1096', 3, N'9ad43271-23f8-4910-b266-d41d41a13d44', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:20.717' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1097, 0, 1081, 0, 2, N'-1,1081,1097', 1, N'ce143a6e-d5ba-400e-bbb0-5c2211cbc78a', N'Make-up', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:45.823' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1098, 0, 1097, 0, 3, N'-1,1081,1097,1098', 0, N'cab8bc03-9a59-4131-9858-d7da4f381738', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:45.857' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1099, 0, 1097, 0, 3, N'-1,1081,1097,1099', 1, N'40868dec-a50b-4219-a759-14ceddda1ecb', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:45.867' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1100, 0, 1097, 0, 3, N'-1,1081,1097,1100', 2, N'832f1cb7-3ec7-48ab-91c3-effa0d238ad7', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:45.880' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1101, 0, 1097, 0, 3, N'-1,1081,1097,1101', 3, N'f3a2bc9a-ba61-45e3-b113-cf8fc7425641', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:22:45.893' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1102, 0, 1081, 0, 2, N'-1,1081,1102', 2, N'c8263eac-dd9d-4b36-9707-44263333c340', N'Body & Health', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:30.410' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1103, 0, 1102, 0, 3, N'-1,1081,1102,1103', 0, N'196feb81-fa87-48db-8d6c-a12f1ac557a4', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:30.493' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1104, 0, 1102, 0, 3, N'-1,1081,1102,1104', 1, N'cfe8d6e0-b9b8-4f8a-b951-e265f0dd4775', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:30.500' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1105, 0, 1102, 0, 3, N'-1,1081,1102,1105', 2, N'93b2e2d2-26d7-485a-9cbb-f8a1002c679f', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:30.533' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1106, 0, 1102, 0, 3, N'-1,1081,1102,1106', 3, N'877f0f4b-0dac-4857-9b36-123dcbca8c3e', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:30.540' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1107, 0, 1081, 0, 2, N'-1,1081,1107', 3, N'50e824b9-6152-446f-b4b5-20a8a98d817f', N'Fragrance', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:56.703' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1108, 0, 1107, 0, 3, N'-1,1081,1107,1108', 0, N'12d33b49-f77a-4e3a-8bd9-6f9cbfb3b22f', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:56.720' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1109, 0, 1107, 0, 3, N'-1,1081,1107,1109', 1, N'cc4cc5b7-3394-4280-bf57-3ac2432645cb', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:56.733' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1110, 0, 1107, 0, 3, N'-1,1081,1107,1110', 2, N'cdbe6a8d-87b7-499a-93bc-00a160258aa5', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:56.743' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1111, 0, 1107, 0, 3, N'-1,1081,1107,1111', 3, N'8ac00ae5-c772-419d-9f3a-b46ca5934e31', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:23:56.753' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1112, 0, 1081, 0, 2, N'-1,1081,1112', 4, N'509626d8-9202-4a2b-9c73-1929ed51dfa2', N'Face', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:24:25.493' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1113, 0, 1112, 0, 3, N'-1,1081,1112,1113', 0, N'8a1e1784-60d9-43ce-8144-ede0952bdb87', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:24:25.513' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1114, 0, 1112, 0, 3, N'-1,1081,1112,1114', 1, N'e8b1063d-566e-4991-94c1-2735535ba4f6', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:24:25.530' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1115, 0, 1112, 0, 3, N'-1,1081,1112,1115', 2, N'0f7a81ce-eb88-4288-b6b8-fb3a0caa5a34', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:24:25.540' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1116, 0, 1112, 0, 3, N'-1,1081,1112,1116', 3, N'b2418050-4d3f-4bca-95f8-47735425eea5', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:24:25.553' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1117, 0, 1081, 0, 2, N'-1,1081,1117', 5, N'720c4d12-0048-4108-a924-f181f52d6d5f', N'For Him', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:25:00.947' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1118, 0, 1117, 0, 3, N'-1,1081,1117,1118', 0, N'f1b26b77-9907-4ebe-9887-6ec30e5ae912', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:25:00.963' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1119, 0, 1117, 0, 3, N'-1,1081,1117,1119', 1, N'c57e8d47-e1cd-4d60-9d21-d433f3bf1be3', N'Gallery', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:25:00.970' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1120, 0, 1117, 0, 3, N'-1,1081,1117,1120', 2, N'52f046b2-c7d0-4bdc-83dd-ac56d121bf9d', N'Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:25:00.997' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1121, 0, 1117, 0, 3, N'-1,1081,1117,1121', 3, N'c1c66a52-0c0b-4d92-bddb-be78b6950bb7', N'Product', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:25:01.007' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1122, 0, 1081, 0, 2, N'-1,1081,1122', 6, N'aca7630d-e4ec-4e83-b718-39b76c0e4efe', N'How-to', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:26:13.127' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1123, 0, 1122, 0, 3, N'-1,1081,1122,1123', 0, N'f2c83498-121d-41aa-b8ce-d19a6b9dfc06', N'Hair', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:26:22.397' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1124, 0, 1122, 0, 3, N'-1,1081,1122,1124', 1, N'8b049680-20b1-4463-b21c-31cc7db4072e', N'Make-up', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:26:34.443' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1125, 0, 1122, 0, 3, N'-1,1081,1122,1125', 2, N'e8ef15f0-5c7d-4593-aa30-ca4a1b06832e', N'Body & Health', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:26:47.887' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1126, 0, 1122, 0, 3, N'-1,1081,1122,1126', 3, N'20d9a250-8c50-4454-9e95-3aa0fe47074d', N'Fragrance', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:26:56.687' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1127, 0, 1122, 0, 3, N'-1,1081,1122,1127', 4, N'683e4c4f-2544-4f74-b57a-6d982f82194b', N'Face', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:03.970' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1128, 0, 1122, 0, 3, N'-1,1081,1122,1128', 5, N'c9757dbc-8277-4d5b-9988-3d9448a6a571', N'For Him', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:16.590' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1129, 0, 1081, 0, 2, N'-1,1081,1129', 7, N'194de80b-bf93-4ce9-9746-fa67a7d35a3a', N'Insider', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.053' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1130, 0, 1129, 0, 3, N'-1,1081,1129,1130', 0, N'68f3b665-3f08-4dac-a336-29a060db8711', N'Hair', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.070' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1131, 0, 1129, 0, 3, N'-1,1081,1129,1131', 1, N'9ae16fca-e9b9-4de5-9d29-73ab33272097', N'Make-up', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.083' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1132, 0, 1129, 0, 3, N'-1,1081,1129,1132', 2, N'fc53025b-0202-4550-bd27-9ac8d53c7350', N'Body & Health', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.093' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1133, 0, 1129, 0, 3, N'-1,1081,1129,1133', 3, N'4ac5b6e0-513d-43fc-80d2-309c372e80eb', N'Fragrance', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.107' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1134, 0, 1129, 0, 3, N'-1,1081,1129,1134', 4, N'0fb926fa-d9fe-4f48-a096-519683f01a62', N'Face', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.117' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1135, 0, 1129, 0, 3, N'-1,1081,1129,1135', 5, N'0be1b907-2f50-43d1-9e9a-8d6e4bbc6cc1', N'For Him', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:27:51.127' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1136, 0, -1, 0, 1, N'-1,1136', 1, N'd0462c9e-c136-4ada-86e9-072a3a2d7b67', N'Content', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:29:23.943' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1137, 0, 1136, 0, 2, N'-1,1136,1137', 0, N'6f5a37ab-2d66-4760-a549-09bb8ea44aa6', N'Article Content', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:29:36.463' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1138, 0, 1136, 0, 2, N'-1,1136,1138', 1, N'873d3e6e-4730-4d9c-8159-94181ab6eb4f', N'How-to Content', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:29:46.123' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1139, 0, 1136, 0, 2, N'-1,1136,1139', 2, N'784c9387-af67-4d3a-aa57-5142850ef4da', N'Gallery Content', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:29:54.083' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1140, 0, 1136, 0, 2, N'-1,1136,1140', 3, N'94691748-86b0-41c5-a04f-2597a697a494', N'Tag Library', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:30:03.357' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1141, 0, 1137, 0, 3, N'-1,1136,1137,1141', 0, N'f8e764e4-2ef1-4656-a247-ccec6da6e277', N'Demo Article', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:30:13.460' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1142, 0, 1138, 0, 3, N'-1,1136,1138,1142', 0, N'236ce569-7f70-49bd-8591-84d73ce570f5', N'Demo how to page', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:30:34.367' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1143, 0, 1139, 0, 3, N'-1,1136,1139,1143', 0, N'38e211ef-7d6a-4a49-8af4-bf9f77b1bd01', N'Demo Gallery page', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', CAST(N'2015-12-09 16:30:46.560' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1144, 0, -1, 0, 1, N'-1,1144', 22, N'18f35b19-4356-4086-b923-1d1f64cf4c88', N'Article Page Potrait', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 18:44:36.380' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1145, 0, 1070, NULL, 1, N'-1,1070,1145', 0, N'd7249621-766a-4aa7-ad3b-081b8b203943', N'Article Page Potrait', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 18:45:09.877' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1146, 0, -1, 0, 1, N'-1,1146', 23, N'01d76981-793f-425b-b8ad-da931de590f5', N'How to Page Potrait', N'a2cb7800-f571-4787-9638-bc48539a0efb', CAST(N'2015-12-09 18:46:24.400' AS DateTime))
GO
INSERT [dbo].[umbracoNode] ([id], [trashed], [parentID], [nodeUser], [level], [path], [sortOrder], [uniqueID], [text], [nodeObjectType], [createDate]) VALUES (1147, 0, 1070, NULL, 1, N'-1,1070,1147', 0, N'61dcf9c8-ba26-40a2-b7fd-a13af36a5347', N'How to Page Potrait', N'6fbde604-4178-42ce-a10b-8a2600a2f07d', CAST(N'2015-12-09 18:46:39.370' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[umbracoNode] OFF
GO
SET IDENTITY_INSERT [dbo].[umbracoRelationType] ON 

GO
INSERT [dbo].[umbracoRelationType] ([id], [dual], [parentObjectType], [childObjectType], [name], [alias]) VALUES (1, 1, N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', N'Relate Document On Copy', N'relateDocumentOnCopy')
GO
INSERT [dbo].[umbracoRelationType] ([id], [dual], [parentObjectType], [childObjectType], [name], [alias]) VALUES (2, 0, N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', N'c66ba18e-eaf3-4cff-8a22-41b16d66a972', N'Relate Parent Document On Delete', N'relateParentDocumentOnDelete')
GO
SET IDENTITY_INSERT [dbo].[umbracoRelationType] OFF
GO

SET IDENTITY_INSERT [dbo].[umbracoUser] ON 
GO
INSERT [dbo].[umbracoUser] ([id], [userDisabled], [userNoConsole], [userType], [startStructureID], [startMediaID], [userName], [userLogin], [userPassword], [userEmail], [userLanguage], [securityStampToken], [failedLoginAttempts], [lastLockoutDate], [lastPasswordChangeDate], [lastLoginDate]) VALUES (0, 0, 0, 1, -1, -1, N'Pacific Magazine', N'umb-admin@pacificmags.com.au', N'TirK9bj8KUdecl2kvNdK1AqzdZw=', N'umb-admin@pacificmags.com.au', N'en-GB', N'3409de8b-0687-42ca-8d3e-e9add925be15', 0, NULL, CAST(N'2015-12-09 15:50:49.777' AS DateTime), CAST(N'2015-12-09 19:13:04.797' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[umbracoUser] OFF
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'content')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'developer')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'forms')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'media')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'member')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'settings')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'uCommerce')
GO
INSERT [dbo].[umbracoUser2app] ([user], [app]) VALUES (0, N'users')
GO
SET IDENTITY_INSERT [dbo].[umbracoUserType] ON 

GO
INSERT [dbo].[umbracoUserType] ([id], [userTypeAlias], [userTypeName], [userTypeDefaultPermissions]) VALUES (1, N'admin', N'Administrators', N'CADMOSKTPIURZ:5F7')
GO
INSERT [dbo].[umbracoUserType] ([id], [userTypeAlias], [userTypeName], [userTypeDefaultPermissions]) VALUES (2, N'writer', N'Writer', N'CAH:F')
GO
INSERT [dbo].[umbracoUserType] ([id], [userTypeAlias], [userTypeName], [userTypeDefaultPermissions]) VALUES (3, N'editor', N'Editors', N'CADMOSKTPUZ:5F')
GO
INSERT [dbo].[umbracoUserType] ([id], [userTypeAlias], [userTypeName], [userTypeDefaultPermissions]) VALUES (4, N'translator', N'Translator', N'AF')
GO
SET IDENTITY_INSERT [dbo].[umbracoUserType] OFF
GO
/****** Object:  Index [IX_cmsContent]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsContent] ON [dbo].[cmsContent]
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsContentType]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsContentType] ON [dbo].[cmsContentType]
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_cmsContentType_icon]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsContentType_icon] ON [dbo].[cmsContentType]
(
	[icon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsContentVersion_ContentId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsContentVersion_ContentId] ON [dbo].[cmsContentVersion]
(
	[ContentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsContentVersion_VersionId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsContentVersion_VersionId] ON [dbo].[cmsContentVersion]
(
	[VersionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsDataType_nodeId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsDataType_nodeId] ON [dbo].[cmsDataType]
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsDictionary_id]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsDictionary_id] ON [dbo].[cmsDictionary]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsDocument]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsDocument] ON [dbo].[cmsDocument]
(
	[nodeId] ASC,
	[versionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsDocument_newest]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsDocument_newest] ON [dbo].[cmsDocument]
(
	[newest] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsDocument_published]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsDocument_published] ON [dbo].[cmsDocument]
(
	[published] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_cmsMacroPropertyAlias]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsMacroPropertyAlias] ON [dbo].[cmsMacro]
(
	[macroAlias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_cmsMacroProperty_Alias]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsMacroProperty_Alias] ON [dbo].[cmsMacroProperty]
(
	[macro] ASC,
	[macroPropertyAlias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsPropertyData]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsPropertyData] ON [dbo].[cmsPropertyData]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsPropertyData_1]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsPropertyData_1] ON [dbo].[cmsPropertyData]
(
	[contentNodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsPropertyData_2]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsPropertyData_2] ON [dbo].[cmsPropertyData]
(
	[versionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsPropertyData_3]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsPropertyData_3] ON [dbo].[cmsPropertyData]
(
	[propertytypeid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsPropertyTypeUniqueID]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsPropertyTypeUniqueID] ON [dbo].[cmsPropertyType]
(
	[UniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_cmsTags]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsTags] ON [dbo].[cmsTags]
(
	[tag] ASC,
	[group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_cmsTaskType_alias]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_cmsTaskType_alias] ON [dbo].[cmsTaskType]
(
	[alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_cmsTemplate_nodeId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_cmsTemplate_nodeId] ON [dbo].[cmsTemplate]
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_AdminPage]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AdminPage] ON [dbo].[uCommerce_AdminPage]
(
	[FullName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_Campaign]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Campaign] ON [dbo].[uCommerce_Campaign]
(
	[CampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Category]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_Category] ON [dbo].[uCommerce_Category]
(
	[Name] ASC,
	[ProductCatalogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_Category_ParentCategoryId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Category_ParentCategoryId] ON [dbo].[uCommerce_Category]
(
	[ParentCategoryId] ASC,
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_Category_ProductCatalogId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Category_ProductCatalogId] ON [dbo].[uCommerce_Category]
(
	[ProductCatalogId] ASC,
	[Deleted] ASC
)
INCLUDE ( 	[CategoryId],
	[Name],
	[ImageMediaId],
	[DisplayOnSite],
	[CreatedOn],
	[ParentCategoryId],
	[ModifiedOn],
	[ModifiedBy],
	[SortOrder],
	[CreatedBy],
	[DefinitionId],
	[Guid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Unique_CategoryDescription_CultureCode_CategoryId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_CategoryDescription] ADD  CONSTRAINT [Unique_CategoryDescription_CultureCode_CategoryId] UNIQUE NONCLUSTERED 
(
	[CultureCode] ASC,
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_CategoryDescription_CategoryId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_CategoryDescription_CategoryId] ON [dbo].[uCommerce_CategoryDescription]
(
	[CategoryId] ASC
)
INCLUDE ( 	[CategoryDescriptionId],
	[DisplayName],
	[Description],
	[CultureCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Unique_CategoryId_ProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_CategoryProductRelation] ADD  CONSTRAINT [Unique_CategoryId_ProductId] UNIQUE NONCLUSTERED 
(
	[CategoryId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CategoryProductRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_CategoryProductRelation] ON [dbo].[uCommerce_CategoryProductRelation]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_CategoryProductRelation_ProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_CategoryProductRelation_ProductId] ON [dbo].[uCommerce_CategoryProductRelation]
(
	[ProductId] ASC
)
INCLUDE ( 	[CategoryProductRelationId],
	[CategoryId],
	[SortOrder]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_CategoryProperty_CategoryId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_CategoryProperty_CategoryId] ON [dbo].[uCommerce_CategoryProperty]
(
	[CategoryId] ASC
)
INCLUDE ( 	[CategoryPropertyId],
	[Value],
	[DefinitionFieldId],
	[CultureCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_Definition]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Definition] ON [dbo].[uCommerce_Definition]
(
	[DefinitionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_Discount_OrderId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Discount_OrderId] ON [dbo].[uCommerce_Discount]
(
	[OrderId] ASC
)
INCLUDE ( 	[DiscountId],
	[CampaignName],
	[CampaignItemName],
	[Description],
	[AmountOffTotal],
	[CreatedOn],
	[ModifiedOn],
	[CreatedBy],
	[ModifiedBy]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_EntityUi_Type]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_uCommerce_EntityUi_Type] ON [dbo].[uCommerce_EntityUi]
(
	[EntityUiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_OrderLine_OrderId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_OrderLine_OrderId] ON [dbo].[uCommerce_OrderLine]
(
	[OrderId] ASC
)
INCLUDE ( 	[OrderLineId],
	[Sku],
	[ProductName],
	[Price],
	[Quantity],
	[CreatedOn],
	[Discount],
	[VAT],
	[Total],
	[VATRate],
	[VariantSku],
	[ShipmentId],
	[UnitDiscount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_OrderLine_ShipmentId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_OrderLine_ShipmentId] ON [dbo].[uCommerce_OrderLine]
(
	[ShipmentId] ASC
)
INCLUDE ( 	[OrderLineId],
	[OrderId],
	[Sku],
	[ProductName],
	[Price],
	[Quantity],
	[CreatedOn],
	[Discount],
	[VAT],
	[Total],
	[VATRate],
	[VariantSku],
	[UnitDiscount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_OrderNumbers]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrderNumbers] ON [dbo].[uCommerce_OrderNumberSerie]
(
	[OrderNumberName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_OrderProperty]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_uCommerce_OrderProperty] ON [dbo].[uCommerce_OrderProperty]
(
	[Key] ASC,
	[OrderId] ASC,
	[OrderLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [uCommerce_OrderProperty_OrderLineId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [uCommerce_OrderProperty_OrderLineId] ON [dbo].[uCommerce_OrderProperty]
(
	[OrderLineId] ASC
)
INCLUDE ( 	[OrderPropertyId],
	[OrderId],
	[Key],
	[Value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_OrderStatusAudit_OrderId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_OrderStatusAudit_OrderId] ON [dbo].[uCommerce_OrderStatusAudit]
(
	[OrderId] ASC
)
INCLUDE ( 	[OrderStatusAuditId],
	[NewOrderStatusId],
	[CreatedOn],
	[CreatedBy],
	[Message]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PaymentMethodProperty_Unique_PaymentMethodId_DefinitionFieldId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_PaymentMethodProperty] ADD  CONSTRAINT [PaymentMethodProperty_Unique_PaymentMethodId_DefinitionFieldId] UNIQUE NONCLUSTERED 
(
	[PaymentMethodId] ASC,
	[CultureCode] ASC,
	[DefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Unique_Permission_UserId_RoleId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_Permission] ADD  CONSTRAINT [Unique_Permission_UserId_RoleId] UNIQUE NONCLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Unique_ProductId_PriceGroupId_PriceGroupPrice]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_PriceGroupPrice] ADD  CONSTRAINT [Unique_ProductId_PriceGroupId_PriceGroupPrice] UNIQUE NONCLUSTERED 
(
	[ProductId] ASC,
	[PriceGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_PriceGroupPrice_PriceGroupId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_PriceGroupPrice_PriceGroupId] ON [dbo].[uCommerce_PriceGroupPrice]
(
	[PriceGroupId] ASC
)
INCLUDE ( 	[Price]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_PriceGroupPrice_ProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_PriceGroupPrice_ProductId] ON [dbo].[uCommerce_PriceGroupPrice]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Product_UniqueSkuAndVariantSku]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Product_UniqueSkuAndVariantSku] ON [dbo].[uCommerce_Product]
(
	[Sku] ASC,
	[VariantSku] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_Product_ParentProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Product_ParentProductId] ON [dbo].[uCommerce_Product]
(
	[ParentProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ProductCatalog_UniqueName]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ProductCatalog_UniqueName] ON [dbo].[uCommerce_ProductCatalog]
(
	[Name] ASC,
	[ProductCatalogGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Unique_ProductDefinitionFieldDescription_CultureCode_ProductDefintionFieldId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_ProductDefinitionFieldDescription] ADD  CONSTRAINT [Unique_ProductDefinitionFieldDescription_CultureCode_ProductDefintionFieldId] UNIQUE NONCLUSTERED 
(
	[CultureCode] ASC,
	[ProductDefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_ProductDescription_ProductId_CultureCode]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_ProductDescription] ADD  CONSTRAINT [IX_uCommerce_ProductDescription_ProductId_CultureCode] UNIQUE NONCLUSTERED 
(
	[ProductId] ASC,
	[CultureCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_ProductDescription_ProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_ProductDescription_ProductId] ON [dbo].[uCommerce_ProductDescription]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ProductDescriptionProperty_Unique_ProductDescriptionId_ProductDefinitionFieldId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_ProductDescriptionProperty] ADD  CONSTRAINT [ProductDescriptionProperty_Unique_ProductDescriptionId_ProductDefinitionFieldId] UNIQUE NONCLUSTERED 
(
	[ProductDescriptionId] ASC,
	[ProductDefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [uCommerce_NonClusteredIndex_ProductDescriptionId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [uCommerce_NonClusteredIndex_ProductDescriptionId] ON [dbo].[uCommerce_ProductDescriptionProperty]
(
	[ProductDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [Unique_ProductProperty_ProductId_ProductDefinitionFieldId]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_ProductProperty] ADD  CONSTRAINT [Unique_ProductProperty_ProductId_ProductDefinitionFieldId] UNIQUE NONCLUSTERED 
(
	[ProductId] ASC,
	[ProductDefinitionFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_ProductProperty_ProductId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_ProductProperty_ProductId] ON [dbo].[uCommerce_ProductProperty]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_ProductRelation]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_uCommerce_ProductRelation] ON [dbo].[uCommerce_ProductRelation]
(
	[ProductId] ASC,
	[RelatedProductId] ASC,
	[ProductRelationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_ProductReview]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_ProductReview] ON [dbo].[uCommerce_ProductReview]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_Order] ON [dbo].[uCommerce_PurchaseOrder]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_uCommerce_PurchaseOrder_BasketId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_PurchaseOrder_BasketId] ON [dbo].[uCommerce_PurchaseOrder]
(
	[BasketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_uCommerce_Shipment_OrderId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_uCommerce_Shipment_OrderId] ON [dbo].[uCommerce_Shipment]
(
	[OrderId] ASC
)
INCLUDE ( 	[ShipmentId],
	[ShipmentName],
	[CreatedOn],
	[ShipmentPrice],
	[ShippingMethodId],
	[ShipmentAddressId],
	[DeliveryNote],
	[TrackAndTrace],
	[CreatedBy],
	[Tax],
	[TaxRate],
	[ShipmentTotal],
	[ShipmentDiscount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Unique_User_External_Id]    Script Date: 9/12/2015 7:58:52 PM ******/
ALTER TABLE [dbo].[uCommerce_User] ADD  CONSTRAINT [Unique_User_External_Id] UNIQUE NONCLUSTERED 
(
	[ExternalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoAccess_nodeId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_umbracoAccess_nodeId] ON [dbo].[umbracoAccess]
(
	[nodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_umbracoAccessRule]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_umbracoAccessRule] ON [dbo].[umbracoAccessRule]
(
	[ruleValue] ASC,
	[ruleType] ASC,
	[accessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_umbracoLanguage_languageISOCode]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_umbracoLanguage_languageISOCode] ON [dbo].[umbracoLanguage]
(
	[languageISOCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoLog]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoLog] ON [dbo].[umbracoLog]
(
	[NodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_umbracoMigration]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_umbracoMigration] ON [dbo].[umbracoMigration]
(
	[name] ASC,
	[version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoNodeObjectType]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoNodeObjectType] ON [dbo].[umbracoNode]
(
	[nodeObjectType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoNodeParentId]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoNodeParentId] ON [dbo].[umbracoNode]
(
	[parentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoNodeTrashed]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoNodeTrashed] ON [dbo].[umbracoNode]
(
	[trashed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoNodeUniqueID]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_umbracoNodeUniqueID] ON [dbo].[umbracoNode]
(
	[uniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_computerName]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_computerName] ON [dbo].[umbracoServer]
(
	[computerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_umbracoServer_isActive]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoServer_isActive] ON [dbo].[umbracoServer]
(
	[isActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_umbracoUser_userLogin]    Script Date: 9/12/2015 7:58:52 PM ******/
CREATE NONCLUSTERED INDEX [IX_umbracoUser_userLogin] ON [dbo].[umbracoUser]
(
	[userLogin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cmsMacro] ADD  CONSTRAINT [DF_cmsMacro_macroUseInEditor]  DEFAULT ('0') FOR [macroUseInEditor]
GO
ALTER TABLE [dbo].[cmsMacro] ADD  CONSTRAINT [DF_cmsMacro_macroRefreshRate]  DEFAULT ('0') FOR [macroRefreshRate]
GO
ALTER TABLE [dbo].[cmsMacro] ADD  CONSTRAINT [DF_cmsMacro_macroCacheByPage]  DEFAULT ('1') FOR [macroCacheByPage]
GO
ALTER TABLE [dbo].[cmsMacro] ADD  CONSTRAINT [DF_cmsMacro_macroCachePersonalized]  DEFAULT ('0') FOR [macroCachePersonalized]
GO
ALTER TABLE [dbo].[cmsMacro] ADD  CONSTRAINT [DF_cmsMacro_macroDontRender]  DEFAULT ('0') FOR [macroDontRender]
GO
ALTER TABLE [dbo].[cmsMacroProperty] ADD  CONSTRAINT [DF_cmsMacroProperty_macroPropertySortOrder]  DEFAULT ('0') FOR [macroPropertySortOrder]
GO
ALTER TABLE [dbo].[cmsMember] ADD  CONSTRAINT [DF_cmsMember_Email]  DEFAULT ('''') FOR [Email]
GO
ALTER TABLE [dbo].[cmsMember] ADD  CONSTRAINT [DF_cmsMember_LoginName]  DEFAULT ('''') FOR [LoginName]
GO
ALTER TABLE [dbo].[cmsMember] ADD  CONSTRAINT [DF_cmsMember_Password]  DEFAULT ('''') FOR [Password]
GO
ALTER TABLE [dbo].[cmsMemberType] ADD  CONSTRAINT [DF_cmsMemberType_memberCanEdit]  DEFAULT ('0') FOR [memberCanEdit]
GO
ALTER TABLE [dbo].[cmsMemberType] ADD  CONSTRAINT [DF_cmsMemberType_viewOnProfile]  DEFAULT ('0') FOR [viewOnProfile]
GO
ALTER TABLE [dbo].[cmsTask] ADD  CONSTRAINT [DF_cmsTask_closed]  DEFAULT ('0') FOR [closed]
GO
ALTER TABLE [dbo].[cmsTask] ADD  CONSTRAINT [DF_cmsTask_DateTime]  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[uCommerce_CategoryTarget] ADD  DEFAULT (NULL) FOR [CategoryGuid]
GO
ALTER TABLE [dbo].[uCommerce_DefinitionRelation] ADD  CONSTRAINT [DF_uCommerce_DefinitionRelation_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[uCommerce_DynamicOrderPropertyTarget] ADD  CONSTRAINT [DF_uCommerce_DynamicOrderPropertyTarget_TargetOrderLine]  DEFAULT ((0)) FOR [TargetOrderLine]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation] ADD  CONSTRAINT [DF_uCommerce_ProductCatalogPriceGroupRelation_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionRelation] ADD  CONSTRAINT [DF_uCommerce_ProductDefinitionRelation_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment] ADD  CONSTRAINT [DF_uCommerce_ProductReviewComment_Helpful]  DEFAULT ((0)) FOR [Helpful]
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment] ADD  CONSTRAINT [DF_uCommerce_ProductReviewComment_Unhelpful]  DEFAULT ((0)) FOR [Unhelpful]
GO
ALTER TABLE [dbo].[uCommerce_QuantityTarget] ADD  CONSTRAINT [DF_uCommerce_Quantity_Target_MinAmount]  DEFAULT ((0)) FOR [MinQuantity]
GO
ALTER TABLE [dbo].[uCommerce_QuantityTarget] ADD  DEFAULT ((0)) FOR [TargetOrderLine]
GO
ALTER TABLE [dbo].[uCommerce_VoucherCode] ADD  CONSTRAINT [DF_uCommerce_VoucherCode_NumberUsed]  DEFAULT ((0)) FOR [NumberUsed]
GO
ALTER TABLE [dbo].[umbracoAccess] ADD  CONSTRAINT [DF_umbracoAccess_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[umbracoAccess] ADD  CONSTRAINT [DF_umbracoAccess_updateDate]  DEFAULT (getdate()) FOR [updateDate]
GO
ALTER TABLE [dbo].[umbracoAccessRule] ADD  CONSTRAINT [DF_umbracoAccessRule_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[umbracoAccessRule] ADD  CONSTRAINT [DF_umbracoAccessRule_updateDate]  DEFAULT (getdate()) FOR [updateDate]
GO
ALTER TABLE [dbo].[umbracoExternalLogin] ADD  CONSTRAINT [DF_umbracoExternalLogin_createDate]  DEFAULT (getdate()) FOR [createDate]
GO
ALTER TABLE [dbo].[umbracoRelation] ADD  CONSTRAINT [DF_umbracoRelation_datetime]  DEFAULT (getdate()) FOR [datetime]
GO
ALTER TABLE [dbo].[cmsContent]  WITH CHECK ADD  CONSTRAINT [FK_cmsContent_cmsContentType_nodeId] FOREIGN KEY([contentType])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsContent] CHECK CONSTRAINT [FK_cmsContent_cmsContentType_nodeId]
GO
ALTER TABLE [dbo].[cmsContent]  WITH CHECK ADD  CONSTRAINT [FK_cmsContent_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsContent] CHECK CONSTRAINT [FK_cmsContent_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsContentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentType_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsContentType] CHECK CONSTRAINT [FK_cmsContentType_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsContentType2ContentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentType2ContentType_umbracoNode_child] FOREIGN KEY([childContentTypeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsContentType2ContentType] CHECK CONSTRAINT [FK_cmsContentType2ContentType_umbracoNode_child]
GO
ALTER TABLE [dbo].[cmsContentType2ContentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentType2ContentType_umbracoNode_parent] FOREIGN KEY([parentContentTypeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsContentType2ContentType] CHECK CONSTRAINT [FK_cmsContentType2ContentType_umbracoNode_parent]
GO
ALTER TABLE [dbo].[cmsContentTypeAllowedContentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentTypeAllowedContentType_cmsContentType] FOREIGN KEY([Id])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsContentTypeAllowedContentType] CHECK CONSTRAINT [FK_cmsContentTypeAllowedContentType_cmsContentType]
GO
ALTER TABLE [dbo].[cmsContentTypeAllowedContentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentTypeAllowedContentType_cmsContentType1] FOREIGN KEY([AllowedId])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsContentTypeAllowedContentType] CHECK CONSTRAINT [FK_cmsContentTypeAllowedContentType_cmsContentType1]
GO
ALTER TABLE [dbo].[cmsContentVersion]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentVersion_cmsContent_nodeId] FOREIGN KEY([ContentId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsContentVersion] CHECK CONSTRAINT [FK_cmsContentVersion_cmsContent_nodeId]
GO
ALTER TABLE [dbo].[cmsContentXml]  WITH CHECK ADD  CONSTRAINT [FK_cmsContentXml_cmsContent_nodeId] FOREIGN KEY([nodeId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsContentXml] CHECK CONSTRAINT [FK_cmsContentXml_cmsContent_nodeId]
GO
ALTER TABLE [dbo].[cmsDataType]  WITH CHECK ADD  CONSTRAINT [FK_cmsDataType_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsDataType] CHECK CONSTRAINT [FK_cmsDataType_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsDataTypePreValues]  WITH CHECK ADD  CONSTRAINT [FK_cmsDataTypePreValues_cmsDataType_nodeId] FOREIGN KEY([datatypeNodeId])
REFERENCES [dbo].[cmsDataType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsDataTypePreValues] CHECK CONSTRAINT [FK_cmsDataTypePreValues_cmsDataType_nodeId]
GO
ALTER TABLE [dbo].[cmsDictionary]  WITH CHECK ADD  CONSTRAINT [FK_cmsDictionary_cmsDictionary_id] FOREIGN KEY([parent])
REFERENCES [dbo].[cmsDictionary] ([id])
GO
ALTER TABLE [dbo].[cmsDictionary] CHECK CONSTRAINT [FK_cmsDictionary_cmsDictionary_id]
GO
ALTER TABLE [dbo].[cmsDocument]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocument_cmsContent_nodeId] FOREIGN KEY([nodeId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsDocument] CHECK CONSTRAINT [FK_cmsDocument_cmsContent_nodeId]
GO
ALTER TABLE [dbo].[cmsDocument]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocument_cmsTemplate_nodeId] FOREIGN KEY([templateId])
REFERENCES [dbo].[cmsTemplate] ([nodeId])
GO
ALTER TABLE [dbo].[cmsDocument] CHECK CONSTRAINT [FK_cmsDocument_cmsTemplate_nodeId]
GO
ALTER TABLE [dbo].[cmsDocument]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocument_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsDocument] CHECK CONSTRAINT [FK_cmsDocument_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsDocumentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocumentType_cmsContentType_nodeId] FOREIGN KEY([contentTypeNodeId])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsDocumentType] CHECK CONSTRAINT [FK_cmsDocumentType_cmsContentType_nodeId]
GO
ALTER TABLE [dbo].[cmsDocumentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocumentType_cmsTemplate_nodeId] FOREIGN KEY([templateNodeId])
REFERENCES [dbo].[cmsTemplate] ([nodeId])
GO
ALTER TABLE [dbo].[cmsDocumentType] CHECK CONSTRAINT [FK_cmsDocumentType_cmsTemplate_nodeId]
GO
ALTER TABLE [dbo].[cmsDocumentType]  WITH CHECK ADD  CONSTRAINT [FK_cmsDocumentType_umbracoNode_id] FOREIGN KEY([contentTypeNodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsDocumentType] CHECK CONSTRAINT [FK_cmsDocumentType_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsLanguageText]  WITH CHECK ADD  CONSTRAINT [FK_cmsLanguageText_cmsDictionary_id] FOREIGN KEY([UniqueId])
REFERENCES [dbo].[cmsDictionary] ([id])
GO
ALTER TABLE [dbo].[cmsLanguageText] CHECK CONSTRAINT [FK_cmsLanguageText_cmsDictionary_id]
GO
ALTER TABLE [dbo].[cmsLanguageText]  WITH CHECK ADD  CONSTRAINT [FK_cmsLanguageText_umbracoLanguage_id] FOREIGN KEY([languageId])
REFERENCES [dbo].[umbracoLanguage] ([id])
GO
ALTER TABLE [dbo].[cmsLanguageText] CHECK CONSTRAINT [FK_cmsLanguageText_umbracoLanguage_id]
GO
ALTER TABLE [dbo].[cmsMacroProperty]  WITH CHECK ADD  CONSTRAINT [FK_cmsMacroProperty_cmsMacro_id] FOREIGN KEY([macro])
REFERENCES [dbo].[cmsMacro] ([id])
GO
ALTER TABLE [dbo].[cmsMacroProperty] CHECK CONSTRAINT [FK_cmsMacroProperty_cmsMacro_id]
GO
ALTER TABLE [dbo].[cmsMember]  WITH CHECK ADD  CONSTRAINT [FK_cmsMember_cmsContent_nodeId] FOREIGN KEY([nodeId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsMember] CHECK CONSTRAINT [FK_cmsMember_cmsContent_nodeId]
GO
ALTER TABLE [dbo].[cmsMember]  WITH CHECK ADD  CONSTRAINT [FK_cmsMember_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsMember] CHECK CONSTRAINT [FK_cmsMember_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsMember2MemberGroup]  WITH CHECK ADD  CONSTRAINT [FK_cmsMember2MemberGroup_cmsMember_nodeId] FOREIGN KEY([Member])
REFERENCES [dbo].[cmsMember] ([nodeId])
GO
ALTER TABLE [dbo].[cmsMember2MemberGroup] CHECK CONSTRAINT [FK_cmsMember2MemberGroup_cmsMember_nodeId]
GO
ALTER TABLE [dbo].[cmsMember2MemberGroup]  WITH CHECK ADD  CONSTRAINT [FK_cmsMember2MemberGroup_umbracoNode_id] FOREIGN KEY([MemberGroup])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsMember2MemberGroup] CHECK CONSTRAINT [FK_cmsMember2MemberGroup_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsMemberType]  WITH CHECK ADD  CONSTRAINT [FK_cmsMemberType_cmsContentType_nodeId] FOREIGN KEY([NodeId])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsMemberType] CHECK CONSTRAINT [FK_cmsMemberType_cmsContentType_nodeId]
GO
ALTER TABLE [dbo].[cmsMemberType]  WITH CHECK ADD  CONSTRAINT [FK_cmsMemberType_umbracoNode_id] FOREIGN KEY([NodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsMemberType] CHECK CONSTRAINT [FK_cmsMemberType_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsPreviewXml]  WITH CHECK ADD  CONSTRAINT [FK_cmsPreviewXml_cmsContent_nodeId] FOREIGN KEY([nodeId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsPreviewXml] CHECK CONSTRAINT [FK_cmsPreviewXml_cmsContent_nodeId]
GO
ALTER TABLE [dbo].[cmsPreviewXml]  WITH CHECK ADD  CONSTRAINT [FK_cmsPreviewXml_cmsContentVersion_VersionId] FOREIGN KEY([versionId])
REFERENCES [dbo].[cmsContentVersion] ([VersionId])
GO
ALTER TABLE [dbo].[cmsPreviewXml] CHECK CONSTRAINT [FK_cmsPreviewXml_cmsContentVersion_VersionId]
GO
ALTER TABLE [dbo].[cmsPropertyData]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyData_cmsPropertyType_id] FOREIGN KEY([propertytypeid])
REFERENCES [dbo].[cmsPropertyType] ([id])
GO
ALTER TABLE [dbo].[cmsPropertyData] CHECK CONSTRAINT [FK_cmsPropertyData_cmsPropertyType_id]
GO
ALTER TABLE [dbo].[cmsPropertyData]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyData_umbracoNode_id] FOREIGN KEY([contentNodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsPropertyData] CHECK CONSTRAINT [FK_cmsPropertyData_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsPropertyType]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyType_cmsContentType_nodeId] FOREIGN KEY([contentTypeId])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsPropertyType] CHECK CONSTRAINT [FK_cmsPropertyType_cmsContentType_nodeId]
GO
ALTER TABLE [dbo].[cmsPropertyType]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyType_cmsDataType_nodeId] FOREIGN KEY([dataTypeId])
REFERENCES [dbo].[cmsDataType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsPropertyType] CHECK CONSTRAINT [FK_cmsPropertyType_cmsDataType_nodeId]
GO
ALTER TABLE [dbo].[cmsPropertyType]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyType_cmsPropertyTypeGroup_id] FOREIGN KEY([propertyTypeGroupId])
REFERENCES [dbo].[cmsPropertyTypeGroup] ([id])
GO
ALTER TABLE [dbo].[cmsPropertyType] CHECK CONSTRAINT [FK_cmsPropertyType_cmsPropertyTypeGroup_id]
GO
ALTER TABLE [dbo].[cmsPropertyTypeGroup]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyTypeGroup_cmsContentType_nodeId] FOREIGN KEY([contenttypeNodeId])
REFERENCES [dbo].[cmsContentType] ([nodeId])
GO
ALTER TABLE [dbo].[cmsPropertyTypeGroup] CHECK CONSTRAINT [FK_cmsPropertyTypeGroup_cmsContentType_nodeId]
GO
ALTER TABLE [dbo].[cmsPropertyTypeGroup]  WITH CHECK ADD  CONSTRAINT [FK_cmsPropertyTypeGroup_cmsPropertyTypeGroup_id] FOREIGN KEY([parentGroupId])
REFERENCES [dbo].[cmsPropertyTypeGroup] ([id])
GO
ALTER TABLE [dbo].[cmsPropertyTypeGroup] CHECK CONSTRAINT [FK_cmsPropertyTypeGroup_cmsPropertyTypeGroup_id]
GO
ALTER TABLE [dbo].[cmsStylesheet]  WITH CHECK ADD  CONSTRAINT [FK_cmsStylesheet_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsStylesheet] CHECK CONSTRAINT [FK_cmsStylesheet_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsTagRelationship]  WITH CHECK ADD  CONSTRAINT [FK_cmsTagRelationship_cmsContent] FOREIGN KEY([nodeId])
REFERENCES [dbo].[cmsContent] ([nodeId])
GO
ALTER TABLE [dbo].[cmsTagRelationship] CHECK CONSTRAINT [FK_cmsTagRelationship_cmsContent]
GO
ALTER TABLE [dbo].[cmsTagRelationship]  WITH CHECK ADD  CONSTRAINT [FK_cmsTagRelationship_cmsPropertyType] FOREIGN KEY([propertyTypeId])
REFERENCES [dbo].[cmsPropertyType] ([id])
GO
ALTER TABLE [dbo].[cmsTagRelationship] CHECK CONSTRAINT [FK_cmsTagRelationship_cmsPropertyType]
GO
ALTER TABLE [dbo].[cmsTagRelationship]  WITH CHECK ADD  CONSTRAINT [FK_cmsTagRelationship_cmsTags_id] FOREIGN KEY([tagId])
REFERENCES [dbo].[cmsTags] ([id])
GO
ALTER TABLE [dbo].[cmsTagRelationship] CHECK CONSTRAINT [FK_cmsTagRelationship_cmsTags_id]
GO
ALTER TABLE [dbo].[cmsTags]  WITH CHECK ADD  CONSTRAINT [FK_cmsTags_cmsTags] FOREIGN KEY([ParentId])
REFERENCES [dbo].[cmsTags] ([id])
GO
ALTER TABLE [dbo].[cmsTags] CHECK CONSTRAINT [FK_cmsTags_cmsTags]
GO
ALTER TABLE [dbo].[cmsTask]  WITH CHECK ADD  CONSTRAINT [FK_cmsTask_cmsTaskType_id] FOREIGN KEY([taskTypeId])
REFERENCES [dbo].[cmsTaskType] ([id])
GO
ALTER TABLE [dbo].[cmsTask] CHECK CONSTRAINT [FK_cmsTask_cmsTaskType_id]
GO
ALTER TABLE [dbo].[cmsTask]  WITH CHECK ADD  CONSTRAINT [FK_cmsTask_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsTask] CHECK CONSTRAINT [FK_cmsTask_umbracoNode_id]
GO
ALTER TABLE [dbo].[cmsTask]  WITH CHECK ADD  CONSTRAINT [FK_cmsTask_umbracoUser] FOREIGN KEY([parentUserId])
REFERENCES [dbo].[umbracoUser] ([id])
GO
ALTER TABLE [dbo].[cmsTask] CHECK CONSTRAINT [FK_cmsTask_umbracoUser]
GO
ALTER TABLE [dbo].[cmsTask]  WITH CHECK ADD  CONSTRAINT [FK_cmsTask_umbracoUser1] FOREIGN KEY([userId])
REFERENCES [dbo].[umbracoUser] ([id])
GO
ALTER TABLE [dbo].[cmsTask] CHECK CONSTRAINT [FK_cmsTask_umbracoUser1]
GO
ALTER TABLE [dbo].[cmsTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cmsTemplate_umbracoNode] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[cmsTemplate] CHECK CONSTRAINT [FK_cmsTemplate_umbracoNode]
GO
ALTER TABLE [dbo].[uCommerce_Address]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Address_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[uCommerce_Country] ([CountryId])
GO
ALTER TABLE [dbo].[uCommerce_Address] CHECK CONSTRAINT [uCommerce_FK_Address_Country]
GO
ALTER TABLE [dbo].[uCommerce_Address]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Address_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[uCommerce_Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[uCommerce_Address] CHECK CONSTRAINT [uCommerce_FK_Address_Customer]
GO
ALTER TABLE [dbo].[uCommerce_AdminTab]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_AdminTab_AdminPage] FOREIGN KEY([AdminPageId])
REFERENCES [dbo].[uCommerce_AdminPage] ([AdminPageId])
GO
ALTER TABLE [dbo].[uCommerce_AdminTab] CHECK CONSTRAINT [uCommerce_FK_AdminTab_AdminPage]
GO
ALTER TABLE [dbo].[uCommerce_AmountOffOrderLinesAward]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_AmountOffOrderLinesAward_uCommerce_Award] FOREIGN KEY([AmountOffOrderLinesAwardId])
REFERENCES [dbo].[uCommerce_Award] ([AwardId])
GO
ALTER TABLE [dbo].[uCommerce_AmountOffOrderLinesAward] CHECK CONSTRAINT [FK_uCommerce_AmountOffOrderLinesAward_uCommerce_Award]
GO
ALTER TABLE [dbo].[uCommerce_AmountOffOrderTotalAward]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_AmountOffOrderTotalAward_uCommerce_Award] FOREIGN KEY([AmountOffOrderTotalAwardId])
REFERENCES [dbo].[uCommerce_Award] ([AwardId])
GO
ALTER TABLE [dbo].[uCommerce_AmountOffOrderTotalAward] CHECK CONSTRAINT [FK_uCommerce_AmountOffOrderTotalAward_uCommerce_Award]
GO
ALTER TABLE [dbo].[uCommerce_AmountOffUnitAward]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_AmountOffUnitAward_uCommerce_Award] FOREIGN KEY([AmountOffUnitAwardId])
REFERENCES [dbo].[uCommerce_Award] ([AwardId])
GO
ALTER TABLE [dbo].[uCommerce_AmountOffUnitAward] CHECK CONSTRAINT [FK_uCommerce_AmountOffUnitAward_uCommerce_Award]
GO
ALTER TABLE [dbo].[uCommerce_Award]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Award_uCommerce_CampaignItem] FOREIGN KEY([CampaignItemId])
REFERENCES [dbo].[uCommerce_CampaignItem] ([CampaignItemId])
GO
ALTER TABLE [dbo].[uCommerce_Award] CHECK CONSTRAINT [FK_uCommerce_Award_uCommerce_CampaignItem]
GO
ALTER TABLE [dbo].[uCommerce_CampaignItem]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CampaignItem_uCommerce_Campaign] FOREIGN KEY([CampaignId])
REFERENCES [dbo].[uCommerce_Campaign] ([CampaignId])
GO
ALTER TABLE [dbo].[uCommerce_CampaignItem] CHECK CONSTRAINT [FK_uCommerce_CampaignItem_uCommerce_Campaign]
GO
ALTER TABLE [dbo].[uCommerce_CampaignItem]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CampaignItem_uCommerce_Definition] FOREIGN KEY([DefinitionId])
REFERENCES [dbo].[uCommerce_Definition] ([DefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_CampaignItem] CHECK CONSTRAINT [FK_uCommerce_CampaignItem_uCommerce_Definition]
GO
ALTER TABLE [dbo].[uCommerce_CampaignItemProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CampaignItemProperty_uCommerce_CampaignItem] FOREIGN KEY([CampaignItemId])
REFERENCES [dbo].[uCommerce_CampaignItem] ([CampaignItemId])
GO
ALTER TABLE [dbo].[uCommerce_CampaignItemProperty] CHECK CONSTRAINT [FK_uCommerce_CampaignItemProperty_uCommerce_CampaignItem]
GO
ALTER TABLE [dbo].[uCommerce_CampaignItemProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CampaignItemProperty_uCommerce_DefinitionField] FOREIGN KEY([DefinitionFieldId])
REFERENCES [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_CampaignItemProperty] CHECK CONSTRAINT [FK_uCommerce_CampaignItemProperty_uCommerce_DefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_Category]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Category_ParentCategory] FOREIGN KEY([ParentCategoryId])
REFERENCES [dbo].[uCommerce_Category] ([CategoryId])
GO
ALTER TABLE [dbo].[uCommerce_Category] CHECK CONSTRAINT [FK_uCommerce_Category_ParentCategory]
GO
ALTER TABLE [dbo].[uCommerce_Category]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Category_uCommerce_Definition] FOREIGN KEY([DefinitionId])
REFERENCES [dbo].[uCommerce_Definition] ([DefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_Category] CHECK CONSTRAINT [FK_uCommerce_Category_uCommerce_Definition]
GO
ALTER TABLE [dbo].[uCommerce_Category]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Category_ProductCatalog] FOREIGN KEY([ProductCatalogId])
REFERENCES [dbo].[uCommerce_ProductCatalog] ([ProductCatalogId])
GO
ALTER TABLE [dbo].[uCommerce_Category] CHECK CONSTRAINT [uCommerce_FK_Category_ProductCatalog]
GO
ALTER TABLE [dbo].[uCommerce_CategoryDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_CategoryDescription_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[uCommerce_Category] ([CategoryId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryDescription] CHECK CONSTRAINT [uCommerce_FK_CategoryDescription_Category]
GO
ALTER TABLE [dbo].[uCommerce_CategoryProductRelation]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_CategoryProductRelation_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[uCommerce_Category] ([CategoryId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryProductRelation] CHECK CONSTRAINT [uCommerce_FK_CategoryProductRelation_Category]
GO
ALTER TABLE [dbo].[uCommerce_CategoryProductRelation]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_CategoryProductRelation_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryProductRelation] CHECK CONSTRAINT [uCommerce_FK_CategoryProductRelation_Product]
GO
ALTER TABLE [dbo].[uCommerce_CategoryProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CategoryProperty_uCommerce_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[uCommerce_Category] ([CategoryId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryProperty] CHECK CONSTRAINT [FK_uCommerce_CategoryProperty_uCommerce_Category]
GO
ALTER TABLE [dbo].[uCommerce_CategoryProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CategoryProperty_uCommerce_DefinitionField] FOREIGN KEY([DefinitionFieldId])
REFERENCES [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryProperty] CHECK CONSTRAINT [FK_uCommerce_CategoryProperty_uCommerce_DefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_CategoryTarget]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_CategoryTarget_uCommerce_CategoryTarget] FOREIGN KEY([CategoryTargetId])
REFERENCES [dbo].[uCommerce_Target] ([TargetId])
GO
ALTER TABLE [dbo].[uCommerce_CategoryTarget] CHECK CONSTRAINT [FK_uCommerce_CategoryTarget_uCommerce_CategoryTarget]
GO
ALTER TABLE [dbo].[uCommerce_DataTypeEnum]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_DataTypeEnum_DataType] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[uCommerce_DataType] ([DataTypeId])
GO
ALTER TABLE [dbo].[uCommerce_DataTypeEnum] CHECK CONSTRAINT [uCommerce_FK_DataTypeEnum_DataType]
GO
ALTER TABLE [dbo].[uCommerce_DataTypeEnumDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_DataTypeEnumDescription_DataTypeEnum] FOREIGN KEY([DataTypeEnumId])
REFERENCES [dbo].[uCommerce_DataTypeEnum] ([DataTypeEnumId])
GO
ALTER TABLE [dbo].[uCommerce_DataTypeEnumDescription] CHECK CONSTRAINT [uCommerce_FK_DataTypeEnumDescription_DataTypeEnum]
GO
ALTER TABLE [dbo].[uCommerce_Definition]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Definition_uCommerce_DefinitionType] FOREIGN KEY([DefinitionTypeId])
REFERENCES [dbo].[uCommerce_DefinitionType] ([DefinitionTypeId])
GO
ALTER TABLE [dbo].[uCommerce_Definition] CHECK CONSTRAINT [FK_uCommerce_Definition_uCommerce_DefinitionType]
GO
ALTER TABLE [dbo].[uCommerce_DefinitionField]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_DefinitionField_uCommerce_DataType] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[uCommerce_DataType] ([DataTypeId])
GO
ALTER TABLE [dbo].[uCommerce_DefinitionField] CHECK CONSTRAINT [FK_uCommerce_DefinitionField_uCommerce_DataType]
GO
ALTER TABLE [dbo].[uCommerce_DefinitionField]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_DefinitionField_uCommerce_Definition] FOREIGN KEY([DefinitionId])
REFERENCES [dbo].[uCommerce_Definition] ([DefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_DefinitionField] CHECK CONSTRAINT [FK_uCommerce_DefinitionField_uCommerce_Definition]
GO
ALTER TABLE [dbo].[uCommerce_DefinitionFieldDescription]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_DefinitionFieldDescription_uCommerce_DefinitionField] FOREIGN KEY([DefinitionFieldId])
REFERENCES [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_DefinitionFieldDescription] CHECK CONSTRAINT [FK_uCommerce_DefinitionFieldDescription_uCommerce_DefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_DefinitionTypeDescription]  WITH CHECK ADD  CONSTRAINT [FK_DefinitionTypeDescription_uCommerce_DefinitionType] FOREIGN KEY([DefinitionTypeId])
REFERENCES [dbo].[uCommerce_DefinitionType] ([DefinitionTypeId])
GO
ALTER TABLE [dbo].[uCommerce_DefinitionTypeDescription] CHECK CONSTRAINT [FK_DefinitionTypeDescription_uCommerce_DefinitionType]
GO
ALTER TABLE [dbo].[uCommerce_Discount]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Discount_uCommerce_PurchaseOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_Discount] CHECK CONSTRAINT [FK_uCommerce_Discount_uCommerce_PurchaseOrder]
GO
ALTER TABLE [dbo].[uCommerce_EmailContent]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_EmailContent_EmailProfile] FOREIGN KEY([EmailProfileId])
REFERENCES [dbo].[uCommerce_EmailProfile] ([EmailProfileId])
GO
ALTER TABLE [dbo].[uCommerce_EmailContent] CHECK CONSTRAINT [uCommerce_FK_EmailContent_EmailProfile]
GO
ALTER TABLE [dbo].[uCommerce_EmailContent]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_EmailContent_EmailType] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[uCommerce_EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[uCommerce_EmailContent] CHECK CONSTRAINT [uCommerce_FK_EmailContent_EmailType]
GO
ALTER TABLE [dbo].[uCommerce_EmailProfileInformation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_EmailProfileInformation_uCommerce_EmailProfile] FOREIGN KEY([EmailProfileId])
REFERENCES [dbo].[uCommerce_EmailProfile] ([EmailProfileId])
GO
ALTER TABLE [dbo].[uCommerce_EmailProfileInformation] CHECK CONSTRAINT [FK_uCommerce_EmailProfileInformation_uCommerce_EmailProfile]
GO
ALTER TABLE [dbo].[uCommerce_EmailProfileInformation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_EmailProfileInformation_uCommerce_EmailType] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[uCommerce_EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[uCommerce_EmailProfileInformation] CHECK CONSTRAINT [FK_uCommerce_EmailProfileInformation_uCommerce_EmailType]
GO
ALTER TABLE [dbo].[uCommerce_EmailTypeParameter]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_EmailTypeParameter_EmailParameter] FOREIGN KEY([EmailParameterId])
REFERENCES [dbo].[uCommerce_EmailParameter] ([EmailParameterId])
GO
ALTER TABLE [dbo].[uCommerce_EmailTypeParameter] CHECK CONSTRAINT [uCommerce_FK_EmailTypeParameter_EmailParameter]
GO
ALTER TABLE [dbo].[uCommerce_EmailTypeParameter]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_EmailTypeParameter_EmailType] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[uCommerce_EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[uCommerce_EmailTypeParameter] CHECK CONSTRAINT [uCommerce_FK_EmailTypeParameter_EmailType]
GO
ALTER TABLE [dbo].[uCommerce_EntityUiDescription]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_EntityUiDescription_uCommerce_EntityUi] FOREIGN KEY([EntityUiId])
REFERENCES [dbo].[uCommerce_EntityUi] ([EntityUiId])
GO
ALTER TABLE [dbo].[uCommerce_EntityUiDescription] CHECK CONSTRAINT [FK_uCommerce_EntityUiDescription_uCommerce_EntityUi]
GO
ALTER TABLE [dbo].[uCommerce_OrderAddress]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_OrderAddress_uCommerce_PurchaseOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_OrderAddress] CHECK CONSTRAINT [FK_uCommerce_OrderAddress_uCommerce_PurchaseOrder]
GO
ALTER TABLE [dbo].[uCommerce_OrderAddress]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderAddress_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[uCommerce_Country] ([CountryId])
GO
ALTER TABLE [dbo].[uCommerce_OrderAddress] CHECK CONSTRAINT [uCommerce_FK_OrderAddress_Country]
GO
ALTER TABLE [dbo].[uCommerce_OrderLine]  WITH CHECK ADD  CONSTRAINT [FK_OrderLine_Shipment] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[uCommerce_Shipment] ([ShipmentId])
GO
ALTER TABLE [dbo].[uCommerce_OrderLine] CHECK CONSTRAINT [FK_OrderLine_Shipment]
GO
ALTER TABLE [dbo].[uCommerce_OrderLine]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderLine_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_OrderLine] CHECK CONSTRAINT [uCommerce_FK_OrderLine_Order]
GO
ALTER TABLE [dbo].[uCommerce_OrderLineDiscountRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_OrderLineDiscountRelation_uCommerce_Discount] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[uCommerce_Discount] ([DiscountId])
GO
ALTER TABLE [dbo].[uCommerce_OrderLineDiscountRelation] CHECK CONSTRAINT [FK_uCommerce_OrderLineDiscountRelation_uCommerce_Discount]
GO
ALTER TABLE [dbo].[uCommerce_OrderLineDiscountRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_OrderLineDiscountRelation_uCommerce_OrderLine] FOREIGN KEY([OrderLineId])
REFERENCES [dbo].[uCommerce_OrderLine] ([OrderLineId])
GO
ALTER TABLE [dbo].[uCommerce_OrderLineDiscountRelation] CHECK CONSTRAINT [FK_uCommerce_OrderLineDiscountRelation_uCommerce_OrderLine]
GO
ALTER TABLE [dbo].[uCommerce_OrderProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_OrderProperty_uCommerce_OrderLine] FOREIGN KEY([OrderLineId])
REFERENCES [dbo].[uCommerce_OrderLine] ([OrderLineId])
GO
ALTER TABLE [dbo].[uCommerce_OrderProperty] CHECK CONSTRAINT [FK_uCommerce_OrderProperty_uCommerce_OrderLine]
GO
ALTER TABLE [dbo].[uCommerce_OrderProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_OrderProperty_uCommerce_PurchaseOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_OrderProperty] CHECK CONSTRAINT [FK_uCommerce_OrderProperty_uCommerce_PurchaseOrder]
GO
ALTER TABLE [dbo].[uCommerce_OrderStatus]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderStatus_OrderStatus1] FOREIGN KEY([NextOrderStatusId])
REFERENCES [dbo].[uCommerce_OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [dbo].[uCommerce_OrderStatus] CHECK CONSTRAINT [uCommerce_FK_OrderStatus_OrderStatus1]
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusAudit]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderStatusAudit_OrderStatus] FOREIGN KEY([NewOrderStatusId])
REFERENCES [dbo].[uCommerce_OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusAudit] CHECK CONSTRAINT [uCommerce_FK_OrderStatusAudit_OrderStatus]
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusAudit]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderStatusAudit_PurchaseOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusAudit] CHECK CONSTRAINT [uCommerce_FK_OrderStatusAudit_PurchaseOrder]
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_OrderStatusDescription_OrderStatus] FOREIGN KEY([OrderStatusId])
REFERENCES [dbo].[uCommerce_OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [dbo].[uCommerce_OrderStatusDescription] CHECK CONSTRAINT [uCommerce_FK_OrderStatusDescription_OrderStatus]
GO
ALTER TABLE [dbo].[uCommerce_Payment]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Payment_Order] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_Payment] CHECK CONSTRAINT [uCommerce_FK_Payment_Order]
GO
ALTER TABLE [dbo].[uCommerce_Payment]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Payment_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_Payment] CHECK CONSTRAINT [uCommerce_FK_Payment_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_Payment]  WITH NOCHECK ADD  CONSTRAINT [uCommerce_FK_Payment_PaymentStatus] FOREIGN KEY([PaymentStatusId])
REFERENCES [dbo].[uCommerce_PaymentStatus] ([PaymentStatusId])
GO
ALTER TABLE [dbo].[uCommerce_Payment] CHECK CONSTRAINT [uCommerce_FK_Payment_PaymentStatus]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethod]  WITH CHECK ADD FOREIGN KEY([DefinitionId])
REFERENCES [dbo].[uCommerce_Definition] ([DefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodCountry]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodCountry_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[uCommerce_Country] ([CountryId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodCountry] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodCountry_Country]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodCountry]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodCountry_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodCountry] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodCountry_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodDescription_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodDescription] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodDescription_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodFee_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[uCommerce_Currency] ([CurrencyId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodFee_Currency]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodFee_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodFee_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PaymentMethodFee_PriceGroup] FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodFee] CHECK CONSTRAINT [uCommerce_FK_PaymentMethodFee_PriceGroup]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_PaymentMethodProperty_uCommerce_DefinitionField] FOREIGN KEY([DefinitionFieldId])
REFERENCES [dbo].[uCommerce_DefinitionField] ([DefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodProperty] CHECK CONSTRAINT [FK_uCommerce_PaymentMethodProperty_uCommerce_DefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_PaymentMethodProperty_uCommerce_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentMethodProperty] CHECK CONSTRAINT [FK_uCommerce_PaymentMethodProperty_uCommerce_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_PaymentProperty]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_PaymentProperty_uCommerce_Payment] FOREIGN KEY([PaymentId])
REFERENCES [dbo].[uCommerce_Payment] ([PaymentId])
GO
ALTER TABLE [dbo].[uCommerce_PaymentProperty] CHECK CONSTRAINT [FK_uCommerce_PaymentProperty_uCommerce_Payment]
GO

ALTER TABLE [dbo].[uCommerce_Permission]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_Permission_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[uCommerce_Role] ([RoleId])
GO
ALTER TABLE [dbo].[uCommerce_Permission] CHECK CONSTRAINT [FK_uCommerce_Permission_RoleId]
GO
ALTER TABLE [dbo].[uCommerce_Permission]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_Permission_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[uCommerce_User] ([UserId])
GO
ALTER TABLE [dbo].[uCommerce_Permission] CHECK CONSTRAINT [FK_uCommerce_Permission_UserId]
GO

ALTER TABLE [dbo].[uCommerce_PriceGroup]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PriceGroup_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[uCommerce_Currency] ([CurrencyId])
GO
ALTER TABLE [dbo].[uCommerce_PriceGroup] CHECK CONSTRAINT [uCommerce_FK_PriceGroup_Currency]
GO
ALTER TABLE [dbo].[uCommerce_PriceGroupPrice]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PriceGroupPrice_PriceGroup] FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_PriceGroupPrice] CHECK CONSTRAINT [uCommerce_FK_PriceGroupPrice_PriceGroup]
GO
ALTER TABLE [dbo].[uCommerce_PriceGroupPrice]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_PriceGroupPrice_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_PriceGroupPrice] CHECK CONSTRAINT [uCommerce_FK_PriceGroupPrice_Product]
GO
ALTER TABLE [dbo].[uCommerce_Product]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Product_ParentProduct] FOREIGN KEY([ParentProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_Product] CHECK CONSTRAINT [FK_uCommerce_Product_ParentProduct]
GO
ALTER TABLE [dbo].[uCommerce_Product]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Product_ProductDefinition] FOREIGN KEY([ProductDefinitionId])
REFERENCES [dbo].[uCommerce_ProductDefinition] ([ProductDefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_Product] CHECK CONSTRAINT [uCommerce_FK_Product_ProductDefinition]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalog]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Catalog_CatalogGroup] FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalog] CHECK CONSTRAINT [uCommerce_FK_Catalog_CatalogGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalog]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Catalog_PriceGroup] FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalog] CHECK CONSTRAINT [uCommerce_FK_Catalog_PriceGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogDescription_ProductCatalog] FOREIGN KEY([ProductCatalogId])
REFERENCES [dbo].[uCommerce_ProductCatalog] ([ProductCatalogId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogDescription] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogDescription_ProductCatalog]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroup_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[uCommerce_Currency] ([CurrencyId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroup_Currency]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroup_EmailProfile] FOREIGN KEY([EmailProfileId])
REFERENCES [dbo].[uCommerce_EmailProfile] ([EmailProfileId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroup_EmailProfile]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroup_OrderNumbers] FOREIGN KEY([OrderNumberId])
REFERENCES [dbo].[uCommerce_OrderNumberSerie] ([OrderNumberId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroup] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroup_OrderNumbers]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupCampaignRelation]  WITH CHECK ADD FOREIGN KEY([CampaignId])
REFERENCES [dbo].[uCommerce_Campaign] ([CampaignId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupCampaignRelation]  WITH CHECK ADD FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroupPaymentMethodMap_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroupPaymentMethodMap_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroupPaymentMethodMap_ProductCatalogGroup] FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupPaymentMethodMap] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroupPaymentMethodMap_ProductCatalogGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroupShippingMethodMap_ProductCatalogGroup] FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroupShippingMethodMap_ProductCatalogGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductCatalogGroupShippingMethodMap_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogGroupShippingMethodMap] CHECK CONSTRAINT [uCommerce_FK_ProductCatalogGroupShippingMethodMap_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductCatalogPriceGroupRelation_uCommerce_PriceGroup] FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation] CHECK CONSTRAINT [FK_uCommerce_ProductCatalogPriceGroupRelation_uCommerce_PriceGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductCatalogPriceGroupRelation_uCommerce_ProductCatalog] FOREIGN KEY([ProductCatalogId])
REFERENCES [dbo].[uCommerce_ProductCatalog] ([ProductCatalogId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogPriceGroupRelation] CHECK CONSTRAINT [FK_uCommerce_ProductCatalogPriceGroupRelation_uCommerce_ProductCatalog]
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogTarget]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductCatalogTarget_uCommerce_Target] FOREIGN KEY([ProductCatalogTargetId])
REFERENCES [dbo].[uCommerce_Target] ([TargetId])
GO
ALTER TABLE [dbo].[uCommerce_ProductCatalogTarget] CHECK CONSTRAINT [FK_uCommerce_ProductCatalogTarget_uCommerce_Target]
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinition]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDefinition_ProductDefinition] FOREIGN KEY([ProductDefinitionId])
REFERENCES [dbo].[uCommerce_ProductDefinition] ([ProductDefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinition] CHECK CONSTRAINT [uCommerce_FK_ProductDefinition_ProductDefinition]
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionField]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDefinitionField_DataType] FOREIGN KEY([DataTypeId])
REFERENCES [dbo].[uCommerce_DataType] ([DataTypeId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionField] CHECK CONSTRAINT [uCommerce_FK_ProductDefinitionField_DataType]
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionField]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDefinitionField_ProductDefinition] FOREIGN KEY([ProductDefinitionId])
REFERENCES [dbo].[uCommerce_ProductDefinition] ([ProductDefinitionId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionField] CHECK CONSTRAINT [uCommerce_FK_ProductDefinitionField_ProductDefinition]
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionFieldDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDefinitionFieldDescription_ProductDefinitionField] FOREIGN KEY([ProductDefinitionFieldId])
REFERENCES [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDefinitionFieldDescription] CHECK CONSTRAINT [uCommerce_FK_ProductDefinitionFieldDescription_ProductDefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_ProductDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDescription_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDescription] CHECK CONSTRAINT [uCommerce_FK_ProductDescription_Product]
GO
ALTER TABLE [dbo].[uCommerce_ProductDescriptionProperty]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDescriptionProperty_ProductDefinitionField] FOREIGN KEY([ProductDefinitionFieldId])
REFERENCES [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDescriptionProperty] CHECK CONSTRAINT [uCommerce_FK_ProductDescriptionProperty_ProductDefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_ProductDescriptionProperty]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductDescriptionProperty_ProductDescription] FOREIGN KEY([ProductDescriptionId])
REFERENCES [dbo].[uCommerce_ProductDescription] ([ProductDescriptionId])
GO
ALTER TABLE [dbo].[uCommerce_ProductDescriptionProperty] CHECK CONSTRAINT [uCommerce_FK_ProductDescriptionProperty_ProductDescription]
GO
ALTER TABLE [dbo].[uCommerce_ProductProperty]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductProperty_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_ProductProperty] CHECK CONSTRAINT [uCommerce_FK_ProductProperty_Product]
GO
ALTER TABLE [dbo].[uCommerce_ProductProperty]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ProductProperty_ProductDefinitionField] FOREIGN KEY([ProductDefinitionFieldId])
REFERENCES [dbo].[uCommerce_ProductDefinitionField] ([ProductDefinitionFieldId])
GO
ALTER TABLE [dbo].[uCommerce_ProductProperty] CHECK CONSTRAINT [uCommerce_FK_ProductProperty_ProductDefinitionField]
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_Product2] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation] CHECK CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_Product2]
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_Product3] FOREIGN KEY([RelatedProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation] CHECK CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_Product3]
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_ProductRelationType] FOREIGN KEY([ProductRelationTypeId])
REFERENCES [dbo].[uCommerce_ProductRelationType] ([ProductRelationTypeId])
GO
ALTER TABLE [dbo].[uCommerce_ProductRelation] CHECK CONSTRAINT [FK_uCommerce_ProductRelation_uCommerce_ProductRelationType]
GO
ALTER TABLE [dbo].[uCommerce_ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[uCommerce_Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReview] CHECK CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_Customer]
GO
ALTER TABLE [dbo].[uCommerce_ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[uCommerce_Product] ([ProductId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReview] CHECK CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_Product]
GO
ALTER TABLE [dbo].[uCommerce_ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_ProductCatalogGroup] FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReview] CHECK CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_ProductCatalogGroup]
GO
ALTER TABLE [dbo].[uCommerce_ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_ProductReviewStatus] FOREIGN KEY([ProductReviewStatusId])
REFERENCES [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReview] CHECK CONSTRAINT [FK_uCommerce_ProductReview_uCommerce_ProductReviewStatus]
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[uCommerce_Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment] CHECK CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_Customer]
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_ProductReview] FOREIGN KEY([ProductReviewId])
REFERENCES [dbo].[uCommerce_ProductReview] ([ProductReviewId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment] CHECK CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_ProductReview]
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_ProductReviewStatus] FOREIGN KEY([ProductReviewStatusId])
REFERENCES [dbo].[uCommerce_ProductReviewStatus] ([ProductReviewStatusId])
GO
ALTER TABLE [dbo].[uCommerce_ProductReviewComment] CHECK CONSTRAINT [FK_uCommerce_ProductReviewComment_uCommerce_ProductReviewStatus]
GO
ALTER TABLE [dbo].[uCommerce_ProductTarget]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ProductTarget_uCommerce_Target] FOREIGN KEY([ProductTargetId])
REFERENCES [dbo].[uCommerce_Target] ([TargetId])
GO
ALTER TABLE [dbo].[uCommerce_ProductTarget] CHECK CONSTRAINT [FK_uCommerce_ProductTarget_uCommerce_Target]
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_PurchaseOrder_uCommerce_OrderAddress] FOREIGN KEY([BillingAddressId])
REFERENCES [dbo].[uCommerce_OrderAddress] ([OrderAddressId])
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder] CHECK CONSTRAINT [FK_uCommerce_PurchaseOrder_uCommerce_OrderAddress]
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Order_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[uCommerce_Currency] ([CurrencyId])
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder] CHECK CONSTRAINT [uCommerce_FK_Order_Currency]
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Order_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[uCommerce_Customer] ([CustomerId])
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder] CHECK CONSTRAINT [uCommerce_FK_Order_Customer]
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Order_OrderStatus1] FOREIGN KEY([OrderStatusId])
REFERENCES [dbo].[uCommerce_OrderStatus] ([OrderStatusId])
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder] CHECK CONSTRAINT [uCommerce_FK_Order_OrderStatus1]
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Order_ProductCatalogGroup] FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_PurchaseOrder] CHECK CONSTRAINT [uCommerce_FK_Order_ProductCatalogGroup]
GO
ALTER TABLE [dbo].[uCommerce_Role]  WITH CHECK ADD FOREIGN KEY([ParentRoleId])
REFERENCES [dbo].[uCommerce_Role] ([RoleId])
GO
ALTER TABLE [dbo].[uCommerce_Role]  WITH CHECK ADD FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_Role]  WITH CHECK ADD FOREIGN KEY([ProductCatalogGroupId])
REFERENCES [dbo].[uCommerce_ProductCatalogGroup] ([ProductCatalogGroupId])
GO
ALTER TABLE [dbo].[uCommerce_Role]  WITH CHECK ADD FOREIGN KEY([ProductCatalogId])
REFERENCES [dbo].[uCommerce_ProductCatalog] ([ProductCatalogId])
GO
ALTER TABLE [dbo].[uCommerce_Shipment]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Shipment_uCommerce_OrderAddress] FOREIGN KEY([ShipmentAddressId])
REFERENCES [dbo].[uCommerce_OrderAddress] ([OrderAddressId])
GO
ALTER TABLE [dbo].[uCommerce_Shipment] CHECK CONSTRAINT [FK_uCommerce_Shipment_uCommerce_OrderAddress]
GO
ALTER TABLE [dbo].[uCommerce_Shipment]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Shipment_uCommerce_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_Shipment] CHECK CONSTRAINT [FK_uCommerce_Shipment_uCommerce_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_Shipment]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_Shipment_PurchaseOrder] FOREIGN KEY([OrderId])
REFERENCES [dbo].[uCommerce_PurchaseOrder] ([OrderId])
GO
ALTER TABLE [dbo].[uCommerce_Shipment] CHECK CONSTRAINT [uCommerce_FK_Shipment_PurchaseOrder]
GO
ALTER TABLE [dbo].[uCommerce_ShipmentDiscountRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ShipmentDiscountRelation_uCommerce_Discount] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[uCommerce_Discount] ([DiscountId])
GO
ALTER TABLE [dbo].[uCommerce_ShipmentDiscountRelation] CHECK CONSTRAINT [FK_uCommerce_ShipmentDiscountRelation_uCommerce_Discount]
GO
ALTER TABLE [dbo].[uCommerce_ShipmentDiscountRelation]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_ShipmentDiscountRelation_uCommerce_Shipment] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[uCommerce_Shipment] ([ShipmentId])
GO
ALTER TABLE [dbo].[uCommerce_ShipmentDiscountRelation] CHECK CONSTRAINT [FK_uCommerce_ShipmentDiscountRelation_uCommerce_Shipment]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethod]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethod_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethod] CHECK CONSTRAINT [uCommerce_FK_ShippingMethod_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodCountry]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodCountry_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[uCommerce_Country] ([CountryId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodCountry] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodCountry_Country]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodCountry]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodCountry_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodCountry] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodCountry_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodDescription]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodDescription_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodDescription] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodDescription_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPaymentMethods]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodPaymentMethods_PaymentMethod] FOREIGN KEY([PaymentMethodId])
REFERENCES [dbo].[uCommerce_PaymentMethod] ([PaymentMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPaymentMethods] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodPaymentMethods_PaymentMethod]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPaymentMethods]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodPaymentMethods_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPaymentMethods] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodPaymentMethods_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodPrice_Currency] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[uCommerce_Currency] ([CurrencyId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodPrice_Currency]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodPrice_PriceGroup] FOREIGN KEY([PriceGroupId])
REFERENCES [dbo].[uCommerce_PriceGroup] ([PriceGroupId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodPrice_PriceGroup]
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice]  WITH CHECK ADD  CONSTRAINT [uCommerce_FK_ShippingMethodPrice_ShippingMethod] FOREIGN KEY([ShippingMethodId])
REFERENCES [dbo].[uCommerce_ShippingMethod] ([ShippingMethodId])
GO
ALTER TABLE [dbo].[uCommerce_ShippingMethodPrice] CHECK CONSTRAINT [uCommerce_FK_ShippingMethodPrice_ShippingMethod]
GO
ALTER TABLE [dbo].[uCommerce_Target]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_Target_uCommerce_Target] FOREIGN KEY([CampaignItemId])
REFERENCES [dbo].[uCommerce_CampaignItem] ([CampaignItemId])
GO
ALTER TABLE [dbo].[uCommerce_Target] CHECK CONSTRAINT [FK_uCommerce_Target_uCommerce_Target]
GO

ALTER TABLE [dbo].[uCommerce_UserGroupPermission]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_UserGroupPermission_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[uCommerce_Role] ([RoleId])
GO
ALTER TABLE [dbo].[uCommerce_UserGroupPermission] CHECK CONSTRAINT [FK_uCommerce_UserGroupPermission_RoleId]
GO
ALTER TABLE [dbo].[uCommerce_UserGroupPermission]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_UserGroupPermission_UserGroupId] FOREIGN KEY([UserGroupId])
REFERENCES [dbo].[uCommerce_UserGroup] ([UserGroupId])
GO
ALTER TABLE [dbo].[uCommerce_UserGroupPermission] CHECK CONSTRAINT [FK_uCommerce_UserGroupPermission_UserGroupId]
GO
ALTER TABLE [dbo].[uCommerce_UserWidgetSetting]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_UserWidgetSetting_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[uCommerce_User] ([UserId])
GO
ALTER TABLE [dbo].[uCommerce_UserWidgetSetting] CHECK CONSTRAINT [FK_uCommerce_UserWidgetSetting_UserId]
GO
ALTER TABLE [dbo].[uCommerce_UserWidgetSettingProperty]  WITH CHECK ADD CONSTRAINT [FK_uCommerce_UserWidgetSettingProperty_UserWidgetSettingId] FOREIGN KEY([UserWidgetSettingId])
REFERENCES [dbo].[uCommerce_UserWidgetSetting] ([UserWidgetSettingId])
GO
ALTER TABLE [dbo].[uCommerce_UserWidgetSettingProperty] CHECK CONSTRAINT [FK_uCommerce_UserWidgetSettingProperty_UserWidgetSettingId]
GO

ALTER TABLE [dbo].[uCommerce_VoucherCode]  WITH NOCHECK ADD  CONSTRAINT [FK_uCommerce_VoucherCode_uCommerce_VoucherCode] FOREIGN KEY([TargetId])
REFERENCES [dbo].[uCommerce_VoucherTarget] ([VoucherTargetId])
GO
ALTER TABLE [dbo].[uCommerce_VoucherCode] CHECK CONSTRAINT [FK_uCommerce_VoucherCode_uCommerce_VoucherCode]
GO
ALTER TABLE [dbo].[uCommerce_VoucherTarget]  WITH CHECK ADD  CONSTRAINT [FK_uCommerce_VoucherTarget_uCommerce_Target] FOREIGN KEY([VoucherTargetId])
REFERENCES [dbo].[uCommerce_Target] ([TargetId])
GO
ALTER TABLE [dbo].[uCommerce_VoucherTarget] CHECK CONSTRAINT [FK_uCommerce_VoucherTarget_uCommerce_Target]
GO
ALTER TABLE [dbo].[umbracoAccess]  WITH CHECK ADD  CONSTRAINT [FK_umbracoAccess_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoAccess] CHECK CONSTRAINT [FK_umbracoAccess_umbracoNode_id]
GO
ALTER TABLE [dbo].[umbracoAccess]  WITH CHECK ADD  CONSTRAINT [FK_umbracoAccess_umbracoNode_id1] FOREIGN KEY([loginNodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoAccess] CHECK CONSTRAINT [FK_umbracoAccess_umbracoNode_id1]
GO
ALTER TABLE [dbo].[umbracoAccess]  WITH CHECK ADD  CONSTRAINT [FK_umbracoAccess_umbracoNode_id2] FOREIGN KEY([noAccessNodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoAccess] CHECK CONSTRAINT [FK_umbracoAccess_umbracoNode_id2]
GO
ALTER TABLE [dbo].[umbracoAccessRule]  WITH CHECK ADD  CONSTRAINT [FK_umbracoAccessRule_umbracoAccess_id] FOREIGN KEY([accessId])
REFERENCES [dbo].[umbracoAccess] ([id])
GO
ALTER TABLE [dbo].[umbracoAccessRule] CHECK CONSTRAINT [FK_umbracoAccessRule_umbracoAccess_id]
GO
ALTER TABLE [dbo].[umbracoDomains]  WITH CHECK ADD  CONSTRAINT [FK_umbracoDomains_umbracoNode_id] FOREIGN KEY([domainRootStructureID])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoDomains] CHECK CONSTRAINT [FK_umbracoDomains_umbracoNode_id]
GO
ALTER TABLE [dbo].[umbracoNode]  WITH CHECK ADD  CONSTRAINT [FK_umbracoNode_umbracoNode_id] FOREIGN KEY([parentID])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoNode] CHECK CONSTRAINT [FK_umbracoNode_umbracoNode_id]
GO
ALTER TABLE [dbo].[umbracoRelation]  WITH CHECK ADD  CONSTRAINT [FK_umbracoRelation_umbracoNode] FOREIGN KEY([parentId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoRelation] CHECK CONSTRAINT [FK_umbracoRelation_umbracoNode]
GO
ALTER TABLE [dbo].[umbracoRelation]  WITH CHECK ADD  CONSTRAINT [FK_umbracoRelation_umbracoNode1] FOREIGN KEY([childId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoRelation] CHECK CONSTRAINT [FK_umbracoRelation_umbracoNode1]
GO
ALTER TABLE [dbo].[umbracoRelation]  WITH CHECK ADD  CONSTRAINT [FK_umbracoRelation_umbracoRelationType_id] FOREIGN KEY([relType])
REFERENCES [dbo].[umbracoRelationType] ([id])
GO
ALTER TABLE [dbo].[umbracoRelation] CHECK CONSTRAINT [FK_umbracoRelation_umbracoRelationType_id]
GO
ALTER TABLE [dbo].[umbracoUser]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser_umbracoUserType_id] FOREIGN KEY([userType])
REFERENCES [dbo].[umbracoUserType] ([id])
GO
ALTER TABLE [dbo].[umbracoUser] CHECK CONSTRAINT [FK_umbracoUser_umbracoUserType_id]
GO
ALTER TABLE [dbo].[umbracoUser2app]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser2app_umbracoUser_id] FOREIGN KEY([user])
REFERENCES [dbo].[umbracoUser] ([id])
GO
ALTER TABLE [dbo].[umbracoUser2app] CHECK CONSTRAINT [FK_umbracoUser2app_umbracoUser_id]
GO
ALTER TABLE [dbo].[umbracoUser2NodeNotify]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser2NodeNotify_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoUser2NodeNotify] CHECK CONSTRAINT [FK_umbracoUser2NodeNotify_umbracoNode_id]
GO
ALTER TABLE [dbo].[umbracoUser2NodeNotify]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser2NodeNotify_umbracoUser_id] FOREIGN KEY([userId])
REFERENCES [dbo].[umbracoUser] ([id])
GO
ALTER TABLE [dbo].[umbracoUser2NodeNotify] CHECK CONSTRAINT [FK_umbracoUser2NodeNotify_umbracoUser_id]
GO
ALTER TABLE [dbo].[umbracoUser2NodePermission]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser2NodePermission_umbracoNode_id] FOREIGN KEY([nodeId])
REFERENCES [dbo].[umbracoNode] ([id])
GO
ALTER TABLE [dbo].[umbracoUser2NodePermission] CHECK CONSTRAINT [FK_umbracoUser2NodePermission_umbracoNode_id]
GO
ALTER TABLE [dbo].[umbracoUser2NodePermission]  WITH CHECK ADD  CONSTRAINT [FK_umbracoUser2NodePermission_umbracoUser_id] FOREIGN KEY([userId])
REFERENCES [dbo].[umbracoUser] ([id])
GO
ALTER TABLE [dbo].[umbracoUser2NodePermission] CHECK CONSTRAINT [FK_umbracoUser2NodePermission_umbracoUser_id]
GO
/****** Object:  StoredProcedure [dbo].[uCommerce_GetOrderNumber]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	Fix for concurrently generating order numbers without duplicates under high load
	and moving prefix and suffix to the OrderNumberSeriesService.
 */
CREATE PROCEDURE [dbo].[uCommerce_GetOrderNumber]
	@OrderNumberName NVARCHAR(128)
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE @Increment INT
	SELECT @Increment = Increment FROM uCommerce_OrderNumberSerie WHERE OrderNumberName = @OrderNumberName;

	DECLARE @TabCounter TABLE (NewCounter INT);
	UPDATE uCommerce_OrderNumberSerie SET CurrentNumber = CurrentNumber+@Increment
	OUTPUT INSERTED.CurrentNumber INTO @tabCounter (NewCounter)
	WHERE OrderNumberName = @OrderNumberName;

	DECLARE @NextOrderNumber INT;
	SELECT @NextOrderNumber = NewCounter FROM @TabCounter;

	SELECT CONVERT(NVARCHAR(256),(@NextOrderNumber)) OrderNumber
	FROM uCommerce_OrderNumberSerie 
	WHERE OrderNumberName = @OrderNumberName;

END
GO
/****** Object:  StoredProcedure [dbo].[uCommerce_GetProductTop10]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Fix for proc including "Cancelled orders"
CREATE PROCEDURE [dbo].[uCommerce_GetProductTop10]
( 
	@ProductCatalogGroupId INT
)
AS
	SET NOCOUNT ON
	
	SELECT TOP 10
		dbo.uCommerce_ProductCatalogGroup.Name,
		dbo.uCommerce_OrderLine.Sku,
		dbo.uCommerce_OrderLine.VariantSku,
		dbo.uCommerce_OrderLine.ProductName,
		SUM(dbo.uCommerce_OrderLine.Quantity) TotalSales,
		SUM(ISNULL(dbo.uCommerce_OrderLine.Total, 0)) TotalRevenue,
		dbo.uCommerce_Currency.ISOCode Currency
	FROM
		dbo.uCommerce_OrderLine
		JOIN dbo.uCommerce_PurchaseOrder ON dbo.uCommerce_PurchaseOrder.OrderId = dbo.uCommerce_OrderLine.OrderId
		JOIN dbo.uCommerce_Currency ON dbo.uCommerce_Currency.CurrencyId = dbo.uCommerce_PurchaseOrder.CurrencyId
		LEFT JOIN dbo.uCommerce_ProductCatalogGroup ON dbo.uCommerce_ProductCatalogGroup.ProductCatalogGroupId = dbo.uCommerce_PurchaseOrder.ProductCatalogGroupId
	WHERE
		(	dbo.uCommerce_ProductCatalogGroup.ProductCatalogGroupId = @ProductCatalogGroupId
			OR
			@ProductCatalogGroupId IS NULL
		)
		AND
			dbo.uCommerce_PurchaseOrder.OrderStatusId in (2, 3, 5, 6, 1000000) -- New order, Completed order, Invoiced, Paid, Requires Attention
	GROUP BY
		dbo.uCommerce_OrderLine.Sku,
		dbo.uCommerce_OrderLine.VariantSku,
		dbo.uCommerce_OrderLine.ProductName,
		dbo.uCommerce_ProductCatalogGroup.Name,
		dbo.uCommerce_Currency.ISOCode
	ORDER BY
		SUM(dbo.uCommerce_OrderLine.Quantity) DESC,
		dbo.uCommerce_ProductCatalogGroup.Name

GO
/****** Object:  StoredProcedure [dbo].[uCommerce_GetProductView]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[uCommerce_GetProductView] 
	@ProductCatalogId INT,
	@CategoryID INT,
	@CultureCode NVARCHAR(50),
	@ProductId INT = NULL,
	@IncludeVariants BIT = 0,
	@IncludeInvisibleProducts BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
            dbo.Product.ProductId, 
			dbo.Product.Sku, 
			dbo.Product.VariantSku, 
			dbo.Product.Name, 
			dbo.Product.DisplayOnSite, 
			dbo.Product.PrimaryImageMediaId, 
            dbo.Currency.ISOCode AS Currency, 
			dbo.PriceGroup.VATRate, 
			dbo.PriceGroupPrice.DiscountPrice AS DiscountPriceAmount, 
			dbo.PriceGroupPrice.Price AS PriceAmount, 
            dbo.ProductDefinition.Name AS ProductDefinitionDisplayName, 
			dbo.ProductDescription.CultureCode, dbo.ProductDescription.DisplayName, 
            dbo.ProductDescription.ShortDescription, 
			dbo.ProductDescription.LongDescription, 
			dbo.InventoryRecord.OnHandQuantity, 
			dbo.InventoryRecord.ReservedQuantity,                     
			dbo.InventoryRecord.Location, 
			dbo.ProductCatalog.Name AS ProductCatalogName, 
			dbo.ProductCatalog.ShowPricesIncludingVAT AS ShowPriceIncludingVAT,
			dbo.Product.ThumbnailImageMediaId
	FROM 
			dbo.Product 
			INNER JOIN dbo.ProductDefinition ON dbo.Product.ProductDefinitionId = dbo.ProductDefinition.ProductDefinitionId 
			INNER JOIN dbo.ProductDescription ON dbo.Product.ProductId = dbo.ProductDescription.ProductId -- Sproget version af beskrivelse, en række per sprog
			-- Catalog info
			LEFT JOIN dbo.CategoryProductRelation ON dbo.CategoryProductRelation.ProductId = dbo.Product.ProductId
			LEFT JOIN dbo.Category ON dbo.Category.CategoryId = dbo.CategoryProductRelation.CategoryId
			LEFT JOIN dbo.ProductCatalog ON dbo.ProductCatalog.ProductCatalogId = dbo.Category.ProductCatalogId
			-- Pricing Info
			LEFT JOIN dbo.PriceGroupPrice ON dbo.PriceGroupPrice.ProductId = dbo.Product.ProductId AND dbo.ProductCatalog.PriceGroupId = dbo.PriceGroupPrice.PriceGroupId
			LEFT JOIN dbo.PriceGroup ON dbo.PriceGroup.PriceGroupId = dbo.PriceGroupPrice.PriceGroupId
			LEFT JOIN dbo.Currency ON dbo.Currency.CurrencyId = dbo.PriceGroup.CurrencyId
			-- Inventory info
			LEFT OUTER JOIN dbo.Inventory ON dbo.ProductCatalog.InventoryId = dbo.Inventory.InventoryId 
			LEFT OUTER JOIN dbo.InventoryRecord ON dbo.Product.ProductId = dbo.InventoryRecord.ProductId AND dbo.Inventory.InventoryId = dbo.InventoryRecord.InventoryId
WHERE		
			(dbo.ProductCatalog.ProductCatalogId = @ProductCatalogId) AND 
			(dbo.ProductDescription.CultureCode = @CultureCode) AND 
			(dbo.CategoryProductRelation.CategoryId = @CategoryId) AND 
			(dbo.Product.ProductId = @ProductId OR @ProductId IS NULL) AND
			(dbo.Product.VariantSKU IS NULL OR @IncludeVariants = 1) 
			AND
			(
				(dbo.Product.DisplayOnSite = 1)
				OR
				(@IncludeInvisibleProducts = 1)
			)
END

GO
/****** Object:  StoredProcedure [dbo].[uCommerce_GetTotalSales]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uCommerce_GetTotalSales]
(
	@StartDate DATETIME, -- NULLABLE
	@EndDate DATETIME, -- NULLABLE
	@ProductCatalogGroupId INT -- NULLABLE
)
AS
	SET NOCOUNT ON
	SELECT 
		dbo.uCommerce_ProductCatalogGroup.Name,
		SUM(ISNULL(dbo.uCommerce_PurchaseOrder.OrderTotal, 0)) Revenue,
		SUM(ISNULL(dbo.uCommerce_PurchaseOrder.VAT, 0)) [VATTotal],
		SUM(ISNULL(dbo.uCommerce_PurchaseOrder.TaxTotal, 0)) [TaxTotal],
		SUM(ISNULL(dbo.uCommerce_PurchaseOrder.ShippingTotal, 0)) [ShippingTotal],
		ISNULL(dbo.uCommerce_Currency.ISOCode, '-') Currency
	FROM
		dbo.uCommerce_PurchaseOrder
		JOIN dbo.uCommerce_Currency ON dbo.uCommerce_Currency.CurrencyId = dbo.uCommerce_PurchaseOrder.CurrencyId
		RIGHT JOIN dbo.uCommerce_ProductCatalogGroup ON dbo.uCommerce_ProductCatalogGroup.ProductCatalogGroupId = dbo.uCommerce_PurchaseOrder.ProductCatalogGroupId
	WHERE
		(
			dbo.uCommerce_PurchaseOrder.CreatedDate BETWEEN @StartDate AND @EndDate
			OR
			(
				@StartDate IS NULL
				AND
				@EndDate IS NULL
			)
			OR
			dbo.uCommerce_PurchaseOrder.CreatedDate IS NULL
		)
		AND
		(
			dbo.uCommerce_ProductCatalogGroup.ProductCatalogGroupId = @ProductCatalogGroupId
			OR
			@ProductCatalogGroupId IS NULL
		)
		AND
		(
			NOT dbo.uCommerce_PurchaseOrder.OrderStatusId IN (1, 4, 7) -- Basket, -- Cancelled Order, -- Cancelled
			OR
			dbo.uCommerce_PurchaseOrder.OrderStatusId IS NULL
		)
	GROUP BY
		dbo.uCommerce_ProductCatalogGroup.Name,
		dbo.uCommerce_Currency.ISOCode

GO
/****** Object:  StoredProcedure [dbo].[uCommerce_ProductSearchSimple]    Script Date: 9/12/2015 7:58:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[uCommerce_ProductSearchSimple] 
	@SearchTerm NVARCHAR(MAX),
	@LimitToCatalogIds NVARCHAR(MAX) -- comma separeted string of ints
AS
	SET NOCOUNT ON

	-- Escape special characters
	SELECT @SearchTerm = 
					REPLACE( 
					REPLACE( 
					REPLACE( 
					REPLACE(
					REPLACE(
					REPLACE( @SearchTerm
					,    '\', '\\'  )
					,	 '--', ''   )
					,	 '''', '\''')                
					,    '%', '\%'  )
					,    '_', '\_'  )
					,    '[', '\['  )

	SELECT @SearchTerm = '%' + @SearchTerm + '%'

	SELECT DISTINCT
		 Product.*
	FROM
		Product
		JOIN ProductProperty
			ON ProductProperty.ProductId = Product.ProductId
		JOIN ProductDefinitionField
			ON ProductDefinitionField.ProductDefinitionFieldId = ProductProperty.ProductDefinitionFieldId
		LEFT JOIN CategoryProductRelation
			ON CategoryProductRelation.ProductId = Product.ProductId
		LEFT JOIN Category
			ON Category.CategoryId = CategoryProductRelation.CategoryId
		LEFT JOIN ProductCatalog
			ON ProductCatalog.ProductCatalogId = Category.ProductCatalogId
		LEFT JOIN dbo.ParseArrayToTable(@LimitToCatalogIds, ';', 1) LimitToCatalogIdsTable
			ON LimitToCatalogIdsTable.NumericValue = ProductCatalog.ProductCatalogId OR @LimitToCatalogIds = '' OR @LimitToCatalogIds IS NULL
	WHERE
		(
			CategoryProductRelation.CategoryId IS NOT NULL
			AND
			(
				Product.Sku LIKE @SearchTerm
				OR
				Product.VariantSku LIKE @SearchTerm
				OR
				Product.Name LIKE @SearchTerm
				OR
				ProductProperty.Value LIKE @SearchTerm
			)
		)	
		OR
		(	-- Include products not in any category, which also matches the search term
			CategoryProductRelation.CategoryId IS NULL
			AND
			(	-- But only if no catalog ids to limit to were provided
				@LimitToCatalogIds IS NULL 
				OR
				@LimitToCatalogIds = ''
			)
			AND
			(
				Product.Sku LIKE @SearchTerm
				OR
				Product.VariantSku LIKE @SearchTerm
				OR
				Product.Name LIKE @SearchTerm
				OR
				ProductProperty.Value LIKE @SearchTerm
			)
		)				

GO

