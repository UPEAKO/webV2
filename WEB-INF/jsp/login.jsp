<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="ubd.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
//judge passwd
	String user = new String(request.getParameter("user").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
	String passwd = new String(request.getParameter("passwd").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
	if (user != null && passwd != null && user.equals("wp") && passwd.equals(DbTool.getPasswd())) {
		//while login and get seseion
		String loginSign = new String("loginSign");
		if (session.isNew()) {
			session.setAttribute(loginSign,new Integer(1));
		}
		response.sendRedirect("home");
		return;
	} else {
		session.invalidate();
		response.sendRedirect("/editor");
		return;
	}
%>