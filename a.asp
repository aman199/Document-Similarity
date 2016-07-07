<%@ Page Language=VB Debug=true %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OLEDB" %>
<script runat=server>
Sub Page_Load(ByVal Sender as Object, ByVal E as EventArgs)
    If Not IsPostBack Then
        Dim DBConn as OleDbConnection
        Dim DBCommand As OleDbDataAdapter
        Dim DSPageData as New DataSet
        DBConn = New OleDbConnection( _
            "PROVIDER=Microsoft.Jet.OLEDB.4.0;" _
            & "DATA SOURCE=" _
            & Server.MapPath("EmployeeDatabase.mdb;"))
        DBCommand = New OleDbDataAdapter _
            ("Select * " _
            & "From Employee " _
            & "Order By LastName, FirstName", DBConn)
        DBCommand.Fill(DSPageData, _
            "Employee")
        dgEmps.DataSource = _
            DSPageData.Tables("Employee").DefaultView
        dgEmps.DataBind()
    End If
End Sub
</SCRIPT>
<HTML>
<HEAD>
<TITLE>Creating Bound Columns in a DataGrid Control</TITLE>
</HEAD>
<Body LEFTMARGIN="40">
<form runat="server">
<BR><BR>
<asp:Label 
    id="lblMessage" 
    Font-Size="12pt"
    Font-Bold="True"
    Font-Name="Lucida Console"
    text="Employee List"
    runat="server"
/>
<BR><BR>
<asp:datagrid
    id="dgEmps" 
    runat="server" 
    autogeneratecolumns="false"
>
    <columns>
        <asp:boundcolumn 
            HeaderText="Last Name" 
            DataField="LastName"
        />
        <asp:boundcolumn 
            HeaderText="First Name" 
            DataField="FirstName"
        />
        <asp:boundcolumn 
            HeaderText="ID" 
            DataField="ID"
            DataFormatString="{0:d}"
        />
    </columns>
</asp:datagrid>
</form>
</BODY>
</HTML>
