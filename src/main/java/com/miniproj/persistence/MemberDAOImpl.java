package com.miniproj.persistence;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.miniproj.model.AutoLoginInfo;
import com.miniproj.model.LoginDTO;
import com.miniproj.model.MemberVO;
import com.miniproj.model.PointLogDTO;

@Repository
public class MemberDAOImpl implements MemberDAO {
	
	@Autowired
	private SqlSession ses;
	
	private static String NS = "com.miniproj.mappers.membermapper";

	@Override
	public int updateUserPoint(PointLogDTO pointLogDTO) throws Exception {
		
		return ses.insert(NS + ".updateUserPoint", pointLogDTO);
	}

	@Override
	public int selectDuplicateId(String tmpUserId) throws Exception {
		
		return ses.selectOne(NS + ".selectUserId", tmpUserId);
	}

	@Override
	public int insertMember(MemberVO registMember) throws Exception {

		return ses.insert(NS + ".insertMember", registMember);
	}

	@Override
	public MemberVO login(LoginDTO loginDTO) throws Exception {
		
		return ses.selectOne(NS + ".loginWithDTO", loginDTO);
	}

	@Override
	public int updateAutoLoginInfo(AutoLoginInfo autoLoginInfo) throws Exception {
		
		return ses.update(NS + ".updateAutoLoginInfo", autoLoginInfo);
	}

	@Override
	public MemberVO checkAutoLogin(String savedCookieSesId) {
		
		return ses.selectOne(NS + ".checkAutoLoginUser", savedCookieSesId);
	}

	@Override
	public int updateAccountLock(String userId) throws Exception {
	    return ses.update(NS + ".updateAccountLock", userId);
	}

	@Override
	public MemberVO selectMemberByUserId(String userId) throws Exception {
		
		return ses.selectOne(NS + ".getUserInfoByUserId", userId);
	}

}
