<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>        
<%
	request.setCharacterEncoding("utf-8");
	String userInformationEmail = request.getParameter("userInformationEmail");
	String userInformationPassword = request.getParameter("userInformationPassword");
	String userInformationName = request.getParameter("userInformationName");
	String userInformationPhone = request.getParameter("userInformationPhone");	
		
//------
	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
	String id_mysql = "root";
	String pw_mysql = "qwer1234";

	int result = 0; // 입력 확인 

	PreparedStatement ps = null;
	try{
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection conn_mysql = DriverManager.getConnection(url_mysql,id_mysql,pw_mysql);
	    Statement stmt_mysql = conn_mysql.createStatement();
	
	    String A = "insert into userInfo (userEmail, userPw, userName, userPhone, ";
	    String B = "userInsertDate) values (?,?,?,?,now())";
	
	    ps = conn_mysql.prepareStatement(A+B);
	    ps.setString(1, userInformationEmail);
	    ps.setString(2, userInformationPassword);
	    ps.setString(3, userInformationName);
	    ps.setString(4, userInformationPhone);
	    
	    result = ps.executeUpdate();
%>[
		{
			"result" : <%=result%>
		}
]
<%
	
	    conn_mysql.close();
	} 
	
	catch (Exception e){
	    e.printStackTrace();
%>[
		{
			"result" : <%=result%>
		}
	]
<%	
	}

%>

