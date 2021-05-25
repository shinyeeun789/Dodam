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
	public ArrayList<Type> findAllergyType(String userID) { 	// 알레르기 원인 찾기
		DietDAO dietDAO = new DietDAO();
		FoodDAO foodDAO = new FoodDAO();
		OutbreakDAO outbreakDAO = new OutbreakDAO();
		ArrayList<Type> percentList = new ArrayList<Type>();
		try {
			// 1.증상 발생 12시간 전 날짜 가져오기
			ArrayList<OutbreakDate> dateList = outbreakDAO.getbeforeDate(userID);
			
			// 2.증상 발생 이전에 먹은 음식 가져오기
			ArrayList<Diet> dietList = new ArrayList<Diet>();
			for(int idx=0; idx<dateList.size(); idx++) {
				String[] bDate = dateList.get(idx).getBeforeDate().split(" ");
				ArrayList<Diet> newList = dietDAO.getobkDietList(userID, bDate[0], dateList.get(idx).getNowDate(), bDate[1], dateList.get(idx).getNowTime());
				dietList = (ArrayList<Diet>) ListUtils.union(dietList, newList);	// dietList와 newList 합치기
			}
			
			// 3.중복 제거하기
			ArrayList<Diet> dDietList = new ArrayList<Diet>(new LinkedHashSet<Diet>(dietList));
			
			// 4.많이 중복된 음식 찾기			
			HashMap<String, Integer> obFoodList_count = new HashMap<String, Integer>();
			for(int i=0; i<dDietList.size(); i++) {
				if(obFoodList_count.containsKey(dDietList.get(i).getFoodName())) {	// HashMap 내부에 이미 Key 값이 존재하는 경우
					obFoodList_count.put(dDietList.get(i).getFoodName(),obFoodList_count.get(dDietList.get(i).getFoodName())+1);
				} else { 															// HashMap 안에 key 값이 존재하지 않는 경우
					obFoodList_count.put(dDietList.get(i).getFoodName(), 1); 		// key 값 생성 후 value를 1로 초기화
				}
			}
			Map<String, Integer> result = sortMap(obFoodList_count);				// value값을 기준으로 오름차순
			
			// 5.음식의 유발식재료 가져오기
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
			
			// 6.유발식재료 중 가장 많이 증상이 발생한 식재료 찾기
			HashMap<String, Integer> igd_count = new HashMap<String, Integer>();
			for(int i=0; i<igdSplit.size(); i++) {
				if(igd_count.containsKey(igdSplit.get(i))) {	// HashMap 내부에 이미 Key 값이 존재하는 경우
					igd_count.put(igdSplit.get(i),igd_count.get(igdSplit.get(i))+1);
				} else { 										// HashMap 안에 key 값이 존재하지 않는 경우
					igd_count.put(igdSplit.get(i), 1); 			// key 값 생성 후 value를 1로 초기화
				}
			}
			Map<String, Integer> type = sortMap(igd_count);		// value값을 기준으로 오름차순
			
			// 7.유발식재료를 먹은 날 증상이 몇 번 발생했는지 계산(%)
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
				ArrayList<Integer> dCountList = new ArrayList<Integer>(new LinkedHashSet<Integer>(countList));	// 중복 제거
				
				Type types = new Type();
				
				types.setIngredient(entry.getKey());
				types.setCount(dCountList.size());
				types.setTotal(dateTimeList.size());
				
				percent = (double)types.getCount() / (double)types.getTotal() * 100.0;
				types.setPercent(percent);
				percentList.add(types);
			}
			
			// 8. 60% 미만 유발식재료 삭제
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
	
	// Map을 내림차순으로 정렬하는 메소드
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
