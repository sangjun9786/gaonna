package com.gaonna.yami.common;


import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/proxy")
public class StaticMapController {

    private final RestTemplate restTemplate = new RestTemplate();

    @GetMapping("/staticMap")
    public ResponseEntity<byte[]> getStaticMap(@RequestParam String lat, @RequestParam String lng) {

        String url = "https://naveropenapi.apigw.ntruss.com/map-static/v2/raster"
                + "?center=" + lng + "," + lat
                + "&level=16&w=300&h=200"
                + "&markers=type:d|size:mid|pos:" + lng + " " + lat;

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-NCP-APIGW-API-KEY-ID", "85oq183idp");
        headers.set("X-NCP-APIGW-API-KEY", "TYQrxCnbp5YP5tLC289l2g6wOg3Iq7TlB9k1tj0c");

        HttpEntity<String> request = new HttpEntity<>(headers);

        ResponseEntity<byte[]> response = restTemplate.exchange(url, HttpMethod.GET, request, byte[].class);

        return ResponseEntity
                .ok()
                .contentType(MediaType.IMAGE_PNG)
                .body(response.getBody());
        

    }
}
