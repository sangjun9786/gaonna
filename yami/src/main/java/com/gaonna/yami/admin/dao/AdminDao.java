package com.gaonna.yami.admin.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.gaonna.yami.member.model.vo.Member;

@Repository
public class AdminDao {

	public Member consoleLogin(SqlSessionTemplate sqlSession, String userId) {
		return sqlSession.selectOne("adminMapper.consoleLogin",userId);
	}

	public String selectRoleType(SqlSessionTemplate sqlSession, Member loginUser) {
		return sqlSession.selectOne("adminMapper.selectRoleType",loginUser);
	}

	public List<Member> searchAdmin(SqlSessionTemplate sqlSession, String select) {
		return sqlSession.selectList("adminMapper.searchAdmin", select);
	}

	public int updateAdmin(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("adminMapper.updateAdmin", m);
	}

	public int updateAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.update("adminMapper.updateAdminRole", m);
	}

	public int deleteAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.delete("adminMapper.deleteAdminRole", m);
	}

	public int insertAdmin(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.insert("adminMapper.insertAdmin",m);
	}

	public int insertAdminRole(SqlSessionTemplate sqlSession, Member m) {
		return sqlSession.insert("adminMapper.insertAdminRole",m);
	}

	public List<Member> searchMemberAll(SqlSessionTemplate sqlSession, Map<String, String> mapping) {
		return sqlSession.selectList("adminMapper.searchMemberAll", mapping);
	}
	
	public List<Member> searchMember(SqlSessionTemplate sqlSession, Map<String, String> mapping) {
		return sqlSession.selectList("adminMapper.searchMember", mapping);
	}

}
