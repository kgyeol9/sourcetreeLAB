package com.myspring.vampir.tac_job_board.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.myspring.vampir.tac_job_board.vo.tac_job_boardVO;
import com.myspring.vampir.tac_job_board.vo.tac_job_commentVO;

public interface tac_job_boardDAO {
	public List<tac_job_boardVO> selectBoardList(@Param("board_type") String board_type,
            @Param("start") int start,
            @Param("limit") int limit);
public int countBoardList(@Param("board_type") String board_type);
public tac_job_boardVO selectBoardById(@Param("board_id") int board_id);
public void insertBoard(tac_job_boardVO boardVO);
public void updateBoard(tac_job_boardVO boardVO);
public void deleteBoard(@Param("board_id") int board_id);
public void increaseViewCount(@Param("board_id") int board_id);
public void increaseRecommendCount(@Param("board_id") int board_id);

public List<tac_job_commentVO> listComments(int board_id);
public int insertComment(tac_job_commentVO comment);
public int updateComment(tac_job_commentVO comment);
public int deleteComment(int comment_id);
}
