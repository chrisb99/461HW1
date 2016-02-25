<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
 
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
<!-- 	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine"> -->
    <style type="text/css">
     body {
          background-color:AliceBlue;
          text-decoration: bold;
          text-size: 1em;
          font-family: 'Tangerine', serif;
          font-size: 20px;
      }
    </style>
  </head>
<body>
<div class = "top-bar">
<p><h1>BLOG      OF      COOKIES</h1></p> <i class="fa fa-birthday-cake"></i>
</div>

<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<p><center><h3>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</h3></center></p>

<%
    } else {
%>

<p><center><h3>Hello! <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a> to post a comment!</h3></center></p>

<%
    }
%>

<a href ="/oldguestbook.jsp"><center>View older comments</center></a>

<%
	ObjectifyService.register(guestbook.Greeting.class);
	List<guestbook.Greeting> greetings = ObjectifyService.ofy().load().type(guestbook.Greeting.class).list();   
	Collections.sort(greetings); 
    if (greetings.isEmpty()) {
%>
        <p>Blog '${fn:escapeXml(guestbookName)}' has no messages.</p>

<%
    } else {
         
        
		for (int i = greetings.size() - 1 ; i > greetings.size() - 6; i --){
			if(i<0) break; 
        	guestbook.Greeting greeting = greetings.get(i);
            pageContext.setAttribute("greeting_content", greeting.getContent());
            if (greeting.getUser() == null) {
%>

                <p><center>You need to<a href="<%= userService.createLoginURL(request.getRequestURI()) %>"> sign in</a> to post a comment.</center></p>

<%
            } else {
                pageContext.setAttribute("greeting_user", greeting.getUser());
%>

                <p><center><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</center></p>
                <blockquote><center>${fn:escapeXml(greeting_content)}</center></blockquote>
            
<%
            }
%>


<%
        }
    }
%>

 

    <form action="/ofysign" method="post">
      <div><center><textarea name="content" rows="3" cols="60"></textarea></center></div>
      <div><center><input type="submit" value="Post" /></center></div>
      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>
 
    
<div style="width:400px;">
<div style="float: left; width: 130px"> 
<form id="thisone" action="post_nrs_users.asp" method="post">
    <input type="submit" name = "subscribe" value="Subscribe" >
</form>
</div>
<div style="float: center; width: 220px"> 
    <form id="thistoo" action="post_nrs_users.asp" method="post">
     <input type="submit" name = "unsubscribe" value="Unsubscribe" >
    </form>
</div>
</div>

 

  </body>
</html>