package medication;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MedicationDAO {
	private Connection conn;
	private ResultSet rs;

	public MedicationDAO() { 
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
		String SQL = "SELECT medicineID FROM medication ORDER BY medicineID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			rs.close();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	//db에 insert하기 위한 메소드
	public int write(String userID, String medicine, String medicineDate, String medicineTime) {
		String SQL = "INSERT INTO medication VALUES(?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setString(3, medicine);
			pstmt.setString(4, medicineDate);
			pstmt.setString(5, medicineTime);
			
			int result = pstmt.executeUpdate();
			pstmt.close();
			return result;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
	
	public MedicineCount getMaxMedicine(String userID) {
		MedicineCount mc = new MedicineCount();
		String SQL = "SELECT medicine, COUNT(medicine) FROM medication "
				+ "WHERE userID = ? and medicineDate BETWEEN LAST_DAY(NOW()-INTERVAL 6 MONTH) + INTERVAL 1 DAY AND LAST_DAY(NOW()) "
				+ "GROUP BY medicine "
				+ "ORDER BY 2 DESC LIMIT 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				mc.setMedicine(rs.getString(1));
				mc.setCount(rs.getInt(2));
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mc;
	}
}
