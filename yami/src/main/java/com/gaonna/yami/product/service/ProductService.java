package com.gaonna.yami.product.service;

import java.util.ArrayList;

import org.springframework.stereotype.Repository;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.location.vo.Location;
import com.gaonna.yami.member.model.vo.Member;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Category;
import com.gaonna.yami.product.vo.Order;
import com.gaonna.yami.product.vo.Product;


@Repository
public interface ProductService {
    //게시글 조회
	int getListCount();

	//조회수 증가
	int increaseCount(int productNo);
//    List<ProductDTO> selectProductList(PageInfo pi);
    
	//상품 리스트 조회
	ArrayList<Product> selectProductList(PageInfo pi);
	
	//상품등록
	int insertProduct(Product p, ArrayList<Attachment> atList);
    
	//카테고리 가져오기
	ArrayList<Category> selectCategoryList();
	
	//거래 희망장소
	Location selectMainLocationByUserNo(int userNo);
	
	//상세보기
	Product selectProductDetail(int productNo);
	
	//상세페이지
	ArrayList<Attachment> selectProductAttachments(int productNo);
	
	//상품 삭제
	int deleteProduct(int productNo);
	
	//상품 수정
	int productUpdate(Product p, ArrayList<Attachment> atList);
	
	//오더 등록
	int productOrder(Order o, Member m);
	
	
	

	
}

//int getListCount();