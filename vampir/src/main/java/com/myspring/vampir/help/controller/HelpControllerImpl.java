package com.myspring.vampir.help.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller("helpController")
public class HelpControllerImpl {

    @RequestMapping(value = "/help/help.do", method = { RequestMethod.GET, RequestMethod.POST })
    private ModelAndView help(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("help");   // ← Tiles 정의 name="help"
        return mav;
    }

    @RequestMapping(value = "/news.do", method = { RequestMethod.GET, RequestMethod.POST })
    private ModelAndView news(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("news");   // ← Tiles 정의 name="news"
        return mav;
    }
}