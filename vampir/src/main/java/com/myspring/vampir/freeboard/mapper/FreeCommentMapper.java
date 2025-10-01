package com.myspring.vampir.freeboard.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.myspring.vampir.freeboard.vo.FreeCommentVO;

public interface FreeCommentMapper {
    List<FreeCommentVO> listByPost(@Param("postId") Long postId);

    int insert(FreeCommentVO vo);

    int updateOwn(@Param("id") Long id,
                  @Param("writerId") String writerId,
                  @Param("content") String content);

    int softDeleteOwn(@Param("id") Long id,
                      @Param("writerId") String writerId);
}
