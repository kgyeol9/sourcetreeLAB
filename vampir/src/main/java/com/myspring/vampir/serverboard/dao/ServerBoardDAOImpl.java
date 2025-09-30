package com.myspring.vampir.serverboard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

@Repository
public class ServerBoardDAOImpl implements ServerBoardDAO {

    private static final String NS = "mapper.serverboard.";

    @Autowired
    private SqlSession sqlSession;

    // ===== °Ô½Ã±Û =====
    @Override
    public List<ServerPostVO> listPosts(Map<String, Object> params) {
        return sqlSession.selectList(NS + "listPosts", params);
    }

    @Override
    public ServerPostVO getPost(int id) {
        return sqlSession.selectOne(NS + "getPost", id);
    }

    @Override
    public void insertPost(ServerPostVO vo) {
        sqlSession.insert(NS + "insertPost", vo);
    }

    @Override
    public void increaseViews(int id) {
        sqlSession.update(NS + "increaseViews", id);
    }

    @Override
    public void updatePost(ServerPostVO vo) {
        sqlSession.update(NS + "updatePost", vo);
    }

    @Override
    public void deletePost(int id, String writer) {
        Map<String,Object> p = new HashMap<String,Object>();
        p.put("id", id);
        p.put("writer", writer);
        sqlSession.delete(NS + "deletePost", p);
    }

    // ===== ´ñ±Û/´ë´ñ±Û =====
    @Override
    public List<ServerCommentVO> listComments(int postId) {
        return sqlSession.selectList(NS + "listComments", postId);
    }

    @Override
    public void insertComment(ServerCommentVO vo) {
        sqlSession.insert(NS + "insertComment", vo);
    }

    @Override
    public void updateComment(ServerCommentVO vo) {
        sqlSession.update(NS + "updateComment", vo);
    }

    @Override
    public void deleteComment(int id, String writer) {
        Map<String,Object> p = new HashMap<String,Object>();
        p.put("id", id);
        p.put("writer", writer);
        sqlSession.delete(NS + "deleteComment", p);
    }
}
