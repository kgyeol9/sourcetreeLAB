package com.myspring.vampir.partyboard.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.partyboard.service.PartyApplicantService;
import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

@Controller
public class PartyBoardController {

    @Autowired
    private PartyApplicantService applicantService;

    // ===== 화면 라우팅 =====
    @RequestMapping(value="/partyboard.do", method=RequestMethod.GET)
    public ModelAndView partyboard(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("/partyboard");
    }

    @RequestMapping(value="/partyboard/view.do", method=RequestMethod.GET)
    public ModelAndView partyboardView(HttpServletRequest request) {
        return new ModelAndView("/partyboardView");
    }

    // ===== 세션 유틸 =====
    private String getLoginUserId(HttpSession session) {
        if (session == null) return null;
        Object o;
        for (String k : new String[]{"loginId","userId","memberId"}) {
            o = session.getAttribute(k);
            if (o != null && !String.valueOf(o).trim().isEmpty()) return String.valueOf(o).trim();
        }
        Object m = session.getAttribute("loginMember");
        if (m != null) {
            try {
                for (String g : new String[]{"getId","getUserId","getMemberId"}) {
                    java.lang.reflect.Method md = m.getClass().getMethod(g);
                    Object v = md.invoke(m);
                    if (v != null && !String.valueOf(v).trim().isEmpty()) return String.valueOf(v).trim();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    private String getLoginNick(HttpSession session) {
        if (session == null) return null;
        Object o;
        for (String k : new String[]{"loginNick","nickname","userNick"}) {
            o = session.getAttribute(k);
            if (o instanceof String && !((String)o).trim().isEmpty()) return ((String)o).trim();
        }
        Object m = session.getAttribute("loginMember");
        if (m != null) {
            try {
                for (String g : new String[]{"getNickname","getNick","getName"}) {
                    java.lang.reflect.Method md = m.getClass().getMethod(g);
                    Object v = md.invoke(m);
                    if (v instanceof String && !((String)v).trim().isEmpty()) return ((String)v).trim();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    // ===== 지원자 API =====

    /** 지원자 목록 */
    @ResponseBody
    @RequestMapping(value="/partyboard/{postId}/applicants.json", method=RequestMethod.GET, produces="application/json; charset=UTF-8")
    public Map<String,Object> applicants(@PathVariable("postId") Long postId) {
        List<PartyApplicantVO> list = applicantService.list(postId);
        Map<String,Object> res = new HashMap<String,Object>();
        res.put("ok", true);
        res.put("items", list);
        return res;
    }

    /** 지원하기 (로그인 필요) */
    @ResponseBody
    @RequestMapping(value="/partyboard/{postId}/apply.do", method=RequestMethod.POST, produces="application/json; charset=UTF-8")
    public Map<String,Object> apply(@PathVariable("postId") Long postId, HttpSession session) {
        String uid = getLoginUserId(session);
        String nick = getLoginNick(session);
        Map<String,Object> res = new HashMap<String,Object>();
        if (uid == null || uid.trim().isEmpty()) {
            res.put("ok", false); res.put("error", "LOGIN_REQUIRED"); return res;
        }
        applicantService.apply(postId, uid, (nick==null?"":nick));
        res.put("ok", true);
        return res;
    }

    /** 수락 (권한 체크는 서비스에서 처리) */
    @ResponseBody
    @RequestMapping(value="/partyboard/{postId}/accept.do", method=RequestMethod.POST, produces="application/json; charset=UTF-8")
    public Map<String,Object> accept(@PathVariable("postId") Long postId,
                                     @RequestParam("userId") String targetUserId,
                                     HttpSession session) {
        String owner = getLoginUserId(session);
        Map<String,Object> res = new HashMap<String,Object>();
        if (owner == null || owner.trim().isEmpty()) {
            res.put("ok", false); res.put("error", "LOGIN_REQUIRED"); return res;
        }
        applicantService.accept(postId, targetUserId, owner);
        res.put("ok", true);
        return res;
    }

    /** 거절 (권한 체크는 서비스에서 처리) */
    @ResponseBody
    @RequestMapping(value="/partyboard/{postId}/reject.do", method=RequestMethod.POST, produces="application/json; charset=UTF-8")
    public Map<String,Object> reject(@PathVariable("postId") Long postId,
                                     @RequestParam("userId") String targetUserId,
                                     HttpSession session) {
        String owner = getLoginUserId(session);
        Map<String,Object> res = new HashMap<String,Object>();
        if (owner == null || owner.trim().isEmpty()) {
            res.put("ok", false); res.put("error", "LOGIN_REQUIRED"); return res;
        }
        applicantService.reject(postId, targetUserId, owner);
        res.put("ok", true);
        return res;
    }
}
