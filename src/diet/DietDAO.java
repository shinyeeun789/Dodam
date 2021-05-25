package diet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class DietDAO {
	private Connection conn;
	private ResultSet rs;
	
	public DietDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/dodam? useUnicode=true&chracterEncoding=utf8&serverTimezone=UTC"; 
			String dbID = "root";
			String dbPassword = "inhatc";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace(); 
		}
	}
	
	// 새로운 번호 부여 메소드
	public int getNext() {
		String SQL = "SELECT dietID FROM diet ORDER BY dietID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			rs.close();
			pstmt.close();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	//foodID를 가져오기 위한 메소드
	public int searchFoodID(String foodName) {
		String SQL = "SELECT foodID FROM food WHERE foodName = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, foodName);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
			rs.close();
			pstmt.close();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	//db에 insert하기 위한 메소드
	public int write(String userID, String dietDate, String dietTime, String brelupper, String foodName, String saveFileName) {
		String SQL = "INSERT INTO diet VALUES(?,?,?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setString(3, dietDate);
			pstmt.setString(4, dietTime);
			pstmt.setString(5, brelupper);
			if(searchFoodID(foodName) == 0)
				pstmt.setString(6, null);
			else
				pstmt.setInt(6, searchFoodID(foodName));
			pstmt.setString(7, foodName);
			pstmt.setString(8, saveFileName);
			int result = -1;
			result = pstmt.executeUpdate();
			pstmt.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	// 식단 리스트를 불러오는 메소드
	public JSONArray getDietList(String userID, String sDate, String eDate) {
		JSONArray jsonArray = new JSONArray();
		try {
			String SQL = "SELECT dietDate, dietTime, brelupper, manufacturer, diet.foodName "
					+ "FROM food right outer join diet using(foodID) "
					+ "WHERE diet.userID = ? and dietDate between ? and ? ORDER BY dietDate, dietTime";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, sDate);
			pstmt.setString(3, eDate);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("dietDate", rs.getString(1));
				obj.put("dietTime", rs.getString(2));
				obj.put("brelupper", rs.getString(3));
				obj.put("manufacturer", rs.getString(4));
				obj.put("foodName", rs.getString(5));
				jsonArray.add(obj);
			}
			rs.close();
			pstmt.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}
	
	// 증상이 발생하기 12시간 전부터 증상이 발생한 시간까지 먹은 음식 가져오는 메소드
	public ArrayList<Diet> getobkDietList(String userID, String startDate, String endDate, String startTime, String endTime) {
		ArrayList<Diet> obkDietList = new ArrayList<Diet>();
		try {
			String SQL = null;
			if(startDate.equals(endDate)) {
				SQL = "SELECT dietID, dietDate, dietTime, diet.foodName FROM diet JOIN food USING(foodID)"
						+ " WHERE userID = ? AND dietDate = ? AND dietTime between ? and ? AND NOT risk = 1";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, endDate);
				pstmt.setString(3, startTime);
				pstmt.setString(4, endTime);
				rs = pstmt.executeQuery();
			} else {
				SQL = "SELECT dietID, dietDate, dietTime, diet.foodName FROM diet JOIN food USING(foodID)"
						+ " WHERE userID = ? AND (dietDate = ? AND dietTime BETWEEN ? AND '23:59:00') OR"
						+ " (dietDate = ? AND dietTime BETWEEN '00:00:00' AND ?) AND NOT risk = 1";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, startDate);
				pstmt.setString(3, startTime);
				pstmt.setString(4, endDate);
				pstmt.setString(5, endTime);
				rs = pstmt.executeQuery();
			}
			while(rs.next()) {
				Diet diet = new Diet();
				diet.setDietID(rs.getInt("dietID"));
				diet.setDietDate(rs.getString("dietDate"));
				diet.setDietTime(rs.getString("dietTime"));
				diet.setFoodName(rs.getString("foodName"));
				obkDietList.add(diet);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return obkDietList;
	}
	
	// 예상 유발식재료를 포함한 음식을 먹은 날 가져오는 메소드
	public ArrayList<Diet> getDateTime(String ingredient, String userID) {
		ArrayList<Diet> dateList = new ArrayList<Diet>();
		try {
			String SQL = "SELECT dietDate, dietTime FROM diet JOIN food USING(foodID) "
					+ "WHERE ingredient LIKE ? AND userID = ? ORDER BY 1,2";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + ingredient + "%");
			pstmt.setString(2, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Diet diet = new Diet();
				diet.setDietDate(rs.getString(1));
				diet.setDietTime(rs.getString(2));
				dateList.add(diet);
			}
			rs.close();
			pstmt.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dateList;
	}
	
	// 알레르기 발생한 날 해당 음식 먹었는지?
	public ArrayList<Integer> getDateTime(String ingredient, String userID, String bDate, String afterDate, String afterTime) {
		ArrayList<Integer> dIDList = new ArrayList<Integer>();
		String beforeDate = bDate.substring(0,10);
		String beforeTime = bDate.substring(11,19);
		String SQL = "";
		try {
			if(beforeDate.equals(afterDate)) {
				SQL = "SELECT dietID FROM diet JOIN food USING(foodID)"
						+ " WHERE userID = ? AND ingredient LIKE ? AND "
						+ "dietDate = ? AND dietTime BETWEEN ? AND ?";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, "%" + ingredient + "%");
				pstmt.setString(3, afterDate);
				pstmt.setString(4, beforeTime);
				pstmt.setString(5, afterTime);
				rs = pstmt.executeQuery();
			} else {
				SQL = "SELECT dietID FROM diet JOIN food USING(foodID)"
						+ " WHERE userID = ? AND ingredient LIKE ? AND (dietDate = ? AND dietTime BETWEEN ? AND '23:59:00') OR"
						+ " (dietDate = ? AND dietTime BETWEEN '00:00:00' AND ?)";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID);
				pstmt.setString(2, "%" + ingredient + "%");
				pstmt.setString(3, beforeDate);
				pstmt.setString(4, beforeTime);
				pstmt.setString(5, afterDate);
				pstmt.setString(6, afterTime);
				rs = pstmt.executeQuery();
			}
			while(rs.next()) {
				dIDList.add(rs.getInt(1));
			}
			rs.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dIDList;
	}
}
