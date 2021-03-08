<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("utf-8");
    	String menuCategory = request.getParameter("menuCategory");
	

	String url_mysql = "jdbc:mysql://localhost/moca?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";
   	
    int count = 0;

    
 try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn_mysql = DriverManager.getConnection(url_mysql, id_mysql, pw_mysql);
        Statement stmt_mysql = conn_mysql.createStatement();

        String query = "select m.menuNo menuNo, m.menuName menuName, h.brand_brandNo brandNo, b.brandName brandName, m.menuPrice menuPrice, round(avg(r.reviewStar),1) reviewAvg, m.menuInformation menuInformation, m.menuCalorie menuCalorie, m.menuImg menuImg";
        String query2 = " from brand b, have h, menu m LEFT OUTER JOIN review r on r.menu_menuNo = m.menuNo where h.brand_brandNo = b.brandNo and h.menu_menuNo = m.menuNo and  m.menuCategory like '%" + menuCategory + "%' group by m.menuNo, h.brand_brandNo order by reviewAvg desc";
	
        ResultSet rs = stmt_mysql.executeQuery(query + query2); // &quot;
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
	            "reviewAvg" : "<%=rs.getString(6) %>",	
                "menuInformation" : "<%=rs.getString(7) %>",
	            "menuCalorie" : "<%=rs.getString(8) %>",
		        "menuImg" : "<%=rs.getString(9) %>"			
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



