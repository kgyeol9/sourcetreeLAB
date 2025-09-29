package com.myspring.vampir.board.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.myspring.vampir.board.vo.ArticleVO;
import com.myspring.vampir.board.vo.CommentVO;


public interface BoardDAO {
	public List selectAllArticlesList() throws DataAccessException;
	public int insertNewArticle(Map articleMap) throws DataAccessException;
	//public void insertNewImage(Map articleMap) throws DataAccessException;
	
	public ArticleVO selectArticle(int articleNO) throws DataAccessException;
	public void updateArticle(Map articleMap) throws DataAccessException;
	public void deleteArticle(List<Integer> ids) throws DataAccessException;
	public List selectImageFileList(int articleNO) throws DataAccessException;
    public List<Integer> selectChildArticles(int articleNO);
    
    public void insertComment(CommentVO comment) throws Exception;
    public List<CommentVO> selectCommentsByArticleId(int articleId) throws Exception;
    public void deleteComment(Map<String, Object> param) throws Exception;
    public void updateComment(Map<String, Object> param) throws Exception;
}
