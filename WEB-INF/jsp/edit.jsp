<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="ubd.*" %>
<%@ page import="java.util.ArrayList" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
			Integer loginSign = (Integer)session.getAttribute("loginSign");
			if (loginSign == null || !loginSign.equals(new Integer(1))) {
				session.invalidate();
				response.sendRedirect("/editor");
				return;
			}
%>

<!DOCTYPE html>
<html>
  <head>
    <title>Edit</title>
	<link rel="shortcut icon" href="/favicon.ico" />
	<link rel="bookmark" href="/favicon.ico" type="image/x-icon"　/>
    <link rel="stylesheet" href="css/editormd.min.css"/>
	<style type="text/css">
	a.button:link, a.button:visited {
    display: inline-block;
    color: #FFF;
    background-color: #8ac007;
    font-weight: 700;
    font-size: 12px;
    text-align: center;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 3px;
    padding-bottom: 4px;
    text-decoration: none;
    margin-left: 5px;
    margin-top: 0;
    margin-bottom: 5px;
    border: 1px solid #aaa;
    border-radius: 5px;
    white-space: nowrap;
	}
	.myinput {
	padding:0 1em;
	text-align:center;
	height:1.7em;
	border-radius:10px;
	</style>
    <script src="js/jquery.min.js"></script>
    <script src="js/editormd.min.js"></script>
	<script src="lib/marked.min.js"></script>
	<script src="lib/prettify.min.js"></script>
	<script src="lib/raphael.min.js"></script>
	<script src="lib/underscore.min.js"></script>
	<script src="lib/sequence-diagram.min.js"></script>
	<script src="lib/flowchart.min.js"></script>
	<script src="lib/jquery.flowchart.min.js"></script>
    <script type="text/javascript">
        $(function() {
            editormd("content-editormd", {
                width   : "100%",
                height  : 1000,
                syncScrolling : "single",
                path    : "lib/",
                saveHTMLToTextarea : false,//true则自动生成另一个textarea保存html的内容，则在同一个form中都会上传到后台
				imageUpload : true,
				imageFormats: ["jpg","jpeg","gif","png","bmp","webp"],
				imageUploadURL: "image",
				htmlDecode: "style,script,iframe", //可以过滤标签解码
				emoji: true,
				taskList: true,
				tex: true,               // 默认不解析
				flowChart: true,         // 默认不解析
				sequenceDiagram: true, // 默认不解析
				codeFold: true
            });
        });
    </script>
<script type="text/javascript">
function store()
{
	var content = document.getElementById("content-editormd-markdown-doc").value;
	//var content = $('#content-editormd-markdown-doc').val(),
	var id = document.getElementById("id").value;
	var title = document.getElementById("title").value;
	var category = document.getElementById("category").value;
	
	var xmlhttp;
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			alert(xmlhttp.responseText);
		}
	}
	xmlhttp.open("POST","store",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("id=" + encodeURIComponent(id) + "&category=" + encodeURIComponent(category) + "&title=" + encodeURIComponent(title) + "&content=" + encodeURIComponent(content) + "&signForDeal=changeNote");
}
</script>
<script type="text/javascript">
function deleteNote()
{
	var id = document.getElementById("id").value;
	var xmlhttp;
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			alert(xmlhttp.responseText);
		}
	}
	xmlhttp.open("POST","store",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("id=" + encodeURIComponent(id) + "&signForDeal=deleteNote");
}
</script>
  </head>
  <body>
<%
	  out.println("<a href=\"home\"><button>home</button></a>");
	  
	  out.println("<button onclick=\"store()\">update</button>");
	  
	  String id = new String(request.getParameter("id").getBytes(StandardCharsets.ISO_8859_1), StandardCharsets.UTF_8);
	  if (id == null)
		  id = "-1";
	  ArrayList<String> result = new ArrayList<>();
	  if (Integer.valueOf(id) >= 8) {
		  result = DbTool.getEach(Integer.valueOf(id));
	  }
	  if (result.size() == 4) {
		  out.println("<input placeholder=\"title\" class=\"myinput\" type=\"text\" size=\"50\" id=\"title\" value=\"" + result.get(1) + "\">");
		  out.println("<input type=\"hidden\" id=\"id\" value=\"" + result.get(0) + "\">");
		  out.println("<input placeholder=\"category\" class=\"myinput\" type=\"text\" size=\"10\" id=\"category\" value=\"" + result.get(3) + "\">");
	  } else {
		  out.println("<input placeholder=\"new title\" class=\"myinput\" type=\"text\" size=\"50\" id=\"title\">");
		  out.println("<input type=\"hidden\" id=\"id\" value=\"-1\">");
		  out.println("<input placeholder=\"category\" class=\"myinput\" type=\"text\" size=\"10\" id=\"category\">");
	  }
	  out.println("<button onclick=\"deleteNote()\">delete</button>");
	  out.println("<a href=\"logout\"><button>logout</button></a>");
%>
<div id="content-editormd" class="form-group">
<textarea style="display:none;" class="form-control" id="content-editormd-markdown-doc" name="content-editormd-markdown-doc">
<%
	  if (result.size() == 4) {
		  out.print(result.get(2));
	  } 
%>
</textarea>
</div>
  </body>
</html>
