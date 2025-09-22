package com.myspring.vampir.DB.dao;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

public interface ItemDAO {
	List<Map<String,Object>> selectAllUnified() throws DataAccessException;
	List<Map<String,Object>> selectEtcUnified() throws DataAccessException;
}
