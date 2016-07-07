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
            ("Select LastName & ', ' & FirstName " _
            & "as EmpName, ID " _
            & "From Employee " _
            & "Order By LastName, FirstName", DBConn)
        DBCommand.Fill(DSPageData, _
            "Employee")
        ddlEmps.DataSource = _
            DSPageData.Tables("Employee").DefaultView
        ddlEmps.DataBind()
    End If
End Sub
Sub SubmitBtn_Click(Sender As Object, E As EventArgs)
    Dim DBConn as OleDbConnection
    Dim DBUpdate As New OleDbCommand
    DBConn = New OleDbConnection( _
        "PROVIDER=Microsoft.Jet.OLEDB.4.0;" _
        & "DATA SOURCE=" _
        & Server.MapPath("EmployeeDatabase.mdb;"))
    DBUpdate.CommandText = "Update Employee Set " _
        & "FirstName = '" & txtFirstName.Text & "' Where " _
        & "ID = " & ddlEmps.SelectedItem.Value
        
    DBUpdate.Connection = DBConn
    DBUpdate.Connection.Open
    DBUpdate.ExecuteNonQuery()
End Sub
</SCRIPT>
<HTML>
<HEAD>
<TITLE>Updating Access Data</TITLE>
</HEAD>
<Body LEFTMARGIN="40">
<form runat="server">
Select the Employee to Update
<BR><BR>
<asp:dropdownlist
    id="ddlEmps"
    datatextfield="EmpName" 
    datavaluefield="ID"
    runat="server"
/>
<BR><BR>
New First Name:
<BR>
<asp:textbox
    id="txtFirstName"
    runat="Server"
/>
<BR><BR>
<asp:button 
    id="butOK"
    text="  OK  "
    onclick="SubmitBtn_Click" 
    runat="server"
/>  
</form>
</BODY>
</HTML>
