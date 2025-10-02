package com.myspring.vampir.member.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.myspring.vampir.member.service.MemberService;
import com.myspring.vampir.member.vo.MemberVO;

@Controller("memberController")
//@EnableAspectJAutoProxy
public class MemberControllerImpl implements MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberVO memberVO;

    @RequestMapping(value = "/home.do", method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView home(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String viewName = (String) request.getAttribute("viewName");
        System.out.println("viewName :: " + viewName);
        return new ModelAndView("/home");
    }

    @Override
    @RequestMapping(value = "/member/listMembers.do", method = RequestMethod.GET)
    public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setContentType("html/text;charset=utf-8");
        String viewName = (String) request.getAttribute("viewName");
        List membersList = memberService.listMembers();
        ModelAndView mav = new ModelAndView(viewName);
        mav.addObject("membersList", membersList);
        return mav;
    }

    @Override
    @RequestMapping(value = "/member/addMember.do", method = RequestMethod.POST)
    public ModelAndView addMember(@ModelAttribute("member") MemberVO member,
                                  HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setContentType("html/text;charset=utf-8");

        HttpSession session = request.getSession();
        String redirectURL = (String) session.getAttribute("redirectURL");
        System.out.println("redirectURL: " + redirectURL);

        if (redirectURL == null ||
            redirectURL.contains("/member/loginForm.do") ||
            redirectURL.contains("/member/memberForm.do")) {
            redirectURL = "/home.do";
        }

        memberService.addMember(member);
        return new ModelAndView("redirect:" + redirectURL);
    }

    @Override
    @RequestMapping(value = "/member/removeMember.do", method = RequestMethod.GET)
    public ModelAndView removeMember(@RequestParam("id") String id,
                                     HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        memberService.removeMember(id);
        return new ModelAndView("redirect:/member/listMembers.do");
    }

    @Override
    @RequestMapping(value = "/member/login.do", method = RequestMethod.POST)
    public ModelAndView login(@ModelAttribute("member") MemberVO member,
                              RedirectAttributes rAttr,
                              HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView();

        // 실제 인증
        memberVO = memberService.login(member);

        if (memberVO != null) {
            HttpSession session = request.getSession();

            // 기존 세션 값
            session.setAttribute("member", memberVO);
            session.setAttribute("isLogOn", true);

            // ★ PartyBoardController가 사용하는 세션 키들 주입
            session.setAttribute("loginId", memberVO.getMemId());
            session.setAttribute("loginNick", memberVO.getNickname());
            session.setAttribute("loginMember", memberVO);

            String redirectURL = (String) session.getAttribute("redirectURL");
            System.out.println("redirectURL: " + redirectURL);

            if (redirectURL == null ||
                redirectURL.contains("/member/loginForm.do") ||
                redirectURL.contains("/member/memberForm.do")) {
                redirectURL = "/home.do";
            }

            if (redirectURL != null) {
                mav.setViewName("redirect:" + redirectURL);
                session.removeAttribute("redirectURL");
            } else {
                mav.setViewName("redirect:/home.do");
            }
        } else {
            rAttr.addAttribute("result", "loginFailed");
            mav.setViewName("redirect:/member/loginForm.do");
        }
        return mav;
    }

    @Override
    @RequestMapping(value = "/member/logout.do", method = RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();

        // 기존 제거
        session.removeAttribute("member");
        session.removeAttribute("isLogOn");

        // ★ 추가한 세션 키들도 함께 제거
        session.removeAttribute("loginId");
        session.removeAttribute("loginNick");
        session.removeAttribute("loginMember");

        return new ModelAndView("redirect:/home.do");
    }

    @RequestMapping(value = "/member/*Form.do", method = {RequestMethod.GET, RequestMethod.POST})
    private ModelAndView form(@RequestParam(value = "result", required = false) String result,
                              HttpServletRequest request,
                              HttpServletResponse response) throws Exception {
        String viewName = (String) request.getAttribute("viewName");

        HttpSession session = request.getSession();
        String referer = request.getHeader("Referer");
        session.setAttribute("redirectURL", referer);

        ModelAndView mav = new ModelAndView();
        mav.addObject("result", result);
        mav.setViewName(viewName);
        return mav;
    }

    private String getViewName(HttpServletRequest request) throws Exception {
        String contextPath = request.getContextPath();
        String uri = (String) request.getAttribute("javax.servlet.include.request_uri");
        if (uri == null || uri.trim().equals("")) {
            uri = request.getRequestURI();
        }

        int begin = 0;
        if (!(contextPath == null || "".equals(contextPath))) {
            begin = contextPath.length();
        }

        int end;
        if (uri.indexOf(";") != -1) {
            end = uri.indexOf(";");
        } else if (uri.indexOf("?") != -1) {
            end = uri.indexOf("?");
        } else {
            end = uri.length();
        }

        String viewName = uri.substring(begin, end);
        if (viewName.indexOf(".") != -1) {
            viewName = viewName.substring(0, viewName.lastIndexOf("."));
        }
        if (viewName.lastIndexOf("/") != -1) {
            viewName = viewName.substring(viewName.lastIndexOf("/", 1), viewName.length());
        }
        return viewName;
    }
}
