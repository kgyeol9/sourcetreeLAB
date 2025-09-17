package com.myspring.vampir.DB.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.DB.service.ItemService;

@Controller
public class ItemControllerImpl implements ItemController {

    @Autowired
    private ItemService itemService;

    // 루트 진입 시 목록으로 리다이렉트 (장비 DB)
    @RequestMapping(value = { "/", "/main.do" }, method = RequestMethod.GET)
    public ModelAndView main() {
        return new ModelAndView("redirect:/DB/listItems.do");
    }

    @Override
    @RequestMapping(value = "/DB/listItems.do", method = RequestMethod.GET)
    public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Map<String, Object>> itemsList = itemService.listItemsUnified();
        System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

        // ★ JSP 파일명이 itemDB.jsp 이므로 뷰 이름도 itemDB로
        ModelAndView mav = new ModelAndView("itemDB");   // /WEB-INF/views/itemDB.jsp (일반적인 ViewResolver 기준)
        mav.addObject("itemsList", itemsList);           // JSP들이 기대하는 키로 통일
        return mav;
    }

    // 직행 링크 (장비 DB)
    @RequestMapping(value = "/itemDB.do", method = RequestMethod.GET)
    public ModelAndView itemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("redirect:/DB/listItems.do");
    }

    @Override
    @RequestMapping(value = "/DB/listEtcItems.do", method = RequestMethod.GET)
    public ModelAndView listEtcItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<Map<String, Object>> itemsList = itemService.listEtcItemsUnified();
        System.out.println("[DEBUG] etc itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

        ModelAndView mav = new ModelAndView("etcDB");    // /WEB-INF/views/etcDB.jsp
        mav.addObject("itemsList", itemsList);           // ★ 키 통일
        return mav;
    }

    // 직행 링크 (기타 DB)
    @RequestMapping(value = "/etcDB.do", method = RequestMethod.GET)
    public ModelAndView EtcItemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return new ModelAndView("redirect:/DB/listEtcItems.do");
    }
}
