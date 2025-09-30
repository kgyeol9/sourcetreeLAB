package com.myspring.vampir.serverboard.dao;

import java.util.List;
import java.util.Map;

import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

public interface ServerBoardDAO {

    // ===== 게시글 =====
    List<ServerPostVO> listPosts(Map<String, Object> params);
    ServerPostVO getPost(int id);
    void insertPost(ServerPostVO vo);
    void increaseViews(int id);

    void updatePost(ServerPostVO vo);        // 제목/내용(+이미지 경로) 수정
    void deletePost(int id, String writer);  // 작성자 검증 포함

    // ===== 댓글/대댓글 =====
    List<ServerCommentVO> listComments(int postId);
    void insertComment(ServerCommentVO vo);
    void updateComment(ServerCommentVO vo);        // id + writer 조건
    void deleteComment(int id, String writer);     // 작성자 검증
}
