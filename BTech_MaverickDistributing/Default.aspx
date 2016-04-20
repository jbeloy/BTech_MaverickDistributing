<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BTech_MaverickDistributing._Default" MaintainScrollPositionOnPostBack = "true" %>
<%@Import Namespace="System.Data"%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server"> 

    <script>

        $(document).ready(function () {

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
    <asp:SqlDataSource ID="SQLType" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as EquipmentTypeName
UNION
SELECT [EquipmentTypeName] FROM [EquipmentType] ORDER BY [EquipmentTypeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLYear" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as EquipmentYearID
UNION
SELECT Cast(EquipmentYearID as VARCHAR(50)) as EquipmentYearID FROM [EquipmentYear] ORDER BY [EquipmentYearID]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLCategory" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as CategoryName
UNION
SELECT [CategoryName] FROM [Category] ORDER BY [CategoryName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLManufacturer" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as ManufacturerName
UNION
SELECT [ManufacturerName] FROM [Manufacturer] ORDER BY [ManufacturerName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLMake" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as MakeName
UNION
SELECT [MakeName] FROM [Make] ORDER BY [MakeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQLModel" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT ' ' as ModelName
UNION
SELECT [ModelName] FROM [Model] ORDER BY [ModelName]"></asp:SqlDataSource>

    <div id="advancedSearch" class="ulCont" runat="server">
        <ul class="list-inline adSearch" style="text-align:center; margin-left:auto; margin-right:auto;">
            <li>
                <h2>ADVANCED SEARCH</h2>
            </li>
        </ul>
        <hr />
        <ul class="list-inline adSearch">
            <li>
                TYPE
                <asp:DropDownList ID="drpType" CssClass="form-control" runat="server" DataSourceID="SQLType" DataTextField="EquipmentTypeName" DataValueField="EquipmentTypeName"></asp:DropDownList>
            </li>
            <li>
                YEAR
                <asp:DropDownList ID="drpYear" CssClass="form-control" runat="server" DataSourceID="SQLYear" DataTextField="EquipmentYearID" DataValueField="EquipmentYearID"></asp:DropDownList>
            </li>
            <li>
                CATEGORY
                <asp:DropDownList ID="drpCategory" CssClass="form-control" runat="server" DataSourceID="SQLCategory" DataTextField="CategoryName" DataValueField="CategoryName"></asp:DropDownList>
            </li>
            <li>
                MANUFACTURER
                <asp:DropDownList ID="drpManufacturer" CssClass="form-control" runat="server" DataSourceID="SQLManufacturer" DataTextField="ManufacturerName" DataValueField="ManufacturerName"></asp:DropDownList>
            </li>
        </ul>
        <ul class="list-inline adSearch">
            <li>
                MAKE
                <asp:DropDownList ID="drpMake" CssClass="form-control" runat="server" DataSourceID="SQLMake" DataTextField="MakeName" DataValueField="MakeName"></asp:DropDownList>
            </li>
            <li>
                MODEL
                <asp:DropDownList ID="drpModel" CssClass="form-control" runat="server" DataSourceID="SQLModel" DataTextField="ModelName" DataValueField="ModelName"></asp:DropDownList>
            </li>
            <li>
                PART NUMBER
                <asp:TextBox ID="txtPartNumber" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>            
            <li>
                 PART DESCRIPTION
                <asp:TextBox ID="txtPartDesc" runat="server" CssClass="form-control adSearchControls"></asp:TextBox>
            </li>
            <li>
                <asp:Button ID="Button1" runat="server" OnClick="btnSearchParts_Click" Text="Search" CssClass="searchButton" />
            </li>
        </ul>
        <ul style="list-style: none;">
            <li style="color: white;">
                <asp:CheckBox ID="CHK_toggleAdvanced" runat="server" Text="Show Drill-Down Search" style="text-indent: 10px;" OnCheckedChanged="CHK_toggleAdvanced_CheckedChanged" AutoPostBack="true"/>
            </li>
        </ul>
    </div>

    <div id="drillDownSearch" class="container" runat="server" style="display: none;">
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12" style="text-align: center;">
                <h1 class="hero-text">Drill-down select</h1>
                <hr />
                <div>
                    <asp:Label ID="lblModelSearch" runat="server" Text="Model part search: " Visible="False" style="text-align: center;"></asp:Label>
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
        </div>
        <ul style="list-style: none;">
            <li>
                <asp:CheckBox ID="CHK_toggleDrillDown" runat="server" Text="Show Drill-Down Search" style="text-indent: 10px;" OnCheckedChanged="CHK_toggleDrillDown_CheckedChanged" AutoPostBack="true" Checked="true"/>
            </li>
        </ul>
    </div>

    <hr />

<%--    <div class="container">
        <div class="row">
        <asp:ListView ID="LV_PartSearch" runat="server" DataSourceID="SQL_ModelPartsSearch">
            <%--<AlternatingItemTemplate>
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
            <AlternatingItemTemplate>
                <tr class="partsInfoAlt">
                    <td colspan="2" rowspan="5">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:100%;max-height: 200px;max-width: 300px;" />
                    </td>
                    <td colspan="3" style="font-weight:bold;font-size:120%;">
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label Text="PART #:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                        </div>
                    </td>
                    <td>
                    </td>
                    <td colspan="1">
                        <div class="cardLabel">
                            <asp:Label Text="YEAR:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PART MANUFACTURER:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                        </div>
                    </td>
                    <td>

                    </td>
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MAKE:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>

                    </td>
                    <td>
                        
                    </td>
                    <td >
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MODEL:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PRICE(CAD):"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                        </div>
                    </td>
                    <td colspan="2"></td>
                   <%-- <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                       <h4>PART CATEGORY:</h4><asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
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
                                <%--<tr runat="server" style="">
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
    </div>--%>

    <div class="row">
        <asp:ListView ID="LV_PartsInfo" runat="server" DataSourceID="SQL_PartsInfo">
            <AlternatingItemTemplate>
                <%--<tr class="partsInfo">
                    <td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>--%>
                    <%--<td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>
                    <td colspan="2">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
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
                </tr>--%>
                <tr class="partsInfoAlt">
                    <%--<td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>--%>
                    <td colspan="2" rowspan="5">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:100%;max-height: 200px;max-width: 300px;" />
                    </td>
                    <td colspan="3" style="font-weight:bold;font-size:120%;">
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label Text="PART #:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                        </div>
                    </td>
                    <td>
                    </td>
                    <td colspan="1">
                        <div class="cardLabel">
                            <asp:Label Text="YEAR:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PART MANUFACTURER:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                        </div>
                    </td>
                    <td>

                    </td>
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MAKE:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>

                    </td>
                    <td>
                        
                    </td>
                    <td >
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MODEL:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PRICE(CAD):"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                        </div>
                    </td>
                    <td colspan="2"></td>
                   <%-- <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                       <h4>PART CATEGORY:</h4><asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>--%>
                </tr>
            </AlternatingItemTemplate>
            <EditItemTemplate>
                <tr style="background-color:#008A8C;color: #FFFFFF;">
                    <td>
                        <asp:Button ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
                        <asp:Button ID="CancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
                    </td>
                    <%--<td>
                        <asp:TextBox ID="MakeNameTextBox" runat="server" Text='<%# Bind("MakeName") %>' />
                    </td>
                    <td>
                        <asp:TextBox ID="EquipmentTypeNameTextBox" runat="server" Text='<%# Bind("EquipmentTypeName") %>' />
                    </td>--%>
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
                    <%--<td>
                        <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="EquipmentTypeNameLabel" runat="server" Text='<%# Eval("EquipmentTypeName") %>' />
                    </td>--%>
                    <td colspan="2" rowspan="4">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:100%;max-height: 200px;max-width: 300px;" />
                    </td>
                    <td colspan="3" style="font-weight:bold;font-size:120%;">
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' />
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td colspan="3">
                        <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                    </td>
                </tr>
                <tr class="partsInfoAlt" />
                    <td colspan="3">
                        <asp:Label ID="CategoryNameLabel" runat="server" Text='<%# Eval("CategoryName") %>' />
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td colspan="3">
                        <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                    </td>
                   <%-- <td>
                        <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                    </td>
                    <td>
                        <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                    </td>
                    <td>
                        <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                    </td>--%>
                </tr>
            </ItemTemplate>
            <LayoutTemplate>
                <table runat="server" class="partsinfoClass">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" class="partsinfoClass" style="padding-top: 25px;">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                    <%--<th runat="server">MakeName</th>
                                    <th runat="server">EquipmentTypeName</th>--%>
                                    <%--<th runat="server"  colspan="2"></th>
                                    <th runat="server">Part Category</th>
                                    <th runat="server">Model</th>
                                    <th runat="server">Year</th>
                                    <th runat="server">Manufacturer</th>
                                    <th runat="server">Part #</th>
                                    <th runat="server">Part Description</th>
                                    <th runat="server">Price (CAD)</th>--%>
                                </tr>
                                <tr id="itemPlaceholder" runat="server" >
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
            <%--<AlternatingItemTemplate>
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
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
                    </td> 
                </tr>
            </AlternatingItemTemplate>--%>
            <AlternatingItemTemplate>
                <tr class="partsInfoAlt">
                    <td colspan="2" rowspan="5">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:100%;max-height: 200px;max-width: 300px;" />
                    </td>
                    <td colspan="3" style="font-weight:bold;font-size:120%;">
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' style="padding:5%;"/>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label Text="PART #:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                        </div>
                    </td>
                    <td>
                    </td>
                    <td colspan="1">
                        <div class="cardLabel">
                            <asp:Label Text="YEAR:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PART MANUFACTURER:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                        </div>
                    </td>
                    <td>

                    </td>
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MAKE:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>

                    </td>
                    <td>
                        
                    </td>
                    <td >
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MODEL:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PRICE(CAD):"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                        </div>
                    </td>
                    <td colspan="2"></td>
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
            <%--<ItemTemplate>
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
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:300px;" />
                    </td>
                </tr>
            </ItemTemplate>--%>
            <ItemTemplate>
                 <tr class="partsInfoAlt">
                    <td colspan="2" rowspan="5">
                        <asp:Image ID="ImageFilePathImage" runat="server" src='<%# Eval("ImageFilePath") %>' Style="width:100%;max-height: 200px;max-width: 300px;" />
                    </td>
                    <td colspan="3" style="font-weight:bold;font-size:120%;">
                        <asp:Label ID="PartDescLabel" runat="server" Text='<%# Eval("PartDesc") %>' style="padding:5%;"/>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label Text="PART #:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PartNumberLabel" runat="server" Text='<%# Eval("PartNumber") %>' />
                        </div>
                    </td>
                    <td>
                    </td>
                    <td colspan="1">
                        <div class="cardLabel">
                            <asp:Label Text="YEAR:" runat="server"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="YearIDLabel" runat="server" Text='<%# Eval("YearID") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PART MANUFACTURER:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ManufacturerNameLabel" runat="server" Text='<%# Eval("ManufacturerName") %>' />
                        </div>
                    </td>
                    <td>

                    </td>
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MAKE:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="MakeNameLabel" runat="server" Text='<%# Eval("MakeName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>

                    </td>
                    <td>
                        
                    </td>
                    <td >
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="MODEL:"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="ModelNameLabel" runat="server" Text='<%# Eval("ModelName") %>' />
                        </div>
                    </td>
                </tr>
                <tr class="partsInfoAlt">
                    <td>
                        <div class="cardLabel">
                            <asp:Label runat="server" Text="PRICE(CAD):"></asp:Label>
                        </div>
                        <div class="cardLabel">
                            <asp:Label ID="PriceLabel" runat="server" Text='<%# Eval("Price", "{0:$0.00}") %>' />
                        </div>
                    </td>
                    <td colspan="2"></td>
                </tr>
            </ItemTemplate>
            <%--<LayoutTemplate>
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
            </LayoutTemplate>--%>
            <LayoutTemplate>
                <table runat="server" class="partsinfoClass" style="border-spacing: 10px;border-collapse: separate;">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" class="partsinfoClass" style="padding-top: 25px;">
                                <tr runat="server" style="background-color:#DCDCDC;color: #000000;">
                                </tr>
                                <tr id="itemPlaceholder" runat="server" style="border: solid black;">
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
