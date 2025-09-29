package com.myspring.vampir.board.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.myspring.vampir.board.dao.BoardDAO;
import com.myspring.vampir.board.vo.ArticleVO;
import com.myspring.vampir.board.vo.CommentVO;


@Service("boardService")
@Transactional(propagation = Propagation.REQUIRED)
public class BoardServiceImpl  implements BoardService{
	@Autowired
	BoardDAO boardDAO;
	
	public List<ArticleVO> listArticles() throws Exception{
		List<ArticleVO> articlesList =  boardDAO.selectAllArticlesList();
        return articlesList;
	}

	
	//占쏙옙占쏙옙 占싱뱄옙占쏙옙 占쌩곤옙占싹깍옙
	@Override
	public int addNewArticle(Map articleMap) throws Exception{
		return boardDAO.insertNewArticle(articleMap);
	}
	
	 //占쏙옙占쏙옙 占싱뱄옙占쏙옙 占쌩곤옙占싹깍옙
	/*
	@Override
	public int addNewArticle(Map articleMap) throws Exception{
		int articleNO = boardDAO.insertNewArticle(articleMap);
		articleMap.put("articleNO", articleNO);
		boardDAO.insertNewImage(articleMap);
		return articleNO;
	}
	*/
	/*
	//占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占싱깍옙
	@Override
	public Map viewArticle(int articleNO) throws Exception {
		Map articleMap = new HashMap();
		ArticleVO articleVO = boardDAO.selectArticle(articleNO);
		List<ImageVO> imageFileList = boardDAO.selectImageFileList(articleNO);
		articleMap.put("article", articleVO);
		articleMap.put("imageFileList", imageFileList);
		return articleMap;
	}
   */
	
	
	 //占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占싱깍옙
	@Override
	public ArticleVO viewArticle(int articleNO) throws Exception {
		ArticleVO articleVO = boardDAO.selectArticle(articleNO);
		return articleVO;
	}
	
	
	@Override
	public void modArticle(Map articleMap) throws Exception {
		boardDAO.updateArticle(articleMap);
	}
	
	@Override
    public void removeArticle(int articleNO) {
        List<Integer> targetIds = new ArrayList<Integer>();
        collectChildren(articleNO, targetIds); // �옄�떇 湲� �옱洹� �깘�깋
        boardDAO.deleteArticle(targetIds);    // �븳 踰덉뿉 �궘�젣
    }
	
    // �옱洹��쟻�쑝濡� 紐⑤뱺 �옄�떇湲��쓣 李얠븘 由ъ뒪�듃�뿉 異붽�
    private void collectChildren(int articleNO, List<Integer> collector) {
        collector.add(articleNO);
        List<Integer> children = boardDAO.selectChildArticles(articleNO);
        for (int child : children) {
            collectChildren(child, collector);
        }
    }
    
    @Override
    public void addComment(CommentVO comment) throws Exception {
        boardDAO.insertComment(comment);
    }

    @Override
    public List<CommentVO> listComments(int articleId) throws Exception {
        return boardDAO.selectCommentsByArticleId(articleId);
    }

    @Override
    public void removeComment(int commentId, int memberId) throws Exception {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("commentId", commentId);
        param.put("memberId", memberId);
        boardDAO.deleteComment(param);
    }

    @Override
    public void updateComment(int commentId, int memberId, String content) throws Exception {
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("commentId", commentId);
        param.put("memberId", memberId);
        param.put("content", content);
        boardDAO.updateComment(param);
    }
	
}
