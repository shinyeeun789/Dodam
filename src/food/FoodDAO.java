package food;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import diet.Diet;

public class FoodDAO {
	private Connection conn;
	private ResultSet rs;

	public FoodDAO() { 
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
	// db에 접근해 검색 결과를 가져오는 메소드
	public ArrayList<Food> search(String storeFood, String searchFood) {
		ArrayList<Food> result = new ArrayList<Food>();
		try {
			if(storeFood == null) {
				String SQL = "SELECT manufacturer, foodName, image FROM food WHERE foodName like ? AND manufacturer IS NOT NULL order by 1, 2";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, "%"+searchFood+"%");
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Food food = new Food();
					food.setManufacturer(rs.getString(1));
					food.setFoodName(rs.getString(2));
					food.setImage(rs.getString(3));
					result.add(food);
				}
			} else if(searchFood == null) {
				String SQL = "SELECT manufacturer, foodName, image FROM food WHERE manufacturer like ? AND manufacturer IS NOT NULL order by 1, 2";
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, "%"+storeFood+"%");
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Food food = new Food();
					food.setManufacturer(rs.getString(1));
					food.setFoodName(rs.getString(2));
					food.setImage(rs.getString(3));
					result.add(food);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public JSONArray getFoodJSON(String keyword) {
		JSONArray jsonArray = new JSONArray();
		try {
			String SQL = "SELECT manufacturer, foodName FROM food WHERE foodName like ? or manufacturer like ? order by 1, 2";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%"+keyword+"%");
			pstmt.setString(2, "%"+keyword+"%");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("manufacturer", rs.getString(1));
				obj.put("foodName", rs.getString(2));
				jsonArray.add(obj);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}
	
	public ArrayList<Food> categories(String category){
		String SQL = "SELECT * FROM food WHERE category = ? order by manufacturer, foodName";
		ArrayList<Food> list = new ArrayList<Food>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, category);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Food food = new Food();
				food.setManufacturer(rs.getString(2));
				food.setFoodName(rs.getString(3));
				food.setIngredient(rs.getString(4));
				food.setCrossContamination(rs.getString(5));
				food.setCategory(rs.getString(6));
				food.setImage(rs.getString(8));
				list.add(food);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; 
	}
	
	// 제품의 모든 정보를 가져오는 메소드
	public Food foodData(String foodName) {
		String SQL = "SELECT * FROM food WHERE foodName = ?";
		Food food = new Food();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, foodName);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				food.setManufacturer(rs.getString(2));
				food.setFoodName(rs.getString(3));
				food.setIngredient(rs.getString(4));
				food.setCrossContamination(rs.getString(5));
				food.setImage(rs.getString(8));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return food;
	}
	
	// 식품을 추천하는지 추천하지 않는지 확인해주는 메소드
	public int checkFood(String allergyType, String ingredient) {
		if(allergyType == null) 
			return -1;
		String[] arrAllergyType = allergyType.split(" ");
		String[] arrIngredient = ingredient.split(" ");
		int check = 0;
		
		for(int i=0; i<arrIngredient.length; i++) {
			int count = 0;
			for(int j=0; j<arrAllergyType.length; j++) {
				if(!arrIngredient[i].equals(arrAllergyType[j])) {
					count++;
				}
			}
			if(count == arrAllergyType.length)
				check++;
		}
		if(check == arrIngredient.length)
			return 0;
		else
			return 1;
	}
	
	// 안전한 음식 5개를 랜덤으로 가져와주는 메소드
	public ArrayList<Food> getSafeFood(String allergyType) {
		String[] allergyArr = allergyType.split(" ");
		ArrayList<Food> foodList = new ArrayList<Food>();
		try {
			String SQL = "SELECT manufacturer, foodName FROM food WHERE NOT ingredient like '%"+allergyArr[0]+"%'";
			if(allergyArr.length != 1) {
				for(int idx=1; idx<allergyArr.length; idx++)
					SQL += " AND NOT ingredient like '%"+allergyArr[idx]+"%'";
			}
			SQL += "ORDER BY RAND() LIMIT 5";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Food food = new Food();
				food.setManufacturer(rs.getString(1));
				food.setFoodName(rs.getString(2));
				foodList.add(food);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return foodList;
	}
	
	// 위험한 음식 5개를 랜덤으로 가져와주는 메소드
	public ArrayList<Food> getDangerFood(String allergyType) {
		String[] allergyArr = allergyType.split(" ");
		ArrayList<Food> foodList = new ArrayList<Food>();
		try {
			String SQL = "SELECT manufacturer, foodName FROM food WHERE ingredient like '%"+allergyType+"%'";
			if(allergyArr.length != 1) {
				for(int idx=1; idx<allergyArr.length; idx++)
					SQL += " OR ingredient like '%"+allergyArr[idx]+"%'";
			}
			SQL += "ORDER BY RAND() LIMIT 5";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Food food = new Food();
				food.setManufacturer(rs.getString(1));
				food.setFoodName(rs.getString(2));
				foodList.add(food);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return foodList;
	}
	
	// 사용자가 업로드한 사진의 이름을 가져와주는 메소드
	public ArrayList<Diet> getFoodImage(String userID) {
		ArrayList<Diet> imgList = new ArrayList<Diet>();
		try {
			String SQL = "SELECT DISTINCT saveFileName, dietDate FROM diet "
					+ "WHERE userID = ? ORDER BY 2";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Diet diet = new Diet();
				diet.setSaveFileName(rs.getString(1));
				diet.setDietDate(rs.getString(2));
				imgList.add(diet);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return imgList;
	}
	
	// 음식의 유발식재료 가져오는 메소드
	public String getIngredient(String foodName) {
		try {
			String SQL = "SELECT ingredient FROM food WHERE foodName = ? AND ingredient IS NOT NULL";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, foodName);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
