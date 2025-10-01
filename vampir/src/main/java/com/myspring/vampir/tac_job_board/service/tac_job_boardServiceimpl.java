package com.myspring.vampir.tac_job_board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO;
import com.myspring.vampir.tac_job_board.vo.tac_job_boardVO;

@Service("tac_job_boardService")
public class tac_job_boardServiceimpl implements tac_job_boardService{
	   @Autowired
	    private tac_job_boardDAO boardDAO;

	    private static final int DEFAULT_PAGE_SIZE = 10;

	    @Override
	    public List<tac_job_boardVO> listBoards(String board_type, int page, int pageSize) {
	        int start = (page - 1) * pageSize;
	        return boardDAO.selectBoardList(board_type, start, pageSize);
	    }

	    @Override
	    public int countBoards(String board_type) {
	        return boardDAO.countBoardList(board_type);
	    }

	    @Override
	    public tac_job_boardVO viewBoard(int board_id) {
	        boardDAO.increaseViewCount(board_id);
	        return boardDAO.selectBoardById(board_id);
	    }

	    @Override
	    public void writeBoard(tac_job_boardVO boardVO) {
	        boardDAO.insertBoard(boardVO);
	    }

	    @Override
	    public void editBoard(tac_job_boardVO boardVO) {
	        boardDAO.updateBoard(boardVO);
	    }

	    @Override
	    public void removeBoard(int board_id) {
	        boardDAO.deleteBoard(board_id);
	    }

	    @Override
	    public void increaseViewCount(int board_id) {
	        boardDAO.increaseViewCount(board_id);
	    }

	    @Override
	    public void increaseRecommendCount(int board_id) {
	        boardDAO.increaseRecommendCount(board_id);
	    }
}
