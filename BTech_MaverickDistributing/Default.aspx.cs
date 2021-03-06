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
            else
            {
                if (!CHK_toggleAdvanced.Checked)
                {
                    drillDownSearch.Attributes.Add("style", "display: none;");
                    advancedSearch.Attributes.Remove("style");
                    CHK_toggleDrillDown.Checked = false;
                }
                else
                {
                    drillDownSearch.Attributes.Remove("style");
                    advancedSearch.Attributes.Add("style", "display: none;");
                }
            }
        }

        protected void Repeater2_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            string MakeName = DataBinder.Eval(e.Item.DataItem, "MakeName").ToString();
            this.Session["make"] = MakeName;
            RepeaterItem item = e.Item;
            Repeater Product = (Repeater)item.FindControl("Repeater3");
            Product.DataBind();
        }

        protected void Repeater3_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            string Year = DataBinder.Eval(e.Item.DataItem, "YearID").ToString();
            RepeaterItem item = e.Item;

            if (this.Session["make"] != null)
            {
                if (this.Session["make"].ToString() == DataBinder.Eval(e.Item.DataItem, "MakeName").ToString())
                    e.Item.Visible = true;
                else
                    e.Item.Visible = false;
            }
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
                    //Session["equipmenttypeid"] = arg[1].ToString();
                    //Get the value of the equipment type node here.
                    string[] equipmentTypeArg = TV_Menu.SelectedNode.Value.Split('_');
                    SqlCommand cmd = new SqlCommand("select distinct MakeName, P.MakeID from Parts P inner join Make M on P.MakeId=M.MakeID  inner join Model Mo on P.ModelID=Mo.ModelID where Mo.EquipmentTypeID=" + equipmentTypeArg[1], conn);
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
                    Session["make"] = arg[1];

                    TV_Menu.SelectedNode.Expand();
                    lblModelSearch.Visible = false;
                    txtModelPartSearch.Visible = false;
                    btnModelSearch.Visible = false;
                }
                else if (arg[0] == "third")
                {
                    //Get the value of the equipment type parent node here.
                    string[] equipmentTypeArg = TV_Menu.SelectedNode.Parent.Parent.Value.Split('_');

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
                    Session["make"] = makeArg[1];
                    Session["year"] = arg[1];

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
                    Session["make"] = makeArg[1];
                    Session["year"] = yearArg[1];
                    Session["model"] = arg[1];

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
            if (string.IsNullOrWhiteSpace(txtPartNumber.Text))
                txtPartNumber.Text = " ";
            if (string.IsNullOrWhiteSpace(txtPartDesc.Text))
                txtPartDesc.Text = " ";

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
                        //Get the value of the equipment type node here.
                        string[] equipmentTypeArg = e.Node.Value.Split('_');
                        SqlCommand cmd = new SqlCommand("select distinct MakeName, P.MakeID from Parts P inner join Make M on P.MakeId=M.MakeID  inner join Model Mo on P.ModelID=Mo.ModelID where Mo.EquipmentTypeID=" + equipmentTypeArg[1], conn);
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
                        //Get the value of the equipment type node here.
                        string[] equipmentTypeArg = e.Node.Parent.Value.Split('_');

                        //Use the selected value from the menue to execute the sql statement.
                        SqlCommand cmd = new SqlCommand("select distinct YearID from Parts P inner join Model M on P.ModelID=M.ModelID  where MakeID="
                            + arg[1] + " and MakeID=" + arg[1] + " and M.EquipmentTypeID=" + equipmentTypeArg[1], conn);
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
                        Session["make"] = arg[1];
                        lblModelSearch.Visible = false;
                        txtModelPartSearch.Visible = false;
                        btnModelSearch.Visible = false;
                    }
                    else if (arg[0] == "third")
                    {
                        //Get the value of the equipment type node here.
                        string[] equipmentTypeArg = e.Node.Parent.Parent.Value.Split('_');

                        //Get the value of the parent node here.
                        string[] makeArg = e.Node.Parent.Value.Split('_');

                        SqlCommand cmd = new SqlCommand("select distinct ModelName, P.ModelID from Parts P inner join Model M on P.ModelID=M.ModelID where MakeID=" 
                            + makeArg[1] + " and YearID=" + arg[1] + " and M.EquipmentTypeID=" + equipmentTypeArg[1], conn);
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
                        Session["make"] = makeArg[1];
                        Session["year"] = arg[1];
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

                        Session["make"] = makeArg[1];
                        Session["year"] = yearArg[1];
                        Session["model"] = arg[1];
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

        protected void CHK_toggleAdvanced_CheckedChanged(object sender, EventArgs e)
        {
            //When the check is changed, check checkbox state, then hide or show drill down selection.
            if(!CHK_toggleAdvanced.Checked)
            {
                drillDownSearch.Attributes.Add("style", "display: none;");
                advancedSearch.Attributes.Remove("style");
                CHK_toggleDrillDown.Checked = false;
            }
            else
            {
                drillDownSearch.Attributes.Remove("style");
                advancedSearch.Attributes.Add("style", "display: none;");
            }
        }

        protected void CHK_toggleDrillDown_CheckedChanged(object sender, EventArgs e)
        {
            //Wehn the check is changed, check checkbox state, then hide or show drill down selection.
            if (!CHK_toggleDrillDown.Checked)
            {
                drillDownSearch.Attributes.Add("style", "display: none;");
                advancedSearch.Attributes.Remove("style");
                CHK_toggleAdvanced.Checked = false;
            }
            else
            {
                drillDownSearch.Attributes.Remove("style");
                advancedSearch.Attributes.Add("style", "display: none;");
            }
        }
    }
}