<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

    request.setCharacterEncoding("utf-8");
    String userEmail = request.getParameter("userEmail");  

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
    String A = "select b.boardNo, u.useremail, u.userNickname, b.boardTitle, b.boardContent, b.boardImg, b.boardInsertDate ";
    String B = "from register r left outer join userinfo u on u.userEmail = r.userinfo_userEmail ";
    String C = "left outer join board b on b.boardNo = r.board_boardNo where b.boardDeleteDate is null and r.userinfo_userEmail = ? order by b.boardInsertDate desc";
    int count = 0;
    PreparedStatement ps = null;
    ResultSet rs =null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(A+B+C);
        ps.setString(1, userEmail);
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
            "boardNo" : "<%=rs.getString(1) %>",
            "userEmail" : "<%=rs.getString(2) %>",
            "userNickname" : "<%=rs.getString(3) %>",
            "boardTitle" : "<%=rs.getString(4) %>",
            "boardContent" : "<%=rs.getString(5) %>",
            "boardImg" : "<%=rs.getString(6) %>",
            "boardInsertDate" : "<%=rs.getString(7) %>"
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
