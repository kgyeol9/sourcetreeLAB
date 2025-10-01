package com.myspring.vampir.partyboard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.partyboard.dao.PartyApplicantDAO;
import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

@Service
public class PartyApplicantServiceImpl implements PartyApplicantService {

    @Autowired
    private PartyApplicantDAO dao;

    @Override
    public List<PartyApplicantVO> list(Long postId) {
        return dao.list(postId);
    }

    @Override
    public void apply(Long postId, String userId, String nick) {
        // 중복 지원 방지: DAO에서 UNIQUE(post_id, user_id)로 막는 것을 권장
        dao.insert(postId, userId, nick);
    }

    @Override
    public void accept(Long postId, String targetUserId, String ownerUserId) {
        // TODO: owner 권한 확인 (파티장/작성자 여부) -> 현재는 생략
        dao.updateStatus(postId, targetUserId, "ACCEPTED");
    }

    @Override
    public void reject(Long postId, String targetUserId, String ownerUserId) {
        // TODO: 권한 확인
        dao.updateStatus(postId, targetUserId, "REJECTED");
    }
}
