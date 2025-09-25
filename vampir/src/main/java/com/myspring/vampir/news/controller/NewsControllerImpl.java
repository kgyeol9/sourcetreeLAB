package com.myspring.vampir.news.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.news.service.NewsService;
import com.myspring.vampir.news.vo.NewsVO;

@Controller("newsController")
// 클래스 매핑 확장: 루트("")와 /news 둘 다 받도록
@RequestMapping({"/news", ""})
public class NewsControllerImpl implements NewsController {

    @Autowired
    private NewsService newsService;

    /** 루트에서 /news.do로 들어온 요청을 목록으로 리다이렉트 */
    @Override
    @RequestMapping(value="/news.do", method=RequestMethod.GET)
    public String newsRoot() {
        return "redirect:/news/list.do";
    }

    /** 목록 */
    @Override
    @RequestMapping(value="/list.do", method=RequestMethod.GET)
    public ModelAndView list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String type,   // 탭 표시용(UI)
            @RequestParam(required = false) String q) {    // 검색어(UI)

        // 현재 Mapper는 필터(type/q) 미구현 가정 → 페이지네이션만
        List<NewsVO> newsList = newsService.listPaged(page, size);
        int total = newsService.countAll();
        int totalPages = (int) Math.ceil((double) total / size);

        ModelAndView mav = new ModelAndView("newsList"); // Tiles 정의명
        mav.addObject("newsList", newsList);
        mav.addObject("page", page);
        mav.addObject("size", size);
        mav.addObject("total", total);
        mav.addObject("totalPages", totalPages);
        // UI 상태 유지용 파라미터
        mav.addObject("type", type);
        mav.addObject("q", q);
        return mav;
    }

    /** 상세 */
    @Override
    @RequestMapping(value="/view.do", method=RequestMethod.GET)
    public ModelAndView view(@RequestParam("articleNO") String articleNO) {
        NewsVO news = newsService.findById(articleNO);
        ModelAndView mav = new ModelAndView("newsView"); // Tiles 정의명
        mav.addObject("news", news);
        return mav;
    }

    /** 작성 폼 */
    @Override
    @RequestMapping(value="/writeForm.do", method=RequestMethod.GET)
    public ModelAndView writeForm() {
        return new ModelAndView("newsForm"); // Tiles 정의명
    }

    /** 등록 */
    @Override
    @RequestMapping(value="/write.do", method=RequestMethod.POST)
    public String write(@ModelAttribute NewsVO vo) {
        // 간이 키 생성(원하면 규칙/시퀀스로 교체 가능)
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
        ModelAndView mav = new ModelAndView("newsForm"); // 같은 폼 재사용
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
