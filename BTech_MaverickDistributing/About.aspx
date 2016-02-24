<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="BTech_MaverickDistributing.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:SqlDataSource ID="SQL_EquipmentType" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [EquipmentTypeName], [EquipmentTypeID] FROM [EquipmentType] ORDER BY [EquipmentTypeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_Make" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [MakeName], [MakeID] FROM [Make] ORDER BY [MakeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_Model" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [ModelName], [ModelID] FROM [Model] ORDER BY [ModelName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_ModelYear" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [EquipmentYearID], [EquipmentYearName] FROM [EquipmentYear] ORDER BY [EquipmentYearName] DESC" ></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_PartCategeory" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [CategoryName], [CategoryID] FROM [Category] ORDER BY [CategoryName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_PartManufacturer" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [ManufacturerName], [ManufacturerTypeID] FROM [Manufacturer] ORDER BY [ManufacturerName]"></asp:SqlDataSource>

    <div class="jumbotron">
        <h1>Car Part Selector Thingy Webstie</h1>
        <p class="lead">ASP.NET is a free web framework for building great Web sites and Web applications using HTML, CSS, and JavaScript.</p>
        <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>
    
    <div class="container-fluid">
        <h2>Add Site Content</h2>
        <hr />
        <div class="row">
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item1">
                    Equipment Type:
                <asp:DropDownList ID="DDL_EquipmentType" runat="server" CssClass="form-control" DataSourceID="SQL_EquipmentType" DataTextField="EquipmentTypeName" DataValueField="EquipmentTypeID"></asp:DropDownList>
                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item2">
                    Make:
                    <asp:DropDownList ID="DDL_Make" runat="server" CssClass="form-control" DataSourceID="SQL_Make" DataTextField="MakeName" DataValueField="MakeID"></asp:DropDownList>
                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item3">
                    Model
                    <asp:DropDownList ID="DDL_Model" runat="server" CssClass="form-control" DataSourceID="SQL_Model" DataTextField="ModelName" DataValueField="ModelID"></asp:DropDownList>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item4">
                    Model Year
                    <asp:DropDownList ID="DDL_ModelYear" runat="server" CssClass="form-control" DataSourceID="SQL_ModelYear" DataTextField="EquipmentYearName" DataValueField="EquipmentYearID"></asp:DropDownList>
                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item5">
                    Part Category
                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" DataSourceID="SQL_PartCategeory" DataTextField="CategoryName" DataValueField="CategoryID"></asp:DropDownList>
                </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12">
                <div id="item6">
                    Part Manufacturer
                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" DataSourceID="SQL_PartManufacturer" DataTextField="ManufacturerName" DataValueField="ManufacturerTypeID"></asp:DropDownList>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
