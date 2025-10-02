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
    public void apply(Long postId, String userId, String nick,
                      String applyTitle, String igNick, String memo, String imagePath) {
        // (권장) DAO 레벨에 UNIQUE(post_id, user_id) 있으므로 중복시 SQLIntegrityConstraintViolationException 발생
        PartyApplicantVO vo = new PartyApplicantVO();
        vo.setPostId(postId);
        vo.setUserId(userId);
        vo.setNick(nick);
        vo.setStatus("APPLIED");
        vo.setApplyTitle(applyTitle);
        vo.setIgNick(igNick);
        vo.setMemo(memo);
        vo.setImagePath(imagePath);
        dao.insert(vo);
    }

    @Override
    public void accept(Long postId, String targetUserId, String ownerUserId) {
        // TODO: ownerUserId 권한 확인
        dao.updateStatus(postId, targetUserId, "ACCEPTED");
    }

    @Override
    public void reject(Long postId, String targetUserId, String ownerUserId) {
        // TODO: ownerUserId 권한 확인
        dao.updateStatus(postId, targetUserId, "REJECTED");
    }
}
