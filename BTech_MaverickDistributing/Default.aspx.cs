using System;
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
        Dictionary<string, string> makeDic = new Dictionary<string, string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                string cn = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(cn))
                {
                    //SqlDataAdapter cmd = new SqlDataAdapter("select EquipmentTypeName from EquipmentType", conn);
                    SqlCommand cmd = new SqlCommand("select EquipmentTypeName, EquipmentTypeID from EquipmentType", conn);

                    conn.Open();

                    DataTable dtTable = new DataTable();
                    dtTable.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow row in dtTable.Rows)
                    {
                        TreeNode node = new TreeNode(row["EquipmentTypeName"].ToString());
                        node.PopulateOnDemand = true;
                        node.Value = "first_" + row["EquipmentTypeID"].ToString();

                        TV_Menu.Nodes.Add(node);
                    }
                }
            }

            //using (SqlConnection conn = new SqlConnection(cn))
            //{
            //    SqlDataAdapter cmd = new SqlDataAdapter("select EquipmentTypeName, EquipmentTypeID from EquipmentType where (EquipmentTypeID IN (select TypeID from Parts)); select TypeID, MakeName, M.MakeID, YearID from Make M inner join Parts P on M.MakeID=P.MakeID; select MakeName, MakeID from Make where (MakeID IN (select MakeID from Parts))", conn);
            //    DataSet ds = new DataSet();
            //    cmd.Fill(ds);

            //    ds.Relations.Add(new DataRelation("TypeID", ds.Tables[0].Columns["EquipmentTypeID"],
            //    ds.Tables[1].Columns["TypeID"]));

            //    ds.Relations.Add(new DataRelation("MakeID", ds.Tables[2].Columns["MakeID"],
            //    ds.Tables[1].Columns["MakeID"]));

            //    parentRepeater.DataSource = ds.Tables[0];
            //    parentRepeater.DataBind();
            //}


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

        protected void TV_Menu_SelectedNodeChanged(object sender, EventArgs e)
        {
            string cn = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(cn))
            {
                //Check what level of tree view we are in before we call the SQL statement.
                string[] arg = TV_Menu.SelectedNode.Value.Split('_');
                if(arg[0] == "first")
                {
                    SqlCommand cmd = new SqlCommand("select distinct MakeName, P.MakeID from Parts P inner join Make M on P.MakeId=M.MakeID", conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["MakeName"].ToString());
                        childNode.PopulateOnDemand = false;
                        childNode.Value = "second_" + childrow["MakeName"];
                        Session["make"] = childrow["MakeID"].ToString();

                        //Add the values into the dictionary, so it cna be itterated through in the select statement later.
                        //makeDic.Add(childrow["MakeName"].ToString(), childrow["MakeID"].ToString());

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }
                }
                else if(arg[0] == "second")
                {
                    //foreach(KeyValuePair<string, string> KVP in makeDic)
                    //{
                        SqlCommand cmd = new SqlCommand("select distinct YearID from Parts where MakeID=" + Session["make"], conn);
                        conn.Open();

                        DataTable dtTableChild = new DataTable();
                        dtTableChild.Load(cmd.ExecuteReader());

                        conn.Close();

                        foreach (DataRow childrow in dtTableChild.Rows)
                        {
                            TreeNode childNode = new TreeNode(childrow["YearID"].ToString());
                            childNode.PopulateOnDemand = false;
                            childNode.Value = "third_" + childrow["YearID"];
                            Session["year"] = childrow["YearID"].ToString();

                            TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                        }
                    //}
                }
                else if(arg[0] == "third")
                {
                    SqlCommand cmd = new SqlCommand("select distinct ModelName, P.ModelID from Parts P inner join Model M on P.ModelID=M.ModelID where MakeID=" + Session["make"].ToString() + " and YearID=" + Session["year"].ToString(), conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["ModelName"].ToString());
                        childNode.PopulateOnDemand = false;
                        childNode.Value = "fourth_" + childrow["ModelName"];
                        Session["model"] = childrow["ModelID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }
                }
                else if (arg[0] == "fourth")
                {
                    SqlCommand cmd = new SqlCommand("select distinct CategoryName, P.CategoryID from Parts P inner join Category C on P.CategoryID=C.CategoryID where MakeID=" + Session["make"].ToString() + " and YearID=" + Session["year"].ToString() + " and ModelID=" + Session["model"], conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["CategoryName"].ToString());
                        childNode.PopulateOnDemand = true;
                        childNode.Value = "fifth_" + childrow["CategoryName"] + "_" + childrow["CategoryID"];
                        Session["category"] = childrow["CategoryID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }
                }
                else if(arg[0] == "fifth")
                {
                    Session["category"] = arg[2];
                    string e1 = Session["make"].ToString();
                    string e2 = Session["year"].ToString();
                    string e3 = Session["model"].ToString();
                    string e4 = Session["category"].ToString();

                    //When the part category is clicked, then we need to bind the listview and data source.
                    //SQL_PartsInfo.DataBind();
                    LV_PartsInfo.DataBind();
                }
            }
        }
    }
}