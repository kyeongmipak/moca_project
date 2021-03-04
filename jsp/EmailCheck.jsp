<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String userInformationEmail = request.getParameter("userInformationEmail");
    int count = 0;
    
    PreparedStatement ps = null;
    ResultSet rs =null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();
        String WhereDefault = "select count(*) count from userInfo where userEmail = ?";
        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setString(1, userInformationEmail);
		
        rs = ps.executeQuery();
        %>
        [ 
  <%
          while (rs.next()) {
              if (count == 0) {
  
              }else{
  %>
              , 
  <%           
              }
              count++;                 
  %>
              {
                    "result" : <%=rs.getString("count")%>
              }
<%		
}
%>
  ]
<%		
        conn_mysql.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
	
%>
