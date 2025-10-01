package com.myspring.vampir.freeboard.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.myspring.vampir.freeboard.vo.FreePostVO;

public interface FreeBoardMapper {
    // 목록
    List<FreePostVO> listPaged(@Param("limit") int limit,
                               @Param("offset") int offset);
    int countAll();

    // 상세 + 조회수
    FreePostVO selectOne(@Param("postId") Long postId);
    int increaseViewCnt(@Param("postId") Long postId);

    // 작성
    int insert(FreePostVO vo);

    // 수정: 본인 글일 때만 반영
    int updateOwn(@Param("postId") Long postId,
                  @Param("writerId") String writerId,
                  @Param("title") String title,
                  @Param("content") String content);

    // 삭제(소프트): 본인 글일 때만 반영
    int softDeleteOwn(@Param("postId") Long postId,
                      @Param("writerId") String writerId);
}
