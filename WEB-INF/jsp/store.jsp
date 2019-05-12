<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.sql.*" %>
<%@ page import="ubd.*" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
	Integer loginSign = (Integer)session.getAttribute("loginSign");
	if (loginSign == null || !loginSign.equals(new Integer(1))) {
		out.println("please login in!");
		session.invalidate();
		return;
	}
	else {
		//content-editormd-html-code
		String signForDeal = new String(request.getParameter("signForDeal").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
		String id = new String(request.getParameter("id").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
		String note_content,note_title,category;
		if (signForDeal.equals("changeNote")) {
			note_content = new String(request.getParameter("content").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
			note_title = new String(request.getParameter("title").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
			category = new String(request.getParameter("category").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
		}
		else {
			note_content = "delete_content";
			note_title = "delete_title";
			category = "delete_category";
		}
		
		if (id == null) {
			id = "-1";
		}
		//add
		if(Integer.valueOf(id) < 0) {
			if (DbTool.add(note_title,note_content,category))
				out.println("note add successfully");
			else
				out.println("note add fail!");
			}
		//change
		else {
			if (DbTool.change(Integer.valueOf(id),note_title,note_content,category,signForDeal)) {
				if (signForDeal.equals("changeNote"))
					out.println("note update successfully!");
				else
					out.println("note delete successfully!");
			}
			else {
				out.println("note update fail!");
			}
		}
	}
%>
