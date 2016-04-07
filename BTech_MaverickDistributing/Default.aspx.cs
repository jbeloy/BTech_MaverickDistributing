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
        TreeNode varSelectedNode = new TreeNode();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                LV_PartsInfo.Visible = false;
                LV_PartSearch.Visible = false;
                LV_AdvancedPartSearch.Visible = false;

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
            TV_Menu.SelectedNode.Expand();
            string cn = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(cn))
            {
                //Check what level of tree view we are in before we call the SQL statement.
                varSelectedNode = TV_Menu.SelectedNode;
                string[] arg = TV_Menu.SelectedNode.Value.Split('_');
                if (arg[0] == "first")
                {
                    SqlCommand cmd = new SqlCommand("select distinct MakeName, P.MakeID from Parts P inner join Make M on P.MakeId=M.MakeID", conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["MakeName"].ToString());
                        childNode.PopulateOnDemand = true;
                        childNode.Value = "second_" + childrow["MakeID"];
                        Session["make"] = childrow["MakeID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }

                    lblModelSearch.Visible = false;
                    txtModelPartSearch.Visible = false;
                    btnModelSearch.Visible = false;
                }
                else if (arg[0] == "second")
                {
                    //Use the selected value from the menue to execute the sql statement.
                    /*SqlCommand cmd = new SqlCommand("select distinct YearID from Parts where MakeID=" + arg[1], conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["YearID"].ToString());
                        childNode.PopulateOnDemand = true;
                        childNode.Value = "third_" + childrow["YearID"];
                        Session["year"] = childrow["YearID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }*/
                    TV_Menu.SelectedNode.Expand();
                    lblModelSearch.Visible = false;
                    txtModelPartSearch.Visible = false;
                    btnModelSearch.Visible = false;
                }
                else if (arg[0] == "third")
                {
                    //Get the value of the parent node here.
                    string[] makeArg = TV_Menu.SelectedNode.Parent.Value.Split('_');

                    /*SqlCommand cmd = new SqlCommand("select distinct ModelName, P.ModelID from Parts P inner join Model M on P.ModelID=M.ModelID where MakeID=" + makeArg[1] + " and YearID=" + arg[1], conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["ModelName"].ToString());
                        childNode.PopulateOnDemand = true;
                        childNode.Value = "fourth_" + childrow["ModelID"];
                        Session["model"] = childrow["ModelID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }*/
                    TV_Menu.SelectedNode.Expand();
                    lblModelSearch.Visible = false;
                    txtModelPartSearch.Visible = false;
                    btnModelSearch.Visible = false;
                }
                else if (arg[0] == "fourth")
                {
                    string[] makeArg = TV_Menu.SelectedNode.Parent.Parent.Value.Split('_');
                    string[] yearArg = TV_Menu.SelectedNode.Parent.Value.Split('_');

                    /*SqlCommand cmd = new SqlCommand("select distinct CategoryName, P.CategoryID from Parts P inner join Category C on P.CategoryID=C.CategoryID where MakeID=" + makeArg[1] + " and YearID=" + yearArg[1] + " and ModelID=" + arg[1], conn);
                    conn.Open();

                    DataTable dtTableChild = new DataTable();
                    dtTableChild.Load(cmd.ExecuteReader());

                    conn.Close();

                    foreach (DataRow childrow in dtTableChild.Rows)
                    {
                        TreeNode childNode = new TreeNode(childrow["CategoryName"].ToString());
                        childNode.PopulateOnDemand = true;
                        childNode.Value = "fifth_" + childrow["CategoryID"];
                        Session["category"] = childrow["CategoryID"].ToString();

                        TV_Menu.SelectedNode.ChildNodes.Add(childNode);
                    }*/
                    TV_Menu.SelectedNode.Expand();
                    lblModelSearch.Text = "Model part search: ";
                    lblModelSearch.Visible = true;
                    txtModelPartSearch.Visible = true;
                    btnModelSearch.Visible = true;
                }
                else if (arg[0] == "fifth")
                {
                    string[] makeArg = TV_Menu.SelectedNode.Parent.Parent.Parent.Value.Split('_');
                    string[] yearArg = TV_Menu.SelectedNode.Parent.Parent.Value.Split('_');
                    string[] modelArg = TV_Menu.SelectedNode.Parent.Value.Split('_');

                    Session["category"] = arg[1];
                    Session["make"] = makeArg[1];
                    Session["year"] = yearArg[1];
                    Session["model"] = modelArg[1];

                    string e1 = Session["make"].ToString();
                    string e2 = Session["year"].ToString();
                    string e3 = Session["model"].ToString();
                    string e4 = Session["category"].ToString();

                    //When the part category is clicked, then we need to bind the listview and data source.
                    LV_PartsInfo.Visible = true;
                    LV_PartSearch.Visible = false;
                    LV_AdvancedPartSearch.Visible = false;
                    LV_PartsInfo.DataBind();
                }
            }
        }

        protected void btnSearchParts_Click(object sender, EventArgs e)
        {
            LV_PartsInfo.Visible = false;
            LV_PartSearch.Visible = false;
            LV_AdvancedPartSearch.Visible = true;
            LV_AdvancedPartSearch.DataBind();
        }

        protected void btnModelSearch_Click(object sender, EventArgs e)
        {
            string[] makeArg = TV_Menu.SelectedNode.Parent.Parent.Value.Split('_');
            string[] yearArg = TV_Menu.SelectedNode.Parent.Value.Split('_');
            string[] modelArg = TV_Menu.SelectedNode.Value.Split('_');
            //TV_Menu.SelectedNode.Collapse();
            //TV_Menu.SelectedNode.Expand();
            //string[] makeArg = varSelectedNode.Parent.Parent.Value.Split('_');
            //string[] yearArg = varSelectedNode.Parent.Value.Split('_');
            //string[] modelArg = varSelectedNode.Value.Split('_');

            Session["make"] = makeArg[1];
            Session["year"] = yearArg[1];
            Session["model"] = modelArg[1];

            string e1 = Session["make"].ToString();
            string e2 = Session["year"].ToString();
            string e3 = Session["model"].ToString();
            string e4 = Session["category"].ToString();

            //Session["search"] = txtModelPartSearch.Text;

            LV_PartsInfo.Visible = false;
            LV_PartSearch.Visible = true;
            LV_AdvancedPartSearch.Visible = false;
            LV_PartSearch.DataBind();
        }

        protected void TV_Menu_TreeNodeExpanded(object sender, TreeNodeEventArgs e)
        {
            if (TV_Menu.SelectedNode != null)
            {
                //TV_Menu.SelectedNode = e.Node;
                string cn = WebConfigurationManager.ConnectionStrings["md_dbConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(cn))
                {
                    //Check what level of tree view we are in before we call the SQL statement.
                    //string[] arg = TV_Menu.SelectedNode.Value.Split('_');
                    //use the event node object to access the 'selected node'
                    varSelectedNode = e.Node;
                    string[] arg = e.Node.Value.Split('_');
                    if (arg[0] == "first")
                    {
                        SqlCommand cmd = new SqlCommand("select distinct MakeName, P.MakeID from Parts P inner join Make M on P.MakeId=M.MakeID", conn);
                        conn.Open();

                        DataTable dtTableChild = new DataTable();
                        dtTableChild.Load(cmd.ExecuteReader());

                        conn.Close();

                        foreach (DataRow childrow in dtTableChild.Rows)
                        {
                            TreeNode childNode = new TreeNode(childrow["MakeName"].ToString());
                            childNode.PopulateOnDemand = true;
                            childNode.Value = "second_" + childrow["MakeID"];
                            Session["make"] = childrow["MakeID"].ToString();
                            e.Node.ChildNodes.Add(childNode);
                        }

                        lblModelSearch.Visible = false;
                        txtModelPartSearch.Visible = false;
                        btnModelSearch.Visible = false;
                    }
                    else if (arg[0] == "second")
                    {
                        //Use the selected value from the menue to execute the sql statement.
                        SqlCommand cmd = new SqlCommand("select distinct YearID from Parts where MakeID=" + arg[1], conn);
                        conn.Open();

                        DataTable dtTableChild = new DataTable();
                        dtTableChild.Load(cmd.ExecuteReader());

                        conn.Close();

                        foreach (DataRow childrow in dtTableChild.Rows)
                        {
                            TreeNode childNode = new TreeNode(childrow["YearID"].ToString());
                            childNode.PopulateOnDemand = true;
                            childNode.Value = "third_" + childrow["YearID"];
                            Session["year"] = childrow["YearID"].ToString();

                            e.Node.ChildNodes.Add(childNode);
                        }

                        lblModelSearch.Visible = false;
                        txtModelPartSearch.Visible = false;
                        btnModelSearch.Visible = false;
                    }
                    else if (arg[0] == "third")
                    {
                        //Get the value of the parent node here.
                        string[] makeArg = e.Node.Parent.Value.Split('_');

                        SqlCommand cmd = new SqlCommand("select distinct ModelName, P.ModelID from Parts P inner join Model M on P.ModelID=M.ModelID where MakeID=" + makeArg[1] + " and YearID=" + arg[1], conn);
                        conn.Open();

                        DataTable dtTableChild = new DataTable();
                        dtTableChild.Load(cmd.ExecuteReader());

                        conn.Close();

                        foreach (DataRow childrow in dtTableChild.Rows)
                        {
                            TreeNode childNode = new TreeNode(childrow["ModelName"].ToString());
                            childNode.PopulateOnDemand = true;
                            childNode.Value = "fourth_" + childrow["ModelID"];
                            Session["model"] = childrow["ModelID"].ToString();

                            e.Node.ChildNodes.Add(childNode);
                        }

                        lblModelSearch.Visible = false;
                        txtModelPartSearch.Visible = false;
                        btnModelSearch.Visible = false;
                    }
                    else if (arg[0] == "fourth")
                    {
                        string[] makeArg = e.Node.Parent.Parent.Value.Split('_');
                        string[] yearArg = e.Node.Parent.Value.Split('_');

                        SqlCommand cmd = new SqlCommand("select distinct CategoryName, P.CategoryID from Parts P inner join Category C on P.CategoryID=C.CategoryID where MakeID=" + makeArg[1] + " and YearID=" + yearArg[1] + " and ModelID=" + arg[1], conn);
                        conn.Open();

                        DataTable dtTableChild = new DataTable();
                        dtTableChild.Load(cmd.ExecuteReader());

                        conn.Close();

                        foreach (DataRow childrow in dtTableChild.Rows)
                        {
                            TreeNode childNode = new TreeNode(childrow["CategoryName"].ToString());
                            childNode.PopulateOnDemand = true;
                            childNode.Value = "fifth_" + childrow["CategoryID"];
                            Session["category"] = childrow["CategoryID"].ToString();

                            e.Node.ChildNodes.Add(childNode);
                        }

                        lblModelSearch.Text = "Model part search: ";
                        lblModelSearch.Visible = true;
                        txtModelPartSearch.Visible = true;
                        btnModelSearch.Visible = true;
                    }
                    else if (arg[0] == "fifth")
                    {
                        string[] makeArg = e.Node.Parent.Parent.Parent.Value.Split('_');
                        string[] yearArg = e.Node.Parent.Parent.Value.Split('_');
                        string[] modelArg = e.Node.Parent.Value.Split('_');

                        Session["category"] = arg[1];
                        Session["make"] = makeArg[1];
                        Session["year"] = yearArg[1];
                        Session["model"] = modelArg[1];

                        string e1 = Session["make"].ToString();
                        string e2 = Session["year"].ToString();
                        string e3 = Session["model"].ToString();
                        string e4 = Session["category"].ToString();

                        //When the part category is clicked, then we need to bind the listview and data source.
                        LV_PartSearch.Visible = false;
                        LV_AdvancedPartSearch.Visible = false;
                        LV_PartsInfo.Visible = true;
                        LV_PartsInfo.DataBind();
                    }
                }
            }

        }
    }
}