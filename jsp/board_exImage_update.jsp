<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
request.setCharacterEncoding("utf-8");

	String boardNo = request.getParameter("boardNo");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");
	String boardImg = request.getParameter("boardImg");
		
//------
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
		String A = "update board set boardTitle = ?, boardContent = ?, boardImg = ? ";
		String B = "where boardNo = ?";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, boardTitle);
		ps.setString(2, boardContent);
		ps.setString(3, boardImg);
		ps.setString(4, boardNo);
	    
	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
	}

%>

