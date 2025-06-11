package com.gaonna.yami.product.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.gaonna.yami.product.service.RecommendService;

@Controller
public class RecommendController {
	
	@Autowired
	private RecommendService service;
	
}
