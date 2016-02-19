<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BTech_MaverickDistributing._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!--SQL Data source for the listview-->
    <asp:SqlDataSource ID="SQL_PartsInfo" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT * FROM [Parts] ORDER BY [PartID]"></asp:SqlDataSource>

    <div class="jumbotron">
        <h1>ASP.NET</h1>
        <p class="lead">ASP.NET is a free web framework for building great Web sites and Web applications using HTML, CSS, and JavaScript.</p>
        <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>

    <div class="row">
        <asp:ListView ID="LV_PartsInfo" runat="server" DataSourceID="SQL_PartsInfo">
            <AlternatingItemTemplate>
                <tr style="background-color:#FFF8DC;">
                    <td>
                        <asp:Label ID="PartIDLabel" runat="server" Text='<%# Eval("PartID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="MakeIDLabel" runat="server" Text='<%# Eval("MakeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="TypeIDLabel" runat="server" Text='<%# Eval("TypeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Eval("CategoryID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelIDLabel" runat="server" Text='<%# Eval("ModelID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerIDLabel" runat="server" Text='<%# Eval("ManufacturerID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedByLabel" runat="server" Text='<%# Eval("CreatedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedDateLabel" runat="server" Text='<%# Eval("CreatedDate") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedByLabel" runat="server" Text='<%# Eval("ModifiedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedDateLabel" runat="server" Text='<%# Eval("ModifiedDate") %>' />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <EditItemTemplate>
                <tr style="background-color:#008A8C;color: #FFFFFF;">
                    <td>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                    </td>
                    <td>
                        <asp:TextBox ID="PartIDTextBox" runat="server" Text='<%# Bind("PartID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="MakeIDTextBox" runat="server" Text='<%# Bind("MakeID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="TypeIDTextBox" runat="server" Text='<%# Bind("TypeID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryIDTextBox" runat="server" Text='<%# Bind("CategoryID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelIDTextBox" runat="server" Text='<%# Bind("ModelID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerIDTextBox" runat="server" Text='<%# Bind("ManufacturerID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PartNumberTextBox" runat="server" Text='<%# Bind("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PartDescTextBox" runat="server" Text='<%# Bind("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PriceTextBox" runat="server" Text='<%# Bind("Price") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ImageFilePathTextBox" runat="server" Text='<%# Bind("ImageFilePath") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CreatedByTextBox" runat="server" Text='<%# Bind("CreatedBy") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CreatedDateTextBox" runat="server" Text='<%# Bind("CreatedDate") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModifiedByTextBox" runat="server" Text='<%# Bind("ModifiedBy") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModifiedDateTextBox" runat="server" Text='<%# Bind("ModifiedDate") %>' />
                    </td>
                </tr>
            </EditItemTemplate>
            <EmptyDataTemplate>
                <table runat="server" style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;">
                    <tr>
                        <td>No data was returned.</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <InsertItemTemplate>
                <tr style="">
                    <td>
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" />
                    </td>
                    <td>
                        <asp:TextBox ID="PartIDTextBox" runat="server" Text='<%# Bind("PartID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="MakeIDTextBox" runat="server" Text='<%# Bind("MakeID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="TypeIDTextBox" runat="server" Text='<%# Bind("TypeID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryIDTextBox" runat="server" Text='<%# Bind("CategoryID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelIDTextBox" runat="server" Text='<%# Bind("ModelID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerIDTextBox" runat="server" Text='<%# Bind("ManufacturerID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PartNumberTextBox" runat="server" Text='<%# Bind("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PartDescTextBox" runat="server" Text='<%# Bind("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="PriceTextBox" runat="server" Text='<%# Bind("Price") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ImageFilePathTextBox" runat="server" Text='<%# Bind("ImageFilePath") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CreatedByTextBox" runat="server" Text='<%# Bind("CreatedBy") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CreatedDateTextBox" runat="server" Text='<%# Bind("CreatedDate") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModifiedByTextBox" runat="server" Text='<%# Bind("ModifiedBy") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModifiedDateTextBox" runat="server" Text='<%# Bind("ModifiedDate") %>' />
                    </td>
                </tr>
            </InsertItemTemplate>
            <ItemTemplate>
                <tr style="background-color:#DCDCDC;color: #000000;">
                    <td>
                        <asp:Label ID="PartIDLabel" runat="server" Text='<%# Eval("PartID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="MakeIDLabel" runat="server" Text='<%# Eval("MakeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="TypeIDLabel" runat="server" Text='<%# Eval("TypeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Eval("CategoryID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelIDLabel" runat="server" Text='<%# Eval("ModelID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerIDLabel" runat="server" Text='<%# Eval("ManufacturerID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedByLabel" runat="server" Text='<%# Eval("CreatedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedDateLabel" runat="server" Text='<%# Eval("CreatedDate") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedByLabel" runat="server" Text='<%# Eval("ModifiedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedDateLabel" runat="server" Text='<%# Eval("ModifiedDate") %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;font-family: Verdana, Arial, Helvetica, sans-serif;">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                    <th runat="server">PartID</th>
                                    <th runat="server">MakeID</th>
                                    <th runat="server">TypeID</th>
                                    <th runat="server">CategoryID</th>
                                    <th runat="server">ModelID</th>
                                    <th runat="server">YearID</th>
                                    <th runat="server">ManufacturerID</th>
                                    <th runat="server">PartNumber</th>
                                    <th runat="server">PartDesc</th>
                                    <th runat="server">Price</th>
                                    <th runat="server">ImageFilePath</th>
                                    <th runat="server">CreatedBy</th>
                                    <th runat="server">CreatedDate</th>
                                    <th runat="server">ModifiedBy</th>
                                    <th runat="server">ModifiedDate</th>
                                </tr>
                                <tr id="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server" style="text-align: center;background-color: #CCCCCC;font-family: Verdana, Arial, Helvetica, sans-serif;color: #000000;"></td>
                    </tr>
                </table>
            </LayoutTemplate>
            <SelectedItemTemplate>
                <tr style="background-color:#008A8C;font-weight: bold;color: #FFFFFF;">
                    <td>
                        <asp:Label ID="PartIDLabel" runat="server" Text='<%# Eval("PartID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="MakeIDLabel" runat="server" Text='<%# Eval("MakeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="TypeIDLabel" runat="server" Text='<%# Eval("TypeID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryIDLabel" runat="server" Text='<%# Eval("CategoryID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelIDLabel" runat="server" Text='<%# Eval("ModelID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerIDLabel" runat="server" Text='<%# Eval("ManufacturerID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedByLabel" runat="server" Text='<%# Eval("CreatedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CreatedDateLabel" runat="server" Text='<%# Eval("CreatedDate") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedByLabel" runat="server" Text='<%# Eval("ModifiedBy") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModifiedDateLabel" runat="server" Text='<%# Eval("ModifiedDate") %>' />
                    </td>
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
    </div>

</asp:Content>
