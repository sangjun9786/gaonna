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

////    리스트 조회
//    @RequestMapping("productList.pr")
//    public String productList(HttpSession session) {
//        ArrayList<Product> list = service.selectProductList();
//        session.setAttribute("list", list);
//        session.addAttribute("pi", pi);
//        return "product/productList2";
//    }
//
//    @RequestMapping("productList2.pro")
//    public String showProduct(HttpSession session) {
//        return "product/productList2";
//    }

////    페이징
//    @GetMapping("/productList.pr")
//    public String productList(@RequestParam(value = "currentPage", defaultValue = "1") 
//    int currentPage, Model model) {
//        int listCount = service.getListCount(); // 총 게시글 개수
//        int boardLimit = 1; // 보여줄 개수
//        int pageLimit = 5; // 페이징 바 개수
//
//        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
//        ArrayList<Product> list = service.selectProductList(pi);
//        model.addAttribute("list", list);
//        model.addAttribute("pi", pi);
//        return "product/productList";
//    }


	
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
    public String productDetail(@RequestParam("productNo") int productNo, Model model) {
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

        model.addAttribute("product", product);
        return "product/productDetail";
    }

    // 파일 업로드
    public String saveFile(MultipartFile uploadFile, HttpSession session) {
        String originName = uploadFile.getOriginalFilename();
        String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        int ranNum = (int) (Math.random() * 90000 + 10000);
        String ext = originName.substring(originName.lastIndexOf("."));
        String changeName = currentTime + ranNum + ext;
        String savePath = session.getServletContext().getRealPath("/resources/uploadFiles/");

        try {
            uploadFile.transferTo(new File(savePath + changeName));
        } catch (IllegalStateException | IOException e) {
            e.printStackTrace();
        }

        return changeName;
    }

    // 등록 이동
    @GetMapping("productEnrollForm.pr")
    public String ProductEnroll() {
        return "product/productEnrollForm";
    }

    // 등록
    @PostMapping("productEnrollForm.pr")
    public String insertProduct(Product p, ArrayList<MultipartFile> uploadFiles, HttpSession session) {
        ArrayList<Attachment> atList = new ArrayList<>();
        int count = 1;
        for (MultipartFile m : uploadFiles) {
            String changeName = saveFile(m, session);
            String originName = m.getOriginalFilename();
            Attachment at = new Attachment();
            at.setChangeName(changeName);
            at.setOriginName(originName);
            at.setFilePath("/resources/uploadFiles/");
            if (count == 1) {
                at.setFileLevel(count++);
            } else {
                at.setFileLevel(2);
            }
            atList.add(at);
        }

        int result = service.insertProduct(p, atList);
        if (result > 0) {
            session.setAttribute("alertMsg", "상품 등록이 성공적으로 처리 되었습니다.");
            return "redirect:/productList2.pro";
        } else {
            session.setAttribute("alertMsg", "상품 등록이 실패!!");
            return "common/errorPage";
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

    // 댓글 목록
    @GetMapping("/replyList")
    @ResponseBody
    public List<Reply> replyList(@RequestParam("productNo") int productNo) {
        System.out.println("📍 댓글 불러오기: " + productNo);
        return replyService.selectReplyList(productNo);
    }
}

////    @GetMapping("/productList.pro")
////    public String productList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model) {
////        int listCount = 50;
////        int pageLimit = 5;
////        int boardLimit = 16;
////        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
////        List<ProductDTO> products = new ArrayList<>();
////        for (int i = pi.getStartRow(); i <= pi.getEndRow() && i <= listCount; i++) {
////            products.add(new ProductDTO(i, "테스트 상품" + i, "photo" + (i % 10 + 1) + ".jpg", i * 1000, "강남구", "패션잡화"));
////        }
////        model.addAttribute("photos", products);
////        model.addAttribute("pi", pi);
////        return "product/productList";
////    }

////    @GetMapping("/productList2.pro")
////    public String productList(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage, Model model) {
////        int listCount = 50;
////        int pageLimit = 5;
////        int boardLimit = 16;
////        PageInfo pi = Pagination.getPageInfo(listCount, currentPage, pageLimit, boardLimit);
////        List<ProductDTO> products = new ArrayList<>();
////        for (int i = pi.getStartRow(); i <= pi.getEndRow() && i <= listCount; i++) {
////            products.add(new ProductDTO(i, "테스트 상품" + i, "photo" + (i % 10 + 1) + ".jpg", i * 1000, "강남구", "패션잡화"));
////        }
////        model.addAttribute("photos", products);
////        model.addAttribute("pi", pi);
////        return "product/productList2";
////    }
