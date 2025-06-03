package com.gaonna.yami.product.service;

import java.util.ArrayList;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.gaonna.yami.common.PageInfo;
import com.gaonna.yami.product.dao.ProductDao;
import com.gaonna.yami.product.model.ProductDTO;
import com.gaonna.yami.product.vo.Attachment;
import com.gaonna.yami.product.vo.Product;

@Service
public class ProductServiceImpl implements ProductService {

//    @Autowired
//    private SqlSession sqlSession;
    
    @Autowired
    private SqlSessionTemplate sqlSession;
    
    @Autowired
    private ProductDao dao;

    @Override
    public int getListCount() {
        return sqlSession.selectOne("productMapper.getListCount");
    }

    @Override
    public List<ProductDTO> selectProductList(PageInfo pi) {
        return sqlSession.selectList("productMapper.selectProductList", pi);
    }
    
    //상세보기
	@Override
	public Product selectProductDetail(int productNo) {
		// TODO Auto-generated method stub
		return dao.selectProductDetail(sqlSession,productNo);
	}
	
	//상품 게시물 등록
	@Transactional
	@Override
	public int insertProduct(Product p, ArrayList<Attachment> atList) {
			
		int productNo = dao.selectProductNo(sqlSession);
		
		if(productNo> 0) {
			p.setProductNo(productNo);
		}else {
			return productNo;
		}
		
		int result = dao.insertAtProduct(sqlSession,p);
			
		int result2 = 1; //첨부파일 등록 반환값 담을 변수
			
		if(result>0) {
			for(Attachment at : atList) {
				at.setProductBno(productNo); //참조게시글번호 추가
				result2 *= dao.insertAttachment(sqlSession,at);
			}
			return result * result2;
			
		}else{
			return result; 
		}
			
	}
    
}