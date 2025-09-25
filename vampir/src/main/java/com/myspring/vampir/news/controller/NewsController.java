package com.myspring.vampir.news.controller;

import org.springframework.web.servlet.ModelAndView;

public interface NewsController {
    ModelAndView list(int page, int size, String type, String q);
    ModelAndView view(String articleNO);
    ModelAndView writeForm();
    String write(com.myspring.vampir.news.vo.NewsVO vo);
    ModelAndView editForm(String articleNO);
    String update(com.myspring.vampir.news.vo.NewsVO vo);
    String delete(String articleNO);
    String newsRoot(); // /news.do -> /news/list.do 리다이렉트
}
