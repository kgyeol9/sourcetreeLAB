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

	@Override
	@RequestMapping(value = "/DB/listItems.do", method = RequestMethod.GET)
	public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Map<String, Object>> itemsList = itemService.listItemsUnified();
		System.out.println("[DEBUG] itemsList size = " + (itemsList == null ? "null" : itemsList.size()));

		// �� JSP ���ϸ��� itemDB.jsp �̹Ƿ� �� �̸��� itemDB��
		ModelAndView mav = new ModelAndView("itemDB"); // /WEB-INF/views/itemDB.jsp (�Ϲ����� ViewResolver ����)
		mav.addObject("itemsList", itemsList); // JSP���� ����ϴ� Ű�� ����
		return mav;
	}

	// ���� ��ũ (��� DB)
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
		mav.addObject("itemsList", itemsList); // �� Ű ����
		return mav;
	}

	// ���� ��ũ (��Ÿ DB)
	@RequestMapping(value = "/etcDB.do", method = RequestMethod.GET)
	public ModelAndView EtcItemDB(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return new ModelAndView("redirect:/DB/listEtcItems.do");
	}

	// ���� ���� ���� ��ư �� ������� �����̷�Ʈ
	@RequestMapping(value = "/formDB.do", method = RequestMethod.GET)
	public String formDB() {
		return "redirect:/DB/listForm.do"; // �� ���ؽ�Ʈ�н� ���� ���� �ʱ�
	}

	// ���� ���� ����Ʈ
	@RequestMapping(value = { "/DB/listForm.do", "/DB/listform.do" }, method = RequestMethod.GET)
	public ModelAndView listForm(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("formDB");
		mav.addObject("formList", java.util.Collections.emptyList());
		return mav;
	}

	// Ż �� ���� ��ư �� ������� �����̷�Ʈ
	@RequestMapping(value = "/mountDB.do", method = RequestMethod.GET)
	public String mountDB() {
		return "redirect:/DB/listMount.do"; // �� ����
	}

	// Ż �� ����Ʈ
	@RequestMapping(value = { "/DB/listMount.do", "/DB/listmount.do" }, method = RequestMethod.GET)
	public ModelAndView listMount(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("mountDB");
		mav.addObject("mountList", java.util.Collections.emptyList());
		return mav;
	}

	/* ===== �÷��� ===== */
	@RequestMapping(value = "/collectionDB.do", method = RequestMethod.GET)
	public String collectionDB() {
		return "redirect:/DB/listCollection.do";
	}

	@RequestMapping(value = "/DB/listCollection.do", method = RequestMethod.GET)
	public ModelAndView listCollection(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("collectionDB");
		mav.addObject("collectionList", Collections.emptyList()); // TODO: ���� ����
		mav.addObject("pageActive", "collection");
		return mav;
	}

	/* ===== �ʻ�ȭ ===== */
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

	/* ===== ���� ===== */
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

	/* ===== ���¿��� ===== */
	@RequestMapping(value = "/magicDB.do", method = RequestMethod.GET)
	public String magicDB() {
		return "redirect:/DB/listMagicResearch.do";
	}

	@RequestMapping(value = "/DB/listMagicResearch.do", method = RequestMethod.GET)
	public ModelAndView listMagicResearch(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView("magicDB"); // ���ϸ�� ��ġ
		mav.addObject("magicList", Collections.emptyList());
		mav.addObject("pageActive", "magic");
		return mav;
	}

	/* ===== ��Ƽ��Ʈ ===== */
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

	/* ===== ���Ƕ� ===== */
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
