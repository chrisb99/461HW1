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

<a href= "/ofyguestbook.jsp">Back</a>
<p><center><h1>Old comments:</h1></center></p>
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "HomeWork1";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>

<%
    } else {
    	
    }
%>



<%
	ObjectifyService.register(guestbook.Greeting.class);
	List<guestbook.Greeting> greetings = ObjectifyService.ofy().load().type(guestbook.Greeting.class).list();   
	Collections.sort(greetings); 
    if (greetings.isEmpty()) {
%>
        <p><center>Blog '${fn:escapeXml(guestbookName)}' has no messages.</center></p>

<%
    } else {
//        for (guestbook.Greeting greeting : greetings) {
		for (int i = greetings.size()-1; i >= 0; i --){
        	guestbook.Greeting greeting = greetings.get(i);
            pageContext.setAttribute("greeting_content", greeting.getContent());
            if (greeting.getUser() != null) {
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

 


 

  </body>

</html>