package com.gaonna.yami.location.service;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.location.dao.LocationDao;
import com.gaonna.yami.location.vo.Bakery;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class LocationServiceImpl implements LocationService{
	@Autowired
	private SqlSessionTemplate sqlSession;
	@Autowired
	private LocationDao dao;
	
    String staticMap;
    String directions5;
    String directions15;
    String geocoding;
    String reverseGeocoding;
    String keyId;
    String key;
    String accessKey;
    String secretKey;
    
	public LocationServiceImpl() {
		try(
			InputStream is = LocationServiceImpl.class.getClassLoader()
            	.getResourceAsStream("naverCloudMaps.json");
            InputStreamReader reader = new InputStreamReader(is))
		{
			 // 최상위 JSON 객체 파싱
            JsonObject root = JsonParser.parseReader(reader).getAsJsonObject();

            // urls 내부 객체에 접근
            JsonObject urls = root.getAsJsonObject("urls");
            staticMap = urls.get("staticMap").getAsString();
            directions5 = urls.get("directions5").getAsString();
            directions15 = urls.get("directions15").getAsString();
            geocoding = urls.get("geocoding").getAsString();
            reverseGeocoding = urls.get("reverseGeocoding").getAsString();

            // keys 내부 객체 접근
            JsonObject keys = root.getAsJsonObject("keys");
            keyId = keys.get("keyId").getAsString();
            key = keys.get("key").getAsString();
            accessKey = keys.get("accessKey").getAsString();
            secretKey = keys.get("secretKey").getAsString();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
	/*
	//시그니처 생성 - url과 timestamp쥐어주고 시그니처 만들기
	public String makeSignature(String url, String timestamp) throws Exception {
		String space = " ";
		String newLine = "\n";
		String method = "GET";
		
		String message = new StringBuilder()
			.append(method)
			.append(space)
			.append(url)
			.append(newLine)
			.append(timestamp)
			.append(newLine)
			.append(accessKey)
			.toString();
		
		SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes("UTF-8"), "HmacSHA256");
		Mac mac = Mac.getInstance("HmacSHA256");
		mac.init(signingKey);
		
		byte[] rawHmac = mac.doFinal(message.getBytes("UTF-8"));
		String encodeBase64String = Base64.getEncoder().encodeToString(rawHmac);
			
		return encodeBase64String;
	}
	*/

	@Override
	public String reverseGeocode(Coord coord) throws Exception{
		
		//url 만들기
		String url = new StringBuilder()
				.append(reverseGeocoding)
				.append("?coords=")
				.append(coord.getLongitude())
				.append(",")
				.append(coord.getLatitude())
				.append("&output=json")
				.append("&orders=admcode")
				.toString();
		/*
		 * 법정동 : legalcode
		 * 행정동 : admcode
		 * 지번 : addr
		 * 도로명주소 : roadaddr
		 */
		
		
		//http형식으로 던지기
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
		    .uri(URI.create(url))
		    .header("x-ncp-apigw-api-key-id", keyId)
		    .header("x-ncp-apigw-api-key", key)
		    .GET()
		    .build();
		
		//받아오기
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String result =  response.body();
		
		// JSON 파싱
	    JsonObject responseJson = JsonParser.parseString(result).getAsJsonObject();
	    JsonObject region = responseJson.getAsJsonArray("results")
	        .get(0).getAsJsonObject()
	        .getAsJsonObject("region");
	        
	    // 주소 정보 설정
	    String address = new StringBuilder()
				.append(region.getAsJsonObject("area1").get("name").getAsString())
				.append(" ")
				.append(region.getAsJsonObject("area2").get("name").getAsString())
				.append(" ")
				.append(region.getAsJsonObject("area3").get("name").getAsString())
				.append(" ")
				.append(region.getAsJsonObject("area4").get("name").getAsString())
				.toString();
	    
		return address;
	}
	
	@Override
	public Location reverseGeocodeLo(Coord coord) throws Exception {
	    // URL 생성 (orders=roadaddr,addr - 도로명, 지번 주소 동시 요청)
	    String url = new StringBuilder()
	        .append(reverseGeocoding)
	        .append("?coords=")
	        .append(coord.getLongitude())
	        .append(",")
	        .append(coord.getLatitude())
	        .append("&output=json")
	        .append("&orders=roadaddr,addr")
	        .toString();

	    // HTTP 요청 전송
	    HttpClient client = HttpClient.newHttpClient();
	    HttpRequest request = HttpRequest.newBuilder()
	        .uri(URI.create(url))
	        .header("x-ncp-apigw-api-key-id", keyId)
	        .header("x-ncp-apigw-api-key", key)
	        .GET()
	        .build();

	    HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
	    String result = response.body();

	    // JSON 파싱
	    JsonObject responseJson = JsonParser.parseString(result).getAsJsonObject();
	    JsonArray results = responseJson.getAsJsonArray("results");
	    
	    Location location = new Location();
	    
	    for (JsonElement element : results) {
	        JsonObject resultObj = element.getAsJsonObject();
	        String resultType = resultObj.get("name").getAsString();
	        
	        // 도로명 주소 처리
	        if ("roadaddr".equals(resultType)) {
	            JsonObject region = resultObj.getAsJsonObject("region");
	            String area1 = region.getAsJsonObject("area1").get("name").getAsString(); // 시/도
	            String area2 = region.getAsJsonObject("area2").get("name").getAsString(); // 시/군/구
	            
	            // 도로명 주소 조합
	            String roadPart = resultObj.has("roadAddress") 
	                ? resultObj.get("roadAddress").getAsString() 
	                : resultObj.getAsJsonObject("land").get("name").getAsString() + " " 
	                  + resultObj.getAsJsonObject("land").get("number1").getAsString();
	            
	            location.setRoadAddress(area1 + " " + area2 + " " + roadPart);

	            // 우편번호 처리
	            if (resultObj.has("zipCode")) {
	                location.setZipCode(resultObj.get("zipCode").getAsString());
	            } else {
	                JsonObject land = resultObj.getAsJsonObject("land");
	                if (land.has("addition1")) {
	                    JsonObject addition1 = land.getAsJsonObject("addition1");
	                    if ("zipcode".equals(addition1.get("type").getAsString())) {
	                        location.setZipCode(addition1.get("value").getAsString());
	                    }
	                }
	            }
	        }

	        
	        //지번 주소
	        else if ("addr".equals(resultType)) {
	            JsonObject region = resultObj.getAsJsonObject("region");
	            StringBuilder jibunAddress = new StringBuilder();
	            
	            jibunAddress.append(region.getAsJsonObject("area1").get("name").getAsString()).append(" ");
	            jibunAddress.append(region.getAsJsonObject("area2").get("name").getAsString()).append(" ");
	            jibunAddress.append(region.getAsJsonObject("area3").get("name").getAsString());
	            
	            JsonObject land = resultObj.getAsJsonObject("land");
	            jibunAddress.append(" ").append(land.get("number1").getAsString());
	            if (!land.get("number2").getAsString().isEmpty()) {
	                jibunAddress.append("-").append(land.get("number2").getAsString());
	            }
	            
	            location.setJibunAddress(jibunAddress.toString());
	        }
	    }
	    return location;
	}


	
	@Override
	public List<Location> geocode(String inputAddress) throws Exception{
		
		inputAddress = URLEncoder.encode(inputAddress, StandardCharsets.UTF_8.toString());
		
		String url = new StringBuilder()
				.append(geocoding)
				.append("?query=")
				.append(inputAddress)
				.toString();
		
		//http형식으로 던지기
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
		    .uri(URI.create(url))
		    .header("Accept", "application/json")
		    .header("x-ncp-apigw-api-key-id", keyId)
		    .header("x-ncp-apigw-api-key", key)
		    .GET()
		    .build();
		
		//받아오기
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String result =  response.body();
	    List<Location> locations = new ArrayList<>();
	    
	    JsonObject root = JsonParser.parseString(result).getAsJsonObject();
	    JsonArray addresses = root.getAsJsonArray("addresses");

	    for (JsonElement element : addresses) {
	        JsonObject address = element.getAsJsonObject();
	        Location location = new Location();
	        
	        location.setRoadAddress(address.get("roadAddress").getAsString());
	        location.setJibunAddress(address.get("jibunAddress").getAsString());
	        
	        JsonArray addressElements = address.getAsJsonArray("addressElements");
	        for (JsonElement elem : addressElements) {
	            JsonObject item = elem.getAsJsonObject();
	            JsonArray types = item.getAsJsonArray("types");
	            
	            for (JsonElement type : types) {
	            	if(type.getAsString().equals("POSTAL_CODE")) {
	            		location.setZipCode(item.get("longName").getAsString());
	            		break;
	            	}
	            }
	        }
	        locations.add(location);
	    }
	    return locations;
	}
	
	@Override
	public List<Coord> selectUserDongne(int userNo) {
		return dao.selectUserDongne(sqlSession,userNo);
	}
	
	@Override
	public int insertDongneMain(Coord currCoord, Member loginUser) {
		
		//currCoord를 coords에 저장하고 currCoord에 coordNo받아옴
		int result = dao.insertDongne(sqlSession,currCoord);
		
		//MEMBER_COORDS에 userNo, coordNo넣기
		Map<String, Integer> memberCoords = new HashMap<>();
		memberCoords.put("userNo", loginUser.getUserNo());
		memberCoords.put("coordNo", currCoord.getCoordNo());
		result *= dao.insertMemberCoords(sqlSession,memberCoords);

		//member의 MAIN_COORD수정
		loginUser.setMainCoord(currCoord.getCoordNo());
		result *= dao.updateMainCoord(sqlSession,loginUser);
		
		return result;
	}
	
	@Override
	public int insertDongne(Coord currCoord, Member loginUser) {
		
		//currCoord를 coords에 저장하고 currCoord에 coordNo받아옴
		int result = dao.insertDongne(sqlSession,currCoord);
		
		//MEMBER_COORDS에 userNo, coordNo넣기
		Map<String, Integer> memberCoords = new HashMap<>();
		memberCoords.put("userNo", loginUser.getUserNo());
		memberCoords.put("coordNo", currCoord.getCoordNo());
		result *= dao.insertMemberCoords(sqlSession,memberCoords);
		return result;
	}
	
	@Override
	public int deleteCoord(int coordNo) {
		//coords 테이블에서 지우기
		//member-coords테이블은 delete on cascade가 걸렸으므로 건드릴 필요없다
		return dao.deleteCoord(sqlSession,coordNo);
	}
	
	@Override
	public List<Location> selectLocation(Member m) {
		return dao.selectLocation(sqlSession,m);
	}
	
	@Transactional
	@Override
	public int deleteUserLocation(HttpSession session,Member m, int locationNo) {
		
		int result = 1;
		
		//유저 대표 배송지일 경우 대표 배송지 지워버리기
		if(m.getMainLocation() == locationNo) {
			result *= dao.deleteMainLocation(sqlSession,m);
			
			if(result>0) {
				//세선 업데이트
				m.setMainLocation(0);
				session.setAttribute("loginUser", m);
			}
		}
		
		//location테이블에서 삭제하기
		//member-location테이블은 delete on cascade가 걸렸으므로 건드릴 필요없다
		result *= dao.deleteLocation(sqlSession,locationNo);
		
		return result;
	}
	
	@Override
	public int updateMainlocation(Member m) {
		return dao.updateMainLocation(sqlSession,m);
	}
	
	//배송지 추가하기
	@Transactional
	@Override
	public int insertLocationMe(Member m, Location lo) {
		int result = 1;
		//location넣기
		result *= dao.insertLocationMe(sqlSession,lo);
		
		//MEMBER_LOCARION에 userNo, locationNo넣기
		Map<String, Integer> memberLocation = new HashMap<>();
		memberLocation.put("userNo", m.getUserNo());
		memberLocation.put("locationNo", lo.getLocationNo());
		result *= dao.insertMemberLocation(sqlSession,memberLocation);
		return result;
	}
	
	//메인 배송지 추가하기
	@Override
	public int insertMainLocation(HttpSession session
			,Member m, Location lo) {
		int result = 1;
		
		//location넣기
		result *= dao.insertLocationMe(sqlSession,lo);
		
		//MEMBER_LOCARION에 userNo, locationNo넣기
		Map<String, Integer> memberLocation = new HashMap<>();
		memberLocation.put("userNo", m.getUserNo());
		memberLocation.put("locationNo", lo.getLocationNo());
		result *= dao.insertMemberLocation(sqlSession,memberLocation);
		
		//mainLocation업데이트
		result *= dao.updateMainLocation(sqlSession,m);
		
		//member세션 업데이트
		m.setMainLocation(lo.getLocationNo());
		session.setAttribute("loginUser", m);
		return result;
	}
	
	
	//-------------------동네빵집 나와바리-------------------
	
	//동네빵집 조회
	@Override
	public List<Bakery> selectBakeries(Coord mainCoord) {
		List<Bakery> result = dao.selectBakeries(sqlSession,mainCoord);
		new Bakery().bakerySDF(result);
		return result;
	}
	
	//댓글 조회
	@Override
	public List<BakeryComment> selectBakeryComment(String bakeryNo, int page) {
		
		//page 유효성 검사
		if(page<=0) {
			page=1;
		}
		
		int startRow = (page-1)*10+1;
		int endRow = page*10;
		
		Map<String, Object> map = new HashMap<>();
		map.put("bakeryNo", bakeryNo);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		
		List<BakeryComment> result = dao.selectBakeryComment(sqlSession,map);
		
		
		
		//parentCommentNo를 기반으로 bakeryComment조회하기
		Map<String, Object> map2 = new HashMap<>();
		map2.put("bakeryNo", bakeryNo);
		map2.put("startRow", 1);
		map2.put("endRow", 10);
		List<BakeryComment> recomment = new ArrayList<>();
		List<BakeryComment> tempList = new ArrayList<>(); //임시 저장용
		
		//parentCommentNo 반복문 돌려서 대댓글 추가하기
		if(result.size()>0) {
			for(BakeryComment comment : result) {
				map2.put("parentCommentNo", comment.getCommentNo());
				recomment = dao.selectBakeryRecomment(sqlSession,map2);
				tempList.addAll(recomment);
			}
			
			result.addAll(tempList);
		}
		
		new BakeryComment().bakeryCommentSDF(result);
		return result;
	}
	
	//대댓글 조회
	@Override
	public List<BakeryComment> selectBakeryRecomment(String bakeryNo, int page, int parentCommentNo) {
		
		//page 유효성 검사
		if(page<=0) {
			page=1;
		}
		
		int startRow = (page-1)*10+1;
		int endRow = page*10;
		
		Map<String, Object> map = new HashMap<>();
		map.put("bakeryNo", bakeryNo);
		map.put("startRow", startRow);
		map.put("endRow", endRow);
		map.put("parentCommentNo", parentCommentNo);
		
		List<BakeryComment> result = dao.selectBakeryRecomment(sqlSession,map);
		new BakeryComment().bakeryCommentSDF(result);
		return result;
	}
	
	
	//댓글 넣기
	@Override
	public int insertBakeryComment(Map<String, Object> map) {
		//유효성 검사
		if(((String)map.get("commentContent")).length() > 100) {
			return 0;
		}else if(!((String)map.get("bakeryLike")).equals("L")
				&& !((String)map.get("bakeryLike")).equals("D")) {
			return 0;
		}
		return dao.insertBakeryComment(sqlSession,map);
	}
	
	//대댓글 넣기
	@Override
	public int insertBakeryRecomment(Map<String, Object> map) {
		//유효성 검사
		if(((String)map.get("commentContent")).length() > 100) {
			return 0;
		}
		return dao.insertBakeryRecomment(sqlSession,map);
	}
	
	//댓글 수정하기
	@Override
	public int updateBakeryComment(Map<String, Object> map) {
		//유효성 검사
		if(((String)map.get("commentContent")).length() > 100) {
			return 0;
		}
		switch (((String)map.get("bakeryLike"))) {
		case "L":
		case "D":
		case "P":
			break;
		default:
			return 0;
		}
		return dao.updateBakeryComment(sqlSession,map);
	}
	
	//댓글 삭제하기
	@Override
	public int deleteBakeryComment(int commentNo) {
		return dao.deleteBakeryComment(sqlSession,commentNo);
	}
}