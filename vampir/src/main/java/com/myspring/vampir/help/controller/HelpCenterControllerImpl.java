package com.myspring.vampir.help.controller;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.help.service.HelpTicketService;
import com.myspring.vampir.help.vo.HelpTicketVO;
import com.myspring.vampir.member.service.MemberService;
import com.myspring.vampir.member.vo.MemberVO;

/**
 * HelpCenterControllerImpl
 * - /help/help.do : 고객센터 메인
 * - /help/ticket/view.do , /help/qna/view.do : 상세 공용
 * - /help/ticket/create.do : 문의 등록 (제목 가공 없이 저장)
 * - /help/search.do : QnA 검색 (분류+키워드, 공개글 + 내 비밀글)
 */
@Controller
@RequestMapping("/help")
public class HelpCenterControllerImpl implements HelpCenterController {

    @Autowired private HelpTicketService ticketService;
    @Autowired private MemberService memberService; // fallback

    /** 고객센터 메인 */
    @Override
    @RequestMapping(value = "/help.do", method = RequestMethod.GET)
    public ModelAndView help(HttpServletRequest request) {
        Integer myCode = currentMemberCode(request);

        List<HelpTicketVO> myTickets = (myCode != null)
                ? ticketService.findMyTickets(myCode)
                : Collections.<HelpTicketVO>emptyList();

        List<HelpTicketVO> qnaList = ticketService.findQnaList(myCode);

        ModelAndView mav = new ModelAndView("help");
        mav.addObject("ticketList", myTickets);
        mav.addObject("qnaList", qnaList);
        return mav;
    }

    /** 공용 상세보기: /help/ticket/view.do, /help/qna/view.do */
    @RequestMapping(value = {"/ticket/view.do", "/qna/view.do"}, method = RequestMethod.GET)
    public ModelAndView viewTicket(HttpServletRequest request,
                                   @RequestParam("id") Long id) {
        HelpTicketVO ticket = ticketService.findById(id);
        ModelAndView mav = new ModelAndView("help/ticket-view");
        if (ticket == null) {
            mav.addObject("error", "존재하지 않는 문의입니다.");
            return mav;
        }

        Integer myCode = currentMemberCode(request);
        if (ticket.isSecret()) {
            if (myCode == null || !ticket.getMem_code().equals(myCode)) {
                mav.addObject("error", "비밀글은 작성자만 열람할 수 있습니다.");
                return mav;
            }
        }

        mav.addObject("t", ticket);
        return mav;
    }

    /** 1:1 문의 등록 (제목은 가공하지 않고 그대로 저장) */
    @Override
    @RequestMapping(value = "/ticket/create.do", method = RequestMethod.POST)
    public ModelAndView createTicket(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        MemberVO me = (session != null) ? (MemberVO) session.getAttribute("member") : null;

        String category = nvl(request.getParameter("category"));
        String title    = nvl(request.getParameter("title"));
        String content  = nvl(request.getParameter("content"));
        String secret   = nvl(request.getParameter("secret"));

        if (me == null) {
            ModelAndView mav = help(request);
            mav.addObject("inlineError", "문의 등록은 로그인 후 사용할 수 있습니다.");
            stashFormValues(mav, category, title, content, secret);
            return mav;
        }

        Integer myCode = currentMemberCode(request);
        if (myCode == null) {
            ModelAndView mav = help(request);
            mav.addObject("inlineError", "회원 코드(mem_code)를 확인할 수 없습니다.");
            stashFormValues(mav, category, title, content, secret);
            return mav;
        }

        if (category.isEmpty() || title.isEmpty() || content.isEmpty()) {
            ModelAndView mav = help(request);
            mav.addObject("inlineError", "필수 입력값이 누락되었습니다.");
            stashFormValues(mav, category, title, content, secret);
            return mav;
        }

        HelpTicketVO vo = new HelpTicketVO();
        vo.setMem_code(myCode);
        vo.setCategory(category);
        vo.setTitle(title); // ← DB에는 순수 제목만 저장
        vo.setContent(content);
        vo.setSecret(isTruthy(secret));

        ticketService.create(vo);
        return new ModelAndView("redirect:/help/help.do");
    }

    /** QnA 검색: /help/search.do?category=&q= */
    @RequestMapping(value = "/search.do", method = RequestMethod.GET)
    public ModelAndView search(HttpServletRequest request,
                               @RequestParam(value = "category", required = false) String category,
                               @RequestParam(value = "q",         required = false) String q) {
        Integer myCode = currentMemberCode(request);

        // 내 문의 영역 유지
        List<HelpTicketVO> myTickets = (myCode != null)
                ? ticketService.findMyTickets(myCode)
                : Collections.<HelpTicketVO>emptyList();

        // 검색 결과
        List<HelpTicketVO> qnaList = ticketService.findQnaBySearch(myCode, nvl(category), nvl(q));

        ModelAndView mav = new ModelAndView("help");
        mav.addObject("ticketList", myTickets);
        mav.addObject("qnaList", qnaList);

        // 검색값 유지용
        mav.addObject("searchCategory", nvl(category));
        mav.addObject("searchQuery", nvl(q));
        return mav;
    }

    /* ---------------------- 유틸 ---------------------- */

    /** 세션에서 현재 회원 mem_code 유연 추출 + 최후보루 DB 재조회 */
    private Integer currentMemberCode(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return null;

        // 1) 직저장 값 우선
        Integer direct = parseIntish(s.getAttribute("memberCode"));
        if (direct != null) return direct;

        // 2) 흔한 세션 키에서 추출
        String[] attrNames = {"member","loginMember","user","memberInfo","memberVO","loginUser"};
        Object memberObj = null;
        for (int i = 0; i < attrNames.length; i++) {
            Object obj = s.getAttribute(attrNames[i]);
            Integer v = extractMemCodeFromUnknown(obj);
            if (v != null) { s.setAttribute("memberCode", v); return v; }
            if (memberObj == null && obj != null) memberObj = obj;
        }

        // 3) mem_id 있으면 DB에서 mem_code 재조회
        String memId = null;
        try {
            if (memberObj instanceof MemberVO) memId = ((MemberVO) memberObj).getMemId();
            else if (memberObj != null) memId = extractStringByNames(memberObj,
                    new String[]{"memId","mem_id","id","username"});
        } catch (Exception ignore) {}

        if (memId != null) {
            try {
                Integer code = memberService.findMemCodeByMemId(memId);
                if (code != null) { s.setAttribute("memberCode", code); return code; }
            } catch (Exception ignore) {}
        }
        return null;
    }

    /** 어떤 객체에서도 mem_code 추출(Map/게터/필드). (자바 1.6 호환 스타일) */
    private Integer extractMemCodeFromUnknown(Object obj) {
        if (obj == null) return null;

        // Map
        if (obj instanceof java.util.Map) {
            java.util.Map m = (java.util.Map) obj;
            String[] keys = {"mem_code","memCode","memberCode","mem_no","memNo","memId","id","code"};
            for (int i=0;i<keys.length;i++){ Integer p = parseIntish(m.get(keys[i])); if (p!=null) return p; }
        }

        // Getter
        String[] getters = {"getMem_code","getMemCode","getMemberCode","getMem_no","getMemNo",
                "getMemId","getId","getCode"};
        for (int i=0;i<getters.length;i++){
            try{
                Method m = obj.getClass().getMethod(getters[i], new Class[0]);
                Object v = m.invoke(obj, new Object[0]);
                Integer p = parseIntish(v);
                if (p!=null) return p;
            }catch(NoSuchMethodException e){}catch(Exception e){}
        }

        // Field
        String[] fields = {"mem_code","memCode","memberCode","mem_no","memNo","memId","id","code"};
        for (int i=0;i<fields.length;i++){
            try{
                Field f = obj.getClass().getDeclaredField(fields[i]);
                f.setAccessible(true);
                Integer p = parseIntish(f.get(obj));
                if (p!=null) return p;
            }catch(NoSuchFieldException e){}catch(Exception e){}
        }
        return null;
    }

    /** 객체에서 문자열 키 후보로 값 추출 */
    private String extractStringByNames(Object obj, String[] names) {
        if (obj == null) return null;

        // Map
        if (obj instanceof java.util.Map) {
            java.util.Map m = (java.util.Map) obj;
            for (int i=0;i<names.length;i++){
                Object v = m.get(names[i]);
                if (v instanceof String) return (String) v;
            }
        }

        // Getter
        for (int i=0;i<names.length;i++){
            String g = "get" + Character.toUpperCase(names[i].charAt(0)) + names[i].substring(1);
            try{
                Method m = obj.getClass().getMethod(g, new Class[0]);
                Object v = m.invoke(obj, new Object[0]);
                if (v instanceof String) return (String) v;
            }catch(Exception e){}
        }

        // Field
        for (int i=0;i<names.length;i++){
            try{
                Field f = obj.getClass().getDeclaredField(names[i]);
                f.setAccessible(true);
                Object v = f.get(obj);
                if (v instanceof String) return (String) v;
            }catch(Exception e){}
        }
        return null;
    }

    /** Number/String 어떤 형태든 정수로 파싱 */
    private Integer parseIntish(Object o) {
        if (o == null) return null;
        if (o instanceof Number) return Integer.valueOf(((Number) o).intValue());
        if (o instanceof String) {
            try { return Integer.valueOf(Integer.parseInt(((String)o).trim())); }
            catch (Exception ignore) {}
        }
        return null;
    }

    private static String nvl(String s){ return (s==null) ? "" : s.trim(); }

    private static boolean isTruthy(String s){
        if (s == null) return false;
        String v = s.trim().toLowerCase();
        return "1".equals(v) || "true".equals(v) || "on".equals(v) || "y".equals(v);
    }

    /** 입력값을 다시 화면에 보여주기 위해 모델에 적재 */
    private static void stashFormValues(ModelAndView mav, String category, String title, String content, String secret){
        mav.addObject("formCategory", category);
        mav.addObject("formTitle", title);
        mav.addObject("formContent", content);
        mav.addObject("formSecret", secret);
    }
}
