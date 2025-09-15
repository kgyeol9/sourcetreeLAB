drop table if exists weaponDB;
drop table if exists armorDB;

-- 이미지링크 이미지링크에 대한 행값 열값
-- 직업(00), 희귀도(00), 종류(00), 아이템개수(0000)
create table weaponDB(
	item_code		varchar(10) not null primary key,
	name			varchar(20)	not null unique,
    upgrade			int	not null default 1,
    job				varchar(10) not null,
    quality			varchar(4) not null,
    min_ATK			int not null,
    max_ATK			int not null,
    add_ATK			int null,
    accuracy		int null,
    critical		int null,
    melee_ATK		int unsigned null comment '근거리 공격력',
    melee_ACR		int unsigned null comment '근거리 명중',
    melee_amp		int unsigned null comment '근거리 증폭',
    range_ATK		int unsigned null comment '원거리 공격력',
    range_ACR		int unsigned null comment '원거리 명중',
    range_amp		int unsigned null comment '원거리 증폭',
    magic_ATK		int unsigned null comment '마법 공격력',
    magic_ACR		int unsigned null comment '마법 명중',
    magic_amp		int unsigned null comment '마법 증폭',
    skill_ATK		int unsigned null comment '스킬 공격력',
    skill_ACR		int unsigned null comment '근거리 명중',
    skill_amp		int unsigned null comment '근거리 증폭',
    engraveOP1		varchar(10) null comment '세공1',
    engravePT1		int unsigned null,
    engraveOP2		varchar(10) null comment '세공2',
    engravePT2		int unsigned null,
    engraveOP3		varchar(10) null comment '세공3',
    engravePT3		int unsigned null,
    skill_name		varchar(10) null,
    skill_comment	varchar(200) null,
    obtain_source	varchar(200) null,
    imgPath			varchar(200) null,
    img_row			int null,
    img_col			int null
);
--  방어구DB, 장신구DB, 부장품DB, 소모품DB, 스킬북DB, 재료DB, 제작DB

create table armorDB(
	item_code		varchar(10) not null primary key,
    name			varchar(20)	not null unique,
    upgrade			int	not null default 1,
    slot			varchar(10) not null,
    quality			varchar(4) not null,
    DEF				int not null,
    dmg_cri_res		int null,
    dmg_skill_res	int null,
    dmg_normal_res	int null,
    accuracy		int null,
    skill_accuracy	int null,
    evasion			int	null,
    skill_evasion	int	null,
    max_hp			int null,
    max_mp			int null,
    cri_res_rate	int	null,
    atk_spd			int null,
    skill_cast_spd	int null,
    spd_rate		int null,
    engraveOP1		varchar(10) null comment '세공1',
    engravePT1		int unsigned null,
    engraveOP2		varchar(10) null comment '세공2',
    engravePT2		int unsigned null,
    engraveOP3		varchar(10) null comment '세공3',
    engravePT3		int unsigned null,
    skill_name		varchar(10) null,
    skill_comment	varchar(200) null,
    obtain_source	varchar(200) null,
    imgPath			varchar(200) null,
    img_row			int null,
    img_col			int null
);

select * from t_member;
select * from weaponDB;
select * from armorDB;

select * from t_member
into outfile 't_member.csv'
fields terminated by ','
enclosed by '"'
lines terminated by '\n';