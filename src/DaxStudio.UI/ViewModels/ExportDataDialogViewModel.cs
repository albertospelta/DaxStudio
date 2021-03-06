﻿using Caliburn.Micro;
using System.ComponentModel.Composition;
using System.Data.SqlClient;
using System.Text;
using System.Data;
using DaxStudio.UI.Extensions;
using ADOTabular.AdomdClientWrappers;
using System.IO;
using Microsoft.Win32;
using System;
using DaxStudio.UI.Events;
using DaxStudio.UI.Model;
using System.Threading.Tasks;
using System.Diagnostics;
using Serilog;
//using System.Windows.Forms;

namespace DaxStudio.UI.ViewModels
{

    [Export]
    public class ExportDataDialogViewModel : Screen
    {

        IEventAggregator _eventAggregator;
        [ImportingConstructor]
        public ExportDataDialogViewModel(IEventAggregator eventAggregator )
        {
            _eventAggregator = eventAggregator;
            this.IsCSVExport = true;
            this.TruncateTables = true;
        }

        // TODO: Any best way to instantiate this object with dependency injection?        
        public DocumentViewModel ActiveDocument { get; set; }

        private bool _isCSVExport = false;
        public bool IsCSVExport
        {
            get { return _isCSVExport; }
            set
            {
                _isCSVExport = value;
                NotifyOfPropertyChange(() => IsCSVExport);
            }
        }

        private bool _isSQLExport = false;
        public bool IsSQLExport
        {
            get { return _isSQLExport; }
            set
            {
                _isSQLExport = value;
                NotifyOfPropertyChange(() => IsSQLExport);
            }
        }

        private string _outputPath = "";
        public string OutputPath {
            get { return _outputPath; }
            set {
                _outputPath = value;
                NotifyOfPropertyChange(() => OutputPath);
            }
        }

        public string ConnectionString { get; set; }
        
        public string SchemaName { get; set; }

        public bool TruncateTables { get; set; }

        public void Export()
        {
            try
            {
                if (IsCSVExport)
                {
                    ActiveDocument.IsQueryRunning = true;
                    Task.Run(() =>
                    {
                        ExportDataToFolder(this.OutputPath);
                    });
                }
                else if (IsSQLExport)
                {
                    Task.Run(() =>
                    {
                        ExportDataToSQLServer(this.ConnectionString, this.SchemaName, this.TruncateTables);
                    });
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex, "{class} {method} {message}", "ExportDataDialogViewModel", "Export", "Error exporting all data from model");
                _eventAggregator.PublishOnUIThread(new OutputMessage(MessageType.Error, $"Error when attempting to export all data - {ex.Message}"));
            }
            finally
            {
                TryClose(true);
            }
        }       

        public void Cancel()
        {

            //TryClose(false);
        }

        public void BrowseFolders()
        {
            // TODO show browse folders
            using (var dialog = new System.Windows.Forms.FolderBrowserDialog())
            {
                System.Windows.Forms.DialogResult result = dialog.ShowDialog();
                if (result == System.Windows.Forms.DialogResult.OK)
                {
                    this.OutputPath = dialog.SelectedPath;
                }
            }
            // set folder

        }

        private void ExportDataToFolder(string outputPath)
        {
            var metadataPane = this.ActiveDocument.MetadataPane;
            var exceptionFound = false;
            

            // TODO: Use async but to be well done need to apply async on the DBCommand & DBConnection
            // TODO: Show warning message?
            if (metadataPane.SelectedModel == null)
            {
                return;
            }

            if (!Directory.Exists(outputPath))
            {
                Directory.CreateDirectory(outputPath);
            }
            ActiveDocument.IsQueryRunning = true;
            ActiveDocument.QueryStopWatch.Start();
            try
            {
                foreach (var table in metadataPane.SelectedModel.Tables)
                {
                    try
                    {
                        var csvFilePath = System.IO.Path.Combine(outputPath, $"{table.Name}.csv");
                        var daxQuery = $"EVALUATE {table.DaxName}";
                        var rows = 0;
                        var tableCnt = 0;
                        var totalTables = metadataPane.SelectedModel.Tables.Count;

                        using (var textWriter = new StreamWriter(csvFilePath, false, Encoding.UTF8))
                        using (var csvWriter = new CsvHelper.CsvWriter(textWriter))
                        using (var statusMsg = new StatusBarMessage(this.ActiveDocument, $"Exporting {table.Name}"))
                        using (var reader = ActiveDocument.Connection.ExecuteReader(daxQuery))
                        {
                            rows = 0;
                            tableCnt++;

                            // Write Header
                            foreach (var colName in reader.CleanColumnNames())
                            {
                                csvWriter.WriteField(colName);
                            }

                            csvWriter.NextRecord();

                            // Write data
                            while (reader.Read())
                            {
                                for (var fieldOrdinal = 0; fieldOrdinal < reader.FieldCount; fieldOrdinal++)
                                {
                                    var fieldValue = reader[fieldOrdinal];

                                    csvWriter.WriteField(fieldValue);
                                }

                                rows++;
                                if (rows % 5000 == 0) {
                                    new StatusBarMessage(ActiveDocument, $"Exporting Table {tableCnt} of {totalTables} : {table.Name} ({rows:N0} rows)");
                                    ActiveDocument.RefreshElapsedTime();
                                }
                                csvWriter.NextRecord();
                            }
                        }
                        
                        ActiveDocument.RefreshElapsedTime();
                        _eventAggregator.PublishOnUIThread(new OutputMessage(MessageType.Information, $"Exported {rows:N0} rows to {table.Name}.csv"));
                    }
                    catch (Exception ex)
                    {
                        exceptionFound = true;
                        Log.Error(ex,"{class} {method} {message}", "ExportDataDialogViewModel","ExportDataToFolder","Error while exporting model to CSV");
                        _eventAggregator.PublishOnUIThread(new OutputMessage(MessageType.Error, $"Error Exporting '{table.Name}':  {ex.Message}"));
                        break; // exit from the loop if we have caught an exception 
                    }
                }
                // export complete
                if (!exceptionFound)
                {
                    ActiveDocument.QueryStopWatch.Stop();
                    _eventAggregator.PublishOnUIThread(new OutputMessage(MessageType.Information, $"Model Export Complete: {metadataPane.SelectedModel.Tables.Count} tables exported",ActiveDocument.QueryStopWatch.ElapsedMilliseconds));
                    ActiveDocument.QueryStopWatch.Reset();
                }
            }
            finally
            {
                ActiveDocument.IsQueryRunning = false;
            }    
            
        }

        private string sqlTableName = string.Empty;
        private int currentTableIdx = 0;
        private int totalTableCnt = 0;

        private void ExportDataToSQLServer(string connStr, string schemaName, bool truncateTables)
        {
            var metadataPane = this.ActiveDocument.MetadataPane;

            // TODO: Use async but to be well done need to apply async on the DBCommand & DBConnection
            // TODO: Show warning message?
            if (metadataPane.SelectedModel == null)
            {
                return;
            }

            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                currentTableIdx = 0;
                totalTableCnt = metadataPane.SelectedModel.Tables.Count;
                foreach (var table in metadataPane.SelectedModel.Tables)
                {
                    currentTableIdx++;
                    var daxQuery = $"EVALUATE('{table.Name}')";

                    using (var statusMsg = new StatusBarMessage(this.ActiveDocument, $"Exporting {table.Name}"))
                    using (var reader = metadataPane.Connection.ExecuteReader(daxQuery))
                    {
                        sqlTableName = $"[{schemaName}].[{table.Name}]";

                        EnsureSQLTableExists(conn, sqlTableName, reader);

                        using (var transaction = conn.BeginTransaction())
                        {
                            if(truncateTables)
                            {
                                using (var cmd = new SqlCommand($"truncate table {sqlTableName}", conn))
                                {
                                    cmd.Transaction = transaction;
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            using (var sqlBulkCopy = new SqlBulkCopy(conn, SqlBulkCopyOptions.TableLock, transaction))
                            {
                                sqlBulkCopy.DestinationTableName = sqlTableName;
                                sqlBulkCopy.BatchSize = 1000;
                                sqlBulkCopy.NotifyAfter = 1000;
                                sqlBulkCopy.SqlRowsCopied += SqlBulkCopy_SqlRowsCopied;
                                sqlBulkCopy.EnableStreaming = true;
                                sqlBulkCopy.WriteToServer(reader);
                                
                            }

                            transaction.Commit();
                        }

                    }
                    _eventAggregator.PublishOnUIThread(new OutputMessage(MessageType.Information, $"Exported {table.Name} to {sqlTableName}"));
                }
            }
        }

        private void SqlBulkCopy_SqlRowsCopied(object sender, SqlRowsCopiedEventArgs e)
        {
            new StatusBarMessage(ActiveDocument, $"Exporting Table {currentTableIdx} of {totalTableCnt} : {sqlTableName} ({e.RowsCopied:N0} rows)");
        }

        private void EnsureSQLTableExists(SqlConnection conn, string sqlTableName, AdomdDataReader reader)
        {
            var strColumns = new StringBuilder();

            var schemaTable = reader.GetSchemaTable();

            foreach (System.Data.DataRow row in schemaTable.Rows)
            {
                var colName = row.Field<string>("ColumnName");

                var regEx = System.Text.RegularExpressions.Regex.Match(colName, @".+\[(.+)\]");

                if (regEx.Success)
                {
                    colName = regEx.Groups[1].Value;
                }

                var sqlType = ConvertDotNetToSQLType(row);

                strColumns.AppendLine($",[{colName}] {sqlType} NULL");
            }

            var cmdText = @"                
                declare @sqlCmd nvarchar(max)

                IF object_id(@tableName, 'U') is not null
                BEGIN
                    raiserror('Droping Table ""%s""', 1, 1, @tableName)
                    set @sqlCmd = 'drop table ' + @tableName + char(13)
                    exec sp_executesql @sqlCmd
                END

                IF object_id(@tableName, 'U') is null
                BEGIN
                    declare @schemaName varchar(20)
		            set @sqlCmd = ''
                    set @schemaName = parsename(@tableName, 2)

                    IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = @schemaName)
                    BEGIN
                        set @sqlCmd = 'CREATE SCHEMA ' + @schemaName + char(13)
                    END

                    set @sqlCmd = @sqlCmd + 'CREATE TABLE ' + @tableName + '(' + @columns + ');'

                    raiserror('Creating Table ""%s""', 1, 1, @tableName)

                    exec sp_executesql @sqlCmd
                END
                ELSE
                BEGIN
                    raiserror('Table ""%s"" already exists', 1, 1, @tableName)
                END
                ";

            using (var cmd = new SqlCommand(cmdText, conn))
            {
                cmd.Parameters.AddWithValue("@tableName", sqlTableName);
                cmd.Parameters.AddWithValue("@columns", strColumns.ToString().TrimStart(','));

                cmd.ExecuteNonQuery();
            }
        }

        private string ConvertDotNetToSQLType(System.Data.DataRow row)
        {
            var dataType = row.Field<System.Type>("DataType").ToString();

            string dataTypeName = null;

            if (row.Table.Columns.Contains("DataTypeName"))
            {
                dataTypeName = row.Field<string>("DataTypeName");
            }

            switch (dataType)
            {
                case "System.Double":
                    {
                        return "float";
                    };
                case "System.Boolean":
                    {
                        return "bit";
                    }
                case "System.String":
                    {
                        var columnSize = row.Field<int?>("ColumnSize");

                        if (string.IsNullOrEmpty(dataTypeName))
                        {
                            dataTypeName = "nvarchar";
                        }

                        string columnSizeStr = "MAX";

                        if (columnSize == null || columnSize <= 0 || (dataTypeName == "varchar" && columnSize > 8000) || (dataTypeName == "nvarchar" && columnSize > 4000))
                        {
                            columnSizeStr = "MAX";
                        }
                        else
                        {
                            columnSizeStr = columnSize.ToString();
                        }

                        return $"{dataTypeName}({columnSizeStr})";
                    }
                case "System.Decimal":
                    {
                        var numericScale = row.Field<int>("NumericScale");
                        var numericPrecision = row.Field<int>("NumericPrecision");

                        if (numericScale == 0)
                        {
                            if (numericPrecision < 10)
                            {
                                return "int";
                            }
                            else
                            {
                                return "bigint";
                            }
                        }

                        if (!string.IsNullOrEmpty(dataTypeName) && dataTypeName.EndsWith("*money"))
                        {
                            return dataTypeName;
                        }

                        if (numericScale != 255)
                        {
                            return $"decimal({numericPrecision}, {numericScale})";
                        }

                        return "decimal(38,4)";
                    }
                case "System.Byte":
                    {
                        return "tinyint";
                    }
                case "System.Int16":
                    {
                        return "smallint";
                    }
                case "System.Int32":
                    {
                        return "int";
                    }
                case "System.Int64":
                    {
                        return "bigint";
                    }
                case "System.DateTime":
                    {
                        return "datetime2(0)";
                    }
                case "System.Byte[]":
                    {
                        return "varbinary(max)";
                    }
                case "System.Xml.XmlDocument":
                    {
                        return "xml";
                    }
                default:
                    {
                        return "nvarchar(MAX)";
                    }
            }
        }
    }
}
