package com.myspring.vampir.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.myspring.vampir.board.vo.ArticleVO;
import com.myspring.vampir.board.vo.CommentVO;
import com.myspring.vampir.board.vo.ImageVO;


@Repository("boardDAO")
public class BoardDAOImpl implements BoardDAO {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List selectAllArticlesList() throws DataAccessException {
		List<ArticleVO> articlesList = articlesList = sqlSession.selectList("mapper.board.selectAllArticlesList");
		return articlesList;
	}

	
	@Override
	public int insertNewArticle(Map articleMap) throws DataAccessException {
		int articleNO = selectNewArticleNO();
		articleMap.put("articleNO", articleNO);
		sqlSession.insert("mapper.board.insertNewArticle",articleMap);
		return articleNO;
	}
    
	//占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占싸듸옙
	/*
	@Override
	public void insertNewImage(Map articleMap) throws DataAccessException {
		List<ImageVO> imageFileList = (ArrayList)articleMap.get("imageFileList");
		int articleNO = (Integer)articleMap.get("articleNO");
		int imageFileNO = selectNewImageFileNO();
		for(ImageVO imageVO : imageFileList){
			imageVO.setImageFileNO(++imageFileNO);
			imageVO.setArticleNO(articleNO);
		}
		sqlSession.insert("mapper.board.insertNewImage",imageFileList);
	}
	
   */
	
	@Override
	public ArticleVO selectArticle(int articleNO) throws DataAccessException {
		return sqlSession.selectOne("mapper.board.selectArticle", articleNO);
	}

	@Override
	public void updateArticle(Map articleMap) throws DataAccessException {
		sqlSession.update("mapper.board.updateArticle", articleMap);
	}

    // �옄�떇 湲� 踰덊샇 議고쉶
	@Override
    public List<Integer> selectChildArticles(int articleNO) {
        return sqlSession.selectList("mapper.board.selectChildArticles", articleNO);
    }

    // �뿬�윭 湲� �궘�젣
	@Override
    public void deleteArticle(List<Integer> ids) {
        sqlSession.delete("mapper.board.deleteArticles", ids);
    }
	
	
	@Override
	public List selectImageFileList(int articleNO) throws DataAccessException {
		List<ImageVO> imageFileList = null;
		imageFileList = sqlSession.selectList("mapper.board.selectImageFileList",articleNO);
		return imageFileList;
	}
	
	private int selectNewArticleNO() throws DataAccessException {
		return sqlSession.selectOne("mapper.board.selectNewArticleNO");
	}
	
	private int selectNewImageFileNO() throws DataAccessException {
		return sqlSession.selectOne("mapper.board.selectNewImageFileNO");
	}

    @Override
    public void insertComment(CommentVO comment) throws Exception {
        sqlSession.insert("com.myspring.vampir.board.dao.BoardDAO.insertComment", comment);
    }

    @Override
    public List<CommentVO> selectCommentsByArticleId(int articleId) throws Exception {
        return sqlSession.selectList("com.myspring.vampir.board.dao.BoardDAO.selectCommentsByArticleId", articleId);
    }

    @Override
    public void deleteComment(Map<String, Object> param) throws Exception {
        sqlSession.delete("com.myspring.vampir.board.dao.BoardDAO.deleteComment", param);
    }

    @Override
    public void updateComment(Map<String, Object> param) throws Exception {
        sqlSession.update("com.myspring.vampir.board.dao.BoardDAO.updateComment", param);
    }


}
