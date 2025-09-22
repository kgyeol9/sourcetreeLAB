package com.myspring.vampir.board.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.board.service.BoardService;
import com.myspring.vampir.board.vo.ArticleVO;

@RestController
public class RestBoardControllerImpl {

	static Logger logger = LoggerFactory.getLogger(BoardController.class);
	@Autowired
	private BoardService boardService;
	@Autowired
	private ArticleVO articleVO;
	
	@RequestMapping(value = "/board/listArticlesJson.do", method = RequestMethod.GET, 
			produces = "application/json")
	public ResponseEntity<List<ArticleVO>> listArticles() throws Exception {
		logger.info("listArticles �޼��� ȣ��");
		List articlesList = boardService.listArticles();
		
		return new ResponseEntity(articlesList,HttpStatus.OK);
	}
	
	@RequestMapping(value= "/board/listArticlesJsonView.do", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView yungyo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView("/board/listArticlesJsonView");
		return mav;
		
	}
	
}