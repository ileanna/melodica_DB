﻿CREATE TABLE [dbo].[DimEmployee](
    [EmployeeId] [int] PRIMARY KEY,
    [LastName] [nvarchar](20) NOT NULL,
    [FirstName] [nvarchar](20) NOT NULL,
    [Title] [nvarchar](30) NULL,
    [ReportsTo] [int] NULL,
    [BirthDate] [datetime] NULL,
    [HireDate] [datetime] NULL,
    [Address] [nvarchar](70) NULL,
    [City] [nvarchar](40) NULL,
    [State] [nvarchar](40) NULL,
    [Country] [nvarchar](40) NULL,
    [PostalCode] [nvarchar](10) NULL,
    [Phone] [nvarchar](24) NULL,
    [Fax] [nvarchar](24) NULL,
    [Email] [nvarchar](60) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );


CREATE TABLE [dbo].[DimTrack](
    [TrackId] [int] PRIMARY KEY,
    [TrackName] [nvarchar](200) NOT NULL,
    [AlbumId] [int] NULL,
    [GenreId] [int] NULL,
    [Composer] [nvarchar](220) NULL,
    [Milliseconds] [int] NOT NULL,
    [Bytes] [int] NULL,
    [UnitPrice] [numeric](10, 2) NOT NULL,
    [AlbumTitle] [nvarchar](160) NOT NULL,
    [ArtistId] [int] NOT NULL,
    [ArtistName] [nvarchar](120) NULL,
    [GenreName] [nvarchar](120) NULL,
    [MediaTypeId] [int] NOT NULL,
    [MediaTypeName][nvarchar](120) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );

CREATE TABLE [dbo].[FactInvoices](
    [InvoiceLineId] [int]  NOT NULL,
    [InvoiceId] [int] NOT NULL,
    [TrackId] [int] NOT NULL,
    [UnitPrice] [numeric](10, 2) NOT NULL,
    [Quantity] [int] NOT NULL,
    [CustomerKey] [int] NOT NULL,      --Customerkey
	--[EmployeeId] [int] NOT NULL,     ---EmployeeID
    [InvoiceDateKey] [int] NOT NULL,
    [BillingAddress] [nvarchar](70) NULL,
    [BillingCity] [nvarchar](40) NULL,
    [BillingState] [nvarchar](40) NULL,
    [BillingCountry] [nvarchar](40) NULL,
    [BillingPostalCode] [nvarchar](10) NULL,
    [Total] [numeric](10, 2) NOT NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
    );

CREATE TABLE [dbo].[DimPlaylist](
    [PlaylistId] [int] NOT NULL,
    [TrackId] [int] NOT NULL,
    [Name] [nvarchar](120) NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
	CONSTRAINT PK_PlaylistTrack PRIMARY KEY (PlaylistId,TrackId)
    );

CREATE TABLE [dbo].[DimCustomer](
	CustomerKey INT  IDENTITY(1,1) Primary Key,
    [CustomerId] [int]  NOT NULL,
    [FirstName] [nvarchar](40) NOT NULL,
    [LastName] [nvarchar](20) NOT NULL,
    [Company] [nvarchar](80) NULL,
    [Address] [nvarchar](70) NULL,
    [City] [nvarchar](40) NULL,
    [State] [nvarchar](40) NULL,
    [Country] [nvarchar](40) NULL,
    [PostalCode] [nvarchar](10) NULL,
    [Phone] [nvarchar](24) NULL,
    [Fax] [nvarchar](24) NULL,
    [Email] [nvarchar](60) NOT NULL,
    [SupportRepId] [int] NULL,
	RowIsCurrent INT DEFAULT 1 NOT NULL,
	RowStartDate DATE DEFAULT '1899-12-31' NOT NULL,
	RowEndDate DATE DEFAULT '9999-12-31' NOT NULL,
	RowChangeReason varchar(200) NULL
	
    );

    ---------------------FOR INCREMENTAL LOADING ------------------------------------
CREATE TABLE InvoicesVersionHistory (RecordOfVersion BIGINT, Date DATETIME);
	