package com.myspring.vampir.serverboard.dao;

import java.util.List;
import java.util.Map;

import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

public interface ServerBoardDAO {
    List<ServerPostVO> listPosts(Map<String, Object> params);
    ServerPostVO getPost(int id);
    void insertPost(ServerPostVO vo);
    void increaseViews(int id);

    // ★ 추가: 게시글 수정/삭제
    void updatePost(ServerPostVO vo);
    void deletePost(int id, String writer); // 작성자 검증 포함

    // ★ 추가: 댓글/대댓글
    List<ServerCommentVO> listComments(int postId);
    void insertComment(ServerCommentVO vo);
    void updateComment(ServerCommentVO vo);     // id + writer 체크
    void deleteComment(int id, String writer);  // 작성자 검증
}
