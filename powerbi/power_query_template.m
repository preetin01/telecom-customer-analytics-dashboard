let
    Source = Folder.Files("C:\telecom_customer_analytics\data"),
    KeepCSV = Table.SelectRows(Source, each [Extension] = ".csv"),
    AddData = Table.AddColumn(KeepCSV, "Data", each Csv.Document([Content],[Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv])),
    Promoted = Table.AddColumn(AddData, "Promoted", each Table.PromoteHeaders([Data],[PromoteAllScalars=true])),
    Selected = Table.SelectColumns(Promoted,{"Name","Promoted"}),
    Renamed = Table.RenameColumns(Selected,{{"Name","SourceFile"}})
in
    Renamed

// Recommended: use individual queries referencing this staging query,
// or Get Data > Text/CSV for each file and apply these transformations:
// 1. Set ID columns to Text.
// 2. Set date fields to Date.
// 3. Set amount/income/prices to Decimal Number.
// 4. Remove errors and trim/clean text columns.
// 5. Load dimensions Customers and Services and fact tables Transactions,
//    Usage, Complaints, SupportInteractions, CustomerServices.
