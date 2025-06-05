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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.model.ProductDTO;
import com.gaonna.yami.product.service.ProductService;
import com.gaonna.yami.product.service.ReplyService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Product;
import com.gaonna.yami.product.vo.Reply;

@Controller
public class ProductController {
	
	//서비스 선언
	@Autowired
	private ProductService service;
	
	@Autowired
    private ReplyService replyService;  // ← 이거 추가하면 오류 해결

//	@GetMapping("/productList.pro")
//	public String productList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model) {
//		int listCount = 50; // 가짜 데이터 개수 (예: 50개)
//		int pageLimit = 5;
//		int boardLimit = 16;
//
//		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
//
//		// 가짜 데이터 생성
//		List<ProductDTO> products = new ArrayList<>();
//		for (int i = pi.getStartRow(); i <= pi.getEndRow() && i <= listCount; i++) {
//			products.add(new ProductDTO(i, "테스트 상품" + i, "photo" + (i % 10 + 1) + ".jpg", i * 1000, "강남구", "패션잡화"));
//		}
//
//		model.addAttribute("photos", products);
//		model.addAttribute("pi", pi);
//
//		return "product/productList";
//	}
	
	@GetMapping("/productList2.pro")
	public String productList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model) {
		int listCount = 50; // 가짜 데이터 개수 (예: 50개)
		int pageLimit = 5;
		int boardLimit = 16;

		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);

		// 가짜 데이터 생성
		List<ProductDTO> products = new ArrayList<>();
		for (int i = pi.getStartRow(); i <= pi.getEndRow() && i <= listCount; i++) {
			products.add(new ProductDTO(i, "테스트 상품" + i, "photo" + (i % 10 + 1) + ".jpg", i * 1000, "강남구", "패션잡화"));
		}

		model.addAttribute("photos", products);
		model.addAttribute("pi", pi);

		return "product/productList2";
	}

	// 상세 페이지 구현

	@Autowired
	private ProductService productService;

	@GetMapping("/productDetail.pro")
	public String productDetail(@RequestParam("productNo") int productNo, Model model) {
		// 1. 상품 정보 조회
		Product product = productService.selectProductDetail(productNo);

		// 2. 첨부파일(사진) 리스트 조회
//        List<Attachment> atList = productService.selectProductAttachments(productNo);

		// 3. 상품 객체에 이미지 리스트 연결
//        product.setAtList(atList);

		// 4. 모델에 담기
		model.addAttribute("product", product); // 뷰에서 ${b.속성명}으로 접근 가능

		System.out.println("test :" + product);
		return "product/productDetail"; // /WEB-INF/views/product/productDetail.jsp
	}

	// 파일 업로드

	public String saveFile(MultipartFile uploadFile, HttpSession session) {
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
			} catch (IllegalStateException | IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	
		return changeName; // 서버에 업로드된 파일명 반환
	}

//    @RequestMapping("detail.bo")
//	public String boardDetail(int bno
//							 ,HttpSession session
//							 ,Model model) {
//		//글 번호를 이용해서 조회수 증가 및 게시글 조회처리하기
//		
//		int result = service.increaseCount(bno);
//		
//		if(result>0) {//조회수 증가 처리가 성공이라면
//			Board b = service.boardDetail(bno);
//			model.addAttribute("b",b);
//			return "board/boardDetailView";
//			
//		}else { //실패라면
//			model.addAttribute("errorMsg","카운트 증가 실패!!");
//			return "common/errorPage";
//		}
//		
//	}
	
	@GetMapping("productEnrollForm.pr")
	public String ProductEnroll() {
		
		return "product/productEnrollForm";
	}
	
	@PostMapping("productEnrollForm.pr")
	public String insertProduct(Product p,ArrayList<MultipartFile> uploadFiles
							 ,HttpSession session) {
		//첨부파일이 여러개일땐 배열또는 리스트 형식으로 전달받으면 된다.
		
		ArrayList<Attachment> atList = new ArrayList<>(); //천부파일 정보들 등록할 리스트
		
		int count =1;
		for(MultipartFile m : uploadFiles) {
			String changeName = saveFile(m,session);
			String originName = m.getOriginalFilename(); //원본 파일명 추출
			
			//파일정보 객체 생성하여 리스트에 추가하기
			Attachment at = new Attachment();
			at.setChangeName(changeName);
			at.setOriginName(originName);
			at.setFilePath("/resources/uploadFiles/");
			if(count==1) {
				at.setFileLevel(count++); //1번 대표사진 설정
			}else {
				at.setFileLevel(2); //나머지
			}
			
			atList.add(at); //리스트에 추가
		}
		
		//서비스에 요청
		int result = service.insertProduct(p,atList);
		
		if(result>0) { //등록 성공
			session.setAttribute("alertMsg", "상품 등록이 성공적으로 처리 되었습니다.");
			return "product/productList2";
		}else {
			session.setAttribute("alertMsg", "상품 등록이 실패!!");
			return "common/errorPage";
		}
		

	}
	
	
	@PostMapping("/insertReply")
	@ResponseBody
	public String insertReply(Reply r, HttpSession session) {
	    // 세션에서 로그인된 사용자 가져오기 (loginUser라는 이름으로 세팅되어 있어야 함)
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        // 로그인하지 않은 상태라면 “fail” 리턴
	        return "fail";
	    }

	    // VO에 userId를 채워 준 뒤 DAO → DB 저장  
	    r.setUserId(loginUser.getUserId());
	    int result = replyService.insertReply(r);
	    return result > 0 ? "success" : "fail";
	}
	
	@GetMapping("/replyList")
    @ResponseBody
    public List<Reply> replyList(@RequestParam("productNo") int productNo) {
        System.out.println("📍 댓글 불러오기: " + productNo);
        return replyService.selectReplyList(productNo);
    }
	
	
	
	
	
	
	

}