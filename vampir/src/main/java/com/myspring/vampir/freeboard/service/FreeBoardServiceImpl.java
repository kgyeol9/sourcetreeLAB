package com.myspring.vampir.freeboard.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.myspring.vampir.freeboard.mapper.FreeBoardMapper;
import com.myspring.vampir.freeboard.vo.FreePostVO;

@Service
public class FreeBoardServiceImpl implements FreeBoardService {

    @Autowired
    private FreeBoardMapper mapper;

    @Override
    public List<FreePostVO> list(int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        int offset = (page - 1) * size;
        return mapper.listPaged(size, offset);
    }

    @Override
    public int count() {
        return mapper.countAll();
    }

    @Override
    public FreePostVO viewAndIncrease(Long postId) {
        if (postId == null) return null;
        mapper.increaseViewCnt(postId);
        return mapper.selectOne(postId);
    }

    @Override
    public Long create(String title, String content, String writerId, String writerName) {
        FreePostVO vo = new FreePostVO();
        vo.setTitle(title);
        vo.setContent(content);
        vo.setWriterId(writerId);
        vo.setWriterName(writerName);
        int inserted = mapper.insert(vo);
        if (inserted != 1 || vo.getPostId() == null) return null;
        return vo.getPostId();
    }

    @Override
    public boolean updateOwn(Long postId, String writerId, String title, String content) {
        if (postId == null || writerId == null) return false;
        return mapper.updateOwn(postId, writerId, title, content) == 1;
    }

    @Override
    public boolean deleteOwn(Long postId, String writerId) {
        if (postId == null || writerId == null) return false;
        return mapper.softDeleteOwn(postId, writerId) == 1;
    }
}
