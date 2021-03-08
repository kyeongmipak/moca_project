<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("utf-8");
//    String search = request.getParameter("search");
    String menuNo = request.getParameter("menuNo");  

	String url_mysql = "jdbc:mysql://localhost/MOCA?serverTimezone=Asia/Seoul&characterEncoding=utf8&useSSL=false";
 	String id_mysql = "root";
 	String pw_mysql = "qwer1234";

     String A = "select r.menu_menuNo menuNo, m.menuName menuName, h.brand_brandNo brandNo, b.brandName brandName, m.menuPrice menuPrice, m.menuImg menuImg, m.menuInformation menuInformation, m.menuCalorie menuCalorie from menu m, review r, brand b, have h ";
     String B = "where r.menu_menuNo = m.menuNo and h.menu_menuNo = m.menuNo and h.brand_brandNo = b.brandNo and m.menuNo = ? order by b.brandName";

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



