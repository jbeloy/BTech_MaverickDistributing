using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTech_MaverickDistributing
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CHK_Clutch_ServerChange(object sender, EventArgs e)
        {
            //When the button is checked, updatae the listview to show that part.

            //Check to see if the checkbox is checked.
            if(CHK_Clutch.Checked)
            {
                //Update the hidden field with the parameters.
                HF_PartsInfo.Value = "Clutch";
            }
            else
            {
                //Erase the value from the HiddenField.
                HF_PartsInfo.Value = null;
            }
        }
    }
}