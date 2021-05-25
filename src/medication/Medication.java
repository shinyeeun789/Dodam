package medication;

public class Medication {
	private int medicineID;
	private String userID;
	private String medicine;
	private String medicineDate;
	private String medicineTime;
	public int getMedicineID() {
		return medicineID;
	}
	public void setMedicineID(int medicineID) {
		this.medicineID = medicineID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getMedicine() {
		return medicine;
	}
	public void setMedicine(String medicine) {
		this.medicine = medicine;
	}
	public String getMedicineDate() {
		return medicineDate;
	}
	public void setMedicineDate(String medicineDate) {
		this.medicineDate = medicineDate;
	}
	public String getMedicineTime() {
		return medicineTime;
	}
	public void setMedicineTime(String medicineTime) {
		this.medicineTime = medicineTime;
	}
}
