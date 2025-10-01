package com.myspring.vampir.tac_job_board.service;

import java.util.List;

import com.myspring.vampir.tac_job_board.vo.tac_job_boardVO;

public interface tac_job_boardService {
    List<tac_job_boardVO> listBoards(String board_type, int page, int pageSize);
    int countBoards(String board_type);
    tac_job_boardVO viewBoard(int board_id);
    void writeBoard(tac_job_boardVO boardVO);
    void editBoard(tac_job_boardVO boardVO);
    void removeBoard(int board_id);
    void increaseViewCount(int board_id);
    void increaseRecommendCount(int board_id);
}
