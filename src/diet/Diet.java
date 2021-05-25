package diet;

public class Diet {
	int dietID;
	String userID;
	String dietDate;
	String dietTime;
	String brelupper;
	int foodID;
	String foodName;
	String saveFileName;
	
	public int getDietID() {
		return dietID;
	}
	public void setDietID(int dietID) {
		this.dietID = dietID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getDietDate() {
		return dietDate;
	}
	public void setDietDate(String dietDate) {
		this.dietDate = dietDate;
	}
	public String getDietTime() {
		return dietTime;
	}
	public void setDietTime(String dietTime) {
		this.dietTime = dietTime;
	}
	public String getBrelupper() {
		return brelupper;
	}
	public void setBrelupper(String brelupper) {
		this.brelupper = brelupper;
	}
	public int getFoodID() {
		return foodID;
	}
	public void setFoodID(int foodID) {
		this.foodID = foodID;
	}
	public String getFoodName() {
		return foodName;
	}
	public void setFoodName(String foodName) {
		this.foodName = foodName;
	}
	public String getSaveFileName() {
		return saveFileName;
	}
	public void setSaveFileName(String saveFileName) {
		this.saveFileName = saveFileName;
	}
	@Override
	public int hashCode() {
		return Integer.valueOf(this.dietID).hashCode() + String.valueOf(this.userID).hashCode() + String.valueOf(this.dietDate).hashCode() 
			+ String.valueOf(this.dietTime).hashCode() + String.valueOf(this.brelupper).hashCode() + String.valueOf(this.foodID).hashCode()
			+ String.valueOf(this.foodName).hashCode() + String.valueOf(this.saveFileName).hashCode();
	}
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Diet) {
            Diet temp = (Diet) obj;
            if(temp.dietID == this.dietID)
            	return true;
        }
        return false;
	}
}
