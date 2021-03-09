<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	String userPw = request.getParameter("userPw");
	String userNickname = request.getParameter("userNickname");
	String userPhone = request.getParameter("userPhone");
	String userImg = request.getParameter("userImg");
	String userEmail = request.getParameter("userEmail");
	String userName = request.getParameter("userName");


//------
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

	int count = 0;
    
    PreparedStatement ps = null;
    ResultSet rs =null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        String WhereDefault = "insert into userInfo (userPw, userNickname, userPhone, userImg, userEmail, userName, userInsertDate) values (?, ?, ?, ?, ?, ?, now())";

        ps = conn_mysql.prepareStatement(WhereDefault); // 

        ps.setString(1, userPw);
		ps.setString(2, userNickname);
		ps.setString(3, userPhone);
		ps.setString(4, userImg);
		ps.setString(5, userEmail);
		ps.setString(6, userName);

	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
    }
    
%>