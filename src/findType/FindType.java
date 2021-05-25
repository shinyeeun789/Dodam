package findType;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.ListUtils;

import diet.Diet;
import diet.DietDAO;
import food.FoodDAO;
import outbreak.OutbreakDAO;
import outbreak.OutbreakDate;

public class FindType {		
	public ArrayList<Type> findAllergyType(String userID) { 	// �˷����� ���� ã��
		DietDAO dietDAO = new DietDAO();
		FoodDAO foodDAO = new FoodDAO();
		OutbreakDAO outbreakDAO = new OutbreakDAO();
		ArrayList<Type> percentList = new ArrayList<Type>();
		try {
			// 1.���� �߻� 12�ð� �� ��¥ ��������
			ArrayList<OutbreakDate> dateList = outbreakDAO.getbeforeDate(userID);
			
			// 2.���� �߻� ������ ���� ���� ��������
			ArrayList<Diet> dietList = new ArrayList<Diet>();
			for(int idx=0; idx<dateList.size(); idx++) {
				String[] bDate = dateList.get(idx).getBeforeDate().split(" ");
				ArrayList<Diet> newList = dietDAO.getobkDietList(userID, bDate[0], dateList.get(idx).getNowDate(), bDate[1], dateList.get(idx).getNowTime());
				dietList = (ArrayList<Diet>) ListUtils.union(dietList, newList);	// dietList�� newList ��ġ��
			}
			
			// 3.�ߺ� �����ϱ�
			ArrayList<Diet> dDietList = new ArrayList<Diet>(new LinkedHashSet<Diet>(dietList));
			
			// 4.���� �ߺ��� ���� ã��			
			HashMap<String, Integer> obFoodList_count = new HashMap<String, Integer>();
			for(int i=0; i<dDietList.size(); i++) {
				if(obFoodList_count.containsKey(dDietList.get(i).getFoodName())) {	// HashMap ���ο� �̹� Key ���� �����ϴ� ���
					obFoodList_count.put(dDietList.get(i).getFoodName(),obFoodList_count.get(dDietList.get(i).getFoodName())+1);
				} else { 															// HashMap �ȿ� key ���� �������� �ʴ� ���
					obFoodList_count.put(dDietList.get(i).getFoodName(), 1); 		// key �� ���� �� value�� 1�� �ʱ�ȭ
				}
			}
			Map<String, Integer> result = sortMap(obFoodList_count);				// value���� �������� ��������
			
			// 5.������ ���߽���� ��������
			int index = 0;
			String[] ingredient;
			ArrayList<String> igdList = new ArrayList<String>();
			ArrayList<String> igdSplit = new ArrayList<String>();
			for(Map.Entry<String, Integer> entry : result.entrySet()) {
				if(index==50)	break;
				igdList.add(foodDAO.getIngredient(entry.getKey()));
				index++;
			}
			for(int i=0; i<igdList.size(); i++) {
				if(igdList.get(i) == null) continue;
				ingredient = igdList.get(i).split(" ");
				for(int j=0; j<ingredient.length; j++) {
					igdSplit.add(ingredient[j]);
				}
			}
			
			// 6.���߽���� �� ���� ���� ������ �߻��� ����� ã��
			HashMap<String, Integer> igd_count = new HashMap<String, Integer>();
			for(int i=0; i<igdSplit.size(); i++) {
				if(igd_count.containsKey(igdSplit.get(i))) {	// HashMap ���ο� �̹� Key ���� �����ϴ� ���
					igd_count.put(igdSplit.get(i),igd_count.get(igdSplit.get(i))+1);
				} else { 										// HashMap �ȿ� key ���� �������� �ʴ� ���
					igd_count.put(igdSplit.get(i), 1); 			// key �� ���� �� value�� 1�� �ʱ�ȭ
				}
			}
			Map<String, Integer> type = sortMap(igd_count);		// value���� �������� ��������
			
			// 7.���߽���Ḧ ���� �� ������ �� �� �߻��ߴ��� ���(%)
			for(Map.Entry<String, Integer> entry : type.entrySet()) {
				if(entry.getValue() == 1)
					continue;
				double percent = 0;
				ArrayList<Integer> countList = new ArrayList<Integer>();
				ArrayList<Diet> dateTimeList = dietDAO.getDateTime(entry.getKey(), userID);
				
				for(int i=0; i<dateList.size(); i++) {
					ArrayList<Integer> newList = dietDAO.getDateTime(entry.getKey(), userID, 
							dateList.get(i).getBeforeDate(), dateList.get(i).getNowDate(), dateList.get(i).getNowTime());
					countList = (ArrayList<Integer>) ListUtils.union(countList, newList);
				}
				ArrayList<Integer> dCountList = new ArrayList<Integer>(new LinkedHashSet<Integer>(countList));	// �ߺ� ����
				
				Type types = new Type();
				
				types.setIngredient(entry.getKey());
				types.setCount(dCountList.size());
				types.setTotal(dateTimeList.size());
				
				percent = (double)types.getCount() / (double)types.getTotal() * 100.0;
				types.setPercent(percent);
				percentList.add(types);
			}
			
			// 8. 60% �̸� ���߽���� ����
			int size = percentList.size();
			for(int idx=0; idx<size; idx++) {
				if(percentList.get(idx).getPercent() < 60.0) {
					percentList.remove(idx);
					size--;		idx--;
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return percentList;
	}
	
	// Map�� ������������ �����ϴ� �޼ҵ�
	public static LinkedHashMap<String, Integer> sortMap(HashMap<String, Integer> map) {
		List<Map.Entry<String, Integer>> entries = new LinkedList<>(map.entrySet());
		Collections.sort(entries, new Comparator<Map.Entry<String, Integer>>() {
			@Override
			public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
				return o2.getValue().compareTo(o1.getValue());
			}
		});
		LinkedHashMap<String, Integer> result = new LinkedHashMap<>();
		for(Map.Entry<String, Integer> entry : entries) {
			result.put(entry.getKey(), entry.getValue());
		}
		return result;
	}
}
