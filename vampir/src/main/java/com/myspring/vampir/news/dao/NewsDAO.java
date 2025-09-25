package com.myspring.vampir.news.dao;

import java.util.List;
import com.myspring.vampir.news.vo.NewsVO;

public interface NewsDAO {
    int countAll();
    List<NewsVO> listPaged(int limit, int offset);
    NewsVO findById(String articleNO);
    int insert(NewsVO vo);
    int update(NewsVO vo);
    int delete(String articleNO);
}
