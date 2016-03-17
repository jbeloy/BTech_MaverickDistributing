﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BTech_MaverickDistributing.Models;
using BTech_MaverickDistributing.SqlStatements;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace BTech_MaverickDistributing
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cn = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(cn))
            {
                SqlDataAdapter cmd = new SqlDataAdapter("select EquipmentTypeName, EquipmentTypeID from EquipmentType where (EquipmentTypeID IN (select TypeID from Parts)); select TypeID, MakeName, M.MakeID, YearID from Make M inner join Parts P on M.MakeID=P.MakeID; select MakeName, MakeID from Make where (MakeID IN (select MakeID from Parts))", conn);
                DataSet ds = new DataSet();
                cmd.Fill(ds);

                ds.Relations.Add(new DataRelation("TypeID", ds.Tables[0].Columns["EquipmentTypeID"],
                ds.Tables[1].Columns["TypeID"]));

                ds.Relations.Add(new DataRelation("MakeID", ds.Tables[2].Columns["MakeID"],
                ds.Tables[1].Columns["MakeID"]));

                parentRepeater.DataSource = ds.Tables[0];
                parentRepeater.DataBind();
            }


            //Create the connection and DataAdapter for the Authors table.
            //string Connection = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
            //SqlConnection cnn = new SqlConnection(Connection);

            //SqlDataAdapter cmd1 = new SqlDataAdapter("select TypeID, MakeID from Parts group by TypeID, MakeID", cnn);
            //SqlDataAdapter cmd4 = new SqlDataAdapter("select * from EquipmentType", cnn);
            //SqlDataAdapter cmd2 = new SqlDataAdapter("select * from Make", cnn);
            ////SqlDataAdapter cmd3 = new SqlDataAdapter("select * from EquipmentYear", cnn);            

            ////Create and fill the DataSet.
            //DataSet ds = new DataSet();
            //cmd4.Fill(ds, "EquipmentType");
            //cmd2.Fill(ds, "Make");
            ////cmd3.Fill(ds, "EquipmentYear");
            //cmd1.Fill(ds, "Parts");

            //////Create the relation bewtween the Authors and Titles tables.
            //ds.Relations.Add("myrelation",
            //ds.Tables["Parts"].Columns["TypeID"],
            //ds.Tables["EquipmentType"].Columns["EquipmentTypeID"]);

            //ds.Relations.Add("myrelation2",
            //ds.Tables["Make"].Columns["MakeID"],
            //ds.Tables["Parts"].Columns["MakeID"]);

            //////Bind the child table to the parent Repeater control, and call DataBind.
            //////parentRepeater.DataSource = ds;
            //parentRepeater.DataSource = ds.Tables["EquipmentType"];
            //Page.DataBind();

            //////Close the connection.
            //cnn.Close();
        }
        //public void LoadTreeViewTest()
        //{
        //    try
        //    {
        //        using (var ctx = new md_dbEntities())
        //        {
        //            List<string> equipmentTypes = new List<string>();
        //            List<string> makes = new List<string>();

        //            var objectContext = (ctx as System.Data.Entity.Infrastructure.IObjectContextAdapter).ObjectContext;

        //            string strSQLtoGetParts = "";
        //            //these are the parameters to get a subset of the result set
        //            int yearToGet = 2005;
        //            string partMakeToGet = "Honda";
        //            string partModelToGet = "TRX450R";
        //            string partCategoryToGet = "CLUTCH";

        //            //use objectContext here..

        //            strSQLtoGetParts = String.Format(Statements.GetPartsByYearMakeModelCategory(), yearToGet, partMakeToGet, partModelToGet, partCategoryToGet);
        //            var getPartSubset = objectContext.ExecuteStoreQuery<PartsView>(strSQLtoGetParts).ToList();

        //            //Get all of the equipment types from the database.
        //            equipmentTypes = Statements.GetEquipmentType();

        //            foreach(string t in equipmentTypes)
        //            {
        //                HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
        //                //Create the correct <li> for the equipment type. Using the naming convention tableAbreviation_recordName eg: et_ATV.
        //                li.InnerHtml = "<div id='et_" + t +"' >" + t + "<label><input type='checkbox'></label></div><ul id='" + t + "_make' runat='server'></ul>";
        //                li.Attributes.Add("onload", "li_" + t + "_Load");
        //                li.ID = "li_" + t;
        //                equipmentType.Controls.Add(li);
        //            }

        //            makes = Statements.GetMake();

        //            foreach(string t in makes)
        //            {
        //                HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
        //                //Create the correct <li> for the equipment type. Using the naming convention tableAbreviation_recordName eg: et_ATV.
        //                li.InnerHtml = "<div id='mk_" + t + "' >" + t + "<label><input type='checkbox'></label></div>";
        //                Page.FindControl("ATV_make").Controls.Add(li);
        //            }

        //            //foreach (var partRow in getPartSubset)
        //            //{
        //            //    HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
        //            //    //li.InnerText = partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.CategoryName; // these are the attributes of the data row from the database
        //            //    li.InnerHtml = "<div id='10' >ATV<label><input type='checkbox'></label></div>";
        //            //    //li.InnerText = "ATV";
        //            //    //tabs.Controls.Add(li);
        //            //    equipmentType.Controls.Add(li);

        //            //    //HtmlGenericControl anchor = new HtmlGenericControl("a");
        //            //    //anchor.Attributes.Add("href", "page.htm");
        //            //    //anchor.InnerText = partRow.PartDesc;

        //            //    //HtmlGenericControl li = new HtmlGenericControl("li");
        //            //    //li.Attributes.Add("class", "MyClass");
        //            //    //li.InnerText = "Item2";
        //            //    //MyList2.Controls.Add(li);
        //            //    //li.Controls.Add(anchor);

        //            //    //li.Controls.Add(partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.Price);
        //            //    //drilldown1.Controls.Add(li);
                        
        //            //}
        //        }

        //    }
        //    catch (Exception ex)
        //    {
        //        //error handling here
        //    }
            
        //}
        //protected void CHK_Clutch_ServerChange(object sender, EventArgs e)
        //{
        //    //When the button is checked, updatae the listview to show that part.

        //    //Check to see if the checkbox is checked.
        //    /*if(CHK_Clutch.Checked)
        //    {
        //        //Update the hidden field with the parameters.
        //        HF_PartsInfo.Value = "Clutch";
        //    }
        //    else
        //    {
        //        //Erase the value from the HiddenField.
        //        HF_PartsInfo.Value = null;
        //    }*/
        //}

        protected void Repeater2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            string MakeName = DataBinder.Eval(e.Item.DataItem, "MakeName").ToString();
            this.Session["make"] = MakeName;
            //this.Session["make"] = "Honda";
            RepeaterItem item = e.Item;
            //Repeater3_ItemDataBound(sender, e);
            Repeater Product = (Repeater)item.FindControl("Repeater3");
            Product.DataBind();
            //Repeater MakeRepeater = (Repeater)sender;
            //MakeRepeater.DataBind();
        }

        protected void Repeater3_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //Repeater MakeRepeater = (Repeater)sender;
            string Year = DataBinder.Eval(e.Item.DataItem, "YearID").ToString();
            RepeaterItem item = e.Item;

            if (this.Session["make"] != null)
            {
                if (this.Session["make"].ToString() == DataBinder.Eval(e.Item.DataItem, "MakeName").ToString())
                    e.Item.Visible = true;
                else
                    e.Item.Visible = false;
            }
            
            //MakeRepeater.DataBind();
        }

        protected void parentRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
            e.Item.ItemType == ListItemType.AlternatingItem)
            {
              DataRowView drv = e.Item.DataItem as DataRowView;
              Repeater ChildRep = e.Item.FindControl("childRepeater") as Repeater;
              ChildRep.DataSource = drv.CreateChildView("TypeID");
              ChildRep.DataBind();
            }
        }

        protected void childRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
            e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = e.Item.DataItem as DataRowView;
                Repeater ChildRep = e.Item.FindControl("childRepeater2") as Repeater;
                ChildRep.DataSource = drv.CreateChildView("MakeID");
                ChildRep.DataBind();
            }
        }
    }
}