package com.myspring.vampir.news.service;

import java.util.List;
import com.myspring.vampir.news.vo.NewsVO;

public interface NewsService {
    int countAll();
    List<NewsVO> listPaged(int page, int size);  // page는 1부터
    NewsVO findById(String articleNO);
    void create(NewsVO vo);
    void update(NewsVO vo);
    void delete(String articleNO);
}
