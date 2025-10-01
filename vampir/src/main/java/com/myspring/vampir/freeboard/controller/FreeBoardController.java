package com.myspring.vampir.freeboard.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.myspring.vampir.freeboard.service.FreeBoardService;
import com.myspring.vampir.freeboard.service.FreeCommentService;
import com.myspring.vampir.freeboard.vo.FreePostVO;
import com.myspring.vampir.freeboard.vo.FreeCommentVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.lang.reflect.Method;
import java.util.List;

@Controller
@RequestMapping("/free")
public class FreeBoardController {

    @Autowired private FreeBoardService service;
    @Autowired private FreeCommentService commentService;

    /* ---- 공통 유틸: 로그인 닉/아이디 꺼내기 (서버게시판 방식과 동일) ---- */
    private String resolveLoginNick(HttpSession session) {
        if (session == null) return null;
        Object v = session.getAttribute("loginNick");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        v = session.getAttribute("nickname");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        v = session.getAttribute("userNick");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        for (String attr : new String[]{"member","user"}) {
            Object obj = session.getAttribute(attr);
            if (obj != null) {
                for (String getter : new String[]{"getNickname","getNick","getName","getUserName"}) {
                    try {
                        Method md = obj.getClass().getMethod(getter);
                        Object nv = md.invoke(obj);
                        if (nv instanceof String && !((String) nv).trim().isEmpty()) return ((String) nv).trim();
                    } catch (Exception ignore) {}
                }
            }
        }
        return null;
    }
    private String resolveLoginId(HttpSession session) {
        if (session == null) return null;
        for (String key : new String[]{"loginId","memberId","userId"}) {
            Object v = session.getAttribute(key);
            if (v != null && !String.valueOf(v).trim().isEmpty()) return String.valueOf(v).trim();
        }
        for (String attr : new String[]{"member","user"}) {
            Object obj = session.getAttribute(attr);
            if (obj != null) {
                for (String getter : new String[]{"getMemberId","getId","getUserId"}) {
                    try {
                        Method md = obj.getClass().getMethod(getter);
                        Object idv = md.invoke(obj);
                        if (idv != null && !String.valueOf(idv).trim().isEmpty()) return String.valueOf(idv).trim();
                    } catch (Exception ignore) {}
                }
            }
        }
        return null;
    }

    /* ===== 목록 ===== */
    @RequestMapping(value="/list.do", method=RequestMethod.GET)
    public ModelAndView list(HttpServletRequest request,
                             @RequestParam(value="page", defaultValue="1") int page,
                             @RequestParam(value="size", defaultValue="10") int size) {
        List<FreePostVO> posts = service.list(page, size);
        int total = service.count();
        int totalPages = (int)Math.ceil((double)total / size);
        boolean login = resolveLoginId(request.getSession()) != null;

        ModelAndView mav = new ModelAndView("/free/list");
        mav.addObject("posts", posts);
        mav.addObject("page", page);
        mav.addObject("size", size);
        mav.addObject("total", total);
        mav.addObject("totalPages", totalPages);
        mav.addObject("login", login);
        return mav;
    }

    /* ===== 글쓰기 폼 ===== */
    @RequestMapping(value="/write.do", method=RequestMethod.GET)
    public ModelAndView writeForm(HttpServletRequest request) {
        boolean login = resolveLoginId(request.getSession()) != null;
        ModelAndView mav = new ModelAndView("/free/write");
        mav.addObject("login", login);
        mav.addObject("loginNick", resolveLoginNick(request.getSession()));
        return mav;
    }

    /* ===== 글 등록 ===== */
    @RequestMapping(value="/write.do", method=RequestMethod.POST)
    public ModelAndView add(HttpServletRequest request,
                            @RequestParam("title") String title,
                            @RequestParam("content") String content) {
        HttpSession session = request.getSession();
        String writerId = resolveLoginId(session);
        if (writerId == null) {
            // 로그인 필요
            return new ModelAndView("redirect:/free/list.do?error=login");
        }
        String nick = resolveLoginNick(session);
        String writerName = (nick != null && !nick.isEmpty()) ? nick : "회원";

        Long newId = service.create(title, content, writerId, writerName);
        if (newId == null) {
            // 실패 시 목록으로
            return new ModelAndView("redirect:/free/list.do?error=insert");
        }
        return new ModelAndView("redirect:/free/view.do?postId=" + newId);
    }

    /* ===== 상세 ===== */
    @RequestMapping(value="/view.do", method=RequestMethod.GET)
    public ModelAndView view(HttpServletRequest request,
                             @RequestParam("postId") Long postId) {
        FreePostVO post = service.viewAndIncrease(postId);
        ModelAndView mav = new ModelAndView("/free/view");
        if (post == null) {
            mav.addObject("notFound", true);
            return mav;
        }
        HttpSession session = request.getSession();
        String loginId = resolveLoginId(session);
        String loginNick = resolveLoginNick(session);
        boolean mine = (loginId != null && loginId.equals(post.getWriterId()));

        List<FreeCommentVO> comments = commentService.list(postId);

        mav.addObject("post", post);
        mav.addObject("comments", comments);
        mav.addObject("login", loginId != null);
        mav.addObject("loginNick", loginNick);
        mav.addObject("mine", mine);
        return mav;
    }

    /* ===== 수정 폼 ===== */
    @RequestMapping(value="/edit.do", method=RequestMethod.GET)
    public ModelAndView editForm(HttpServletRequest request,
                                 @RequestParam("postId") Long postId) {
        FreePostVO post = service.viewAndIncrease(postId); // 혹시 조회수 증가가 싫다면 별도 selectOne으로 교체
        ModelAndView mav = new ModelAndView("/free/edit");
        if (post == null) {
            mav.addObject("notFound", true);
            return mav;
        }
        String loginId = resolveLoginId(request.getSession());
        boolean mine = (loginId != null && loginId.equals(post.getWriterId()));
        mav.addObject("post", post);
        mav.addObject("mine", mine);
        mav.addObject("login", loginId != null);
        return mav;
    }

    /* ===== 수정 처리 ===== */
    @RequestMapping(value="/update.do", method=RequestMethod.POST)
    public ModelAndView update(HttpServletRequest request,
                               @RequestParam("postId") Long postId,
                               @RequestParam("title") String title,
                               @RequestParam("content") String content) {
        String loginId = resolveLoginId(request.getSession());
        if (loginId == null) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=login");
        }
        boolean ok = service.updateOwn(postId, loginId, title, content);
        if (!ok) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=update");
        }
        return new ModelAndView("redirect:/free/view.do?postId=" + postId);
    }

    /* ===== 삭제 처리 ===== */
    @RequestMapping(value="/delete.do", method=RequestMethod.POST)
    public ModelAndView delete(HttpServletRequest request,
                               @RequestParam("postId") Long postId) {
        String loginId = resolveLoginId(request.getSession());
        if (loginId == null) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=login");
        }
        boolean ok = service.deleteOwn(postId, loginId); // ★ deleteOwn을 직접 호출
        if (!ok) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=delete");
        }
        return new ModelAndView("redirect:/free/list.do?msg=deleted");
    }

    /* ===== 댓글 등록/수정/삭제 ===== */
    @RequestMapping(value="/comment/add.do", method=RequestMethod.POST)
    public ModelAndView commentAdd(HttpServletRequest request,
                                   @RequestParam("postId") Long postId,
                                   @RequestParam(value="parentId", required=false) Long parentId,
                                   @RequestParam("content") String content) {
        HttpSession session = request.getSession();
        String loginId = resolveLoginId(session);
        if (loginId == null) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=login");
        }
        String nick = resolveLoginNick(session);
        String writerName = (nick != null && !nick.isEmpty()) ? nick : "회원";
        commentService.add(postId, parentId, content, loginId, writerName);
        return new ModelAndView("redirect:/free/view.do?postId=" + postId);
    }

    @RequestMapping(value="/comment/update.do", method=RequestMethod.POST)
    public ModelAndView commentUpdate(HttpServletRequest request,
                                      @RequestParam("id") Long id,
                                      @RequestParam("postId") Long postId,
                                      @RequestParam("content") String content) {
        String loginId = resolveLoginId(request.getSession());
        if (loginId == null) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=login");
        }
        commentService.edit(id, loginId, content);
        return new ModelAndView("redirect:/free/view.do?postId=" + postId);
    }

    @RequestMapping(value="/comment/delete.do", method=RequestMethod.POST)
    public ModelAndView commentDelete(HttpServletRequest request,
                                      @RequestParam("id") Long id,
                                      @RequestParam("postId") Long postId) {
        String loginId = resolveLoginId(request.getSession());
        if (loginId == null) {
            return new ModelAndView("redirect:/free/view.do?postId=" + postId + "&error=login");
        }
        commentService.remove(id, loginId);
        return new ModelAndView("redirect:/free/view.do?postId=" + postId);
    }
}
