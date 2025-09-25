package com.myspring.vampir.board.service;

import java.util.List;
import java.util.Map;

import com.myspring.vampir.board.vo.ArticleVO;
import com.myspring.vampir.board.vo.CommentVO;

public interface BoardService {
	public List<ArticleVO> listArticles() throws Exception;
	public int addNewArticle(Map articleMap) throws Exception;
	public ArticleVO viewArticle(int articleNO) throws Exception;
	//public Map viewArticle(int articleNO) throws Exception;
	public void modArticle(Map articleMap) throws Exception;
	public void removeArticle(int articleNO) throws Exception;
    public void addComment(CommentVO comment) throws Exception;
    public List<CommentVO> listComments(int articleId) throws Exception;
    public void removeComment(int commentId, int memberId) throws Exception;
}
