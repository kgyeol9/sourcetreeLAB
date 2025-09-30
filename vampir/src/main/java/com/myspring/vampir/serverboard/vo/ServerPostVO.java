package com.myspring.vampir.serverboard.vo;

import java.util.Date;

public class ServerPostVO {
  private Integer id;
  private String  world;     // kapf / ...
  private String  server;    // "1" / "2" / "3"
  private String  title;
  private String  content;
  private String  writer;
  private Integer views;
  private Date    regDate;

  // ★ 이미지 경로(웹에서 접근 가능한 상대경로: /uploads/yyyymm/uuid.ext 등)
  private String  imagePath;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }

  public String getWorld() { return world; }
  public void setWorld(String world) { this.world = world; }

  public String getServer() { return server; }
  public void setServer(String server) { this.server = server; }

  public String getTitle() { return title; }
  public void setTitle(String title) { this.title = title; }

  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }

  public String getWriter() { return writer; }
  public void setWriter(String writer) { this.writer = writer; }

  public Integer getViews() { return views; }
  public void setViews(Integer views) { this.views = views; }

  public Date getRegDate() { return regDate; }
  public void setRegDate(Date regDate) { this.regDate = regDate; }

  public String getImagePath() { return imagePath; }
  public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}
