package com.myspring.vampir.freeboard.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.myspring.vampir.freeboard.mapper.FreeCommentMapper;
import com.myspring.vampir.freeboard.vo.FreeCommentVO;

@Service
public class FreeCommentServiceImpl implements FreeCommentService {

    @Autowired
    private FreeCommentMapper mapper;

    @Override
    public List<FreeCommentVO> list(Long postId) {
        return mapper.listByPost(postId);
    }

    @Override
    public Long add(Long postId, Long parentId, String content, String writerId, String writerName) {
        if (postId == null || writerId == null || content == null || content.trim().isEmpty()) return null;
        FreeCommentVO vo = new FreeCommentVO();
        vo.setPostId(postId);
        vo.setParentId(parentId);
        vo.setContent(content.trim());
        vo.setWriterId(writerId);
        vo.setWriterName(writerName != null && !writerName.trim().isEmpty() ? writerName.trim() : "È¸¿ø");
        int ok = mapper.insert(vo);
        return ok == 1 ? vo.getId() : null;
    }

    @Override
    public boolean edit(Long id, String writerId, String content) {
        if (id == null || writerId == null || content == null || content.trim().isEmpty()) return false;
        return mapper.updateOwn(id, writerId, content.trim()) == 1;
    }

    @Override
    public boolean remove(Long id, String writerId) {
        if (id == null || writerId == null) return false;
        return mapper.softDeleteOwn(id, writerId) == 1;
    }
}
