package com.myspring.vampir.serverboard.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.serverboard.service.ServerBoardService;
import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

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

    /** 세션에서 로그인 닉네임 추출 */
    private String resolveLoginNick(HttpSession session) {
        if (session == null) return null;
        Object v = session.getAttribute("loginNick");
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

    /** 목록 (경로형) */
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

    /** 목록 (쿼리형) */
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

    /** 글 등록 (+ 이미지 저장 후 본문에 <img> 자동삽입: 컨텍스트 경로 포함) */
    @RequestMapping(value = {"/serverboard/add", "/serverboard/add.do"}, method = RequestMethod.POST)
    public ModelAndView add(@RequestParam("world") String world,
                            @RequestParam("server") String server,
                            @RequestParam("title") String title,
                            @RequestParam("content") String content,
                            @RequestParam(value = "image", required = false) MultipartFile image,
                            HttpSession session,
                            HttpServletRequest request) {

        String writer = resolveLoginNick(session);
        if (writer == null || writer.trim().isEmpty()) writer = "익명";

        ServerPostVO vo = new ServerPostVO();
        vo.setWorld(world);
        vo.setServer(server);
        vo.setTitle(title);
        vo.setContent(content);
        vo.setWriter(writer);

        service.write(vo);

        // 업로드 파일 저장 (옵션) + 본문 자동 삽입
        try {
            if (image != null && !image.isEmpty()) {
                String uploadsAbs = session.getServletContext().getRealPath("/uploads");
                java.nio.file.Path upDir = java.nio.file.Paths.get(uploadsAbs);
                java.nio.file.Files.createDirectories(upDir);

                String orig = image.getOriginalFilename();
                String ext  = (orig != null && orig.lastIndexOf('.')!=-1) ? orig.substring(orig.lastIndexOf('.')+1) : "";
                String fname = "post_" + vo.getId() + "_" + System.currentTimeMillis() + (ext.isEmpty()?"":"."+ext.toLowerCase());
                java.nio.file.Path dest = upDir.resolve(fname);
                image.transferTo(dest.toFile());

                // ★ 컨텍스트 경로 포함
                String ctx = request.getContextPath(); // 예: /vampir
                String rel = ctx + "/uploads/" + fname;

                String body = (content == null ? "" : content) + "\n\n<img src=\"" + rel + "\" style=\"max-width:100%\"/>";
                ServerPostVO patch = new ServerPostVO();
                patch.setId(vo.getId());
                patch.setTitle(vo.getTitle());
                patch.setContent(body);
                patch.setWriter(writer);
                service.update(patch, writer);
            }
        } catch (Exception ignore) {}

        return new ModelAndView("redirect:/serverboard/" + world + "/" + server);
    }

    /** 상세 (경로형) */
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

    /** 상세 (쿼리형) */
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

    /** 수정 폼 */
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

    /**
     * 수정 처리
     * - deleteImage=1 이면 /uploads의 post_{id}_* 일괄 삭제
     * - 새 image 업로드 시 저장 후 본문(content) 하단에 <img ...> 자동 삽입 (컨텍스트 경로 포함)
     */
    @RequestMapping(value={"/serverboard/{world}/{server}/update.do"}, method=RequestMethod.POST)
    public ModelAndView update(@PathVariable("world") String world,
                               @PathVariable("server") String server,
                               @RequestParam("id") int id,
                               @RequestParam("title") String title,
                               @RequestParam("content") String content,
                               @RequestParam(value="deleteImage", required=false) String deleteImage,
                               @RequestParam(value="image", required=false) MultipartFile image,
                               @RequestParam(value="autoEmbed", required=false, defaultValue="1") String autoEmbed,
                               HttpSession session,
                               HttpServletRequest request) {
        String loginNick = resolveLoginNick(session);

        // 1) 기존 이미지 삭제 (옵션)
        try {
            if ("1".equals(deleteImage)) {
                String uploadsAbs = session.getServletContext().getRealPath("/uploads");
                java.nio.file.Path up = java.nio.file.Paths.get(uploadsAbs);
                if (java.nio.file.Files.exists(up)) {
                    try (java.nio.file.DirectoryStream<java.nio.file.Path> ds =
                             java.nio.file.Files.newDirectoryStream(up, "post_" + id + "_*")) {
                        for (java.nio.file.Path p : ds) {
                            try { java.nio.file.Files.deleteIfExists(p); } catch (Exception ignore) {}
                        }
                    }
                }
            }
        } catch (Exception ignore) {}

        // 2) 새 이미지 저장 (옵션) + 본문 자동 삽입 (옵션)
        try {
            if (image != null && !image.isEmpty()) {
                String uploadsAbs = session.getServletContext().getRealPath("/uploads");
                java.nio.file.Path upDir = java.nio.file.Paths.get(uploadsAbs);
                java.nio.file.Files.createDirectories(upDir);

                String orig = image.getOriginalFilename();
                String ext  = (orig != null && orig.lastIndexOf('.')!=-1) ? orig.substring(orig.lastIndexOf('.')+1) : "";
                String fname = "post_" + id + "_" + System.currentTimeMillis() + (ext.isEmpty() ? "" : "."+ext.toLowerCase());
                java.nio.file.Path dest = upDir.resolve(fname);
                image.transferTo(dest.toFile());

                if ("1".equals(autoEmbed)) {
                    String ctx = request.getContextPath(); // 예: /vampir
                    String rel = ctx + "/uploads/" + fname;
                    content = (content == null ? "" : content) + "\n\n<img src=\"" + rel + "\" style=\"max-width:100%\"/>";
                }
            }
        } catch (Exception ignore) {}

        ServerPostVO vo = new ServerPostVO();
        vo.setId(id);
        vo.setTitle(title);
        vo.setContent(content);
        vo.setWriter(loginNick);
        service.update(vo, loginNick);

        return new ModelAndView("redirect:/serverboard/" + world + "/" + server + "/view.do?id=" + id);
    }

    /** 삭제 */
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
