package ubd;

import java.sql.*;
import java.util.LinkedHashMap;
import java.util.ArrayList;


public class DbTool {
	final static String connecUrl = "jdbc:mysql://localhost:3306/editor?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC";
	final static String user = "abc";
	final static String passwd = "123456";
	
	public static String getPasswd() {
		Connection connection = null;
		String myPasswd = null;
		try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(connecUrl,user,passwd);
        PreparedStatement preparedStatement0 = connection.prepareStatement("select user_passwd from users_tb where user_name = ?");
		preparedStatement0.setString(1,"wp");
		ResultSet result = preparedStatement0.executeQuery();
		while(result.next()) {
			myPasswd = result.getString("user_passwd");
		}
        connection.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null)
					connection.close();
			} catch(SQLException e) { 
				e.printStackTrace();
			}
		}
		return myPasswd;
	}
	
	public static boolean add(String noteTitle,String noteContent,String category) {
		Connection connection = null;
		try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(connecUrl,user,passwd);
        PreparedStatement preparedStatement = connection.prepareStatement("insert into notes_tb(note_title,note_content,category) values(?,?,?)");
        preparedStatement.setString(1,noteTitle);
        preparedStatement.setString(2,noteContent);
		preparedStatement.setString(3,category);
		int result = preparedStatement.executeUpdate();
		PreparedStatement preparedStatement1 = connection.prepareStatement("insert ignore into category_tb(category) values(?)");
		preparedStatement1.setString(1,category);
		int result1 = preparedStatement1.executeUpdate();
		preparedStatement.close();
		preparedStatement1.close();
        connection.close();
		if (result > 0)
			return true;
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null)
					connection.close();
			} catch(SQLException e) { 
				e.printStackTrace();
			}
		}
		return false;
	}
	
	//category add,delete,do nothing
	public static boolean change(int id, String title, String content,String category,String signForDeal) {
		int result = -1;
		Connection connection = null;
		try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(connecUrl,user,passwd);
		//get old category
		ResultSet oldCategorys = null;
		String oldCategory = null;
		PreparedStatement preparedStatement0 = connection.prepareStatement("select category from notes_tb where note_id = ?");
		preparedStatement0.setInt(1,id);
		oldCategorys = preparedStatement0.executeQuery();
		while (oldCategorys.next()) {
			oldCategory = oldCategorys.getString("category");
		}
		if (oldCategory == null)
			return false;
		if (signForDeal.equals("changeNote")) {
			//update notes_tb
			PreparedStatement preparedStatement = connection.prepareStatement("update notes_tb set note_title=?,note_content=?,category=? where note_id=?");
			preparedStatement.setString(1,title);
			preparedStatement.setString(2,content);
			preparedStatement.setString(3,category);
			preparedStatement.setInt(4,id);
			result = preparedStatement.executeUpdate();	
		}
		else if (signForDeal.equals("deleteNote")){
			//update notes_tb
			PreparedStatement preparedStatement = connection.prepareStatement("delete from notes_tb where note_id=?");
			preparedStatement.setInt(1,id);
			result = preparedStatement.executeUpdate();	
		}
		//Does current category exist in category_tb
		if (!oldCategory.equals(category) && signForDeal.equals("changeNote")) {
			PreparedStatement preparedStatement1 = connection.prepareStatement("insert ignore into category_tb(category) values(?)");
			preparedStatement1.setString(1,category);
			int result1 = preparedStatement1.executeUpdate();
		}
		//numberOfNotesInOldCategory
		ResultSet numberOfNotesInOldCategorys = null;
		PreparedStatement preparedStatement2 = connection.prepareStatement("select count(*) from notes_tb where category = ?");
		preparedStatement2.setString(1,oldCategory);
		numberOfNotesInOldCategorys = preparedStatement2.executeQuery();
		int numberOfNotesInOldCategory = 1;
		while (numberOfNotesInOldCategorys.next()) {
			numberOfNotesInOldCategory = numberOfNotesInOldCategorys.getInt(1);
		}
		///delete oldCategory
		if (numberOfNotesInOldCategory == 0) {
			PreparedStatement preparedStatement3 = connection.prepareStatement("delete from category_tb where category = ?");
			preparedStatement3.setString(1,oldCategory);
			int result3 = preparedStatement3.executeUpdate();
		}
        connection.close();
		if (result > 0)
			return true;
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null)
					connection.close();
			} catch(SQLException e) { 
				e.printStackTrace();
			}
		}
		return false;
	}
	
	public static LinkedHashMap<String, ArrayList<TitleID> > getHome() {
		LinkedHashMap<String, ArrayList<TitleID> > result = new LinkedHashMap<>();
		String name,alias;
		ArrayList<TitleID> tempTitles = new ArrayList<>();
		Connection connection = null;
		try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(connecUrl,user,passwd);
        PreparedStatement preparedStatement = connection.prepareStatement("select * from category_tb");
		ResultSet category_names = preparedStatement.executeQuery();
		ResultSet notes;
		PreparedStatement preparedStatement1 = null;
		while(category_names.next()) {
			name = category_names.getString("category");
			String sql1 = "select note_id,note_title from notes_tb where category=?";
			if (preparedStatement1 == null) {
				preparedStatement1 = connection.prepareStatement(sql1);
			}
			preparedStatement1.setString(1,name);
			notes = preparedStatement1.executeQuery();
			while (notes.next()) {
				int noteId = notes.getInt("note_id");
				String noteTitle = notes.getString("note_title");
				tempTitles.add(new TitleID(noteId,noteTitle));
			}
			result.put(name,tempTitles);
			tempTitles = new ArrayList<>();
		}
        preparedStatement.close();
		preparedStatement1.close();
        connection.close();
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null)
					connection.close();
			} catch(SQLException e) { 
				e.printStackTrace();
			}
		}
		return result;
	}

	public static ArrayList<String> getEach(int noteId) {
		ArrayList<String> result  = new ArrayList<>();
		Connection connection = null;
		try {
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection(connecUrl,user,passwd);
        PreparedStatement pst1 = connection.prepareStatement("select note_title,note_content,category from notes_tb where note_id= ?");
		pst1.setInt(1,noteId);
		ResultSet noteContent = pst1.executeQuery();
		while(noteContent.next()) {
			result.add(Integer.toString(noteId));
			result.add(noteContent.getString("note_title"));
			result.add(noteContent.getString("note_content"));
			result.add(noteContent.getString("category"));
		}
        pst1.close();
        connection.close();
        } catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (connection != null)
					connection.close();
			} catch(SQLException e) { 
				e.printStackTrace();
			}
		}
		return result;
	}
}