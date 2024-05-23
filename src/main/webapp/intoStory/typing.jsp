<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.google.gson.Gson" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">  
    <title>Typing Speed Test Game</title>
    <link rel="stylesheet" href="style2.css?after">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  </head>
  <body>
    <div class="wrapper">
      <input type="text" class="input-field">
      <div class="content-box">
        <div class="typing-text">
          <p></p>
        </div>
        <div class="content">
          <ul class="result-details">
            <li class="time">
              <p>Time Left:</p>
              <span><b>60</b>s</span>
            </li>
            <li class="mistake">
              <p>Mistakes:</p>
              <span>0</span>
            </li>
            <li class="wpm">
              <p>WPM:</p>
              <span>0</span>
            </li>
            <li class="cpm">
              <p>CPM:</p>
              <span>0</span>
            </li>
          </ul>
          <button>Try Again</button>
        </div>
      </div>
    </div>
<!--     <script src="script_context.js"></script> -->
	<script>
	console.log("what")
	<% 
	//임시 세션 설정
	HttpSession userSession  = request.getSession();
    userSession.setAttribute("id", "321");
	
	Class.forName("com.mysql.jdbc.Driver");
	String db_address = "jdbc:mysql://localhost:3306/fairytale";
	String db_username = "root";
	String db_pwd = "1234";
            
	Connection connection = DriverManager.getConnection(db_address, db_username, db_pwd);
	
	String title = request.getParameter("title");
	String id = (String)session.getAttribute("id");
	int progress = 1;
			
	//만약 저장된 내용이 없다면 새로 가져와야함
	String findSave = "SELECT progress from fairytale_user WHERE id=? AND title=?";
	PreparedStatement psmt = connection.prepareStatement(findSave);
	psmt.setString(1, id);
	psmt.setString(2, title);
	ResultSet result = psmt.executeQuery();
	if (result.next()) {
        progress = result.getInt("progress"); // 쿼리 결과가 있다면 progress 값 설정
    }
	
	List<String> paragraphs = new ArrayList<>();
	
	String insertQuery = "SELECT text_eng FROM fairytale WHERE ? <= (SELECT MAX(progress) FROM fairytale) AND title = ?";
	psmt = connection.prepareStatement(insertQuery);
	psmt.setInt(1, progress);
	psmt.setString(2, title);
	result = psmt.executeQuery();	
	
	while (result.next()) {
	    String text = result.getString("text_eng");
	    paragraphs.add(text);
	}
    
    //이거는 내용 뽑기
    for (String content : paragraphs) {
        System.out.println(content); // 또는 다른 원하는 작업을 수행할 수 있습니다.
    }
    
    String jsonParagraphs = new Gson().toJson(paragraphs);
	%>	
	const paragraphs = <%= jsonParagraphs %>;
	console.log("Paragraphs: ", paragraphs);
	</script>
    <script src="script2.js"></script>
  </body>
</html>