package com.myspring.vampir.partyboard.vo;

import java.util.Date;

public class PartyApplicantVO {
    private Long id;
    private Long postId;
    private String userId;
    private String nick;
    private String status; // APPLIED / ACCEPTED / REJECTED
    private Date createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getPostId() { return postId; }
    public void setPostId(Long postId) { this.postId = postId; }
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getNick() { return nick; }
    public void setNick(String nick) { this.nick = nick; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
