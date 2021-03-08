<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    
    String userInformationEmail = request.getParameter("userInformationEmail");
    String userInformationName = request.getParameter("userInformationName");
    String userInformationPhone = request.getParameter("userInformationPhone");
    int count = 0;
    
    PreparedStatement ps = null;
    ResultSet rs =null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();
        String WhereDefault = "select userPw from userInfo where userEmail = ? and userName = ? and userPhone = ?";
        ps = conn_mysql.prepareStatement(WhereDefault);
        ps.setString(1, userInformationEmail);
		ps.setString(2, userInformationName);
        ps.setString(2, userInformationPhone);
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
                    "result" : "<%=rs.getString("userPw")%>"
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
