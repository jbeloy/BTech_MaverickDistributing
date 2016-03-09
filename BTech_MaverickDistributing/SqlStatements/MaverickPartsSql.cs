using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI.WebControls;

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

        public static List<string> GetEquipmentType()
        {
            string Connection = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(Connection);
            SqlDataReader reader;
            List<string> EquipmentTypes = new List<string>();

            //This funciton will take all of the values and create them.
            try
            {
                sqlConnection.Open();
            }
            catch (Exception err)
            {
                Console.WriteLine(err.Message);
            }

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = sqlConnection;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetEquipmentType";           //getting the  procedure created in SQL.

            try
            {
                reader = cmd.ExecuteReader(); //added October 21

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        //We will read every value form the reader into the list.
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            EquipmentTypes.Add(reader[i].ToString());
                        }
                    }
                }

                sqlConnection.Close();
                return EquipmentTypes;
            }
            catch (Exception ex)
            {
                //If the execution fails, we need to close the connection string.
                sqlConnection.Close();
                Console.WriteLine(ex.Message);

                //Return -1 if the insert fails.
                return null;
            }
        }
    }
}