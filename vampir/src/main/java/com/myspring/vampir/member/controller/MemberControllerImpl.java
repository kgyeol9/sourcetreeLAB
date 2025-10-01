package com.myspring.vampir.member.controller;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
public class MemberControllerImpl implements MemberController {

    @Autowired private MemberService memberService;
    @Autowired private MemberVO memberVO;

    @RequestMapping(value= {"", "/", "/home.do"}, method = {RequestMethod.GET, RequestMethod.POST})
    public ModelAndView home(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String viewName = (String)request.getAttribute("viewName");
        System.out.println("viewName :: "+ viewName);
        return new ModelAndView("/home");
    }

    @Override
    @RequestMapping(value="/member/listMembers.do" ,method = RequestMethod.GET)
    public ModelAndView listMembers(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setContentType("html/text;charset=utf-8");
        String viewName = (String)request.getAttribute("viewName");
        List membersList = memberService.listMembers();
        ModelAndView mav = new ModelAndView(viewName);
        mav.addObject("membersList", membersList);
        return mav;
    }

    @Override
    @RequestMapping(value="/member/addMember.do" ,method = RequestMethod.POST)
    public ModelAndView addMember(@ModelAttribute("member") MemberVO member,
                                  HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("utf-8");
        response.setContentType("html/text;charset=utf-8");
        HttpSession session = request.getSession();

        int result = memberService.addMember(member);

        String redirectURL = (String) session.getAttribute("redirectURL");
        if (redirectURL == null ||
            redirectURL.indexOf("/member/loginForm.do") != -1 ||
            redirectURL.indexOf("/member/memberForm.do") != -1) {
            redirectURL = "/home.do";
        }
        return new ModelAndView("redirect:"+redirectURL);
    }

    @Override
    @RequestMapping(value="/member/removeMember.do" ,method = RequestMethod.GET)
    public ModelAndView removeMember(@RequestParam("id") String id,
                                     HttpServletRequest request, HttpServletResponse response) throws Exception{
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

        memberVO = memberService.login(member); // DB 인증 (여기서 mem_code까지 SELECT 되도록 1) 반영)

        if (memberVO != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("member", memberVO);
            session.setAttribute("isLogOn", Boolean.TRUE);

            // ① 우선 VO에서 mem_code를 캐치
            Integer memCode = extractMemCodeFromUnknown(memberVO);

            // ② 여전히 null이면, 아이디로 mem_code를 한 번 더 조회(최후의 보루)
            if (memCode == null && memberVO.getMem_id() != null) {
                try {
                    memCode = memberService.findMemCodeByMemId(memberVO.getMem_id());
                } catch (Exception ignore) {}
            }

            // ③ 찾았다면 세션에 저장
            if (memCode != null) {
                session.setAttribute("memberCode", memCode);
            } else {
                System.out.println("[WARN] mem_code could not be resolved at login.");
            }

            String redirectURL = (String) session.getAttribute("redirectURL");
            if (redirectURL == null ||
                redirectURL.indexOf("/member/loginForm.do") != -1 ||
                redirectURL.indexOf("/member/memberForm.do") != -1) {
                redirectURL = "/home.do";
            }

            if (redirectURL != null) {
                mav.setViewName("redirect:"+redirectURL);
                session.removeAttribute("redirectURL");
            } else {
                mav.setViewName("redirect:/home.do");
            }
        } else {
            rAttr.addAttribute("result","loginFailed");
            mav.setViewName("redirect:/member/loginForm.do");
        }
        return mav;
    }

    @Override
    @RequestMapping(value = "/member/logout.do", method =  RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        session.removeAttribute("member");
        session.removeAttribute("memberCode"); // 같이 정리
        session.removeAttribute("isLogOn");
        return new ModelAndView("redirect:/home.do");
    }

    @Override
    @RequestMapping(
        value = "/member/overlapped.do",
        method = RequestMethod.POST,
        produces = "text/plain; charset=UTF-8"
    )
    public ResponseEntity<String> overlapped(@RequestParam("id") String id) throws Exception {
        String result = memberService.overlapped(id);
        if (result == null) result = "true";
        return ResponseEntity
                .ok()
                .header("Content-Type", "text/plain; charset=UTF-8")
                .body(result.trim());
    }

    @RequestMapping(value = "/member/*Form.do", method =  {RequestMethod.GET, RequestMethod.POST})
    private ModelAndView form(@RequestParam(value= "result", required=false) String result,
                              HttpServletRequest request,
                              HttpServletResponse response) throws Exception {
        String viewName = (String)request.getAttribute("viewName");
        HttpSession session = request.getSession();
        String referer = request.getHeader("Referer");
        session.setAttribute("redirectURL", referer);
        ModelAndView mav = new ModelAndView();
        mav.addObject("result",result);
        mav.setViewName(viewName);
        return mav;
    }

    // ===== mem_code 추출 유틸 (Java 1.6 호환) =====

    /** 어떤 객체에서도 mem_code 추출을 시도(Map/게터/필드). */
    private Integer extractMemCodeFromUnknown(Object obj) {
        if (obj == null) return null;

        // 1) Map
        if (obj instanceof java.util.Map) {
            java.util.Map m = (java.util.Map) obj;
            String[] keys = { "mem_code", "memCode", "memberCode", "mem_no", "memNo", "memId", "id", "code" };
            for (int i=0; i<keys.length; i++) {
                Integer parsed = parseIntish(m.get(keys[i]));
                if (parsed != null) return parsed;
            }
        }

        // 2) 게터
        String[] getters = {
            "getMem_code", "getMemCode", "getMemberCode",
            "getMem_no", "getMemNo", "getMemId",
            "getId", "getCode"
        };
        for (int i=0; i<getters.length; i++) {
            try {
                Method m = obj.getClass().getMethod(getters[i], new Class[0]);
                Object v = m.invoke(obj, new Object[0]);
                Integer parsed = parseIntish(v);
                if (parsed != null) return parsed;
            } catch (NoSuchMethodException e) {
            } catch (Exception e) {
            }
        }

        // 3) 필드
        String[] fields = { "mem_code", "memCode", "memberCode", "mem_no", "memNo", "memId", "id", "code" };
        for (int i=0; i<fields.length; i++) {
            try {
                Field fld = obj.getClass().getDeclaredField(fields[i]);
                fld.setAccessible(true);
                Integer parsed = parseIntish(fld.get(obj));
                if (parsed != null) return parsed;
            } catch (NoSuchFieldException e) {
            } catch (Exception e) {
            }
        }
        return null;
    }

    /** Number/String 어떤 형태든 정수로 파싱 (1.6 호환) */
    private Integer parseIntish(Object o) {
        if (o == null) return null;
        if (o instanceof Number) return Integer.valueOf(((Number) o).intValue());
        if (o instanceof String) {
            try { return Integer.valueOf(Integer.parseInt(((String) o).trim())); } catch (Exception ignore) {}
        }
        return null;
    }

    // (프로젝트에서 쓰는 getViewName 유틸은 그대로 둠)
}
