package com.myspring.vampir.freeboard.service;

import java.util.List;
import com.myspring.vampir.freeboard.vo.FreePostVO;

public interface FreeBoardService {
    List<FreePostVO> list(int page, int size);
    int count();

    // 상세 + 조회수
    FreePostVO viewAndIncrease(Long postId);

    // 작성
    Long create(String title, String content, String writerId, String writerName);

    // 수정/삭제 (본인만)
    boolean updateOwn(Long postId, String writerId, String title, String content);
    boolean deleteOwn(Long postId, String writerId);
}
