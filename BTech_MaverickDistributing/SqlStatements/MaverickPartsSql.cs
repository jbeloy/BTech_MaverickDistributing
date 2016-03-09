using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BTech_MaverickDistributing.SqlStatements
{
    class Statements
    {
        public static string GetPartsByYearMakeModelCategory()
        {
            string crlf = "\r\n";
            string sql = "select * from PartsView " + crlf +
                            " Where YearID = {0} and  MakeName = '{1}' and ModelName = '{2}'  and CategoryName = '{3}' " + crlf +
                            " order by ManufacturerName, PartDesc";

            return sql;
        }
    }
}