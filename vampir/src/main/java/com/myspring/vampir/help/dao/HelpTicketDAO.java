package com.myspring.vampir.help.dao;

import java.util.List;
import com.myspring.vampir.help.vo.HelpTicketVO;

public interface HelpTicketDAO {
    int insert(HelpTicketVO vo);
    List<HelpTicketVO> selectByMember(Integer memberCode);
    List<HelpTicketVO> selectQnaList(Integer memberCodeOrNull);

    // ★ 추가
    HelpTicketVO selectById(Long id);
    List<HelpTicketVO> searchQna(Integer memberCode, String category, String q);
}
