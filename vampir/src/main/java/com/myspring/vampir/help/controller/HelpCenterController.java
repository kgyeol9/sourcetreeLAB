package com.myspring.vampir.help.controller;

import javax.servlet.http.HttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

/**
 * 고객센터(Help) 컨트롤러 인터페이스
 * - /help/help.do : 메인 화면 렌더 (내 문의, QnA 목록)
 * - /help/ticket/create.do : 1:1 문의 등록 (로그인 필수)
 */
public interface HelpCenterController {

    /** 고객센터 메인 (help.jsp) */
    ModelAndView help(HttpServletRequest request);

    /** 1:1 문의 등록 (로그인 필수) */
    ModelAndView createTicket(HttpServletRequest request);
}
