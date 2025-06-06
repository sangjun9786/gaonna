package com.gaonna.yami.product.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.product.model.ProductDTO;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Product;


@Repository
public interface ProductService {
    //게시글 조회
	int getListCount();

//    List<ProductDTO> selectProductList(PageInfo pi);
    
	//조회수 증가
	int increaseCount(int productNo);
    
	//상세보기
	Product selectProductDetail(int productNo);
	
	//상품등록
	int insertProduct(Product p, ArrayList<Attachment> atList);
	
	//상품 리스트 조회
	ArrayList<Product> selectProductList(PageInfo pi);
	
	//상세페이지
	ArrayList<Attachment> selectProductAttachments(int productNo);

	
}

//int getListCount();