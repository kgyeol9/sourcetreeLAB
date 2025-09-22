package com.myspring.vampir.DB.controller;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.DB.service.ItemService;

@Controller
public class ItemControllerImpl implements ItemController {

	@Autowired
	private ItemService itemService;

	// 루트 진입 시 목록으로 리다이렉트 (장비 DB)
	@RequestMapping(value = { "/", "/main.do" }, method = RequestMethod.GET)
	public ModelAndView main() {
		return new ModelAndView("redirect:/DB/listItems.do");
	}

	@Override
	@RequestMapping(value = "/DB/listItems.do", method = RequestMethod.GET)
	public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Map<String, Object>> itemsList = itemService.listItemsUnified();
		System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

		// ★ JSP 파일명이 itemDB.jsp 이므로 뷰 이름도 itemDB로
		ModelAndView mav = new ModelAndView("itemDB"); // /WEB-INF/views/itemDB.jsp (일반적인 ViewResolver 기준)
		mav.addObject("itemsList", itemsList); // JSP들이 기대하는 키로 통일
		return mav;
	}

	// 직행 링크 (장비 DB)
	@RequestMapping(value = "/itemDB.do", method = RequestMethod.GET)
	public ModelAndView itemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return new ModelAndView("redirect:/DB/listItems.do");
	}

	@Override
	@RequestMapping(value = "/DB/listEtcItems.do", method = RequestMethod.GET)
	public ModelAndView listEtcItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Map<String, Object>> itemsList = itemService.listEtcItemsUnified();
		System.out.println("[DEBUG] etc itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

		ModelAndView mav = new ModelAndView("etcDB"); // /WEB-INF/views/etcDB.jsp
		mav.addObject("itemsList", itemsList); // ★ 키 통일
		return mav;
	}

	// 직행 링크 (기타 DB)
	@RequestMapping(value = "/etcDB.do", method = RequestMethod.GET)
	public ModelAndView EtcItemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return new ModelAndView("redirect:/DB/listEtcItems.do");
	}

	// 피의 형상 진입 버튼 → 목록으로 리다이렉트
	@RequestMapping(value = "/formDB.do", method = RequestMethod.GET)
	public String formDB() {
		return "redirect:/DB/listForm.do"; // ← 컨텍스트패스 직접 넣지 않기
	}

	// 피의 형상 리스트
	@RequestMapping(value = { "/DB/listForm.do", "/DB/listform.do" }, method = RequestMethod.GET)
	public ModelAndView listForm(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("formDB");
		mav.addObject("formList", java.util.Collections.emptyList());
		return mav;
	}

	// 탈 것 진입 버튼 → 목록으로 리다이렉트
	@RequestMapping(value = "/mountDB.do", method = RequestMethod.GET)
	public String mountDB() {
		return "redirect:/DB/listMount.do"; // ← 동일
	}

	// 탈 것 리스트
	@RequestMapping(value = { "/DB/listMount.do", "/DB/listmount.do" }, method = RequestMethod.GET)
	public ModelAndView listMount(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("mountDB");
		mav.addObject("mountList", java.util.Collections.emptyList());
		return mav;
	}

	/* ===== 컬렉션 ===== */
	@RequestMapping(value = "/collectionDB.do", method = RequestMethod.GET)
	public String collectionDB() {
		return "redirect:/DB/listCollection.do";
	}

	@RequestMapping(value = "/DB/listCollection.do", method = RequestMethod.GET)
	public ModelAndView listCollection(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("collectionDB");
		mav.addObject("collectionList", Collections.emptyList()); // TODO: 서비스 연동
		mav.addObject("pageActive", "collection");
		return mav;
	}

	/* ===== 초상화 ===== */
	@RequestMapping(value = "/portraitDB.do", method = RequestMethod.GET)
	public String portraitDB() {
		return "redirect:/DB/listPortrait.do";
	}

	@RequestMapping(value = "/DB/listPortrait.do", method = RequestMethod.GET)
	public ModelAndView listPortrait(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("portraitDB");
		mav.addObject("portraitList", Collections.emptyList());
		mav.addObject("pageActive", "portrait");
		return mav;
	}

	/* ===== 규율 ===== */
	@RequestMapping(value = "/disciplineDB.do", method = RequestMethod.GET)
	public String disciplineDB() {
		return "redirect:/DB/listDiscipline.do";
	}

	@RequestMapping(value = "/DB/listDiscipline.do", method = RequestMethod.GET)
	public ModelAndView listDiscipline(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("disciplineDB");
		mav.addObject("disciplineList", Collections.emptyList());
		mav.addObject("pageActive", "discipline");
		return mav;
	}

	/* ===== 마력연구 ===== */
	@RequestMapping(value = "/magicDB.do", method = RequestMethod.GET)
	public String magicDB() {
		return "redirect:/DB/listMagicResearch.do";
	}

	@RequestMapping(value = "/DB/listMagicResearch.do", method = RequestMethod.GET)
	public ModelAndView listMagicResearch(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("magicDB"); // 파일명과 일치
		mav.addObject("magicList", Collections.emptyList());
		mav.addObject("pageActive", "magic");
		return mav;
	}

	/* ===== 아티팩트 ===== */
	@RequestMapping(value = "/artifactDB.do", method = RequestMethod.GET)
	public String artifactDB() {
		return "redirect:/DB/listArtifact.do";
	}

	@RequestMapping(value = "/DB/listArtifact.do", method = RequestMethod.GET)
	public ModelAndView listArtifact(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("artifactDB");
		mav.addObject("artifactList", Collections.emptyList());
		mav.addObject("pageActive", "artifact");
		return mav;
	}

	/* ===== 세피라 ===== */
	@RequestMapping(value = "/sephiraDB.do", method = RequestMethod.GET)
	public String sephiraDB() {
		return "redirect:/DB/listSephira.do";
	}

	@RequestMapping(value = "/DB/listSephira.do", method = RequestMethod.GET)
	public ModelAndView listSephira(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("sephiraDB");
		mav.addObject("sephiraList", Collections.emptyList());
		mav.addObject("pageActive", "sephira");
		return mav;
	}
}
