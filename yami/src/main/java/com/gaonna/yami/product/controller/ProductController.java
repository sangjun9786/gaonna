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

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.service.ProductService;
import com.gaonna.yami.product.service.ReplyService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
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
	    int boardLimit = 2; // 한 페이지당 보여줄 상품 수
	    int pageLimit = 5;   // 페이징바에 표시될 페이지 수

	    // 3. 페이징 정보 생성
	    PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);

	    // 4. 현재 페이지에 해당하는 상품 목록 조회
	    ArrayList<Product> list = service.selectProductList(pi); // 페이징 적용된 DAO 메서드

	    // 5. JSP에 전달
	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);

	    // 6. 렌더링할 JSP
	    return "product/productList2";
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
        if(loginUser != null) {
            System.out.println("[로그] loginUser.roleType = " + loginUser.getRoleType());
            System.out.println("[로그] loginUser.roleType 타입 = " + (loginUser.getRoleType() == null ? "null" : loginUser.getRoleType().getClass().getName()));
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
 		
// 		if (originName == null || originName.equals("")) {
// 	        return null;
// 	    }
//
// 	    // 2. 확장자 존재 여부 체크
// 	    int dotIndex = originName.lastIndexOf(".");
// 	    String ext = "";
// 	    if (dotIndex != -1 && dotIndex < originName.length() - 1) {
// 	        ext = originName.substring(dotIndex); // 예: ".jpg"
// 	    } else {
// 	        // 확장자가 없는 경우, 기본 확장자 설정 or 실패 처리
// 	        ext = ""; // 또는 return null;
// 	    }
// 
 		//2.시간 형식 문자열로 추출
 		String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

 		//3.랜덤값 5자리 추출
 		int ranNum = (int) (Math.random() * 90000 + 10000);
 		//4.원본파일에서 확장자 추출
 		String ext = originName.substring(originName.lastIndexOf("."));

 		//5.합치기
 		String changeName = currentTime + ranNum + ext;

// 		//6. 서버에 업로드 처리할때 물리적인 경로 추출하기
 		String savePath = session.getServletContext().getRealPath("/resources/uploadFiles/");
// 							
 		System.out.println("실제 저장 경로 (savePath): " + savePath);
 		System.out.println("전체 파일 경로: " + savePath + changeName);
 		
 		//6. 외부 경로 쓰기위해 경로 설정
// 		String savePath = "C:/upload/";
// 		//6-1 저장 폴더 없으면 생성 
// 		File folder = new File(savePath);
// 		if(!folder.exists()){
// 			
// 	        folder.mkdirs(); // 폴더 생성
// 	    }
 		
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

	//등록 이동
	@GetMapping("productEnrollForm.pr")
	public String ProductEnroll(Model model) {
		ArrayList<Category> categoryList = service.selectCategoryList(); // DB 또는 서비스에서 가져오기
		model.addAttribute("categoryList", categoryList);
		return "product/productEnrollForm";
	}
	
	//등록 
	@PostMapping("productEnrollForm.pr")
	public String insertProduct(Product p
            					,@RequestParam("thumbnail") MultipartFile thumbnail
            					,@RequestParam("uploadFiles")ArrayList<MultipartFile> uploadFiles
//								,ArrayList<MultipartFile> uploadFiles
								,HttpSession session) {
		//첨부파일이 여러개일땐 배열또는 리스트 형식으로 전달받으면 된다.
		
		ArrayList<Attachment> atList = new ArrayList<>(); //천부파일 정보들 등록할 리스트
		
//		int count =1;
//		for(MultipartFile m : uploadFiles) {
//			if (m == null || m.isEmpty()) continue;
//			String changeName = saveFile(m,session);
//			//저장실패시 처리중단 및 에러페이지 반환
//			if (changeName == null) {
//	            session.setAttribute("alertMsg", "파일 저장 중 오류가 발생했습니다.");
//	            return "common/errorPage";
//		    }
//			
//			String originName = m.getOriginalFilename(); //원본 파일명 추출
//			
//			//파일정보 객체 생성하여 리스트에 추가하기
//			Attachment at = new Attachment();
//			at.setChangeName(changeName);
//			at.setOriginName(originName);
//			at.setFilePath("/resources/uploadFiles/");
//			if(count==1) {
//				at.setFileLevel(count++); //1번 대표사진 설정
//			}else {
//				at.setFileLevel(2); //나머지
//			}
//			
//			atList.add(at); //리스트에 추가
//		}
		
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
	    
	    System.out.println("업로드된 파일 개수: " + uploadFiles.size());

	    //상세 이미지
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
	    System.out.println("업로드된 파일 개수: " + uploadFiles.size());

//		System.out.println(p);
//		System.out.println(uploadFiles);
		//서비스에 요청
		int result = service.insertProduct(p,atList);
		
		if(result>0) { //등록 성공
			session.setAttribute("alertMsg", "상품 등록이 성공적으로 처리 되었습니다.");
			return "redirect:/productList2.pro";
		}else {
//			session.setAttribute("alertMsg", "상품 등록이 실패!!");
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
			return "redirect:/productList2.pro";//게시글 목록페이지로 재요청

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
		
	 	//위임하는 페이지에 게시글 정보 담아가기
		model.addAttribute("p",p);
		
		return "product/productUpdate";
	}
	
	//게시글 수정 등록작업 메소드
	@PostMapping("update.pro")
	public String productUpdate(Product p
							 	,MultipartFile reUploadFile
							 	,HttpSession session) {
		
		//정보수정 성공시 성공메시지와 함께 기존에 첨부파일이 잇었다면 삭제 후 디테일뷰로 재요청
		//정보수정 실패시 실패 메ㅣ지와 함께 디테일뷰로 재요청
		
		//새로운 첨부파일이 있는 경우 - 데이터베이스에 변경된 데이터 적용 + 서버에 업로드된 기존 첨부파일 삭제해야함
		//새로운 첨부파일이 없는 경우 - 데이터베이스에 변경된 데이터 적용
		//게시글 등록 기능에서 사용했던 첨부파일 처리 참고해서 진행

		String deleteFile =null;
		//기존에 첨부파일이 있었는지 확인작업
		if(!reUploadFile.getOriginalFilename().equals("")){//파일경로가 빈문자열이 아니라면(파일이 있다면)
			//기존에 첨부파일이 있었는지 확인
			if(p.getOriginName()!= null) {
				deleteFile = p.getChangeName(); //서버에 업로드되어있는 파일명 저장(추후 삭제 처리용)
			}
			
			//새로 업로드된 파일 정보를 데이터베이스에 등록 및 서버 업로드 작업 수행
			String changeName = saveFile(reUploadFile,session);
			
			//업로드 처리 후 변경된 파일명 데이터 베이스에 등록하기 위해서 p에 세팅해주기
			p.setOriginName(reUploadFile.getOriginalFilename()); //원본파일명	
			p.setChangeName(changeName);
	
		}
			int result = service.productUpdate(p);
			if(result>0) {
				session.setAttribute("alertMsg", "게시글 수정 성공!");
				//기존파일 있었으면 삭제처리하기
				if(deleteFile != null) {
					new File(session.getServletContext().getRealPath(deleteFile)).delete();
				}
			}else {
				//정보수정 실패시 실패 메시지와 함꼐 디테일뷰로 재요청
				session.setAttribute("alertMsg", "게시글 수정 실패!");				
			}

			return "redirect:/productDetail.pro?productNo="+p.getProductNo(); //디테일뷰 페이지
		
	}
	
    // 댓글 목록
    @GetMapping("/replyList")
    @ResponseBody
    public List<Reply> replyList(@RequestParam("productNo") int productNo) {
        System.out.println("📍 댓글 불러오기: " + productNo);
        return replyService.selectReplyList(productNo);
    }
}


