package com.example;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class tester extends HttpServlet {

    private String message;
 
    public void init() throws ServletException {
       // Do required initialization
       message = "Hello World";
    }
 
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

      response.setContentType("text/html");
      PrintWriter out = response.getWriter();
      out.println("<h1>" + message + "</h1>");
    }

   public void destroy() {
      // do nothing.
   }
}
