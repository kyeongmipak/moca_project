<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";


	String userInfo_userEmail = request.getParameter("userInfo_userEmail");
	String menu_menuNo = request.getParameter("menu_menuNo");

    String WhereDefault = "select count(*) from moca.like where userInfo_userEmail = ? and menu_menuNo = ? ";
    int count = 0;

	PreparedStatement ps = null;
	ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(WhereDefault);
	ps.setString(1, userInfo_userEmail);
	ps.setString(2, menu_menuNo);
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
			"result" : <%=rs.getString(1) %>
			
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
