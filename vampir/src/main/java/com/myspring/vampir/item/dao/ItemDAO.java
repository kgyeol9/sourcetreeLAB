package com.myspring.vampir.item.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

public interface ItemDAO {
	List<Map<String,Object>> selectAllUnified() throws DataAccessException;
}
