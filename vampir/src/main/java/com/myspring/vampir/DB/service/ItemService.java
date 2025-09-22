package com.myspring.vampir.DB.service;

import java.util.List;
import java.util.Map;

public interface ItemService {
	List <Map<String,Object>> listItemsUnified();

	List<Map<String, Object>> listEtcItemsUnified();
}
