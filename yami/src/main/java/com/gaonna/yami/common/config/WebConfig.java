package com.gaonna.yami.common.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	
	 @Override
	 public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /resources/uploadFiles/** 로 요청이 들어오면
        // 실제 파일 시스템 C:/upload/ 디렉토리에서 파일을 제공하도록 매핑
        registry.addResourceHandler("/resources/uploadFiles/**")
                .addResourceLocations("file:///C:/upload/");
        
        // 예) <img src="/resources/uploadFiles/파일명.jpg">로 요청 시
        // 실제 C:/upload/파일명.jpg를 반환함
	}
}
