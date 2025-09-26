package com.myspring.vampir.partyboard.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class PartyBoardController {

    @RequestMapping(value="/partyboard.do", method=RequestMethod.GET)
    public ModelAndView partyboard(HttpServletRequest request, HttpServletResponse response) {
        // Tiles 정의명 "/partyboard" 로 반환
        return new ModelAndView("/partyboard");
    }
    
    @RequestMapping(value="/partyboard/view.do", method=RequestMethod.GET)
    public ModelAndView partyboardView(HttpServletRequest request) {
        // 데모: 파라미터 그대로 보여주는 뷰
        return new ModelAndView("/partyboardView"); // Tiles 정의 이름
    }

}

