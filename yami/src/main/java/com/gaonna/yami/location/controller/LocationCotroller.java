package com.gaonna.yami.location.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Location;

@Controller
public class LocationCotroller {
	@Autowired
	public LocationService service;
	
	// https://api.ncloud-docs.com/docs/application-maps-overview
	
	//실험실
	@RequestMapping("currLo.lab")
	public String getLocation(HttpSession session, Model model, Location lo) {
		try {
			session.removeAttribute("currLo");
			if(lo.getLatitude()==null) {
				session.setAttribute("alertMsg", "위치확인 필수!!!");
			}
			Location currLo = service.reverseGeocode(lo);
			session.setAttribute("currLo", currLo);
			return "redirect:/lab";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/lab";
		}
	}
	@RequestMapping("address.lab")
	public String getAddress(HttpSession session, Model model, String address) {
		try {
			session.removeAttribute("currAdd");
			List<String> result = service.geocode(address);
			session.setAttribute("currAdd", result);
			return "redirect:/lab";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/lab";
		}
	}
}
