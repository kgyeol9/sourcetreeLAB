package com.myspring.vampir.partyboard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

@Repository
public class PartyApplicantDAOImpl implements PartyApplicantDAO {

    private static final String NS = "mapper.partyboard.applicant.";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<PartyApplicantVO> list(Long postId) {
        return sqlSession.selectList(NS + "list", postId);
    }

    @Override
    public void insert(Long postId, String userId, String nick) {
        Map<String,Object> p = new HashMap<String,Object>();
        p.put("postId", postId);
        p.put("userId", userId);
        p.put("nick",   nick);
        sqlSession.insert(NS + "insert", p);
    }

    @Override
    public void updateStatus(Long postId, String userId, String status) {
        Map<String,Object> p = new HashMap<String,Object>();
        p.put("postId", postId);
        p.put("userId", userId);
        p.put("status", status);
        sqlSession.update(NS + "updateStatus", p);
    }
}
