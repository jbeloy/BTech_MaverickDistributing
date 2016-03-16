<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BTech_MaverickDistributing._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script>
        
        function setSearch(item)
        {
            Session("search") = item;
        }

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


    <style>

        * {
  box-sizing: border-box;
}

body {
  padding: 1em;
}

small {
  font-size: 12px;
  color: #999;
}

.drilldown {
  font-size: 0px;
}

.drilldown > * {
  font-size: 14px;
}

.drilldown ul {
  display: block;
  list-style: inside none;
  padding-left: 1em;
}

.drilldown .drilldown__options-container,
.drilldown .drilldown__selected-container {
  display: inline-block;
  vertical-align: top;
}

.drilldown .drilldown__options-container {
  width: 50%;
}

.drilldown .drilldown__options-container > ul {
  margin-top: 0;
  padding: 0;
}

.drilldown .drilldown__selected-container {
  width: 47.5%;
  margin-left: 2.5%;
}

.drilldown .drilldown__selected-container .drilldown__selected {
  min-height: 5em;
  border: 1px solid #CCC;
  background-color: #EEE;
}

.drilldown .drilldown__selected-container .drilldown__selected p {
  margin: 0.25em;
  padding: 0.5em;
  display: block;
  cursor: pointer;
  border: 1px solid #CCC;
  border-radius: 0.25em;
  background-color: #FFF;
}

.drilldown .drilldown__selected-container .drilldown__selected p:after {
  content: "X";
  display: inline-block;
  padding: 0 0.25em;
  float: right;
}

.drilldown .drilldown__selected-container .drilldown__selected p:hover {
  background-color: #FFE;
}

.drilldown li {
  margin: 0.25em 0;
}

.drilldown li label {
  position: absolute;
  top: 0;
  right: 0;
  height: 100%;
  width: 3em;
  background-color: #CCC;
  display: block;
  text-align: center;
  border-left: 1px solid #CCC;
  border-radius: 0 0.25em 0.25em 0;
  box-shadow: inset 0 1px 3px #999;
}

.drilldown li input[type=checkbox] {
  vertical-align: middle;
  height: 100%;
  display: inline-block;
}

.drilldown li > div {
  position: relative;
  padding: 0.5em 0 0.5em 1em;
  background-color: #FFF;
  border: 1px solid #CCC;
  border-radius: 0.25em;
  cursor: pointer;
  transition: all 0.2s;
}

.drilldown li > div.active {
  background-color: #FFC;
}

.drilldown li > div.active + ul div:not(.selected) {
  background-color: #FFE;
}

.drilldown li > div.selected {
  background-color: #EFF;
}

.drilldown li > ul {
  display: none;
}

.drilldown__input {
  width: 100%;
}


    </style>

    <!--SQL Data source for the listview-->
    <asp:SqlDataSource ID="SQL_PartsInfo" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="GetPartsInfo" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_EquipmentType" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [EquipmentTypeName] FROM [EquipmentType] ORDER BY [EquipmentTypeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_Make" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="SELECT [MakeName] FROM [Make] ORDER BY [MakeName]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SQL_Year" runat="server" ConnectionString="<%$ ConnectionStrings:md_dbConnectionString %>" SelectCommand="GetYear" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:CookieParameter CookieName="make" Name="Make" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="jumbotron">
        <h1>Car Part Selector Thingy Webstie</h1>
        <p class="lead">ASP.NET is a free web framework for building great Web sites and Web applications using HTML, CSS, and JavaScript.</p>
        <p><a href="http://www.asp.net" class="btn btn-primary btn-lg">Learn more &raquo;</a></p>
    </div>



    <h1>Drill-down select</h1>

<div id="drilldown1" class="drilldown">
  <div class="drilldown__options-container">
    <p>Click to expand the options:</p>
    <ul id="equipmentType" runat="server">

        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SQL_EquipmentType">
            <HeaderTemplate><ul></HeaderTemplate>
            <ItemTemplate>
                <li><div id="et_<%# Eval("EquipmentTypeName") %>"><%# Eval("EquipmentTypeName") %><label><input type="checkbox"></label></div><ul runat="server">
                    <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SQL_Make" OnItemDataBound="Repeater2_ItemDataBound">
                        <ItemTemplate>
                            <li><div id="mk_<%# Eval("MakeName") %>"><%# Eval("MakeName") %><label><input type="checkbox" onclick="setSearch('<%# Eval("MakeName").ToString() %>')"></label></div><ul runat="server">
                                <asp:Repeater ID="Repeater3" runat="server" DataSourceID="SQL_Year">
                                    <ItemTemplate>
                                        <li><div id="year_<%# Eval("YearID") %>"><%# Eval("YearID") %><label><input type="checkbox" onclick="setSearch('<%# Eval("YearID").ToString() %>')"></label></div><ul runat="server">
                            
                                        </ul></li></ItemTemplate>
                                </asp:Repeater>
                            </ul></li></ItemTemplate>
                    </asp:Repeater>
                </ul></li></ItemTemplate>
            <FooterTemplate></ul></FooterTemplate>
        </asp:Repeater>
      
    </ul>
  </div>
  <div class="drilldown__selected-container">
    <p>Selected items:</p>
    <div id="drilldown1Selected" class="drilldown__selected"></div>
    <p><small>To remove selected items click them above.</small></p>
  </div>
</div>
<input type="text" id="drilldownInput" class="drilldown__input" value="" style="display: none;">



    <ul runat="server" id="tabs"> 
    </ul> 

    <div class="row">
        <asp:ListView ID="LV_PartsInfo" runat="server" DataSourceID="SQL_PartsInfo">
            <AlternatingItemTemplate>
                <tr style="background-color:#FFF8DC;">
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
                <tr style="background-color:#DCDCDC;color: #000000;">
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
                <table runat="server">
                    <tr runat="server">
                        <td runat="server">
                            <table id="itemPlaceholderContainer" runat="server" border="1" style="background-color: #FFFFFF;border-collapse: collapse;border-color: #999999;border-style:none;border-width:1px;font-family: Verdana, Arial, Helvetica, sans-serif;">
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
