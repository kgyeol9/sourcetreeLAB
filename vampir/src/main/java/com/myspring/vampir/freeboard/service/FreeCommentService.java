package com.myspring.vampir.freeboard.service;

import java.util.List;
import com.myspring.vampir.freeboard.vo.FreeCommentVO;

public interface FreeCommentService {
    List<FreeCommentVO> list(Long postId);
    Long add(Long postId, Long parentId, String content, String writerId, String writerName);
    boolean edit(Long id, String writerId, String content);
    boolean remove(Long id, String writerId);
}
