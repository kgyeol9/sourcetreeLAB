package com.myspring.vampir.member.vo;

import java.sql.Date;
import org.springframework.stereotype.Component;

@Component("memberVO")
public class MemberVO {

    // �궡遺� 湲곗� (移대찞耳��씠�뒪)
    private String memId;
    private String memPwd;
    private String nickname;
    private String email;
    private Date   joinDate;
    
    // ✅ 새로 추가할 필드들
    private int memCode;          // PK, comments.member_id가 참조하는 컬럼
    private int boardCount;       // 작성한 게시글 수
    private int commentCount;     // 작성한 댓글 수

    public int getMemCode() {
		return memCode;
	}

	public void setMemCode(int memCode) {
		this.memCode = memCode;
	}

	public int getBoardCount() {
		return boardCount;
	}

	public void setBoardCount(int boardCount) {
		this.boardCount = boardCount;
	}

	public int getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}

	public MemberVO() { }

    public MemberVO(int memCode, String memId, String memPwd, String nickname, String email, Date joinDate, int boardCount, int commentCount) {
        this.memCode = memCode;
        this.memId = memId;
        this.memPwd = memPwd;
        this.nickname = nickname;
        this.email = email;
        this.joinDate = joinDate;
        this.boardCount = boardCount;
        this.commentCount = commentCount;
    }
    
    // ====== 怨듭떇 �봽濡쒗띁�떚 (留ㅽ띁/�떊洹� �뤌�뿉�꽌 �궗�슜) ======
    public String getMemId() { return memId; }
    public void setMemId(String memId) { this.memId = memId; }

    public String getMemPwd() { return memPwd; }
    public void setMemPwd(String memPwd) { this.memPwd = memPwd; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Date getJoinDate() { return joinDate; }
    public void setJoinDate(Date joinDate) { this.joinDate = joinDate; }

    // ====== �뤌 �샇�솚 (snake 耳��씠�뒪 name=mem_id/mem_pwd 諛붿씤�뵫�슜) ======
    public String getMem_id() { return memId; }
    public void setMem_id(String mem_id) { this.memId = mem_id; }

    public String getMem_pwd() { return memPwd; }
    public void setMem_pwd(String mem_pwd) { this.memPwd = mem_pwd; }

    // ====== JSP �샇�솚 (�삁�쟾 ${id}, ${pwd}, ${name} 吏��썝) ======
    public String getId() { return memId; }
    public void setId(String id) { this.memId = id; }

    public String getPwd() { return memPwd; }
    public void setPwd(String pwd) { this.memPwd = pwd; }

    public String getName() { return nickname; }
    public void setName(String name) { this.nickname = name; }

    @Override
    public String toString() {
        return "MemberVO{" +
                "memId='" + memId + '\'' +
                ", memPwd='" + memPwd + '\'' +
                ", nickname='" + nickname + '\'' +
                ", email='" + email + '\'' +
                ", joinDate=" + joinDate +
                '}';
    }
}
