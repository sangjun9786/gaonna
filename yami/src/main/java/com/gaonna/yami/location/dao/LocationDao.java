package com.gaonna.yami.location.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.location.vo.Coord;

@Repository
public class LocationDao {

	public List<Coord> selectUserDongne(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectList("locationMapper.selectUserDongne", userNo);
	}

}
