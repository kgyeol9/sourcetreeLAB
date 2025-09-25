package com.myspring.vampir.news.vo;

import java.util.Date;

public class NewsVO {
    private String articleNO;      // N-0001 형식
    private Integer parentNO;      // 스레드/답글용 (현재 0)
    private String title;          // 제목
    private String content;        // 본문(HTML 가능)
    private String imageFileName;  // 첨부 이미지 파일명
    private Date writedate;        // 작성일시
    private String id;             // 작성자 ID (t_member.mem_id)

    public NewsVO() {}

    public String getArticleNO() { return articleNO; }
    public void setArticleNO(String articleNO) { this.articleNO = articleNO; }

    public Integer getParentNO() { return parentNO; }
    public void setParentNO(Integer parentNO) { this.parentNO = parentNO; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getImageFileName() { return imageFileName; }
    public void setImageFileName(String imageFileName) { this.imageFileName = imageFileName; }

    public Date getWritedate() { return writedate; }
    public void setWritedate(Date writedate) { this.writedate = writedate; }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    @Override
    public String toString() {
        return "NewsVO{" +
                "articleNO='" + articleNO + '\'' +
                ", parentNO=" + parentNO +
                ", title='" + title + '\'' +
                ", writedate=" + writedate +
                ", id='" + id + '\'' +
                '}';
    }
}
