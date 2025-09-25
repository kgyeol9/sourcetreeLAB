package com.myspring.vampir.news.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.news.vo.NewsVO;

@Repository("newsDAO")
public class NewsDAOImpl implements NewsDAO {

    private static final String NS = "com.myspring.vampir.news.mapper.NewsMapper";
    // ↑ mapper/news.xml 의 <mapper namespace="..."> 값과 반드시 동일해야 함

    @Autowired
    private SqlSession sqlSession;
    
    

    @Override
    public int countAll() {
        return sqlSession.selectOne(NS + ".countAll");
    }

    @Override
    public List<NewsVO> listPaged(int limit, int offset) {
    	Map<String,Object> p = new HashMap<String, Object>();
        p.put("limit", limit);
        p.put("offset", offset);
        return sqlSession.selectList(NS + ".listPaged", p);
    }

    @Override
    public NewsVO findById(String articleNO) {
        return sqlSession.selectOne(NS + ".findById", articleNO);
    }

    @Override
    public int insert(NewsVO vo) {
        return sqlSession.insert(NS + ".insert", vo);
    }

    @Override
    public int update(NewsVO vo) {
        return sqlSession.update(NS + ".update", vo);
    }

    @Override
    public int delete(String articleNO) {
        return sqlSession.delete(NS + ".delete", articleNO);
    }
}
