package outbreak;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class OutbreakDAO {
	private Connection conn;
	private ResultSet rs;

	public OutbreakDAO() { 
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
	// ���ο� ��ȣ �ο� �޼ҵ�
	public int getNext() {
		String SQL = "SELECT outbreakID FROM outbreak ORDER BY outbreakID DESC";
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
	
	//db�� insert�ϱ� ���� �޼ҵ�
	public int write(String userID, String outbreakDate, String outbreakTime, String type, String bodyPart) {
		String SQL = "INSERT INTO outbreak VALUES(?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, userID);
			pstmt.setString(3, outbreakDate);
			pstmt.setString(4, outbreakTime);
			pstmt.setString(5, type);
			pstmt.setString(6, bodyPart);
			
			int result = pstmt.executeUpdate();
			pstmt.close();
			return result;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //�����ͺ��̽� ����
	}
	
	// ���� List�� �������� �޼ҵ�
	public JSONArray getOutbreakList(String userID, String sDate, String eDate) {
		JSONArray jsonArray = new JSONArray();
		try {
			String SQL = "SELECT outbreakDate, outbreakTime, type, bodyPart "
					+ "FROM outbreak "
					+ "WHERE userID = ? and outbreakDate between ? and ? ORDER BY outbreakDate, outbreakTime";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, sDate);
			pstmt.setString(3, eDate);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				JSONObject obj = new JSONObject();
				obj.put("outbreakDate", rs.getString(1));
				obj.put("outbreakTime", rs.getString(2));
				obj.put("type", rs.getString(3));
				obj.put("bodyPart", rs.getString(4));
				jsonArray.add(obj);
			}
			rs.close();
			pstmt.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return jsonArray;
	}
	
	// ������ ��Ÿ�� ��¥, �ð� �������� �޼ҵ�
	public ArrayList<Outbreak> getOutbreakDT(String userID) {
		ArrayList<Outbreak> outbreakList = new ArrayList<Outbreak>();
		try {
			String SQL = "SELECT DISTINCT outbreakDate, outbreakTime FROM outbreak WHERE userID = ? ORDER BY outbreakDate";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Outbreak obk = new Outbreak();
				obk.setOutbreakDate(rs.getString(1));
				obk.setOutbreakTime(rs.getString(2));
				outbreakList.add(obk);
			}
			rs.close();
			pstmt.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return outbreakList;
	}
	
	// ������ ��Ÿ���� 12�ð� �� ��¥�� �������� �޼ҵ�
	public ArrayList<OutbreakDate> getbeforeDate(String userID) {
		ArrayList<OutbreakDate> dateList = new ArrayList<OutbreakDate>();
		try {
			String SQL = "SELECT DATE_ADD(CONCAT(outbreakDate, ' ', outbreakTime), INTERVAL -12 HOUR), outbreakDate, outbreakTime "
					+ "FROM outbreak WHERE userID = ? ORDER BY 1";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				OutbreakDate oDate = new OutbreakDate();
				oDate.setBeforeDate(rs.getString(1));
				oDate.setNowDate(rs.getString(2));
				oDate.setNowTime(rs.getString(3));
				dateList.add(oDate);
			}
			rs.close();
			pstmt.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return dateList;
	}
	
	// �ֱ� 5���� ���� ���� ��ȭ�� �������� �޼ҵ�
	public ArrayList<OutbreakCount> getoutbreakCount(String userID) {
		ArrayList<OutbreakCount> oCount = new ArrayList<OutbreakCount>();
		try {
			String SQL = "SELECT date_format(outbreakDate, '%Y-%m') m, count(*) FROM outbreak " + 
					"WHERE userID = ? AND outbreakDate BETWEEN LAST_DAY(NOW() - interval 6 month) + interval 1 DAY AND LAST_DAY(now()) " + 
					"GROUP BY m ORDER BY 1";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				OutbreakCount outbreakCount = new OutbreakCount();
				outbreakCount.setOutbreakMonth(rs.getString(1));
				outbreakCount.setCount(rs.getInt(2));
				oCount.add(outbreakCount);
			}
			rs.close();
			pstmt.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return oCount;
	}
	
	// ���� ���� ������ ��Ÿ�� ���� �������� �޼ҵ�
	public String getMaxType(String userID, int option) {
		try {
			String SQL = "SELECT type, COUNT(*) FROM outbreak WHERE userID = ? GROUP BY type ORDER BY 2 DESC LIMIT 1";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			String result = null;
			if(rs.next()) {
				if(option == 1)
					result = rs.getString(1);
				else
					result = Integer.toString(rs.getInt(2));
			}
			rs.close();
			pstmt.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	// ���� ������ ���� �������� �޼ҵ�
	public int getTypeCount(String userID) {
		try {
			String SQL = "SELECT COUNT(*) FROM outbreak WHERE userID = ?";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			int result = 0;
			if(rs.next())
				result = rs.getInt(1);
			rs.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	// ���� ���� ������ ��Ÿ�� ����
	public String getMaxBodypart(String userID, int option) {
		try {
			String SQL = "SELECT bodyPart, COUNT(*) FROM outbreak WHERE userID = ? and bodyPart IS NOT NULL "
					+ "GROUP BY bodyPart ORDER BY 2 DESC LIMIT 1";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			String result = null;
			if(rs.next()) {
				if (option == 1)
					result = rs.getString(1);
				else
					result = Integer.toString(rs.getInt(2));
			}
			rs.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
	// ��ϵ� ��� ������ ���� ���ϴ� �޼ҵ�
	public int getBodypartCount(String userID) {
		try {
			String SQL = "SELECT COUNT(*) FROM outbreak WHERE bodypart IS NOT NULL AND userID = ?";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			int result = 0;
			if(rs.next())
				result = rs.getInt(1);
			rs.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public int getTotalCount(String userID) {
		try {
			String SQL = "SELECT COUNT(*) FROM outbreak WHERE userID = ? "
					+ "and outbreakDate BETWEEN LAST_DAY(NOW()-interval 1 month)+interval 1 DAY AND LAST_DAY(now())";
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			int result = 0;
			if(rs.next())
				result = rs.getInt(1);
			rs.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
