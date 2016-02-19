<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
  <head>
   <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
	<body>

<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "";
    }
    pageContext.setAttribute("guestbookName", guestbookName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<a href= "ofyguestbook.jsp">Back</a>
<p>Old comments:</p>

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
        <p>Blog '${fn:escapeXml(guestbookName)}' has no messages.</p>

<%
    } else {
//        for (guestbook.Greeting greeting : greetings) {
		for (int i = greetings.size()-1; i >= 0; i --){
        	guestbook.Greeting greeting = greetings.get(i);
            pageContext.setAttribute("greeting_content", greeting.getContent());
            if (greeting.getUser() != null) {
                pageContext.setAttribute("greeting_user", greeting.getUser());
%>

                <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
                <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
            
<%
            }
%>


<%
        }
    }
%>

 


 

  </body>
 </head>
</html>