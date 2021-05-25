package findType;

public class Type implements Comparable<Type> {
	private String ingredient;
	private int count;
	private int total;
	private double percent;
	
	public String getIngredient() {
		return ingredient;
	}
	public void setIngredient(String ingredient) {
		this.ingredient = ingredient;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public double getPercent() {
		return percent;
	}
	public void setPercent(double percent) {
		this.percent = percent;
	}
	@Override
	public int compareTo(Type o) {		// 내림차순 정렬
		if(this.percent < o.percent) {
			return 1;
		} else if(this.percent == o.percent) {
			return 0;
		} else {
			return -1;
		}
	}
}
