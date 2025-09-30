package com.myspring.vampir.serverboard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.serverboard.dao.ServerBoardDAO;
import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

@Service
public class ServerBoardServiceImpl implements ServerBoardService {

    @Autowired
    private ServerBoardDAO dao;

    @Override
    public List<ServerPostVO> list(String world, String server) {
        Map<String, Object> p = new HashMap<String, Object>();
        p.put("world",  world);
        p.put("server", server);
        return dao.listPosts(p);
    }

    @Override
    public void write(ServerPostVO vo) {
        // world/server 유효성
        if (vo == null) return;
        if (vo.getWorld() == null || vo.getServer() == null) return;
        if ("ALL".equalsIgnoreCase(vo.getWorld()) || "ALL".equalsIgnoreCase(vo.getServer())) {
            throw new IllegalArgumentException("월드/서버는 '전체'로 저장할 수 없습니다.");
        }
        dao.insertPost(vo);
    }

    @Override
    public ServerPostVO findById(long id) {
        return dao.getPost((int) id);
    }

    @Override
    public void increaseViews(int id) {
        dao.increaseViews(id);
    }

    // ===== 게시글 수정/삭제 =====
    @Override
    public void update(ServerPostVO vo, String loginNick) {
        if (vo == null) return;
        // 작성자 검증은 Mapper(where writer = #{writer})에서 처리
        vo.setWriter(loginNick);
        dao.updatePost(vo);
    }

    @Override
    public void delete(int id, String loginNick) {
        dao.deletePost(id, loginNick);
    }

    // ===== 댓글/대댓글 =====
    @Override
    public List<ServerCommentVO> comments(int postId) {
        return dao.listComments(postId);
    }

    @Override
    public void addComment(ServerCommentVO vo, String loginNick) {
        if (vo == null) return;
        vo.setWriter(loginNick == null || loginNick.trim().isEmpty() ? "익명" : loginNick.trim());
        dao.insertComment(vo);
    }

    @Override
    public void editComment(ServerCommentVO vo, String loginNick) {
        if (vo == null) return;
        vo.setWriter(loginNick);
        dao.updateComment(vo);
    }

    @Override
    public void removeComment(int id, String loginNick) {
        dao.deleteComment(id, loginNick);
    }
}
