package com.myspring.vampir.DB.vo;

import org.springframework.stereotype.Component;

@Component("SubequipVO")
public class SubequipVO {
	private String item_code;
	
	public SubequipVO() {
		
	}
	
	public SubequipVO(String item_code) {
		this.item_code = item_code;
	}
}
