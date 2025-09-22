package com.myspring.vampir.DB.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

@Repository("itemDAO")
public class ItemDAOImpl implements ItemDAO {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public List<Map<String,Object>> selectAllUnified() throws DataAccessException {
	    // (선택) 디버그는 weapon 네임스페이스로
	    String curDb = sqlSession.selectOne("mapper.weapon.currentDatabase");
	    Integer w    = sqlSession.selectOne("mapper.weapon.countWeapon");
	    System.out.println("[DEBUG] DB=" + curDb + ", weaponDB count=" + w);

	    // 통합 목록
	    return sqlSession.selectList("mapper.itemUnified.selectAllAsMap");
	}

	@Override
	public List<Map<String, Object>> selectEtcUnified() throws DataAccessException {

		String curDB = sqlSession.selectOne("mapper.consumable.currentDatabase");
		Integer consume = sqlSession.selectOne("mapper.consumable.countConsumable");
		System.out.println("[DEBUG] DB=" + curDB + ", consumableDB count=" + consume);
		
		return sqlSession.selectList("mapper.etcitemUnified.selectEtcAsMap");
	}

}
