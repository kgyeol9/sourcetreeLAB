package com.myspring.vampir.item.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;

public interface ItemController {
	public ModelAndView listItems(HttpServletRequest request, HttpServletResponse response) throws Exception;

}