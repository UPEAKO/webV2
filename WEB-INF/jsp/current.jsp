<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="ubd.*" %>
<%@ page import="java.util.ArrayList" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
						Integer loginSign1 = (Integer)session.getAttribute("loginSign");
						if (loginSign1 == null || !loginSign1.equals(new Integer(1))) {
							out.println("<div id=\"content-editormd\"><textarea style=\"display:none;\">not login</textarea></div>");
							session.invalidate();
							return;
						} 
						String id = new String(request.getParameter("id").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
						ArrayList<String> result = DbTool.getEach(Integer.valueOf(id));
						String title,content;
						if (result.size() == 4) {
							title = result.get(1);
							content = result.get(2);
						} else {
							out.println("<div id=\"content-editormd\"><textarea style=\"display:none;\">error</textarea></div>");
							return;
						}
%>

<div id="content-editormd">
	<center>
		<h2>
		<% out.println(title); %>
		</h2>
	</center>
	<textarea style="display:none;">
<% out.println(content); %>
	</textarea>
</div>
<div class="clr"></div>