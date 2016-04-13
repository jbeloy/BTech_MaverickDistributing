<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BTech_MaverickDistributing._Default" MaintainScrollPositionOnPostBack = "true" %>
<%@Import Namespace="System.Data"%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server"> 

    <script>

        $(document).ready(function () {

            //When the checkbox is checked, hide the advanced search, and show the drill down search.
            $('#toggleAdvanced').click(function () {
                if ($('drillDownSearch').hasClass('hidden'))
                {
                    //if dds has hidden class, remove the class and apply it to advanced search.
                    $('drillDownSearch').removeClass('hidden');
                }
            });

            //
            // Settings
            //
            var animationSpeed = 700;
            var drilldownInput = $('#drilldownInput');

            var objDrilldown = {

                animationSpeed: 200,
                drilldown: {},
                drilldownInput: {},
                drilldownSelected: {},

                init: function (id, formID) {
                    this.drilldown = $("#" + id);

                    if (formID) { this.drilldownInput = $("#" + formID); }
                    else { console.log("You haven't give me an input to play with"); }

                    // Add a container for the selected items
                    this.drilldownSelected = $("#" + this.drilldown.attr('id') + "Selected");

                    // Build the selected items from the hidden input value
                    this.build();

                    // setup listeners
                    this.listeners.all(this);
                    console.log('new Drilldown object initialized.');
                },

                build: function () {
                    var self = this;
                    var values = this.drilldownInput.val().split(' ');
                    if (values.length > 1) {
                        for (i in values) {
                            var item = this.drilldown.find("#" + values[i] + " input:checkbox");
                            // since this is not a true click, force the checkbox to be checked
                            item.attr('checked', true);
                            this.selectItem(item[0]);
                        }
                    } else {
                        // deselect all
                        this.drilldown.find('input:checkbox').attr('checked', false);
                    }
                    this.updateSelected();
                },

                listeners: {
                    all: function (self) {
                        this.lists(self);
                        this.selected(self);
                    },
                    lists: function (self) {
                        // listen to clicks on the tree list of items
                        self.drilldown.find("li > div").click(function (e) {
                            if (e.target.localName == "div") { self.openItem(e.target); }
                            if (e.target.localName == "input") { self.selectItem(e.target); }
                        });
                        return "List listeners added";
                    },
                    selected: function (self) {
                        // listen to clicks on the drill-down selected
                        self.drilldownSelected.click(function (e) {
                            var selected = $(e.target);
                            var item = $("#" + selected.attr('data-id'));
                            var checkbox = item.find("input:checkbox");
                            selected.remove();
                            checkbox.attr("checked", false);
                            self.updateSelected();
                        });
                        return "Selected items listeners added";
                    }
                },

                closeLists: function () {
                    this.drilldown.find('ul').hide();
                },

                clearActive: function () {
                    this.drilldown.find(".active").removeClass("active");
                },

                openItem: function (item) {
                    var item = $(item);
                    var child = item.next('ul');
                    var wasVisible = child.is(':visible');
                    // close all lists
                    this.closeLists();
                    // reveal the parents of this element
                    item.parents('ul').show();
                    // animate the contained <ul>
                    // if it is already open, hide it, and vice versa
                    if (wasVisible) {
                        child.show().slideUp(this.animationSpeed);
                        this.clearActive();
                    } else {
                        child.slideDown(this.animationSpeed);
                        // add an active class to the <div>
                        // only if it has a child <ul> list
                        if (item.closest('li').has('ul').length) {
                            this.clearActive();
                            item.addClass('active');
                        }
                    }
                },

                selectItem: function (item) {
                    // When a checkbox is selected, add a 'selected' class to the parent <div>
                    var checkbox = $(item);
                    var item = checkbox.closest('div');
                    if (checkbox.is(':checked')) {
                        item.addClass('selected');
                    } else {
                        item.removeClass('selected');
                    }
                    this.updateSelected();
                },

                updateSelected: function () {
                    // create a new variable for this so that the each() functions can use the correct scope
                    var self = this;
                    var checked = this.drilldown.find("input:checked");
                    var unchecked = this.drilldown.find("input:checkbox:not(:checked)");
                    var values = '';
                    this.drilldownSelected.empty();
                    unchecked.each(function (key, val) { $(val).closest('div').removeClass('selected'); });
                    checked.each(function (key, val) {
                        // store the string of IDs for saved reports retrieval
                        values = values + " " + $(val).closest("div").attr("id");
                        // add to the selected list for easy removal
                        var parentDiv = $(val).closest('div');
                        self.drilldownSelected.append($("<p/>").text(parentDiv.text()).attr('data-id', parentDiv.attr('id')));
                    });
                    this.drilldownInput.val(values);
                }

            };

            // use the object prototypal setup to create instances of the Drilldown object
            function Drilldown(item, inputID) {
                function drilldown() { }
                drilldown.prototype = objDrilldown;
                var f = new drilldown();
                f.init(item, inputID);
                return f;
            }

            var drilldown = new Drilldown("drilldown1", "drilldownInput");

        });

    </script>

    <!--SQL Data source for the listview-->
    <asp:SqlDataSource ID="SQL_PartsInfo" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="GetPartsInfo" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="MakeID" SessionField="make" Type="Int32" />
            <asp:SessionParameter Name="CategoryID" SessionField="category" Type="Int32" />
            <asp:SessionParameter Name="ModelID" SessionField="model" Type="Int32" />
            <asp:SessionParameter Name="YearID" SessionField="year" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_ModelPartsSearch" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="GetModelParts" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="MakeID" SessionField="make" Type="Int32" />
            <asp:SessionParameter Name="ModelID" SessionField="model" Type="Int32" />
            <asp:SessionParameter Name="YearID" SessionField="year" Type="Int32" />
            <asp:ControlParameter ControlID="txtModelPartSearch" Name="PartSearchWildCard" PropertyName="Text" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_AdvancedPartSearch" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="GetAdvancedSearchParts" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="drpType" Name="EquipmentType" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="drpCategory" Name="Category" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="drpMake" Name="MakeName" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="drpModel" Name="ModelName" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="drpManufacturer" DefaultValue="" Name="ManufacturerName" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="drpYear" Name="YearID" PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="txtPartNumber" Name="PartNumber" PropertyName="Text" Type="String" />
                <asp:ControlParameter ControlID="txtPartDesc" Name="PartDesc" PropertyName="Text" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

    <asp:DropDownList ID="drpType" runat="server" DataSourceID="SQLType" DataTextField="EquipmentTypeName" DataValueField="EquipmentTypeName">
    </asp:DropDownList>

    <asp:SqlDataSource ID="SQLType" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [EquipmentTypeName] FROM [EquipmentType] ORDER BY [EquipmentTypeName]"></asp:SqlDataSource>

    <asp:DropDownList ID="drpYear" runat="server" DataSourceID="SQLYear" DataTextField="EquipmentYearID" DataValueField="EquipmentYearID">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SQLYear" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [EquipmentYearID] FROM [EquipmentYear] ORDER BY [EquipmentYearID] DESC"></asp:SqlDataSource>
    <asp:DropDownList ID="drpCategory" runat="server" DataSourceID="SQLCategory" DataTextField="CategoryName" DataValueField="CategoryName">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SQLCategory" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [CategoryName] FROM [Category] ORDER BY [CategoryName]"></asp:SqlDataSource>
    <asp:DropDownList ID="drpManufacturer" runat="server" DataSourceID="SQLManufacturer" DataTextField="ManufacturerName" DataValueField="ManufacturerName">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SQLManufacturer" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]"></asp:SqlDataSource>
    <asp:DropDownList ID="drpMake" runat="server" DataSourceID="SQLMake" DataTextField="MakeName" DataValueField="MakeName">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SQLMake" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [MakeName] FROM [Make] ORDER BY [MakeName]"></asp:SqlDataSource>
    <asp:DropDownList ID="drpModel" runat="server" DataSourceID="SQLModel" DataTextField="ModelName" DataValueField="ModelName">
    </asp:DropDownList>
    <asp:SqlDataSource ID="SQLModel" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [ModelName] FROM [Model] ORDER BY [ModelName]"></asp:SqlDataSource>

    <div id="advancedSearch" class="ulCont">
        <ul class="list-inline adSearch">
            <li>
                TYPE
                <asp:TextBox ID="txtType" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>
            <li>
                YEAR
                <asp:TextBox ID="txtYear" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>
            <li>
                CATEGORY
                <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>
            <li>
                MANUFACTURER
                <asp:TextBox ID="txtManufacturer" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>
        </ul>
        <ul class="list-inline adSearch">
                    <li>
                        PART NUMBER
                        <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
                    </li>
                    <li>
                        MAKE
                        <asp:TextBox ID="txtMake" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
                    </li>
                    <li>
                        MODEL
                        <asp:TextBox ID="txtModel" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
                    </li>
                    <li>
                         PART DESCRIPTION
                        <asp:TextBox ID="txtPartDesc" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
                    </li>
                    <li>
                        <asp:Button ID="Button1" runat="server" OnClick="btnSearchParts_Click" Text="Search" CssClass="searchButton" />
                    </li>
                </ul>
        <ul>
            <li>
                <section>
                    <input id='one' type='checkbox' />
                      <label for='one'>
                        <span id="toggleAdvanced"></span>
                        Drill-Down Selection
                        <ins><i>Drill-Down Selection</i></ins>
                      </label>
                </section>
            </li>
        </ul>
    </div>

    <div id="drillDownSearch" class="container">
        <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <h1 class="hero-text">Drill-down select</h1>
                <hr />
                <div>
                    <asp:Label ID="lblModelSearch" runat="server" Text="Model part search: " Visible="False"></asp:Label>
                    <div style="display: flex;">
                        <asp:TextBox ID="txtModelPartSearch" CssClass="form-control" runat="server" Visible="false"></asp:TextBox>
                        <asp:Button ID="btnModelSearch" runat="server" CssClass="searchDrillDownButton" OnClick="btnModelSearch_Click" Text="Search" Visible="False" />
                    </div>
                </div>
                <asp:TreeView ID="TV_Menu" runat="server" OnSelectedNodeChanged="TV_Menu_SelectedNodeChanged" NodeStyle-VerticalPadding="10" OnTreeNodeExpanded="TV_Menu_TreeNodeExpanded" >
                    <HoverNodeStyle Font-Underline="false" />
                    <NodeStyle Font-Names="Verdana" Font-Size="11pt" ForeColor="Black"
                    HorizontalPadding="0px" NodeSpacing="0px" />
                <ParentNodeStyle Font-Bold="False" />
                <SelectedNodeStyle Font-Underline="True" ForeColor="#DD5555"
                    HorizontalPadding="0px" />
                </asp:TreeView>
                <br />
            </div>
            <%--<div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                <h1>Advanced Search</h1>
                <hr />
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    Type
                    <asp:TextBox ID="txtType" runat="server" CssClass="form-control"></asp:TextBox>
                    Year
                    <asp:TextBox ID="txtYear" runat="server" CssClass="form-control"></asp:TextBox>
                    Category
                    <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control"></asp:TextBox>
                    Manufacturer
                    <asp:TextBox ID="txtManufacturer" runat="server" CssClass="form-control"></asp:TextBox>
                    Part Number
                    <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-control"></asp:TextBox>
                <br />
                </div>
                <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12">
                    Make
                    <asp:TextBox ID="txtMake" runat="server" CssClass="form-control"></asp:TextBox>
                    Model
                    <asp:TextBox ID="txtModel" runat="server" CssClass="form-control"></asp:TextBox>
                    Part Description
                    <asp:TextBox ID="txtPartDesc" runat="server" CssClass="form-control"></asp:TextBox>
                    <br />
                    <asp:Button ID="btnSearchParts" runat="server" OnClick="btnSearchParts_Click" Text="Search" CssClass="btn btn-primary pull-right" />
                </div>
            </div>--%><%--<asp:Button ID="btnSearchParts" runat="server" OnClick="btnSearchParts_Click" Text="Search" CssClass="btn btn-primary pull-right" />--%>
        </div>
    </div>
    <hr />

    <div class="container-fluid">
        <div class="row">
        <asp:ListView ID="LV_PartSearch" runat="server" DataSourceID="SQL_ModelPartsSearch">
            <AlternatingItemTemplate>
                <tr class="partsInfo">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                </tr>
            </AlternatingItemTemplate>
            <EditItemTemplate>
                <tr style="">
                    <td>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                    </td>
                    <td>
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </EditItemTemplate>
            <EmptyDataTemplate>
                <table runat="server" style="">
                    <tr>
                        <td>No data was returned.</td>
                    </tr>
                </table>
            </EmptyDataTemplate>
            <InsertItemTemplate>
                <tr>
                    <td>
                        <asp:Button ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Clear" />
                    </td>
                    <td>
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </InsertItemTemplate>
            <ItemTemplate>
                <tr class="partsInfo">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="partsinfoClass">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" class="jobDetailsClass">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                <%--<tr runat="server" style="">--%>
                                    <th runat="server">MakeName</th>
                                    <th runat="server">EquipmentTypeName</th>
                                    <th runat="server">CategoryName</th>
                                    <th runat="server">ModelName</th>
                                    <th runat="server">YearID</th>
                                    <th runat="server">ManufacturerName</th>
                                    <th runat="server">PartNumber</th>
                                    <th runat="server">PartDesc</th>
                                    <th runat="server">Price</th>
                                    <th runat="server">ImageFilePath</th>
                                </tr>
                                <tr id="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr runat="server">
                        <td runat="server" style=""></td>
                    </tr>
                </table>
            </LayoutTemplate>
            <SelectedItemTemplate>
                <tr style="">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
        </div>
    </div>

    <div class="row">
        <asp:ListView ID="LV_PartsInfo" runat="server" DataSourceID="SQL_PartsInfo">
            <AlternatingItemTemplate>
                <tr class="partsInfo">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                    </td>
                    <td>
                        <%--<asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />--%>
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
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
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </EditItemTemplate>
            <EmptyDataTemplate>
                <table runat="server" style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;">
                    <tr>
                        <td>No parts where found.</td>
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
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </InsertItemTemplate>
            <ItemTemplate>
                <tr class="partsInfoAlt">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                    </td>
                    <td>
                        <%--<asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />--%>
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
                    </td>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="partsinfoClass">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" class="partsinfoClass">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                    <th runat="server">MakeName</th>
                                    <th runat="server">EquipmentTypeName</th>
                                    <th runat="server">CategoryName</th>
                                    <th runat="server">ModelName</th>
                                    <th runat="server">YearID</th>
                                    <th runat="server">ManufacturerName</th>
                                    <th runat="server">PartNumber</th>
                                    <th runat="server">PartDesc</th>
                                    <th runat="server">Price</th>
                                    <th runat="server">ImageFilePath</th>
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
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
    </div>
    
    <div class="row">
        <asp:ListView ID="LV_AdvancedPartSearch" runat="server" DataSourceID="SQL_AdvancedPartSearch">
            <AlternatingItemTemplate>
                <tr class="partsInfo">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                    </td>
                    <td>
                        <%--<asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />--%>
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
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
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </EditItemTemplate>
            <EmptyDataTemplate>
                <table runat="server" style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;">
                    <tr>
                        <td>No parts where found.</td>
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
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="CategoryNameTextBox" runat="server" Text='<%# Bind("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ModelNameTextBox" runat="server" Text='<%# Bind("ModelName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="YearIDTextBox" runat="server" Text='<%# Bind("YearID") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="ManufacturerNameTextBox" runat="server" Text='<%# Bind("ManufacturerName") %>' />
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
                </tr>
            </InsertItemTemplate>
            <ItemTemplate>
                <tr class="partsInfoAlt">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                    <td>
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                    </td>
                    <td>
                        <%--<asp:Label ID="ImageFilePathLabel" runat="server" Text='<%# Eval("ImageFilePath") %>' />--%>
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
                    </td>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="partsinfoClass">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" class="partsinfoClass">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                    <th runat="server">MakeName</th>
                                    <th runat="server">EquipmentTypeName</th>
                                    <th runat="server">CategoryName</th>
                                    <th runat="server">ModelName</th>
                                    <th runat="server">YearID</th>
                                    <th runat="server">ManufacturerName</th>
                                    <th runat="server">PartNumber</th>
                                    <th runat="server">PartDesc</th>
                                    <th runat="server">Price</th>
                                    <th runat="server">ImageFilePath</th>
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
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                </tr>
            </SelectedItemTemplate>
        </asp:ListView>
    </div>
</asp:Content>
