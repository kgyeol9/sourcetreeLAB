package com.myspring.vampir.news.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.vampir.news.dao.NewsDAO;
import com.myspring.vampir.news.vo.NewsVO;

@Service("newsService")
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsDAO newsDAO;

    @Override
    public int countAll() {
        return newsDAO.countAll();
    }

    @Override
    public List<NewsVO> listPaged(int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        int offset = (page - 1) * size;
        return newsDAO.listPaged(size, offset);
    }

    @Override
    public NewsVO findById(String articleNO) {
        return newsDAO.findById(articleNO);
    }

    @Transactional
    @Override
    public void create(NewsVO vo) {
        // articleNO는 현재 수동/폼 입력 기반. (자동 규칙 필요하면 다음 단계에서 추가 가능)
        newsDAO.insert(vo);
    }

    @Transactional
    @Override
    public void update(NewsVO vo) {
        newsDAO.update(vo);
    }

    @Transactional
    @Override
    public void delete(String articleNO) {
        newsDAO.delete(articleNO);
    }
}
