package com.gaonna.yami.product.controller;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.common.Pagination;
import com.gaonna.yami.product.model.ProductDTO;

@Controller
public class ProductController {

    @GetMapping("/productList.pro")
    public String productList(@RequestParam(value="currentPage", defaultValue="1") int currentPage, Model model) {
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

        return "product/productList";
    }
}