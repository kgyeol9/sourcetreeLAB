package com.myspring.vampir.partyboard.service;

import java.util.List;
import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

public interface PartyApplicantService {
    List<PartyApplicantVO> list(Long postId);
    void apply(Long postId, String userId, String nick,
               String applyTitle, String igNick, String memo, String imagePath);
    void accept(Long postId, String targetUserId, String ownerUserId);
    void reject(Long postId, String targetUserId, String ownerUserId);
}
