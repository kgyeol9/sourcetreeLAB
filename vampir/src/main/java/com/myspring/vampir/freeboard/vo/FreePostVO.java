package com.myspring.vampir.freeboard.vo;

import java.util.Date;

public class FreePostVO {
    private Long postId;
    private String title;
    private String content;
    private String writerId;
    private String writerName;
    private Integer viewCnt;
    private Integer commentCnt;
    private Boolean isDeleted;
    private Date createdAt;
    private Date updatedAt;

    // getter/setter
    public Long getPostId() { return postId; }
    public void setPostId(Long postId) { this.postId = postId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getWriterId() { return writerId; }
    public void setWriterId(String writerId) { this.writerId = writerId; }
    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }
    public Integer getViewCnt() { return viewCnt; }
    public void setViewCnt(Integer viewCnt) { this.viewCnt = viewCnt; }
    public Integer getCommentCnt() { return commentCnt; }
    public void setCommentCnt(Integer commentCnt) { this.commentCnt = commentCnt; }
    public Boolean getIsDeleted() { return isDeleted; }
    public void setIsDeleted(Boolean isDeleted) { this.isDeleted = isDeleted; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
}
