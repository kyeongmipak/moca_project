<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("utf-8");
	String userInfo_userEmail = request.getParameter("userEmail");

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String WhereDefault = "select l.userInfo_userEmail, l.menu_menuNo, m.menuName, m.menuPrice, m.menuImg, m.menuCalorie, m.menuInformation, m.menuCategory from menu m, moca.like l";
		String B = " where m.menuNo = l.menu_menuNo And l.userInfo_userEmail = '" + userInfo_userEmail + "'";
    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ResultSet rs = stmt_mysql.executeQuery(WhereDefault + B); // &quot;
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
			"userInfo_userEmail" : "<%=rs.getString(1) %>",
			"menu_menuNo" : <%=rs.getInt(2) %>,
			"menuName" : "<%=rs.getString(3) %>",   
			"menuPrice" : "<%=rs.getString(4) %>", 
			"menuImg" : "<%=rs.getString(5) %>",
			"menuCalorie" : "<%=rs.getString(6) %>",
			"menuInformation" : "<%=rs.getString(7) %>",
			"menuCategory" : "<%=rs.getString(8) %>"
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
