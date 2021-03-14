<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");
    String search = request.getParameter("search");

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

     String WhereDefault = "select distinct(m.menuNo) menuNo, m.menuName menuName, h.brand_brandNo brandNo, b.brandName brandName, m.menuPrice menuPrice, m.menuImg menuImg, m.menuInformation menuInformation, m.menuCalorie menuCalorie from menu m LEFT OUTER JOIN review r on r.menu_menuNo = m.menuNo, brand b, have h ";
     String WhereDefault2 = "where h.menu_menuNo = m.menuNo and h.brand_brandNo = b.brandNo order by b.brandName";

    int count = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();
        
        ResultSet rs = stmt_mysql.executeQuery(WhereDefault+WhereDefault2); // &quot;
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
                "menuNo" : "<%=rs.getString(1) %>", 
                "menuName" : "<%=rs.getString(2) %>",
                "brandNo" : "<%=rs.getString(3) %>", 
                "brandName" : "<%=rs.getString(4) %>",  
                "menuPrice" : "<%=rs.getString(5) %>",
	            "menuImg" : "<%=rs.getString(6) %>",
		"menuInformation" : "<%=rs.getString(7) %>",
	            "menuCalorie" : "<%=rs.getString(8) %>"		
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



