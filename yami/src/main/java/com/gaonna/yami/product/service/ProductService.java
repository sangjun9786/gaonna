package com.gaonna.yami.product.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.model.ProductDTO;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Order;
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
	
	//카테고리 가져오기
	ArrayList<Category> selectCategoryList();
	
	//상품 삭제
	int deleteProduct(int productNo);
	
	//상품 수정
	int productUpdate(Product p);

	//오더 등록
	int productOrder(Order o, Member m);
	
	

	
}

//int getListCount();