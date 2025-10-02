package com.myspring.vampir.tac_job_board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.tac_job_board.vo.tac_job_boardVO;
import com.myspring.vampir.tac_job_board.vo.tac_job_commentVO;


@Repository("tac_job_boardDAO")
public class tac_job_boardDAOimpl implements tac_job_boardDAO{
    @Autowired
    private SqlSession sqlSession;
    private static final String NS = "com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.";

    @Override
    public List<tac_job_boardVO> selectBoardList(String board_type, int start, int limit) {
        // Java 6 호환: Map.of 대신 HashMap 사용
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("board_type", board_type);
        paramMap.put("start", start);
        paramMap.put("limit", limit);

        return sqlSession.selectList(
            "com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.selectBoardList",
            paramMap
        );
    }


    @Override
    public int countBoardList(String board_type) {
        return sqlSession.selectOne("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.countBoardList", board_type);
    }

    @Override
    public tac_job_boardVO selectBoardById(int board_id) {
        return sqlSession.selectOne("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.selectBoardById", board_id);
    }

    @Override
    public void insertBoard(tac_job_boardVO boardVO) {
        sqlSession.insert("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.insertBoard", boardVO);
    }

    @Override
    public void updateBoard(tac_job_boardVO boardVO) {
        sqlSession.update("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.updateBoard", boardVO);
    }

    @Override
    public void deleteBoard(int board_id) {
        sqlSession.delete("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.deleteBoard", board_id);
    }

    @Override
    public void increaseViewCount(int board_id) {
        sqlSession.update("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.increaseViewCount", board_id);
    }

    @Override
    public void increaseRecommendCount(int board_id) {
        sqlSession.update("com.myspring.vampir.tac_job_board.dao.tac_job_boardDAO.increaseRecommendCount", board_id);
    }
    
    @Override
    public List<tac_job_commentVO> listComments(int board_id) {
        return sqlSession.selectList(NS + "listComments", board_id);
    }

    @Override
    public int insertComment(tac_job_commentVO comment) {
        return sqlSession.insert(NS + "insertComment", comment);
    }

    @Override
    public int updateComment(tac_job_commentVO comment) {
        return sqlSession.update(NS + "updateComment", comment);
    }

    @Override
    public int deleteComment(int comment_id) {
        return sqlSession.delete(NS + "deleteComment", comment_id);
    }

}
