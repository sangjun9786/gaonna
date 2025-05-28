package com.gaonna.yami.location.service;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Service;

import com.gaonna.yami.location.vo.Location;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class LocationServiceImpl implements LocationService{
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

	@Override
	public Location reverseGeocode(Location lo) throws Exception{
		
		//url 만들기
		String url = new StringBuilder()
				.append(reverseGeocoding)
				.append("?coords=")
				.append(lo.getLongitude())
				.append(",")
				.append(lo.getLatitude())
				.append("&output=json")
				.append("&orders=admcode")
				.toString();
		/*
		 * 법정동 : legalcode
		 * 행정동 : admcode
		 * 지번 : addr
		 * 도로명주소 : roadaddr
		 */
		
		//시그니처 생성
		String signature = makeSignature(url, lo.getTimestamp());
		
		//http형식으로 던지기
		HttpClient client = HttpClient.newHttpClient();
		HttpRequest request = HttpRequest.newBuilder()
		    .uri(URI.create(url))
		    .header("x-ncp-apigw-timestamp", lo.getTimestamp())
		    .header("x-ncp-iam-access-key", accessKey)
		    .header("x-ncp-apigw-signature-v2", signature)
		    .header("x-ncp-apigw-api-key-id", keyId)
		    .header("x-ncp-apigw-api-key", key)
		    .GET()
		    .build();
		
		//받아오기
		HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
		String result =  response.body();
		System.out.println(result);
		
		// JSON 파싱
	    JsonObject responseJson = JsonParser.parseString(result).getAsJsonObject();
	    JsonObject region = responseJson.getAsJsonArray("results")
	        .get(0).getAsJsonObject()
	        .getAsJsonObject("region");
	        
	    // 주소 정보 설정
	    lo.setArea1(region.getAsJsonObject("area1").get("name").getAsString());
	    lo.setArea2(region.getAsJsonObject("area2").get("name").getAsString());
	    lo.setArea3(region.getAsJsonObject("area3").get("name").getAsString());
	    
	    System.out.println(lo);
	    
		return lo;
	}

}

/* 네이버 api사용 응답 예제
{
  "status": {
    "code": 0,
    "name": "ok",
    "message": "done"
  },
  "results": [
    {
      "name": "legalcode",
      "code": {
        "id": "1156011700",
        "type": "L",
        "mappingId": "09560117"
      },
      "region": {
        "area0": {
          "name": "kr",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        },
        "area1": {
          "name": "서울특별시",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.978388,
              "y": 37.56661
            }
          },
          "alias": "서울"
        },
        "area2": {
          "name": "영등포구",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.896004,
              "y": 37.526436
            }
          }
        },
        "area3": {
          "name": "당산동",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.9065,
              "y": 37.5347
            }
          }
        },
        "area4": {
          "name": "",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        }
      }
    },
    {
      "name": "admcode",
      "code": {
        "id": "1156056000",
        "type": "A",
        "mappingId": "09560560"
      },
      "region": {
        "area0": {
          "name": "kr",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        },
        "area1": {
          "name": "서울특별시",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.978388,
              "y": 37.56661
            }
          },
          "alias": "서울"
        },
        "area2": {
          "name": "영등포구",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.896004,
              "y": 37.526436
            }
          }
        },
        "area3": {
          "name": "당산2동",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.897327,
              "y": 37.531048
            }
          }
        },
        "area4": {
          "name": "",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        }
      }
    },
    {
      "name": "addr",
      "code": {
        "id": "1156011700",
        "type": "L",
        "mappingId": "09560117"
      },
      "region": {
        "area0": {
          "name": "kr",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        },
        "area1": {
          "name": "서울특별시",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.978388,
              "y": 37.56661
            }
          },
          "alias": "서울"
        },
        "area2": {
          "name": "영등포구",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.896004,
              "y": 37.526436
            }
          }
        },
        "area3": {
          "name": "당산동",
          "coords": {
            "center": {
              "crs": "EPSG:4326",
              "x": 126.9065,
              "y": 37.5347
            }
          }
        },
        "area4": {
          "name": "",
          "coords": {
            "center": {
              "crs": "",
              "x": 0.0,
              "y": 0.0
            }
          }
        }
      },
      "land": {
        "type": "1",
        "number1": "74",
        "number2": "5",
        "addition0": {
          "type": "",
          "value": ""
        },
        "addition1": {
          "type": "",
          "value": ""
        },
        "addition2": {
          "type": "",
          "value": ""
        },
        "addition3": {
          "type": "",
          "value": ""
        },
        "addition4": {
          "type": "",
          "value": ""
        },
        "coords": {
          "center": {
            "crs": "",
            "x": 0.0,
            "y": 0.0
          }
        }
      }
    }
  ]
}
*/