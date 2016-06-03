<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="BTech_MaverickDistributing.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>

    <link rel="stylesheet" href="Content/loginStyles.css" type="text/css" />
</head>

<body>
    <form id="form1" runat="server">
    <div>
    
        <div class="login">
  
          <h2 class="login-header">Log in</h2>

          <div class="login-container">
            <p><input type="email" placeholder="Email"/></p>
            <p><input type="password" placeholder="Password"/></p>
            <p><input type="submit" value="Log in"/></p>
          </div>
        </div>

    </div>
    </form>
</body>
</html>
