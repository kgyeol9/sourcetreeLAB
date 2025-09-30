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
        p.put("world", world);
        p.put("server", server);
        return dao.listPosts(p);
    }

    @Override
    public void write(ServerPostVO vo) {
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

    @Override
    public void update(ServerPostVO vo, String loginNick) {
        // 작성자 본인만
        if (loginNick == null || !loginNick.equals(vo.getWriter())) {
            throw new IllegalStateException("작성자만 수정할 수 있습니다.");
        }
        dao.updatePost(vo);
    }

    @Override
    public void delete(int id, String loginNick) {
        if (loginNick == null) throw new IllegalStateException("삭제 권한이 없습니다.");
        dao.deletePost(id, loginNick); // 쿼리에서 writer 매칭 검증
    }

    @Override
    public List<ServerCommentVO> comments(int postId) {
        return dao.listComments(postId);
    }

    @Override
    public void addComment(ServerCommentVO vo, String loginNick) {
        vo.setWriter(loginNick != null && !loginNick.trim().isEmpty() ? loginNick : "익명");
        dao.insertComment(vo);
    }

    @Override
    public void editComment(ServerCommentVO vo, String loginNick) {
        if (loginNick == null) throw new IllegalStateException("수정 권한이 없습니다.");
        vo.setWriter(loginNick);
        dao.updateComment(vo); // mapper에서 writer 일치 조건으로 업데이트
    }

    @Override
    public void removeComment(int id, String loginNick) {
        if (loginNick == null) throw new IllegalStateException("삭제 권한이 없습니다.");
        dao.deleteComment(id, loginNick);
    }
}
