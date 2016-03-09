using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BTech_MaverickDistributing.Models;
using BTech_MaverickDistributing.SqlStatements;
using System.Web.UI.HtmlControls;

namespace BTech_MaverickDistributing
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //LoadTreeViewTest();
        }
        public void LoadTreeViewTest()
        {
            try
            {
                using (var ctx = new md_dbEntities())
                {
                    List<string> equipmentTypes = new List<string>();
                    List<string> makes = new List<string>();

                    var objectContext = (ctx as System.Data.Entity.Infrastructure.IObjectContextAdapter).ObjectContext;

                    string strSQLtoGetParts = "";
                    //these are the parameters to get a subset of the result set
                    int yearToGet = 2005;
                    string partMakeToGet = "Honda";
                    string partModelToGet = "TRX450R";
                    string partCategoryToGet = "CLUTCH";

                    //use objectContext here..

                    strSQLtoGetParts = String.Format(Statements.GetPartsByYearMakeModelCategory(), yearToGet, partMakeToGet, partModelToGet, partCategoryToGet);
                    var getPartSubset = objectContext.ExecuteStoreQuery<PartsView>(strSQLtoGetParts).ToList();

                    //Get all of the equipment types from the database.
                    equipmentTypes = Statements.GetEquipmentType();

                    foreach(string t in equipmentTypes)
                    {
                        HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
                        //Create the correct <li> for the equipment type. Using the naming convention tableAbreviation_recordName eg: et_ATV.
                        li.InnerHtml = "<div id='et_" + t +"' >" + t + "<label><input type='checkbox'></label></div><ul id='" + t + "_make' runat='server'></ul>";
                        li.Attributes.Add("onload", "li_" + t + "_Load");
                        li.ID = "li_" + t;
                        equipmentType.Controls.Add(li);
                    }

                    makes = Statements.GetMake();

                    foreach(string t in makes)
                    {
                        HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
                        //Create the correct <li> for the equipment type. Using the naming convention tableAbreviation_recordName eg: et_ATV.
                        li.InnerHtml = "<div id='mk_" + t + "' >" + t + "<label><input type='checkbox'></label></div>";
                        Page.FindControl("ATV_make").Controls.Add(li);
                    }

                    //foreach (var partRow in getPartSubset)
                    //{
                    //    HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
                    //    //li.InnerText = partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.CategoryName; // these are the attributes of the data row from the database
                    //    li.InnerHtml = "<div id='10' >ATV<label><input type='checkbox'></label></div>";
                    //    //li.InnerText = "ATV";
                    //    //tabs.Controls.Add(li);
                    //    equipmentType.Controls.Add(li);

                    //    //HtmlGenericControl anchor = new HtmlGenericControl("a");
                    //    //anchor.Attributes.Add("href", "page.htm");
                    //    //anchor.InnerText = partRow.PartDesc;

                    //    //HtmlGenericControl li = new HtmlGenericControl("li");
                    //    //li.Attributes.Add("class", "MyClass");
                    //    //li.InnerText = "Item2";
                    //    //MyList2.Controls.Add(li);
                    //    //li.Controls.Add(anchor);

                    //    //li.Controls.Add(partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.Price);
                    //    //drilldown1.Controls.Add(li);
                        
                    //}
                }

            }
            catch (Exception ex)
            {
                //error handling here
            }
            
        }
        protected void CHK_Clutch_ServerChange(object sender, EventArgs e)
        {
            //When the button is checked, updatae the listview to show that part.

            //Check to see if the checkbox is checked.
            /*if(CHK_Clutch.Checked)
            {
                //Update the hidden field with the parameters.
                HF_PartsInfo.Value = "Clutch";
            }
            else
            {
                //Erase the value from the HiddenField.
                HF_PartsInfo.Value = null;
            }*/
        }
    }
}