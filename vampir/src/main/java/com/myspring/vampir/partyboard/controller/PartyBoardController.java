package com.myspring.vampir.partyboard.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.partyboard.service.PartyApplicantService;
import com.myspring.vampir.partyboard.vo.PartyApplicantVO;

@Controller
public class PartyBoardController {

    @Autowired
    private PartyApplicantService applicantService;

    // ================= 화면 라우팅 =================
    /** 리스트: world/server 파라미터를 뷰로 전달 */
    @RequestMapping(value = "/partyboard.do", method = RequestMethod.GET)
    public ModelAndView partyboard(@RequestParam(value="world", required=false) String world,
                                   @RequestParam(value="server", required=false) String server,
                                   HttpServletRequest request,
                                   HttpServletResponse response) {
        ModelAndView mav = new ModelAndView("/partyboard"); // /WEB-INF/views/partyboard.jsp
        mav.addObject("world",  world  == null ? "" : world);
        mav.addObject("server", server == null ? "" : server);
        return mav;
    }

    @RequestMapping(value = "/partyboard/view.do", method = RequestMethod.GET)
    public ModelAndView partyboardView(HttpServletRequest request) {
        return new ModelAndView("/partyboardView");
    }

    // ================= 세션 유틸 =================
    /** 로그인한 사용자 ID(문자열)를 세션에서 최대한 호환성 있게 꺼낸다. */
    private String getLoginUserId(HttpSession session) {
        if (session == null) return null;

        // 1) 문자열로 바로 저장된 경우
        for (String k : new String[]{"loginId", "userId", "memberId"}) {
            Object v = session.getAttribute(k);
            if (v instanceof String) {
                String s = ((String) v).trim();
                if (!s.isEmpty()) return s;
            }
        }

        // 2) 기존 프로젝트에서 쓰던 "loginMember" 객체
        Object loginMember = session.getAttribute("loginMember");
        if (loginMember != null) {
            try {
                for (String g : new String[]{"getId", "getUserId", "getMemberId", "getMemId"}) {
                    Object v = loginMember.getClass().getMethod(g).invoke(loginMember);
                    if (v != null && !String.valueOf(v).trim().isEmpty())
                        return String.valueOf(v).trim();
                }
            } catch (Exception ignore) {}
        }

        // 3) 로그인 컨트롤러가 넣는 "member" (MemberVO)
        Object member = session.getAttribute("member");
        if (member != null) {
            try {
                for (String g : new String[]{"getMemId", "getId"}) {
                    Object v = member.getClass().getMethod(g).invoke(member);
                    if (v != null && !String.valueOf(v).trim().isEmpty())
                        return String.valueOf(v).trim();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    /** 닉네임을 세션에서 꺼낸다. */
    private String getLoginNick(HttpSession session) {
        if (session == null) return null;

        for (String k : new String[]{"loginNick", "nickname", "userNick"}) {
            Object v = session.getAttribute(k);
            if (v instanceof String) {
                String s = ((String) v).trim();
                if (!s.isEmpty()) return s;
            }
        }

        Object loginMember = session.getAttribute("loginMember");
        if (loginMember != null) {
            try {
                for (String g : new String[]{"getNickname", "getNick", "getName"}) {
                    Object v = loginMember.getClass().getMethod(g).invoke(loginMember);
                    if (v instanceof String && !((String) v).trim().isEmpty())
                        return ((String) v).trim();
                }
            } catch (Exception ignore) {}
        }

        Object member = session.getAttribute("member");
        if (member != null) {
            try {
                for (String g : new String[]{"getNickname", "getName"}) {
                    Object v = member.getClass().getMethod(g).invoke(member);
                    if (v instanceof String && !((String) v).trim().isEmpty())
                        return ((String) v).trim();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    // ================= 지원자 API =================

    /** 지원자 목록 */
    @ResponseBody
    @RequestMapping(
        value = "/partyboard/{postId}/applicants.json",
        method = RequestMethod.GET,
        produces = "application/json; charset=UTF-8"
    )
    public Map<String, Object> applicants(@PathVariable("postId") Long postId) {
        List<PartyApplicantVO> list = applicantService.list(postId);
        Map<String, Object> res = new HashMap<String, Object>();
        res.put("ok", true);
        res.put("items", list);
        return res;
    }

    /** 지원하기 (멀티파트/일반 폼 모두 허용) */
    @ResponseBody
    @RequestMapping(
        value = "/partyboard/{postId}/apply.do",
        method = RequestMethod.POST,
        produces = "application/json; charset=UTF-8"
    )
    public Map<String, Object> apply(@PathVariable("postId") Long postId,
                                     @RequestParam(value = "applyTitle", required = false) String applyTitle,
                                     @RequestParam(value = "igNick", required = false) String igNick,
                                     @RequestParam(value = "memo", required = false) String memo,
                                     @RequestParam(value = "image", required = false) MultipartFile image,
                                     HttpSession session, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<String, Object>();

        String uid = getLoginUserId(session);
        String nick = getLoginNick(session);

        if (uid == null || uid.trim().isEmpty()) {
            res.put("ok", false);
            res.put("error", "LOGIN_REQUIRED");
            res.put("message", "로그인이 필요합니다.");
            return res;
        }
        if (nick == null) nick = "";

        String savedPath = null;
        try {
            // === 선택 이미지 저장 ===
            if (image != null && !image.isEmpty()) {
                if (image.getSize() > (5L * 1024 * 1024)) {
                    res.put("ok", false);
                    res.put("error", "FILE_TOO_LARGE");
                    res.put("message", "이미지는 최대 5MB까지 업로드 가능합니다.");
                    return res;
                }

                // Servlet 2.5 호환: request.getSession().getServletContext()
                String webRoot = request.getSession().getServletContext().getRealPath("/");
                File dir = new File(webRoot, "resources/upload/party_applicants/" + postId);
                if (!dir.exists() && !dir.mkdirs())
                    throw new IOException("mkdirs failed: " + dir.getAbsolutePath());

                String original = image.getOriginalFilename();
                String ext = (original != null && original.lastIndexOf('.') > -1)
                        ? original.substring(original.lastIndexOf('.')) : "";
                String filename = "app_" + uid.replaceAll("[^a-zA-Z0-9_-]", "_") + "_" + System.currentTimeMillis() + ext;

                File dest = new File(dir, filename);
                image.transferTo(dest);

                savedPath = "resources/upload/party_applicants/" + postId + "/" + filename;
            }

            // === DB 저장 ===
            applicantService.apply(
                postId,
                uid,
                nick,
                (applyTitle == null ? "" : applyTitle.trim()),
                (igNick == null ? "" : igNick.trim()),
                (memo == null ? "" : memo.trim()),
                savedPath
            );

            res.put("ok", true);
            res.put("imagePath", savedPath);
            return res;

        } catch (org.springframework.dao.DuplicateKeyException e) {
            res.put("ok", false);
            res.put("error", "ALREADY_APPLIED");
            res.put("message", "이미 이 글에 지원했습니다.");
            return res;
        } catch (MultipartException e) {
            res.put("ok", false);
            res.put("error", "MULTIPART_ERROR");
            res.put("message", e.getMessage());
            return res;
        } catch (Exception e) {
            res.put("ok", false);
            res.put("error", "SERVER_ERROR");
            res.put("message", e.getClass().getSimpleName() + (e.getMessage() == null ? "" : " - " + e.getMessage()));
            return res;
        }
    }

    /** 수락 */
    @ResponseBody
    @RequestMapping(
        value = "/partyboard/{postId}/accept.do",
        method = RequestMethod.POST,
        produces = "application/json; charset=UTF-8"
    )
    public Map<String, Object> accept(@PathVariable("postId") Long postId,
                                      @RequestParam("userId") String targetUserId,
                                      HttpSession session) {
        Map<String, Object> res = new HashMap<String, Object>();
        String owner = getLoginUserId(session);
        if (owner == null || owner.trim().isEmpty()) {
            res.put("ok", false);
            res.put("error", "LOGIN_REQUIRED");
            res.put("message", "로그인이 필요합니다.");
            return res;
        }
        applicantService.accept(postId, targetUserId, owner);
        res.put("ok", true);
        return res;
    }

    /** 거절 */
    @ResponseBody
    @RequestMapping(
        value = "/partyboard/{postId}/reject.do",
        method = RequestMethod.POST,
        produces = "application/json; charset=UTF-8"
    )
    public Map<String, Object> reject(@PathVariable("postId") Long postId,
                                      @RequestParam("userId") String targetUserId,
                                      HttpSession session) {
        Map<String, Object> res = new HashMap<String, Object>();
        String owner = getLoginUserId(session);
        if (owner == null || owner.trim().isEmpty()) {
            res.put("ok", false);
            res.put("error", "LOGIN_REQUIRED");
            res.put("message", "로그인이 필요합니다.");
            return res;
        }
        applicantService.reject(postId, targetUserId, owner);
        res.put("ok", true);
        return res;
    }
}
