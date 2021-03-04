<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
 pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@page import="java.sql.*"%>

<%

	request.setCharacterEncoding("utf-8");
	String boardTitle = request.getParameter("boardTitle");
	String boardContent = request.getParameter("boardContent");

	//------
	String savePath = "/usr/local/apache-tomcat-8.5.46/webapps/ROOT/moca/image";
	int sizeLimit = 10 * 1024 * 1024;
	
	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit, new DefaultFileRenamePolicy());

	File file = multi.getFile("file");
	String name = multi.getParameter("name");
	
	// DB
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "INSERT INTO board (boardTitle, boardContent, boardImg, boardInsertDate) ";
	    String B = "VALUES(?, ?, ?, now())";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, boardTitle);
		ps.setString(2, boardContent);
		ps.setString(3, file.getName());

	    ps.executeUpdate();
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
    }
    
%>