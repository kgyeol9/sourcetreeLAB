package com.myspring.vampir.item.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.item.service.ItemService;

@Controller // ("itemController") 생략 추천
public class ItemControllerImpl implements ItemController {

    @Autowired
    private ItemService itemService;

    // 루트 진입 시 목록으로 리다이렉트
    @RequestMapping(value = { "/", "/main.do" }, method = RequestMethod.GET)
    public ModelAndView main() {
        return new ModelAndView("redirect:/item/listItems.do");
    }

    @Override
    @RequestMapping(value = "/item/listItems.do", method = RequestMethod.GET)
    public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
        // ★ 통합(Map) 리스트 호출
        List<Map<String, Object>> itemsList = itemService.listItemsUnified();

        System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

        // ★ 바로 itemDB.jsp 렌더 (ViewResolver에 맞춰 경로 조절)
        ModelAndView mav = new ModelAndView("itemDB");
        mav.addObject("itemsList", itemsList);
        return mav;
    }

    // (선택) 기존 /itemDB.do 엔드포인트는 목록으로 리다이렉트하거나 동일 로직 재사용
    @RequestMapping(value = "/itemDB.do", method = RequestMethod.GET)
    public ModelAndView itemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("redirect:/item/listItems.do");
    }
    
    @RequestMapping(value = "/etcItemDB.do", method = RequestMethod.GET)
    public ModelAndView etcItemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	return new ModelAndView("redirect:/item/listItems.do");
    }
}
