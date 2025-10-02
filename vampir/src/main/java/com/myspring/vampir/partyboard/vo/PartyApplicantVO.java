package com.myspring.vampir.partyboard.vo;

import java.util.Date;

public class PartyApplicantVO {
    private Long id;
    private Long postId;
    private String userId;
    private String nick;        // DB: nickname
    private String status;      // APPLIED / ACCEPTED / REJECTED
    private String applyTitle;  // 지원 제목
    private String igNick;      // 인게임 닉네임
    private String memo;        // 메모
    private String imagePath;   // 업로드 이미지 상대경로
    private Date createdAt;     // DB: applied_at

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
    public String getApplyTitle() { return applyTitle; }
    public void setApplyTitle(String applyTitle) { this.applyTitle = applyTitle; }
    public String getIgNick() { return igNick; }
    public void setIgNick(String igNick) { this.igNick = igNick; }
    public String getMemo() { return memo; }
    public void setMemo(String memo) { this.memo = memo; }
    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
