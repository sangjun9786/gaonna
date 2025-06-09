package com.gaonna.yami.location.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gaonna.yami.location.service.LocationService;
import com.gaonna.yami.location.vo.Bakery;
import com.gaonna.yami.location.vo.BakeryComment;
import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.google.gson.Gson;

@Controller
public class LocationCotroller {
	@Autowired
	public LocationService service;
	
	//실험실
	@RequestMapping("currLo.lab")
	public String getLocation(HttpSession session, Model model, Coord coord) {
		try {
			session.removeAttribute("currLo");
			String currLo = service.reverseGeocode(coord);
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
			List<Location> result = service.geocode(address);
			session.setAttribute("currAdd", result);
			return "redirect:/lab";
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/lab";
		}
	}
	
	
	//ajax로 위치 검색
	@ResponseBody
	@RequestMapping("getGeocode.lo")
	public String getGeocode(HttpSession session
			, Model model, String inputAddress){
		try {
			List<Location> search = service
					.geocode(inputAddress);
	        String json = new Gson().toJson(search);
	        return json;
		} catch (Exception e) {
			e.printStackTrace();
			return "[]";
		}
	}
	
	//유저 배송지 추가
	@PostMapping("insertLocation.me")
	public String insertLocationMe(HttpSession session
			,Model model, Location lo
			,@RequestParam(name = "isMain", required = false)
				String isMain) {
		try {
			Member m = (Member)session.getAttribute("loginUser");
			int result=0;
			
			//이미 배송지가 5개 이상이면 가세요라
			List<Location> oldLocations =
					(List<Location>)session.getAttribute("location");
			if(oldLocations.size()>=5) {
				model.addAttribute("alertMsg","주소는 최대 5개 까지 등록 가능합니다.");
				return "redirect:/";
				
			}else if (
			    !lo.getRoadAddress().matches("^.{0,80}$") ||
			    !lo.getJibunAddress().matches("^.{0,80}$") ||
			    !lo.getDetailAddress().matches("^.{0,60}$") ||
			    !lo.getZipCode().matches("^\\d{1,8}$")){
				
			    model.addAttribute("alertMsg", "입력값이 허용 범위를 초과했습니다.");
			    return "common/errorPage";
			}else if(isMain==null) {
				//메인 배송지가 아닐 때
				result = service.insertLocationMe(m,lo);
				
			}else if(isMain.equals("Y")) {
				//메인 배송지일때
				result = service.insertMainLocation(session,m,lo);
			}
			
			
			if(result>0) {
				return "redirect:deliveryAddress.me";
			}else {
				throw new Exception();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("alertMsg","주소 추가에 실패했습니다.");
			return "common/errorPage";
		}
	}
	
	
	//ajax로 위치 검색
	@ResponseBody
	@RequestMapping("getReverseGeocode.lo")
	public String getGeocode(HttpSession session
			, Model model, Coord coord){
		try {
			Location lo = service.reverseGeocodeLo(coord);
	        String json = new Gson().toJson(lo);
	        return json;
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	
	//동네(location) 메인으로
	@GetMapping("dongneMain.dn")
	public String dongneMain(HttpSession session,Model model){
		try {
			List<Coord> coords = (List<Coord>)session.getAttribute("coords");
			Member m = (Member)session.getAttribute("loginUser");
			
			//유저의 대표동네 추출
			Coord mainCoord = null;
			for(Coord c : coords) {
				if(c.getCoordNo() == m.getMainCoord()) {
					mainCoord = c;
					break;
				}
			}
			System.out.println("컨트롤러, 대표동네 : "+mainCoord);
			
			//model에 json형식으로 bakery조회
			List<Bakery> bakeries = service.selectBakeries(mainCoord);
			System.out.println("컨트롤러, bakeries : "+bakeries);
			String bakeriesJson = new Gson().toJson(bakeries);
			model.addAttribute("bakeriesJson", bakeriesJson);
			
			return "dongne/map";
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("alertMsg","500 err");
			return "common/errorPage";
		}
	}
	
	@PostMapping("selectBakeryComment.dn")
	public Map<String, Object> selectBakeryComment(int bakeryNo, int page) {
		try {
			List<BakeryComment> bakeryComments = service.selectBakeryComment(bakeryNo,page);
			
		    Map<String, Object> response = new HashMap<>();
		    response.put("comments", bakeryComments);
//		    response.put("hasNext", hasNext);
		    response.put("status", "pass");
		    return response;
		} catch (Exception e) {
			e.printStackTrace();
			Map<String, Object> response = new HashMap<>();
			response.put("status", "noPass");
			return response;
		}
	}
	
	
	
	
	
	
	
	
}
