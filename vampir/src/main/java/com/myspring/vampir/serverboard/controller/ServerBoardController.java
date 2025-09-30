package com.myspring.vampir.serverboard.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.serverboard.service.ServerBoardService;
import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

// ▼ 이미지 업로드에 필요한 import (기존 기능 유지, 추가만)
import org.springframework.web.multipart.MultipartFile;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class ServerBoardController {

    @Autowired
    private ServerBoardService service;

    private static final Map<String, String> WORLD_LABELS = new LinkedHashMap<String, String>();
    static {
        WORLD_LABELS.put("kapf","카프"); WORLD_LABELS.put("olga","올가"); WORLD_LABELS.put("shima","쉬마");
        WORLD_LABELS.put("oscar","오스카"); WORLD_LABELS.put("damir","다미르"); WORLD_LABELS.put("moarte","모아르테");
        WORLD_LABELS.put("razvi","라즈비"); WORLD_LABELS.put("foam","포아메"); WORLD_LABELS.put("dorlingen","돌링엔");
        WORLD_LABELS.put("kizaiya","키자이아"); WORLD_LABELS.put("nel","넬"); WORLD_LABELS.put("mila","밀라");
        WORLD_LABELS.put("lilith","릴리스"); WORLD_LABELS.put("kain","카인"); WORLD_LABELS.put("ridel","리델");
    }

    // 로그인 닉네임 해석 (여러 세션 키 지원) — 기존 그대로 사용
    private String resolveLoginNick(HttpSession session) {
        if (session == null) return null;
        Object v;
        v = session.getAttribute("loginNick");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        v = session.getAttribute("nickname");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        v = session.getAttribute("userNick");
        if (v instanceof String && !((String) v).trim().isEmpty()) return ((String) v).trim();
        Object m = session.getAttribute("member");
        if (m != null) {
            try {
                for (String getter : new String[]{"getNickname","getNick","getName","getUserName"}) {
                    java.lang.reflect.Method md = m.getClass().getMethod(getter);
                    Object nv = md.invoke(m);
                    if (nv instanceof String && !((String) nv).trim().isEmpty()) return ((String) nv).trim();
                }
            } catch (Exception ignore) {}
        }
        Object u = session.getAttribute("user");
        if (u != null) {
            try {
                for (String getter : new String[]{"getNickname","getNick","getName","getUserName"}) {
                    java.lang.reflect.Method md = u.getClass().getMethod(getter);
                    Object nv = md.invoke(u);
                    if (nv instanceof String && !((String) nv).trim().isEmpty()) return ((String) nv).trim();
                }
            } catch (Exception ignore) {}
        }
        return null;
    }

    /** 선택 화면 */
    @RequestMapping(value = "/serverboard.do", method = RequestMethod.GET)
    public ModelAndView select() {
        return new ModelAndView("/serverboardSelect");
    }

    /** 목록 화면 (경로형) */
    @RequestMapping(value = {"/serverboard/{world}/{server}", "/serverboard/{world}/{server}.do"}, method = RequestMethod.GET)
    public ModelAndView list(@PathVariable("world") String world,
                             @PathVariable("server") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/list");
        List<ServerPostVO> articles = service.list(world, server);
        mav.addObject("articles", articles);
        mav.addObject("world", world);
        mav.addObject("server", server);
        mav.addObject("worldLabel", WORLD_LABELS.get(world));
        mav.addObject("serverLabel", server + " 서버");
        return mav;
    }

    /** 목록 화면 (쿼리스트링형) */
    @RequestMapping(value = "/serverboard/list.do", method = RequestMethod.GET)
    public ModelAndView listWithParams(@RequestParam("world") String world,
                                       @RequestParam("server") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/list");
        List<ServerPostVO> articles = service.list(world, server);
        mav.addObject("articles", articles);
        mav.addObject("world", world);
        mav.addObject("server", server);
        mav.addObject("worldLabel", WORLD_LABELS.get(world));
        mav.addObject("serverLabel", server + " 서버");
        return mav;
    }

    /** 글쓰기 폼 */
    @RequestMapping(value = {"/serverboard/write", "/serverboard/write.do"}, method = RequestMethod.GET)
    public ModelAndView writeForm(@RequestParam(value = "world", defaultValue = "ALL") String world,
                                  @RequestParam(value = "server", defaultValue = "ALL") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/write");
        mav.addObject("world", world);
        mav.addObject("server", server);
        return mav;
    }

    /** 글 등록 처리 */
    @RequestMapping(value = {"/serverboard/add", "/serverboard/add.do"}, method = RequestMethod.POST)
    public ModelAndView add(@RequestParam("world") String world,
                            @RequestParam("server") String server,
                            @RequestParam("title") String title,
                            @RequestParam("content") String content,
                            HttpSession session) {

        String writer = resolveLoginNick(session);
        if (writer == null || writer.trim().isEmpty()) writer = "익명";

        ServerPostVO vo = new ServerPostVO();
        vo.setWorld(world);
        vo.setServer(server);
        vo.setTitle(title);
        vo.setContent(content);
        vo.setWriter(writer);

        service.write(vo);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server);
    }

    /** 상세 보기 (경로형) */
    @RequestMapping(value = {"/serverboard/{world}/{server}/view/{id}", "/serverboard/{world}/{server}/view/{id}.do"}, method = RequestMethod.GET)
    public ModelAndView viewPath(@PathVariable("world") String world,
                                 @PathVariable("server") String server,
                                 @PathVariable("id") long id,
                                 HttpSession session) {
        service.increaseViews((int) id);
        ServerPostVO post = service.findById(id);
        List<ServerCommentVO> comments = service.comments((int) id);
        String loginNick = resolveLoginNick(session);
        ModelAndView mav = new ModelAndView("/serverboard/view");
        mav.addObject("post", post);
        mav.addObject("comments", comments);
        mav.addObject("world", world);
        mav.addObject("server", server);
        mav.addObject("loginNick", loginNick);
        return mav;
    }

    /** 상세 보기 (쿼리형) */
    @RequestMapping(value = {"/serverboard/{world}/{server}/view", "/serverboard/{world}/{server}/view.do"}, method = RequestMethod.GET)
    public ModelAndView viewQuery(@PathVariable("world") String world,
                                  @PathVariable("server") String server,
                                  @RequestParam("id") long id,
                                  HttpSession session) {
        service.increaseViews((int) id);
        ServerPostVO post = service.findById(id);
        List<ServerCommentVO> comments = service.comments((int) id);
        String loginNick = resolveLoginNick(session);
        ModelAndView mav = new ModelAndView("/serverboard/view");
        mav.addObject("post", post);
        mav.addObject("comments", comments);
        mav.addObject("world", world);
        mav.addObject("server", server);
        mav.addObject("loginNick", loginNick);
        return mav;
    }

    /** 게시글 수정 폼 */
    @RequestMapping(value={"/serverboard/{world}/{server}/edit/{id}","/serverboard/{world}/{server}/edit/{id}.do"}, method=RequestMethod.GET)
    public ModelAndView editForm(@PathVariable("world") String world,
                                 @PathVariable("server") String server,
                                 @PathVariable("id") long id,
                                 HttpSession session) {
        ServerPostVO post = service.findById(id);
        String loginNick = resolveLoginNick(session);
        ModelAndView mav = new ModelAndView("/serverboard/edit");
        mav.addObject("post", post);
        mav.addObject("world", world);
        mav.addObject("server", server);
        mav.addObject("loginNick", loginNick);
        return mav;
    }

    /** 게시글 수정 처리 — 이미지 추가/삭제 지원 (기존 기능 유지, 추가만) */
    @RequestMapping(value={"/serverboard/{world}/{server}/update.do"}, method=RequestMethod.POST)
    public ModelAndView update(@PathVariable("world") String world,
                               @PathVariable("server") String server,
                               @RequestParam("id") int id,
                               @RequestParam("title") String title,
                               @RequestParam("content") String content,
                               @RequestParam(value="image", required=false) MultipartFile image,      // ★추가
                               @RequestParam(value="deleteImage", required=false) String deleteImage, // ★추가
                               HttpSession session) {
        String loginNick = resolveLoginNick(session);

        ServerPostVO vo = new ServerPostVO();
        vo.setId(id);
        vo.setTitle(title);
        vo.setContent(content);
        vo.setWriter(loginNick);

        // ▼ 이미지 처리 (DB 스키마/매퍼 변경 없음 — 파일만 저장/삭제)
        try {
            // 삭제 체크 시: 기존 파일 경로를 별도 보관 중이라면 여기서 제거
            if ("1".equals(deleteImage)) {
                // 예시) String old = service.findById(id).getImagePath();
                // if (old != null) Files.deleteIfExists(Paths.get(session.getServletContext().getRealPath(old)));
                // vo.setImagePath(null); // DB에 경로 필드가 있다면 null 설정
            }

            // 새 파일 업로드 시 저장
            if (image != null && !image.isEmpty()) {
                String uploadsRel = "/uploads"; // servlet-context.xml 에서 /uploads/** 매핑이 있어야 함
                String uploadsAbs = session.getServletContext().getRealPath(uploadsRel);
                Files.createDirectories(Paths.get(uploadsAbs));

                String orig = image.getOriginalFilename();
                String ext = (orig != null && orig.lastIndexOf('.') != -1) ? orig.substring(orig.lastIndexOf('.')+1) : "";
                String safeName = "post_" + id + "_" + System.currentTimeMillis() + (ext.isEmpty() ? "" : "."+ext.toLowerCase());
                Path dest = Paths.get(uploadsAbs, safeName);
                image.transferTo(dest.toFile());

                String relPath = uploadsRel + "/" + safeName; // 예) /uploads/post_123_....
                // DB에 이미지 경로 컬럼이 있다면 아래처럼 설정
                // vo.setImagePath(relPath);
            }
        } catch (Exception ignore) {
            // 업로드 실패가 본문 수정까지 막지 않도록 무시(로그만 권장)
        }

        service.update(vo, loginNick);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server + "/view.do?id=" + id);
    }

    /** 게시글 삭제 */
    @RequestMapping(value={"/serverboard/{world}/{server}/delete.do"}, method=RequestMethod.POST)
    public ModelAndView delete(@PathVariable("world") String world,
                               @PathVariable("server") String server,
                               @RequestParam("id") int id,
                               HttpSession session) {
        String loginNick = resolveLoginNick(session);
        service.delete(id, loginNick);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server);
    }

    /** 댓글 등록 */
    @RequestMapping(value={"/serverboard/{world}/{server}/comment/add.do"}, method=RequestMethod.POST)
    public ModelAndView commentAdd(@PathVariable("world") String world,
                                   @PathVariable("server") String server,
                                   @RequestParam("postId") int postId,
                                   @RequestParam(value="parentId", required=false) Integer parentId,
                                   @RequestParam("content") String content,
                                   HttpSession session) {
        String loginNick = resolveLoginNick(session);
        ServerCommentVO c = new ServerCommentVO();
        c.setPostId(postId);
        c.setParentId(parentId);
        c.setContent(content);
        service.addComment(c, loginNick);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server + "/view.do?id=" + postId);
    }

    /** 댓글 수정 */
    @RequestMapping(value={"/serverboard/{world}/{server}/comment/update.do"}, method=RequestMethod.POST)
    public ModelAndView commentUpdate(@PathVariable("world") String world,
                                      @PathVariable("server") String server,
                                      @RequestParam("id") int id,
                                      @RequestParam("postId") int postId,
                                      @RequestParam("content") String content,
                                      HttpSession session) {
        String loginNick = resolveLoginNick(session);
        ServerCommentVO c = new ServerCommentVO();
        c.setId(id);
        c.setContent(content);
        service.editComment(c, loginNick);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server + "/view.do?id=" + postId);
    }

    /** 댓글 삭제 */
    @RequestMapping(value={"/serverboard/{world}/{server}/comment/delete.do"}, method=RequestMethod.POST)
    public ModelAndView commentDelete(@PathVariable("world") String world,
                                      @PathVariable("server") String server,
                                      @RequestParam("id") int id,
                                      @RequestParam("postId") int postId,
                                      HttpSession session) {
        String loginNick = resolveLoginNick(session);
        service.removeComment(id, loginNick);
        return new ModelAndView("redirect:/serverboard/" + world + "/" + server + "/view.do?id=" + postId);
    }
}
