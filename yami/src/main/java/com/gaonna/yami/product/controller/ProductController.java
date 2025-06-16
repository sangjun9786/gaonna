package com.gaonna.yami.product.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.gaonna.yami.chat.model.service.ChatService;
import com.gaonna.yami.chat.model.vo.ChatRoom;
import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.service.ProductService;
import com.gaonna.yami.product.service.ReplyService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.product.vo.Reply;
import com.gaonna.yami.wishlist.model.service.WishlistService;

@Controller
public class ProductController {

    @Autowired
    private ProductService service;

    @Autowired
    private ReplyService replyService;
    
    @Autowired
    private WishlistService wishlistService; // ✅ 이거 추가해줘야 빨간줄 사라짐
    
    @Autowired
    private ChatService chatService;

	//test 리스트 
    @RequestMapping("productList2.pro")
	public String productList(@RequestParam(value = "currentPage", defaultValue = "1") 
							 int currentPage
							,@RequestParam(value = "selectedLocation", defaultValue = "0") 
							 String selectedLocation
							,@RequestParam(value = "selectedCategory", defaultValue = "0") 
							 int selectedCategory
							,Model model) {
		
		//0. 페이지 필터 정보 초기화
		if(selectedLocation.equals("0")) {
			model.addAttribute("selectedLocation", "0");
		}
		if(selectedCategory == 0) {
			model.addAttribute("selectedCategory", 0);
		}
		
	    // 1. 전체 상품 개수
	    int listCount = service.getListCount();

	    // 2. 페이징 관련 설정
	    int boardLimit = 12; // 한 페이지당 보여줄 상품 수
	    int pageLimit = 5;   // 페이징바에 표시될 페이지 수

	    // 3. 페이징 정보 생성
	    PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);

	    // 4. 현재 페이지에 해당하는 상품 목록 조회
	    ArrayList<Product> list = service.selectProductList(pi); // 페이징 적용된 DAO 메서드

	    // 5. JSP에 전달
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);

	    // 6. 렌더링할 JSP
//	    return "product/productList2";
	    return "redirect:/filter.bo?currentPage=1&location=all&category=0";
	    
	}
    
    // 상세 페이지
    @GetMapping("/productDetail.pro")
    public String productDetail(@RequestParam("productNo") int productNo, Model model, HttpSession session) {
    	int result = service.increaseCount(productNo);
        if (result <= 0) {
            model.addAttribute("errorMsg", "게시글 조회 실패!!");
            return "common/errorPage";
        }

        Product product = service.selectProductDetail(productNo);

        ArrayList<Attachment> atList = service.selectProductAttachments(productNo);
        product.setAtList(atList);
        
     // ✅ 좋아요 개수 조회 추가
        int count = wishlistService.getWishCount(productNo);
        model.addAttribute("wishCount", count); // << 이거 추가
        
     // 로그인유저 체크
        Member loginUser = (Member) session.getAttribute("loginUser");
     // 로그인한 경우만 채팅 방 여부 확인 (6/15 상준 에러 수정)
        if (loginUser != null) {
            if (loginUser.getUserNo() != product.getUserNo()) {
                ChatRoom room = chatService.findRoomByUsersAndProduct(
                    product.getUserNo(), loginUser.getUserNo(), productNo
                );
                model.addAttribute("alreadyChatted", room != null);
            }
        } else {
            model.addAttribute("alreadyChatted", false); // 로그인 안했으면 채팅방 없음 처리
        }

        model.addAttribute("product", product);
        return "product/productDetail";
    }

    // 파일 업로드
 	public String saveFile(
 						   MultipartFile uploadFile, 
 						   HttpSession session) {
 		//1.원본 파일명 추출
 		String originName = uploadFile.getOriginalFilename();
 		
 		//2.시간 형식 문자열로 추출
 		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

 		//3.랜덤값 5자리 추출
 		int ranNum = (int) (Math.random() * 90000 + 10000);
 		//4.원본파일에서 확장자 추출
 		String ext = originName.substring(originName.lastIndexOf("."));

 		//5.합치기
 		String changeName = currentTime + ranNum + ext;

 		//6. 서버에 업로드 처리할때 물리적인 경로 추출하기
 		String savePath = session.getServletContext().getRealPath("/resources/uploadFiles/");
 		
 		//7.경로와 변경된 이름을 이용하여 파일 업로드 처리 메소드 수행
 		//MultipartFile 의 transferTo() 메소드 이용

 		try {
 			uploadFile.transferTo(new File(savePath + changeName));
 			return changeName;
 		} catch (IllegalStateException | IOException e) {
 			// TODO Auto-generated catch block
 			e.printStackTrace();
 			return null; //저장 실패 시 null 반환
 		}

 	}

    // 댓글 등록
    @PostMapping("/insertReply")
    @ResponseBody
    public String insertReply(Reply r, HttpSession session) {
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "fail";
        }
        r.setUserId(loginUser.getUserId());
        int result = replyService.insertReply(r);
        return result > 0 ? "success" : "fail";
    }

    // 등록 이동
    @GetMapping("productEnrollForm.pr")
    public String productEnroll(Model model, HttpSession session) {
        // 카테고리 리스트
        ArrayList<Category> categoryList = service.selectCategoryList();
        model.addAttribute("categoryList", categoryList);

        // 로그인 유저 정보
        Member loginUser = (Member) session.getAttribute("loginUser");
        if (loginUser != null) {
            int userNo = loginUser.getUserNo();

            // 메인 위치 정보 조회
            Location mainLocation = service.selectMainLocationByUserNo(userNo);

            if (mainLocation != null) {
                model.addAttribute("mainLocation", mainLocation); // JSP에서 사용 가능
            }
        }

        return "product/productEnrollForm";
    }
	
	//등록 
	@PostMapping("productEnrollForm.pr")
	public String insertProduct(Product p
            					,@RequestParam("thumbnail") MultipartFile thumbnail
            					,@RequestParam(value = "uploadFiles", required = false)ArrayList<MultipartFile> uploadFiles
								,HttpSession session) {
		
		ArrayList<Attachment> atList = new ArrayList<>(); //천부파일 정보들 등록할 리스트
		
		//대표 이미지
	    if (!thumbnail.isEmpty()) {
	        String changeName = saveFile(thumbnail, session);
	        if (changeName == null) {
	            session.setAttribute("alertMsg", "대표 이미지 저장 실패!");
	            return "common/errorPage";
	        }
	        Attachment at = new Attachment();
	        at.setChangeName(changeName);
	        at.setOriginName(thumbnail.getOriginalFilename());
	        at.setFilePath("/resources/uploadFiles/");
	        at.setFileLevel(1); // 대표
	        atList.add(at);
	    }
	    

	    //상세 이미지
	    if(uploadFiles != null && !uploadFiles.isEmpty()) {
	    	for (MultipartFile file :  uploadFiles) {
		        if (file == null || file.isEmpty()) continue;
		        String changeName = saveFile(file, session);
		        if (changeName == null) continue;
		        Attachment at = new Attachment();
		        at.setChangeName(changeName);
		        at.setOriginName(file.getOriginalFilename());
		        at.setFilePath("/resources/uploadFiles/");
		        at.setFileLevel(2); // 상세
		        atList.add(at);
		    	System.out.println("파일명: " + file.getOriginalFilename());
		    }
	    }
		//서비스에 요청
		int result = service.insertProduct(p,atList);
		
		if(result>0) { //등록 성공
			session.setAttribute("alertMsg", "상품 등록이 성공적으로 처리 되었습니다.");
//			return "redirect:/productList2.pro";
//			return "redirect:/productList2.pro?currentPage=1&selectedLocation=0&selectedCategory=0";
			return "redirect:/filter.bo?currentPage=1&location=all&category=0";
		}else {
			session.setAttribute("alertMsg", "상품 등록이 실패!!");
			return "common/errorPage";
		}
		

	}
	
	
	//게시글 삭제
	@RequestMapping("delete.pro")
	public String deleteProduct(int productNo
							  ,String filePath
							  ,HttpSession session) {
		
		//삭제 요청 및 처리
		//성공시 게시글 삭제 성공 메시지를 담고 게시글 목록페이지로 재요청
		//실패시 게시글 삭제 실패 메시지를 담고 기존 상세페이지로 재요청
		int result = service.deleteProduct(productNo);
		
		if(result>0) {
			session.setAttribute("alertMsg", "게시글 삭제 성공!");
			
			//만약 파일 정보가 있었다면 파일 삭제 시키기
			if(!filePath.equals("")){//파일경로가 빈문자열이 아니라면(파일이 있다면)
				
				//파일객체로 해당 파일위치 연결하여 삭제 메소드 작성
				new File(session.getServletContext().getRealPath(filePath)).delete();				
			}
//			return "redirect:/productList2.pro";//게시글 목록페이지로 재요청
//			return "redirect:/productList2.pro?currentPage=1&selectedLocation=0&selectedCategory=0";
			return "redirect:/filter.bo?currentPage=1&location=all&category=0";

		}else {
			session.setAttribute("alertMsg", "게시글 삭제 실패!");
			return "redirect:/productDetail.pro?productNo="+productNo;
		}
		
	}
	
	//게시글 수정
	@GetMapping("update.pro")
	public String ProductUpdate(int productNo
								 ,Model model) {
		
		//글번호로 게시글 정보 조회
		Product p =service.selectProductDetail(productNo);
		
		ArrayList<Category> categoryList = service.selectCategoryList();
		
	 	//위임하는 페이지에 게시글 정보 담아가기
		model.addAttribute("p",p);
		model.addAttribute("categoryList", categoryList);
		
		return "product/productUpdate";
	}
	
	//게시글 수정 등록작업 메소드
	@PostMapping("update.pro")
	public String productUpdate(
	        Product p,
	        @RequestParam(value = "thumbnail", required = false) MultipartFile thumbnail,
	        @RequestParam(value = "uploadFiles", required = false) ArrayList<MultipartFile> uploadFiles,
	        @RequestParam(value = "keepDetailFiles", required = false) String[] keepDetailFiles,
	        HttpSession session) {

	    ArrayList<Attachment> atList = new ArrayList<>();

	    // 대표 이미지
	    if (thumbnail != null && !thumbnail.isEmpty()) {
	        String origin = thumbnail.getOriginalFilename();
	        String change = saveFile(thumbnail, session);
	        Attachment at = new Attachment();
	        at.setFileLevel(1);
	        at.setOriginName(origin);
	        at.setChangeName(change);
	        at.setFilePath("/resources/uploadFiles/");
	        atList.add(at);
	    } else if (p.getChangeName() != null && !p.getChangeName().isEmpty()) {
	        Attachment at = new Attachment();
	        at.setFileLevel(1);
	        at.setOriginName(p.getOriginName());
	        at.setChangeName(p.getChangeName());
	        at.setFilePath("/resources/uploadFiles/");
	        atList.add(at);
	    }

	    // 기존 유지할 상세 이미지
	    if (keepDetailFiles != null) {
	        for (String fileName : keepDetailFiles) {
	            if (fileName != null && !fileName.trim().isEmpty()) {
	                Attachment at = new Attachment();
	                at.setFileLevel(2);
	                at.setChangeName(fileName);
	                at.setOriginName(fileName); // 실제 원본명을 따로 조회하지 않는다면 동일하게 넣음
	                at.setFilePath("/resources/uploadFiles/");
	                atList.add(at);
	            }
	        }
	    }

	    // 새로 업로드된 상세 이미지
	    if (uploadFiles != null && !uploadFiles.isEmpty()) {
	        for (MultipartFile mf : uploadFiles) {
	            if (mf != null && !mf.isEmpty()) {
	                String origin = mf.getOriginalFilename();
	                String change = saveFile(mf, session);
	                Attachment at = new Attachment();
	                at.setFileLevel(2);
	                at.setOriginName(origin);
	                at.setChangeName(change);
	                at.setFilePath("/resources/uploadFiles/");
	                atList.add(at);
	            }
	        }
	    }

	    // 상세 이미지 3개 제한
	    long detailCount = atList.stream().filter(a -> a.getFileLevel() == 2).count();
	    if (detailCount > 3) {
	        session.setAttribute("errorMsg", "상세 이미지는 최대 3개까지 등록 가능합니다.");
	        return "common/errorPage";
	    }

	    // 서비스 호출
	    int result = service.productUpdate(p, atList);
	    session.setAttribute("alertMsg", result > 0 ? "게시글 수정 성공!" : "게시글 수정 실패!");

	    return "redirect:/filter.bo?currentPage=1&location=all&category=0";
	}
	
	
    // 댓글 목록
    @GetMapping("/replyList")
    @ResponseBody
    public List<Reply> replyList(@RequestParam("productNo") int productNo) {
        System.out.println("📍 댓글 불러오기: " + productNo);
        return replyService.selectReplyList(productNo);
    }
    
    //댓글 업데이트
    @PostMapping("updateReply")
    @ResponseBody
    public String updateReply(HttpSession session
    		,Reply reply) {
    	try {
    		Member m = (Member)session.getAttribute("loginUser");
    		if(m.getRoleType() == "N" &&
    				m.getUserId() != reply.getUserId()) {
    			return "fail";
    		}
    		
    		int result = replyService.updateReply(reply);
    		
    		if(result>0) {
    			return "success";
    		}else {
    			return "fail";
    		}
		} catch (Exception e) {
			session.setAttribute("alertMsg", "댓글 수정 실패");
			e.printStackTrace();
			return "fail";
		}
    }
    
    //예상 금액 페이지 (포인트, 거래 넘기기)
    @PostMapping("/productPay")
    public String productPay(
					         @RequestParam("productNo") int productNo
					        ,Order o
					        ,Model model
					        ,HttpSession session){
    	
        // 1. 상품 정보 불러오기
        Product product = service.selectProductDetail(productNo);
        ArrayList<Attachment> atList = service.selectProductAttachments(productNo);
        product.setAtList(atList);
        
        // 2. 로그인 유저 정보도 model에 담기
        Member m = (Member) session.getAttribute("loginUser");
        model.addAttribute("loginUser", m);
        model.addAttribute("product", product);
        model.addAttribute("order", o);
        model.addAttribute("product", product);
        return "product/productPay";

    }
    
    //댓글 삭제
    @PostMapping("deleteReply")
    @ResponseBody
    public String deleteReply(HttpSession session
    		,Reply reply) {
    	try {
    		Member m = (Member)session.getAttribute("loginUser");
    		if(m.getRoleType() == "N" &&
    				m.getUserId() != reply.getUserId()) {
    			return "fail";
    		}
    		
    		int result = replyService.deleteReply(reply);
    		
    		if(result>0) {
    			return "success";
    		}else {
    			return "fail";
    		}
		} catch (Exception e) {
			session.setAttribute("alertMsg", "댓글 수정 실패");
			e.printStackTrace();
			return "fail";
		}
    }
    
	// 구매하기 (구매자 정보 및 메시지 전달)
	@GetMapping("/buyProduct")
	public String buyProduct(@RequestParam("productNo") 
							  int productNo
							  ,Order o
							  ,Model model
							  ,HttpSession session) {
	    // 1. 상품 정보 조회
	    Product product = service.selectProductDetail(productNo);
	    ArrayList<Attachment> atList = service.selectProductAttachments(productNo);
	    product.setAtList(atList);
	    
	    // 2. (옵션) 로그인 유저 정보 (세션에서 꺼낼 수 있음)
	    Member m = (Member) session.getAttribute("loginUser");
	    
	    // 3. 판매자의 mainLocation 조회
	    Location mainLocation = null;
	    if (product != null && product.getUserNo() > 0) {
	        mainLocation = service.selectMainLocationByUserNo(product.getUserNo());
	    }
	
	    // 3. 모델에 상품/유저/거래 정보 담기
	    model.addAttribute("order", o);
	    model.addAttribute("product", product);
	    model.addAttribute("loginUser", m);
	    model.addAttribute("mainLocation", mainLocation); 
	    // 4. 구매 폼 페이지로 이동
	    return "product/productBuy";
	}
    
	    //거래 진행 페이지(주문 요약, 구매 확정 , 취소)
    
    @PostMapping("/productOrder")
    public String productOrder(@RequestParam("productNo") int productNo
            				   ,Order o             
            				   ,Model model
            				   ,HttpSession session
    						   ){
        // 1. 상품 정보 불러오기
        Product product = service.selectProductDetail(productNo);
        ArrayList<Attachment> atList = service.selectProductAttachments(productNo);
        product.setAtList(atList);

        // 2. 로그인 유저 정보
        Member m = (Member) session.getAttribute("loginUser");
        // 3. 값 담기 
        o.setStatus("REQ"); // 거래중
        
        int result = service.productOrder(o,m);
        
        if(result>0) {
        	Location mainLocation = service.selectMainLocationByUserNo(product.getUserNo());
        	model.addAttribute("product", product);
            model.addAttribute("order", o);        
            model.addAttribute("loginUser", m);
            model.addAttribute("mainLocation", mainLocation);
            return "product/productOrder";
        } else {
        	model.addAttribute("msg", "결제 처리에 실패했습니다. 다시 시도해주세요.");
        	return "common/errorPage";
        }
        
        
    }
    
    
    
    
}


