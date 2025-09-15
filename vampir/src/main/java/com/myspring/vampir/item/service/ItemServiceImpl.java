package com.myspring.vampir.item.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.myspring.vampir.item.dao.ItemDAO;

@Service("itemService")
public class ItemServiceImpl implements ItemService {
	
	@Autowired
	private ItemDAO itemDAO;
	
	@Override
	public List<Map<String, Object>> listItemsUnified() {
		return itemDAO.selectAllUnified();
	}
}