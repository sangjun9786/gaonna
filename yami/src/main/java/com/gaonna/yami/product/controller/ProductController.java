package com.gaonna.yami.product.controller;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.product.service.ProductService;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Product;

@Controller
public class ProductController {
	
	//서비스 선언
	@Autowired
	private ProductService service;

////	리스트 조회
//	@RequestMapping("productList.pr")
//	public String productList(HttpSession session) {
//	    
//	
//	    ArrayList<Product> list = service.selectProductList();
//
//	    session.setAttribute("list", list);
//	    session.addAttribute("pi", pi);
//
//	    return "product/productList2";
//	}
//	
//	
//	@RequestMapping("productList2.pro")
//	public String showProduct(HttpSession session) {
//		return "product/productList2";
//	}

	
//	//페이징
//	@GetMapping("/productList.pr")
//	public String productList(@RequestParam(value = "currentPage", defaultValue = "1") 
//	int currentPage
//	, Model model) {
//		int listCount = service.getListCount(); // 가짜 데이터 개수 (예: 50개) 총 게시글 개수
//		int boardLimit = 1; //보여줄 개수
//		int pageLimit = 5; //페이징 바 개수
//		
//		PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
//		
//		ArrayList<Product> list = service.
//				
//				model.addAttribute("list", list);
//		model.addAttribute("pi", pi);
//		
//		return "product/productList";
//	}
	
	//test 리스트 
	@RequestMapping("productList2.pro")
	public String productList(@RequestParam(value = "currentPage", defaultValue = "1") 
							 int currentPage
							,Model model) {

	    // 1. 전체 상품 개수
	    int listCount = service.getListCount();

	    // 2. 페이징 관련 설정
	    int boardLimit = 1; // 한 페이지당 보여줄 상품 수
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
	public String productDetail(@RequestParam("productNo") int productNo, Model model) {
		// 1. 상품 정보 조회
		Product product = service.selectProductDetail(productNo);

		// 2. 첨부파일(사진) 리스트 조회
        ArrayList<Attachment> atList = service.selectProductAttachments(productNo);

		// 3. 상품 객체에 이미지 리스트 연결
        product.setAtList(atList);

		// 4. 모델에 담기
		model.addAttribute("product", product);

		System.out.println("test :" + product);
		// 🔍 테스트용 로그 출력
		System.out.println("[DEBUG] 상품번호: " + product.getProductNo());
		System.out.println("[DEBUG] 제목: " + product.getProductTitle());
		System.out.println("[DEBUG] 첨부파일 개수: " + (atList != null ? atList.size() : 0));
		if (atList != null) {
			for (Attachment at : atList) {
				System.out.println("[DEBUG] 파일명: " + at.getChangeName() + " / 경로: " + at.getFilePath());
			}
		}

		return "product/productDetail"; 
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

//  @RequestMapping("detail.bo")
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
	
	//등록 이동
	@GetMapping("productEnrollForm.pr")
	public String ProductEnroll() {
		
		return "product/productEnrollForm";
	}
	
	//등록 
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
			return "redirect:/productList.pr";
		}else {
			session.setAttribute("alertMsg", "상품 등록이 실패!!");
			return "common/errorPage";
		}
		

	}
	

}

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

//	@GetMapping("/productList2.pro")
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
//		return "product/productList2";
//	}