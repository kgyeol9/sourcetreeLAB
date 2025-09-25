package com.myspring.vampir.board.controller;

import java.io.File;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.board.service.BoardService;
import com.myspring.vampir.board.vo.ArticleVO;
import com.myspring.vampir.board.vo.CommentVO;
import com.myspring.vampir.member.vo.MemberVO;

@Controller("boardController")
public class BoardControllerImpl implements BoardController {
	private static final String ARTICLE_IMAGE_REPO = "C:\\board\\article_image";
	@Autowired
	private BoardService boardService;
	@Autowired
	private ArticleVO articleVO;

	// �솕硫� �솗�씤�슜(紐⑸줉/�옉�꽦/�닔�젙/�긽�꽭) - �럹�씠吏� �씪�슦�똿留�
	@RequestMapping(value = "/board/list.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView listPage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");

		System.out.println("viewName :: " + viewName);

		List articlesList = boardService.listArticles();
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("articlesList", articlesList);
		return mav;

	}

	@RequestMapping(value = "/board/write.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView writePage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName"); // ex) "/board/write"
		return new ModelAndView(viewName);
	}

	@RequestMapping(value = "/board/edit.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView editPage(@RequestParam("articleNO") int articleNO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName"); // ex) "/board/edit"

		articleVO = boardService.viewArticle(articleNO);
		ModelAndView mav = new ModelAndView();
		mav.setViewName(viewName);
		mav.addObject("article", articleVO);
		return mav;
	}

	@RequestMapping(value = "/board/view.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView viewPage(@RequestParam("articleNO") int articleNO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	String viewName = (String) request.getAttribute("viewName");
	articleVO = boardService.viewArticle(articleNO);
	ModelAndView mav = new ModelAndView();
	mav.setViewName(viewName);
	mav.addObject("article", articleVO);
	return mav;
}

	@Override
	@RequestMapping(value = "/board/listArticles.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView listArticles(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");

		System.out.println("viewName :: " + viewName);

		List articlesList = boardService.listArticles();
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("articlesList", articlesList);
		return mav;

	}

	// @Override
	@RequestMapping(value = "/board/listImages.do", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView listImages(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		List imageList = boardService.listArticles();
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("imageList", imageList);
		return mav;
	}

	// 占쏙옙 占쏙옙 占싱뱄옙占쏙옙 占쌜억옙占쏙옙
	@Override
	@RequestMapping(value = "/board/addNewArticle.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity addNewArticle(MultipartHttpServletRequest multipartRequest, HttpServletResponse response)
			throws Exception {
		multipartRequest.setCharacterEncoding("utf-8");
		Map<String, Object> articleMap = new HashMap<String, Object>();
		Enumeration enu = multipartRequest.getParameterNames();
		while (enu.hasMoreElements()) {
			String name = (String) enu.nextElement();
			String value = multipartRequest.getParameter(name);
			articleMap.put(name, value);
		}

		String imageFileName = upload(multipartRequest);
		HttpSession session = multipartRequest.getSession();
		MemberVO memberVO = (MemberVO) session.getAttribute("member");
		String id = memberVO.getMemId();
		articleMap.put("parentNO", 0);
		articleMap.put("id", id);
		articleMap.put("imageFileName", imageFileName);

		String message;
		ResponseEntity resEnt = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			int articleNO = boardService.addNewArticle(articleMap);
			if (imageFileName != null && imageFileName.length() != 0) {
				File srcFile = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + imageFileName);
				File destDir = new File(ARTICLE_IMAGE_REPO + "\\" + articleNO);
				FileUtils.moveFileToDirectory(srcFile, destDir, true);
			}

			message = "<script>";
			message += " alert('�깉湲� 異붽�');";
			message += " location.href='" + multipartRequest.getContextPath() + "/board/list.do'; ";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
		} catch (Exception e) {
			File srcFile = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + imageFileName);
			srcFile.delete();

			message = " <script>";
			message += " alert('�삤瑜� 諛쒖깮');');";
			message += " location.href='" + multipartRequest.getContextPath() + "/board/articleForm.do'; ";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
			e.printStackTrace();
		}
		return resEnt;
	}

	// 占싼곤옙占쏙옙 占싱뱄옙占쏙옙 占쏙옙占쏙옙占쌍깍옙
	@RequestMapping(value = "/board/viewArticle.do", method = RequestMethod.GET)
	public ModelAndView viewArticle(@RequestParam("articleNO") int articleNO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		articleVO = boardService.viewArticle(articleNO);
		ModelAndView mav = new ModelAndView();
		mav.setViewName(viewName);
		mav.addObject("article", articleVO);
		return mav;
	}

	/*
	 * //占쏙옙占쏙옙 占싱뱄옙占쏙옙 占쏙옙占쏙옙占쌍깍옙
	 * 
	 * @RequestMapping(value="/board/viewArticle.do" ,method = RequestMethod.GET)
	 * public ModelAndView viewArticle(@RequestParam("articleNO") int articleNO,
	 * HttpServletRequest request, HttpServletResponse response) throws Exception{
	 * String viewName = (String)request.getAttribute("viewName"); Map
	 * articleMap=boardService.viewArticle(articleNO); ModelAndView mav = new
	 * ModelAndView(); mav.setViewName(viewName); mav.addObject("articleMap",
	 * articleMap); return mav; }
	 */

	// 占쏙옙 占쏙옙 占싱뱄옙占쏙옙 占쏙옙占쏙옙 占쏙옙占�
	@RequestMapping(value = "/board/modArticle.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity modArticle(MultipartHttpServletRequest multipartRequest, HttpServletResponse response)
			throws Exception {
		multipartRequest.setCharacterEncoding("utf-8");
		Map<String, Object> articleMap = new HashMap<String, Object>();
		Enumeration enu = multipartRequest.getParameterNames();
		while (enu.hasMoreElements()) {
			String name = (String) enu.nextElement();
			String value = multipartRequest.getParameter(name);
			articleMap.put(name, value);
		}

		String imageFileName = upload(multipartRequest);
		articleMap.put("imageFileName", imageFileName);

		String articleNO = (String) articleMap.get("articleNO");
		String message;
		ResponseEntity resEnt = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		try {
			boardService.modArticle(articleMap);
			if (imageFileName != null && imageFileName.length() != 0) {
				File srcFile = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + imageFileName);
				File destDir = new File(ARTICLE_IMAGE_REPO + "\\" + articleNO);
				FileUtils.moveFileToDirectory(srcFile, destDir, true);

				String originalFileName = (String) articleMap.get("originalFileName");
				File oldFile = new File(ARTICLE_IMAGE_REPO + "\\" + articleNO + "\\" + originalFileName);
				oldFile.delete();
			}
			message = "<script>";
			message += " alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂');";
			message += " location.href='" + multipartRequest.getContextPath() + "/board/view.do?articleNO="
					+ articleNO + "';";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
		} catch (Exception e) {
			File srcFile = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + imageFileName);
			srcFile.delete();
			message = "<script>";
			message += " alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂');";
			message += " location.href='" + multipartRequest.getContextPath() + "/board/view.do?articleNO="
					+ articleNO + "';";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
		}
		return resEnt;
	}

	@Override
	@RequestMapping(value = "/board/removeArticle.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity removeArticle(@RequestParam("articleNO") int articleNO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		response.setContentType("text/html; charset=UTF-8");
		String message;
		ResponseEntity resEnt = null;
		HttpHeaders responseHeaders = new HttpHeaders();
		responseHeaders.add("Content-Type", "text/html; charset=utf-8");
		System.out.println("articleNO:" +articleNO);
		try {
			boardService.removeArticle(articleNO);
			File destDir = new File(ARTICLE_IMAGE_REPO + "\\" + articleNO);
			FileUtils.deleteDirectory(destDir);

			message = "<script>";
			message += " alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂.');";
			message += " location.href='" + request.getContextPath() + "/board/list.do';";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);

		} catch (Exception e) {
			message = "<script>";
			message += " alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂.');";
			message += " location.href='" + request.getContextPath() + "/board/list.do';";
			message += " </script>";
			resEnt = new ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
			e.printStackTrace();
		}
		return resEnt;
	}

	/*
	 * //湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂
	 * 
	 * @Override
	 * 
	 * @RequestMapping(value="/board/addNewArticle.do" ,method = RequestMethod.POST)
	 * 
	 * @ResponseBody public ResponseEntity addNewArticle(MultipartHttpServletRequest
	 * multipartRequest, HttpServletResponse response) throws Exception {
	 * multipartRequest.setCharacterEncoding("utf-8"); String imageFileName=null;
	 * 
	 * Map articleMap = new HashMap(); Enumeration
	 * enu=multipartRequest.getParameterNames(); while(enu.hasMoreElements()){
	 * String name=(String)enu.nextElement(); String
	 * value=multipartRequest.getParameter(name); articleMap.put(name,value); }
	 * 
	 * //湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂 HttpSession session = multipartRequest.getSession();
	 * MemberVO memberVO = (MemberVO) session.getAttribute("member"); String id =
	 * memberVO.getId(); articleMap.put("id",id); articleMap.put("parentNO", 0);
	 * 
	 * List<String> fileList =upload(multipartRequest); List<ImageVO> imageFileList
	 * = new ArrayList<ImageVO>(); if(fileList!= null && fileList.size()!=0) {
	 * for(String fileName : fileList) { ImageVO imageVO = new ImageVO();
	 * imageVO.setImageFileName(fileName); imageFileList.add(imageVO); }
	 * articleMap.put("imageFileList", imageFileList); } String message;
	 * ResponseEntity resEnt=null; HttpHeaders responseHeaders = new HttpHeaders();
	 * responseHeaders.add("Content-Type", "text/html; charset=utf-8"); try { int
	 * articleNO = boardService.addNewArticle(articleMap); if(imageFileList!=null &&
	 * imageFileList.size()!=0) { for(ImageVO imageVO:imageFileList) { imageFileName
	 * = imageVO.getImageFileName(); File srcFile = new
	 * File(ARTICLE_IMAGE_REPO+"\\"+"temp"+"\\"+imageFileName); File destDir = new
	 * File(ARTICLE_IMAGE_REPO+"\\"+articleNO); //destDir.mkdirs();
	 * FileUtils.moveFileToDirectory(srcFile, destDir,true); } }
	 * 
	 * message = "<script>"; message += " alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂');"; message +=
	 * " location.href='"+multipartRequest.getContextPath()
	 * +"/board/listArticles.do'; "; message +=" </script>"; resEnt = new
	 * ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
	 * 
	 * 
	 * }catch(Exception e) { if(imageFileList!=null && imageFileList.size()!=0) {
	 * for(ImageVO imageVO:imageFileList) { imageFileName =
	 * imageVO.getImageFileName(); File srcFile = new
	 * File(ARTICLE_IMAGE_REPO+"\\"+"temp"+"\\"+imageFileName); srcFile.delete(); }
	 * }
	 * 
	 * 
	 * message = " <script>"; message +=" alert('湲��옄媛� �븞 源⑥죱�쑝硫� 醫뗪쿋�꽕�슂');');"; message
	 * +=" location.href='"+multipartRequest.getContextPath()
	 * +"/board/articleForm.do'; "; message +=" </script>"; resEnt = new
	 * ResponseEntity(message, responseHeaders, HttpStatus.CREATED);
	 * e.printStackTrace(); } return resEnt; }
	 * 
	 */

	@RequestMapping(value = "/board/*Form.do", method = { RequestMethod.GET, RequestMethod.POST })
	private ModelAndView form(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = (String) request.getAttribute("viewName");
		System.out.println("viewName : " + viewName);
		ModelAndView mav = new ModelAndView();
		mav.setViewName(viewName);
		return mav;
	}

	// 占싼곤옙 占싱뱄옙占쏙옙 占쏙옙占싸듸옙占싹깍옙
	private String upload(MultipartHttpServletRequest multipartRequest) throws Exception {
		String imageFileName = null;
		Iterator<String> fileNames = multipartRequest.getFileNames();

		while (fileNames.hasNext()) {
			String fileName = fileNames.next();
			MultipartFile mFile = multipartRequest.getFile(fileName);
			imageFileName = mFile.getOriginalFilename();
			File file = new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + fileName);
			if (mFile.getSize() != 0) { // File Null Check
				if (!file.exists()) { // 占쏙옙貫占� 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占�
					file.getParentFile().mkdirs(); // 占쏙옙恝占� 占쌔댐옙占싹댐옙 占쏙옙占썰리占쏙옙占쏙옙 占쏙옙占쏙옙
					mFile.transferTo(new File(ARTICLE_IMAGE_REPO + "\\" + "temp" + "\\" + imageFileName)); // 占쌈시뤄옙 占쏙옙占쏙옙占�
																											// multipartFile占쏙옙
																											// 占쏙옙占쏙옙
																											// 占쏙옙占싹뤄옙
																											// 占쏙옙占쏙옙
				}
			}

		}
		return imageFileName;
	}

	/*
	 * //占쏙옙占쏙옙 占싱뱄옙占쏙옙 占쏙옙占싸듸옙占싹깍옙 private List<String> upload(MultipartHttpServletRequest
	 * multipartRequest) throws Exception{ List<String> fileList= new
	 * ArrayList<String>(); Iterator<String> fileNames =
	 * multipartRequest.getFileNames(); while(fileNames.hasNext()){ String fileName
	 * = fileNames.next(); MultipartFile mFile = multipartRequest.getFile(fileName);
	 * String originalFileName=mFile.getOriginalFilename();
	 * fileList.add(originalFileName); File file = new File(ARTICLE_IMAGE_REPO
	 * +"\\"+"temp"+"\\" + fileName); if(mFile.getSize()!=0){ //File Null Check
	 * if(!file.exists()){ //占쏙옙貫占� 占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙占쏙옙占쏙옙 占쏙옙占쏙옙 占쏙옙占�
	 * file.getParentFile().mkdirs(); //占쏙옙恝占� 占쌔댐옙占싹댐옙 占쏙옙占썰리占쏙옙占쏙옙 占쏙옙占쏙옙
	 * mFile.transferTo(new File(ARTICLE_IMAGE_REPO
	 * +"\\"+"temp"+ "\\"+originalFileName)); //占쌈시뤄옙 占쏙옙占쏙옙占� multipartFile占쏙옙 占쏙옙占쏙옙
	 * 占쏙옙占싹뤄옙 占쏙옙占쏙옙 } } } return fileList; }
	 */
	
    // ✅ 댓글 목록 조회
    @RequestMapping(value = "/comment/list.do", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<List<CommentVO>> list(@RequestParam("articleId") int articleId) throws Exception {
        List<CommentVO> comments = boardService.listComments(articleId);
        return new ResponseEntity<List<CommentVO>>(comments, HttpStatus.OK);
    }

    // ✅ 댓글 추가 (세션에서 member_code 꺼내서 사용)
    @RequestMapping(value = "/comment/add.do", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> add(@RequestBody CommentVO comment, HttpSession session) throws Exception {
        MemberVO member = (MemberVO) session.getAttribute("member");

        System.out.println("✅ 세션에서 가져온 memCode: " + member.getMemCode());
        
        if (member == null) {
            return new ResponseEntity<String>("로그인이 필요합니다.", HttpStatus.UNAUTHORIZED);
        }

        comment.setMemberId(member.getMemCode()); // 세션에서 member_code 설정
        boardService.addComment(comment);
        return new ResponseEntity<String>("success", HttpStatus.OK);
    }

    // ✅ 댓글 삭제
    @RequestMapping(value = "/comment/delete.do", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> delete(@RequestParam("id") int id, HttpSession session) throws Exception {
        MemberVO member = (MemberVO) session.getAttribute("member");
        if (member == null) {
            return new ResponseEntity<String>("로그인이 필요합니다.", HttpStatus.UNAUTHORIZED);
        }

        boardService.removeComment(id, member.getMemCode());
        return new ResponseEntity<String>("success", HttpStatus.OK);
    }
}

