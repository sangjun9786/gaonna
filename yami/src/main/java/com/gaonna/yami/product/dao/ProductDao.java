package com.gaonna.yami.product.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Product;

@Repository
public class ProductDao {

	//상세
	public Product selectProductDetail(SqlSessionTemplate sqlSession, int productNo) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("productMapper.selectProductDetail",productNo);
		
	}
	
	//상품 번호
	public int selectProductNo(SqlSessionTemplate sqlSession) {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("productMapper.selectProductNo");
	}
	
	//상품게시글
	public int insertAtProduct(SqlSessionTemplate sqlSession, Product p) {
		// TODO Auto-generated method stub
		return sqlSession.insert("productMapper.insertAtProduct",p);
	}
	
	//첨부파일 
	public int insertAttachment(SqlSessionTemplate sqlSession, Attachment at) {
		// TODO Auto-generated method stub
		return sqlSession.insert("productMapper.insertAttachment",at);
	}


}
