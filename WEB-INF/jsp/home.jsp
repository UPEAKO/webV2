<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="ubd.*" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.Date" %>

<% 
Integer loginSign1 = (Integer)session.getAttribute("loginSign");
if (loginSign1 == null || !loginSign1.equals(new Integer(1))) {
	session.invalidate();
	response.sendRedirect("/editor");
	return;
} 
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="shortcut icon" href="/favicon.ico" />
<link rel="bookmark" href="/favicon.ico" type="image/x-icon"　/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>WP</title>
<link rel="stylesheet" type="text/css" href="css/style_sheet.css" media="screen" />
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
    $(function () {
        editormd.markdownToHTML("content-editormd", {
            htmlDecode: "style,script,iframe", //可以过滤标签解码
            emoji: true,
            taskList: true,
            tex: true,               // 默认不解析
            flowChart: true,         // 默认不解析
            sequenceDiagram: true, // 默认不解析
            codeFold: true
        });
    })
</script>
<script type="text/javascript">
function current(obj)
{
	var id = obj.id;
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
			document.getElementById("content_midd").innerHTML=xmlhttp.responseText;
			editormd.markdownToHTML("content-editormd", {
            htmlDecode: "style,script,iframe", //可以过滤标签解码
            emoji: true,
            taskList: true,
            tex: true,               // 默认不解析
            flowChart: true,         // 默认不解析
            sequenceDiagram: true, // 默认不解析
            codeFold: true
			});
			document.getElementById("edit").innerHTML = "<a href=\"edit?id=" + id + "\">edit</a>";
		}
	}
	xmlhttp.open("POST","current",true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("id=" + id);
}
</script>
</head>
<body>
	<div id="wrapper"><!--####  wrapper  ###-->
		<div id="header"><!--header--> 
			<div id="icon_area"><!--icon area-->
				<ul>
				<li><a href="#"><img src="images/facebook.png"  alt=""/></a></li>
				<li><a href="#"><img src="images/feed.png"  alt=""/></a></li>
				<li><a href="#"><img src="images/flickr.png"  alt=""/></a></li>
				<li><a href="#"><img src="images/stumbleupon.png"  alt=""/></a></li>
				<li><a href="#"><img src="images/twitter.png"  alt=""/></a></li>        
				</ul>
			</div><!--icon area-->
			<h1>WP</h1>
			<h6>UPEAKONE</h6>
		</div><!--header end-->
		<div id="middle-nav"><!--menu-->
			<div id="nav_top"><!--menu top--> 
				<ul>
					<li><a href="#">Home</a></li>
					<li><a href="https://music.itmxue.cn/" target="_blank">Music</a></li>
					<li><a href="http://192.168.1.1:8888" target="_blank">Video</a></li>
					<li><a href="edit?id=-1">Create</a></li>
<%
ArrayList<String> result = DbTool.getEach(Integer.valueOf(8));
LinkedHashMap<String, ArrayList<TitleID> > categoryTitles = new LinkedHashMap<>();
categoryTitles = DbTool.getHome();
String title = "title";
String content = "content";
if (result.size() == 4) {
	out.println("<li id=\"edit\"><a href=\"edit?id=" + result.get(0)+ "\">Edit</a></li>");
	title = result.get(1);
	content = result.get(2);
} else {
	out.println("<li id=\"edit\"><a href=\"edit?id=8\">Edit</a></li>");
	title = "Wrong!";
	content = "Wrong";
}
%>
					<li><a href="logout">Logout</a></li>
				</ul>
			</div><!--menu top end--> 
		</div><!--menu end-->
		<div id="banner"><!--banner-->
			<img src="images/header1.jpg" alt="" />
		</div><!--banner end-->
		<div id="content_wrapper"><!-- content wrapper-->
			<div id="content_laft"><!--content laft-->
<%

ArrayList<TitleID> titles;
if (!categoryTitles.isEmpty()) {
	for (String key : categoryTitles.keySet()) {
		titles = categoryTitles.get(key);
		out.println("<div class=\"box\">");
		out.println("<h2 class=\"box_h2\">" + key + "</h2>");
		out.println("<ul class=\"box_ul\">");
		for(TitleID titleId : titles) {
			out.println("<li class=\"box_ul_li\" id=\"" + titleId.getNoteId() + "\" onclick=\"current(this)\">"+ titleId.getNoteTitle() + "</li>");
		}
		out.println("</ul>");
		out.println("</div>");
	}
} else {
	out.println("getHome fail!");
}

%>
				<div class="clr"></div>
			</div><!--content laft end-->
			<div id="content_midd"><!--content midd-->
				<div id="content-editormd">
					<center>
						<h2>
<% 
out.println(title); 
%>
						</h2>
					</center>
					<textarea style="display:none;">
<% 
out.println(content);
%>
					</textarea>
				</div><!--content-editormd end-->
				<div class="clr"></div>
			</div><!--content midd end -->
		</div><!-- content wrapper end -->
		<div id="footer"><!--footer-->
			<div id="footer_nav">
				<ul>                   
					<li><a href="https://music.itmxue.cn/">Music</a></li>
					<li><a href="https://developer.android.com/">Android developer</a></li>
					<li><a href="https://dillinger.io/">Dillinger</a></li>
					<li><a href="https://cn.bing.com/">Bing</a></li>
					<li><a href="https://www.google.com">Google</a></li>                 
				</ul>
			</div>
			<div id="copyright">&copy; copyright 2019,
				<a href="http://wypmk.xyz">wypmk.xyz</a>
				<a href="http://validator.w3.org/check?uri=referer"><img src="http://www.w3.org/Icons/valid-xhtml10" alt="Valid XHTML 1.0 Transitional" height="21" width="78" /></a> 
				<a href="http://jigsaw.w3.org/css-validator/check/referer"><img style="border:0;width:78px;height:21px" src="http://jigsaw.w3.org/css-validator/images/vcss-blue"alt="Valid CSS!" /></a>   
			</div>
		</div><!--footer end-->
		<div class="clr"></div>
	</div><!--####  wrapper  ###-->
</body>
</html>
