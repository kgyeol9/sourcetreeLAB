package com.myspring.vampir.DB.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.DB.dao.ItemDAO;

@Service("itemService")
public class ItemServiceImpl implements ItemService {
	
	@Autowired
	private ItemDAO itemDAO;
	
	@Override
	public List<Map<String, Object>> listItemsUnified() {
		return itemDAO.selectAllUnified();
	}

	@Override
	public List<Map<String, Object>> listEtcItemsUnified() {
		return itemDAO.selectEtcUnified();
	}
}