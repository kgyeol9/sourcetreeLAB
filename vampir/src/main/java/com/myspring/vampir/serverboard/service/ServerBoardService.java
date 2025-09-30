package com.myspring.vampir.serverboard.service;

import java.util.List;

import com.myspring.vampir.serverboard.vo.ServerPostVO;
import com.myspring.vampir.serverboard.vo.ServerCommentVO;

public interface ServerBoardService {
    List<ServerPostVO> list(String world, String server);
    void write(ServerPostVO vo);
    ServerPostVO findById(long id);
    void increaseViews(int id);

    // ★ 추가: 게시글 수정/삭제
    void update(ServerPostVO vo, String loginNick);
    void delete(int id, String loginNick);

    // ★ 추가: 댓글/대댓글
    List<ServerCommentVO> comments(int postId);
    void addComment(ServerCommentVO vo, String loginNick);
    void editComment(ServerCommentVO vo, String loginNick);
    void removeComment(int id, String loginNick);
}
