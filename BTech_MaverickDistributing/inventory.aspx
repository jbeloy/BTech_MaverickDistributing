<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="inventory.aspx.cs" Inherits="BTech_MaverickDistributing.inventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href="Content/uploadStyles.css" />

    <div class="container-fluid" style="background-color:#596877;">
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <div class="uploadContainer">
                    <h1>CHOOSE A FILE TO UPLOAD</h1>
                    <asp:FileUpload CssClass="upload" ID="FU_Inventory" runat="server" />
                 </div>
            </div>
        </div>
    </div>
    
</asp:Content>




