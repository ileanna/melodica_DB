----FOR INCREMENTAL LOADING ----------------------------------------------------------------


INSERT INTO InvoicesVersionHistory ([RecordOfVersion], [Date])
SELECT MAX([RecordOfVersion]), GETDATE()
FROM ChinookStaging.dbo.StagingInvoices;
GO

--------------------------------------------------------------------------------------------------------

INSERT INTO [dbo].[FactInvoices]
           ([InvoiceLineId]
           ,[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,[CustomerKey]
           ,[InvoiceDateKey]
           ,[BillingAddress]
           ,[BillingCity]
           ,[BillingState]
           ,[BillingCountry]
           ,[BillingPostalCode]
           ,[Total])
     SELECT
           [InvoiceLineId]
           ,i.[InvoiceId]
           ,[TrackId]
           ,[UnitPrice]
           ,[Quantity]
           ,c.[CustomerKey]
           ,d.[DateKey]
           ,i.[BillingAddress]
           ,i.[BillingCity]
           ,i.[BillingState]
           ,i.[BillingCountry]
           ,i.[BillingPostalCode]
           ,i.[Total]
	FROM [ChinookStaging].[dbo].[StagingInvoices] i
	inner join DimDate d on i.InvoiceDate = d.Date
	inner join DimCustomer c on CustomerKey = c.CustomerKey;
