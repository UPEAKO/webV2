<%@ page import="java.nio.charset.StandardCharsets" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
		session.invalidate();
		response.sendRedirect("/editor");
%>

	 

