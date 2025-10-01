package com.myspring.vampir.partyboard.dao;

import java.util.List;
import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

public interface PartyApplicantDAO {
    List<PartyApplicantVO> list(Long postId);
    void insert(Long postId, String userId, String nick);
    void updateStatus(Long postId, String userId, String status);
}
