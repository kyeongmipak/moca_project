<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%

    request.setCharacterEncoding("utf-8");
	String email = request.getParameter("email");

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=UTC&characterEncoding=utf8&useSSL=FALSE";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

    String A = "select r.reviewNo, r.menu_menuNo, u.userNickname, r.reviewContent, r.reviewImg, r.reviewStar, date_format(r.reviewInsertDate, '%Y-%m-%d'), ";
    String B = "m.menuName, h.brand_brandNo, b.brandName, m.menuPrice, m.menuImg, m.menuInformation, m.menuCalorie ";
    String C = "from menu m, review r, brand b, have h, userinfo u where u.userEmail = r.userinfo_userEmail and u.userEmail = ? and r.menu_menuNo = m.menuNo ";
    String D = "and h.menu_menuNo = m.menuNo and h.brand_brandNo = b.brandNo order by r.reviewInsertDate desc";
    
    int count = 0;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        ps = conn_mysql.prepareStatement(A + B + C + D);
        ps.setString(1, email);
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
                "reviewInsertDate" : "<%=rs.getString(7) %>",
                "menuName" : "<%=rs.getString(8) %>",
                "brandNo" : "<%=rs.getString(9) %>",
                "brandName" : "<%=rs.getString(10) %>",
                "menuPrice" : "<%=rs.getString(11) %>",
                "menuImg" : "<%=rs.getString(12) %>",
                "menuInformation" : "<%=rs.getString(13) %>",
                "menuCalorie" : "<%=rs.getString(14) %>"
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
