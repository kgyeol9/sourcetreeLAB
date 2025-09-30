package com.myspring.vampir.serverboard.vo;

import java.util.Date;

public class ServerCommentVO {
  private Integer id;
  private Integer postId;     // FK -> server_posts.id
  private Integer parentId;   // 대댓글이면 부모 댓글 id, 아니면 null
  private String  writer;
  private String  content;
  private Date    regDate;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }

  public Integer getPostId() { return postId; }
  public void setPostId(Integer postId) { this.postId = postId; }

  public Integer getParentId() { return parentId; }
  public void setParentId(Integer parentId) { this.parentId = parentId; }

  public String getWriter() { return writer; }
  public void setWriter(String writer) { this.writer = writer; }

  public String getContent() { return content; }
  public void setContent(String content) { this.content = content; }

  public Date getRegDate() { return regDate; }
  public void setRegDate(Date regDate) { this.regDate = regDate; }
}
