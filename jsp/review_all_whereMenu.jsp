<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

    request.setCharacterEncoding("utf-8");
    String menuNo = request.getParameter("menuNo");   

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String A = "select r.reviewNo, r.menu_menuNo, u.userNickname, r.reviewContent, r.reviewImg, r.reviewStar, r.reviewInsertDate ";
    String B = "from review r, userinfo u where u.userEmail = r.userinfo_userEmail and r.menu_menuNo = ? order by r.reviewInsertDate desc";
    int count = 0;
    PreparedStatement ps = null;
    ResultSet rs =null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(A+B);
        ps.setString(1, menuNo);
        rs = ps.executeQuery(); // &quot; 
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
			"reviewNo" : "<%=rs.getString(1) %>",
            "menuNo" : "<%=rs.getString(2) %>",
			"userNickname" : "<%=rs.getString(3) %>",
            "reviewContent" : "<%=rs.getString(4) %>",
            "reviewImg" : "<%=rs.getString(5) %>",
            "reviewStar" : "<%=rs.getString(6) %>",
            "reviewInsertDate" : "<%=rs.getString(7) %>"	
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
