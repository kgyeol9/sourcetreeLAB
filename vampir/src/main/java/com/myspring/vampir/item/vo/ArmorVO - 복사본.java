package com.myspring.vampir.item.vo;

import org.springframework.stereotype.Component;

@Component("ArmorVO")
public class ArmorVO {
	private String item_code;
	
	public ArmorVO() {
		
	}
	
	public ArmorVO(String item_code) {
		this.item_code = item_code;
	}
}
