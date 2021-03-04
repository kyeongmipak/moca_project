<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");

	String email = request.getParameter("email");
	String menuNo = request.getParameter("menuNo");
	String content = request.getParameter("reviewContent");
	String star = request.getParameter("reviewStar");
		
//------
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "INSERT INTO review (userinfo_userEmail, menu_menuNo, reviewContent, reviewStar, reviewInsertDate";
	    String B = ") values (?,?,?,?,now())";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, email);
		ps.setString(2, menuNo);
		ps.setString(3, content);
		ps.setString(4, star);
	    
	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
	}

%>

