package com.gaonna.yami.location.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.location.vo.Coord;
import com.gaonna.yami.member.model.vo.Member;

@Repository
public class LocationDao {

	public List<Coord> selectUserDongne(SqlSessionTemplate sqlSession, int userNo) {
		return sqlSession.selectList("locationMapper.selectUserDongne", userNo);
	}

	public int insertDongne(SqlSessionTemplate sqlSession, Coord currCoord) {
		return sqlSession.insert("locationMapper.insertDongne",currCoord);
	}

	public int insertMemberCoords(SqlSessionTemplate sqlSession, Map<String, Integer> memberCoords) {
		return sqlSession.insert("locationMapper.insertMemberCoords",memberCoords);
	}

	public int updateMainCoord(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.update("memberMapper.updateMainCoord",loginUser);
	}

}
