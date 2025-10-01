package com.myspring.vampir.help.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.help.vo.HelpTicketVO;

@Repository
public class HelpTicketDAOImpl implements HelpTicketDAO {

    private static final String NS = "helpTicket."; // mybatis namespace + '.'

    private final SqlSessionTemplate sst;

    @Autowired
    public HelpTicketDAOImpl(SqlSessionTemplate sst) {
        this.sst = sst;
    }

    @Override
    public int insert(HelpTicketVO vo) {
        return sst.insert(NS + "insert", vo);
    }

    @Override
    public List<HelpTicketVO> selectByMember(Integer memberCode) {
        Map<String, Object> p = new HashMap<String, Object>();
        // 파라미터 키를 XML과 동일한 mem_code로 통일
        p.put("mem_code", memberCode);
        return sst.selectList(NS + "selectByMember", p);
    }

    @Override
    public List<HelpTicketVO> selectQnaList(Integer memberCodeOrNull) {
        Map<String, Object> p = new HashMap<String, Object>();
        // 공개글 + (내 비밀글) 조회 시 null 허용
        p.put("mem_code", memberCodeOrNull);
        return sst.selectList(NS + "selectQnaList", p);
    }

    @Override
    public HelpTicketVO selectById(Long id) {
        return sst.selectOne(NS + "selectById", id);
    }
    
    @Override
    public List<HelpTicketVO> searchQna(Integer memberCode, String category, String q) {
        Map<String,Object> p = new HashMap<String, Object>();
        p.put("mem_code", memberCode);
        p.put("category", category);
        p.put("q", q);
        return sst.selectList(NS + "searchQna", p);
    }
}
