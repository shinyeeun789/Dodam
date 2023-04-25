<div align="center">
  <img src="https://user-images.githubusercontent.com/70800414/120181071-84b73d80-c247-11eb-8ca1-d39b83105443.png" height="100"/>
</div>

#
JSP + MySQL을 사용한 알레르기 관리 웹 프로젝트입니다.

## 💻 프로젝트 소개
식품 알레르기 환자들을 위한 안전한 제품 및 섭취 제한 식품 정보를 제공해주는 웹사이트입니다.<br/>
본 시스템의 기대효과는 대학병원 방문 없이 알레르기 원인을 예상할 수 있어 사용자의 시간과 부담을 감소시킬 수 있고, 시스템에 기록된 식단, 증상 데이터를 알레르기 치료 참고 자료로 사용하게 될 것입니다.

### 🕰 개발 기간
2020.09 ~ 2020.12

### 📚 개발 환경
![Java](https://img.shields.io/badge/Java-007396.svg?&style=for-the-badge&logo=Java&logoColor=white)
![HTML5](https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![css3](https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![jQuery](https://img.shields.io/badge/jquery-0769AD?style=for-the-badge&logo=jquery&logoColor=white)
![mySQL](https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=EclipseIDE&logoColor=white)
![ApacheTomcat](https://img.shields.io/badge/ApacheTomcat-F8DC75?style=for-the-badge&logo=ApacheTomcat&logoColor=black)

## 📱 주요 기능
### 1. 식단 관리 기능
#### (1) 식단 추가
- Ajax를 사용하여 섭취한 음식명을 비동기 방식으로 검색
- 사용자가 선택한 음식을 MySQL Table에 추가
- 식단 이미지 업로드
#### (2) 식단 리스트
- jqGrid를 사용하여 식단 리스트 시각화
#### 📷 View
<table>
  <tr>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234186604-61acba0a-096e-468f-a914-0abe12c7d54e.png" width="500" alt=""/> <br/>
      <sub><b> PIC1 : 식단 추가 </sub></b>
    </td>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234188841-7806c34f-1576-4e2c-bf0c-dc70f347216a.png" width="800" alt=""/> <br/>
      <sub><b> PIC2 : 식단 리스트 </sub></b>
    </td>
  </tr>
</table>

### 2. 증상 및 약 복용 정보 관리 기능
#### (1) 증상 추가 
- 증상이 발생한 날짜와 시간 선택
- 드롭박스: 증상의 종류 선택
- 라디오버튼: 증상 발생 위치 선택
#### (2) 약 복용 정보 추가
- 약을 복용한 날짜와 시간 선택
- 복용한 약 정보 
#### (3) 증상 및 약 복용 정보 리스트
- jqGrid를 사용하여 증상 리스트 시각화
#### 📷 View
<table>
  <tr>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234188972-6e5880d3-9e30-46e9-b78f-6bfb9573577c.png" width="500" alt=""/> <br/>
      <sub><b> PIC1 : 증상 추가 </sub></b>
    </td>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234189134-3e3db986-e135-4caf-a518-a6f631580eb7.png" width="800" alt=""/> <br/>
      <sub><b> PIC2 : 증상 리스트 </sub></b>
    </td>
  </tr>
</table>

### 3. 알레르기 원인 분석 기능
- 원인 분석 결과를 원형 그래프로 도식화
- 원인 분석 단계 <br/>
  (1) '증상 발생' 테이블에서 증상이 발생한 날짜와 시간 추출 <br/>
  (2) 증상 발생 12시간 전부터 증상 발생 시간까지 섭취한 음식들을 ‘식단’ 테이블에서 추출 <br/>
  (3) 추출한 음식 중 많이 섭취한 음식 50가지에 포함된 유발 식재료 찾기 <br/>
  (4) 해당 유발 식재료를 섭취했을 때 증상 발생률을 계산 <br/>
  (5) 증상 발생률이 60% 이상인 알레르기 유발 식재료를 발생률이 높은 순서대로 출력 <br/>
#### 📷 View
<table>
  <tr>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234192061-c74c91e9-74db-42a1-ab23-8462d695afa5.png" width="500" alt=""/> <br/>
      <sub><b> PIC1 : 알레르기 원인 분석 </sub></b>
    </td>
  </tr>
</table>

### 4. 증상 발생 분석 기능
- 월별 증상 발생률을 Chart.js의 Line 타입으로 도식화
- 차트의 하단에는 알레르기증상 데이터 분석 후 출력
#### 📷 View
<table>
  <tr>
    <td align="center">
      <img src="https://user-images.githubusercontent.com/70800414/234191548-bc25043c-3d70-429e-bf27-da6b85c13cd6.png" width="500" alt=""/> <br/>
      <sub><b> PIC1 : 증상 발생 변화 </sub></b>
    </td>
  </tr>
</table>
