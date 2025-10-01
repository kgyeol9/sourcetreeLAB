package com.myspring.vampir.help.service;

import java.util.List;
import com.myspring.vampir.help.vo.HelpTicketVO;

public interface HelpTicketService {
    Long create(HelpTicketVO vo);
    List<HelpTicketVO> findMyTickets(Integer memberCode);
    List<HelpTicketVO> findQnaList(Integer memberCodeOrNull);

    // ★ 추가
    HelpTicketVO findById(Long id);
    List<HelpTicketVO> findQnaBySearch(Integer memberCode, String category, String q);
}
