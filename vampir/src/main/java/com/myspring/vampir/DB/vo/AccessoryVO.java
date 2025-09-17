package com.myspring.vampir.DB.vo;

import org.springframework.stereotype.Component;

@Component("AccessoryVO")
public class AccessoryVO {
	private String item_code;
	
	public AccessoryVO() {
		
	}
	
	public AccessoryVO(String item_code) {
		this.item_code = item_code;
	}
}
