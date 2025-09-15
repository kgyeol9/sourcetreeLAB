package com.myspring.vampir.item.vo;

import org.springframework.stereotype.Component;

@Component("itemVO")
public class ItemVO {
	private String item_code;
	private String name;
	private int upgrade;
	private String job;
	private String quality;
	private int min_ATK;
	private int max_ATK;
	private int add_ATK;
	private int accuracy;
	private int critical;
	private int job_ATK;
	private int job_ACR;
	private int job_amp;
	private int skill_ATK;
	private int skill_ACR;
	private int skill_amp;
	private String engraveOP1;
	private int engravePT1;
	private String engraveOP2;
	private int engravePT2;
	private String engraveOP3;
	private int engravePT3;
	private String skill_name;
	private String skill_comment;
	private String obtain_source;
	private String imgPath;
	private int img_row;
	private int img_col;
	
	public ItemVO() {}
	
	public ItemVO(String item_code, String name, int upgrade, String job, String quality, int min_ATK, int maxATK, int add_ATK, int accracy, int critical, int job_ATK, int job_ACR, int job_amp, int skill_ATK, int skill_ACR, int skill_amp, String engraveOP1, int engravePT1, String engraveOP2, int engravePT2, String engraveOP3, int engravePT3, String skill_name, String skill_comment, String obtain_source, String imgPath, int img_row, int img_col) {
		this.item_code = item_code;
		this.name = name;
		this.upgrade = upgrade;
		this.job = job;
		this.quality = quality;
		this.min_ATK = min_ATK;
		this.max_ATK = max_ATK;
		this.add_ATK = add_ATK;
		this.accuracy = accuracy;
		this.critical = critical;
		this.job_ATK = job_ATK;
		this.job_ACR = job_ACR;
		this.job_amp = job_amp;
		this.skill_ATK = skill_ATK;
		this.skill_ACR = skill_ACR;
		this.skill_amp = skill_amp;
		this.engraveOP1 = engraveOP1;
		this.engravePT1 = engravePT1;
		this.engraveOP2 = engraveOP2;
		this.engravePT2 = engravePT2;
		this.engraveOP3 = engraveOP3;
		this.engravePT3 = engravePT3;
		this.skill_name = skill_name;
		this.skill_comment = skill_comment;
		this.obtain_source = obtain_source;
		this.imgPath = imgPath;
		this.img_row = img_row;
		this.img_col = img_col;
	}

	public String getItem_code() {
		return item_code;
	}

	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getUpgrade() {
		return upgrade;
	}

	public void setUpgrade(int upgrade) {
		this.upgrade = upgrade;
	}

	public String getJob() {
		return job;
	}

	public void setJob(String job) {
		this.job = job;
	}

	public String getQuality() {
		return quality;
	}

	public void setQuality(String quality) {
		this.quality = quality;
	}

	public int getMin_ATK() {
		return min_ATK;
	}

	public void setMin_ATK(int min_ATK) {
		this.min_ATK = min_ATK;
	}

	public int getMax_ATK() {
		return max_ATK;
	}

	public void setMax_ATK(int max_ATK) {
		this.max_ATK = max_ATK;
	}

	public int getAdd_ATK() {
		return add_ATK;
	}

	public void setAdd_ATK(int add_ATK) {
		this.add_ATK = add_ATK;
	}

	public int getAccuracy() {
		return accuracy;
	}

	public void setAccuracy(int accuracy) {
		this.accuracy = accuracy;
	}

	public int getCritical() {
		return critical;
	}

	public void setCritical(int critical) {
		this.critical = critical;
	}

	public int getJob_ATK() {
		return job_ATK;
	}

	public void setJob_ATK(int job_ATK) {
		this.job_ATK = job_ATK;
	}

	public int getJob_ACR() {
		return job_ACR;
	}

	public void setJob_ACR(int job_ACR) {
		this.job_ACR = job_ACR;
	}

	public int getJob_amp() {
		return job_amp;
	}

	public void setJob_amp(int job_amp) {
		this.job_amp = job_amp;
	}

	public int getSkill_ATK() {
		return skill_ATK;
	}

	public void setSkill_ATK(int skill_ATK) {
		this.skill_ATK = skill_ATK;
	}

	public int getSkill_ACR() {
		return skill_ACR;
	}

	public void setSkill_ACR(int skill_ACR) {
		this.skill_ACR = skill_ACR;
	}

	public int getSkill_amp() {
		return skill_amp;
	}

	public void setSkill_amp(int skill_amp) {
		this.skill_amp = skill_amp;
	}

	public String getEngraveOP1() {
		return engraveOP1;
	}

	public void setEngraveOP1(String engraveOP1) {
		this.engraveOP1 = engraveOP1;
	}

	public int getEngravePT1() {
		return engravePT1;
	}

	public void setEngravePT1(int engravePT1) {
		this.engravePT1 = engravePT1;
	}

	public String getEngraveOP2() {
		return engraveOP2;
	}

	public void setEngraveOP2(String engraveOP2) {
		this.engraveOP2 = engraveOP2;
	}

	public int getEngravePT2() {
		return engravePT2;
	}

	public void setEngravePT2(int engravePT2) {
		this.engravePT2 = engravePT2;
	}

	public String getEngraveOP3() {
		return engraveOP3;
	}

	public void setEngraveOP3(String engraveOP3) {
		this.engraveOP3 = engraveOP3;
	}

	public int getEngravePT3() {
		return engravePT3;
	}

	public void setEngravePT3(int engravePT3) {
		this.engravePT3 = engravePT3;
	}

	public String getSkill_name() {
		return skill_name;
	}

	public void setSkill_name(String skill_name) {
		this.skill_name = skill_name;
	}

	public String getSkill_comment() {
		return skill_comment;
	}

	public void setSkill_comment(String skill_comment) {
		this.skill_comment = skill_comment;
	}

	public String getObtain_source() {
		return obtain_source;
	}

	public void setObtain_source(String obtain_source) {
		this.obtain_source = obtain_source;
	}

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public int getImg_row() {
		return img_row;
	}

	public void setImg_row(int img_row) {
		this.img_row = img_row;
	}

	public int getImg_col() {
		return img_col;
	}

	public void setImg_col(int img_col) {
		this.img_col = img_col;
	}
	
	
}
// item_code, name, upgrade, job, quality, min_ATK, max_ATK, add_ATK, accuracy,
// critical, job_ATK, job_ACR, job_amp, skill_ATK, skill_ACR, skill_amp,
// engraveOP1, engravePT1, engraveOP2, engravePT2, engraveOP3, engravePT3,
// skill_name, skill_comment, ontain_source, imgPath, img_row, img_col