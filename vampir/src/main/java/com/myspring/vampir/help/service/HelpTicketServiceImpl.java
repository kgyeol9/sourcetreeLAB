package com.myspring.vampir.help.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.help.dao.HelpTicketDAO;
import com.myspring.vampir.help.vo.HelpTicketVO;

@Service
public class HelpTicketServiceImpl implements HelpTicketService {

    private final HelpTicketDAO dao;

    @Autowired
    public HelpTicketServiceImpl(HelpTicketDAO dao) {
        this.dao = dao;
    }

    @Override
    public Long create(HelpTicketVO vo) {
        dao.insert(vo);
        return vo.getId();
    }

    @Override
    public List<HelpTicketVO> findMyTickets(Integer memberCode) {
        return dao.selectByMember(memberCode);
    }

    @Override
    public List<HelpTicketVO> findQnaList(Integer memberCodeOrNull) {
        return dao.selectQnaList(memberCodeOrNull);
    }
    
    @Override
    public HelpTicketVO findById(Long id) {
        return dao.selectById(id);
    }
    
    @Override
    public List<HelpTicketVO> findQnaBySearch(Integer memberCode, String category, String q) {
        return dao.searchQna(memberCode, category, q);
    }
}
