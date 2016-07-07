<%@ Page Language=VB Debug=true %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SQLClient" %>
<script runat=server>
Sub Page_Load(ByVal Sender as Object, ByVal E as EventArgs)
    If Not IsPostBack Then
        Dim DBConn as SQLConnection
        Dim DBCommand As SQLDataAdapter
        Dim DSPageData as New DataSet
'        DBConn = New SQLConnection("server=localhost;" _
 '           & "Initial Catalog=TT;" _
  '          & "User Id=sa;" _
   '         & "Password=yourpassword;")
        DBConn = New SQLConnection("Data Source=whsql-v08.prod.mesa1.secureserver.net;Initial Catalog=DB_49907;User ID=java2suser;Password='password';")
        DBCommand = New SQLDataAdapter _
            ("Select LastName + ', ' + FirstName " _
            & "as EmpName, ID " _
            & "From Employee " _
            & "Order By LastName, FirstName", DBConn)
        DBCommand.Fill(DSPageData, _
            "Employees")
        ddlEmps.DataSource = _
            DSPageData.Tables("Employees").DefaultView
        ddlEmps.DataBind()
    End If
End Sub
Sub SubmitBtn_Click(Sender As Object, E As EventArgs)
    Dim DBConn as SQLConnection
    Dim DBDelete As New SQLCommand
'        DBConn = New SQLConnection("server=localhost;" _
 '           & "Initial Catalog=TT;" _
  '          & "User Id=sa;" _
   '         & "Password=yourpassword;")
    DBConn = New SQLConnection("Data Source=whsql-v08.prod.mesa1.secureserver.net;Initial Catalog=DB_49907;User ID=java2suser;Password='password';")
    DBDelete.CommandText = "Delete From Employee " _
        & "Where ID = " & ddlEmps.SelectedItem.Value
    DBDelete.Connection = DBConn
    DBDelete.Connection.Open
    DBDelete.ExecuteNonQuery()
End Sub
</SCRIPT>
<HTML>
<HEAD>
<TITLE>Deleting SQL Server Data</TITLE>
</HEAD>
<Body LEFTMARGIN="40">
<form runat="server">
Select the Employee to Delete
<BR><BR>
<asp:dropdownlist
    id="ddlEmps"
    datatextfield="EmpName" 
    datavaluefield="ID"
    runat="server"
/>
<BR><BR>

<asp:button 
    id="butDelete"
    text="Delete"
    onclick="SubmitBtn_Click" 
    runat="server"
/>  
</form>
</BODY>
</HTML>
