package com.myspring.vampir.news.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.news.service.NewsService;
import com.myspring.vampir.news.vo.NewsVO;

@Controller("newsController")
@RequestMapping("/news")
public class NewsControllerImpl implements NewsController {

    @Autowired
    private NewsService newsService;

    /** /vampir/news.do -> 목록으로 */
    @Override
    @RequestMapping(value="/news.do", method=RequestMethod.GET)
    public String newsRoot() {
        return "redirect:/news/list.do";
    }

    /** 목록 */
    @Override
    @RequestMapping(value="/list.do", method=RequestMethod.GET)
    public ModelAndView list(
            @RequestParam(defaultValue="1") int page,
            @RequestParam(defaultValue="10") int size,
            @RequestParam(required=false) String type,
            @RequestParam(required=false) String q) {

        // 현재 DAO/Mapper는 필터 미구현 가정 (페이지네이션만)
        List<NewsVO> newsList = newsService.listPaged(page, size);
        int total = newsService.countAll();
        int totalPages = (int)Math.ceil((double)total / size);

        ModelAndView mav = new ModelAndView("newsList"); // Tiles 정의명
        mav.addObject("newsList", newsList);
        mav.addObject("page", page);
        mav.addObject("size", size);
        mav.addObject("total", total);
        mav.addObject("totalPages", totalPages);
        // UI 파라미터 그대로 전달 (탭/검색 표시용)
        mav.addObject("type", type);
        mav.addObject("q", q);
        return mav;
    }

    /** 상세 */
    @Override
    @RequestMapping(value="/view.do", method=RequestMethod.GET)
    public ModelAndView view(@RequestParam("articleNO") String articleNO) {
        NewsVO news = newsService.findById(articleNO);
        ModelAndView mav = new ModelAndView("newsView");
        mav.addObject("news", news);
        return mav;
    }

    /** 작성 폼 */
    @Override
    @RequestMapping(value="/writeForm.do", method=RequestMethod.GET)
    public ModelAndView writeForm() {
        return new ModelAndView("newsForm");
    }

    /** 등록 */
    @Override
    @RequestMapping(value="/write.do", method=RequestMethod.POST)
    public String write(@ModelAttribute NewsVO vo) {
        if (vo.getArticleNO() == null || vo.getArticleNO().trim().isEmpty()) {
            vo.setArticleNO("N-" + System.currentTimeMillis());
        }
        if (vo.getParentNO() == null) vo.setParentNO(0);
        newsService.create(vo);
        return "redirect:/news/view.do?articleNO=" + vo.getArticleNO();
    }

    /** 수정 폼 */
    @Override
    @RequestMapping(value="/editForm.do", method=RequestMethod.GET)
    public ModelAndView editForm(@RequestParam("articleNO") String articleNO) {
        NewsVO news = newsService.findById(articleNO);
        ModelAndView mav = new ModelAndView("newsForm");
        mav.addObject("news", news);
        return mav;
    }

    /** 수정 */
    @Override
    @RequestMapping(value="/update.do", method=RequestMethod.POST)
    public String update(@ModelAttribute NewsVO vo) {
        newsService.update(vo);
        return "redirect:/news/view.do?articleNO=" + vo.getArticleNO();
    }

    /** 삭제 */
    @Override
    @RequestMapping(value="/delete.do", method=RequestMethod.POST)
    public String delete(@RequestParam("articleNO") String articleNO) {
        newsService.delete(articleNO);
        return "redirect:/news/list.do";
    }
}
