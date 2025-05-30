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

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gaonna.yami.location.dao.LocationDao;
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
	
}