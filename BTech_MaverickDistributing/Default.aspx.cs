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
            LoadTreeViewTest();
        }
        public void LoadTreeViewTest()
        {
            try
            {
                using (var ctx = new md_dbEntities())
                {
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

                    foreach (var partRow in getPartSubset)
                    {
                        HtmlGenericControl li = new HtmlGenericControl("li");//Create html control <li>
                        //li.InnerText = partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.CategoryName; // these are the attributes of the data row from the database
                        li.InnerHtml = "<div id='10' >ATV<label><input type='checkbox'></label></div>";
                        //li.InnerText = "ATV";
                        //tabs.Controls.Add(li);
                        equipmentType.Controls.Add(li);

                        //HtmlGenericControl anchor = new HtmlGenericControl("a");
                        //anchor.Attributes.Add("href", "page.htm");
                        //anchor.InnerText = partRow.PartDesc;

                        //HtmlGenericControl li = new HtmlGenericControl("li");
                        //li.Attributes.Add("class", "MyClass");
                        //li.InnerText = "Item2";
                        //MyList2.Controls.Add(li);
                        //li.Controls.Add(anchor);

                        //li.Controls.Add(partRow.ManufacturerName + ", " + partRow.PartDesc + ", " + partRow.Price);
                        //drilldown1.Controls.Add(li);
                        
                    }
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