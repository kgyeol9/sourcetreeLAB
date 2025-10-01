package com.myspring.vampir.help.vo;

import java.time.LocalDateTime;

public class HelpTicketVO {
    private Long id;
    private Integer mem_code;     // ← memberCode → mem_code로 통일
    private String category;
    private String title;
    private String content;
    private boolean secret;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    // mem_code getter/setter (컨트롤러에서 me.getMem_code()와도 자연스럽게 호환)
    public Integer getMem_code() { return mem_code; }
    public void setMem_code(Integer mem_code) { this.mem_code = mem_code; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public boolean isSecret() { return secret; }
    public void setSecret(boolean secret) { this.secret = secret; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
