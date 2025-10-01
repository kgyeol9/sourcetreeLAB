package com.myspring.vampir.tac_job_board.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.myspring.vampir.member.vo.MemberVO;
import com.myspring.vampir.tac_job_board.service.tac_job_boardService;
import com.myspring.vampir.tac_job_board.vo.tac_job_boardVO;

@Controller
@RequestMapping("/tac_job")
public class tac_job_boardController {
    @Autowired
    private tac_job_boardService boardService;

    
    
    // 목록 페이지 (GET)
    @RequestMapping(value="/list.do", method = RequestMethod.GET)
    public ModelAndView listPage(@RequestParam(value="type", defaultValue="all") String type,
                                 @RequestParam(value="page", defaultValue="1") int page) {
        int pageSize = 10;
        List<tac_job_boardVO> boards = boardService.listBoards(type, page, pageSize);
        int totalCount = boardService.countBoards(type);

        ModelAndView mav = new ModelAndView("/tac_job/list");
        mav.addObject("boards", boards);
        mav.addObject("page", page);
        mav.addObject("totalCount", totalCount);
        mav.addObject("type", type);
        return mav;
    }

    // 글쓰기 폼 (GET)
    @RequestMapping(value="/write.do", method = RequestMethod.GET)
    public ModelAndView writeForm(@RequestParam(value="type", defaultValue="job") String type) {
        if (!"guide".equals(type) && !"job".equals(type)) type = "job";

        ModelAndView mav = new ModelAndView("/tac_job/write");
        mav.addObject("type", type);
        return mav;
    }

    // 글 등록 처리 (POST) — **이미지/파일/세션 자동 처리 없음**
    @RequestMapping(value="/add.do", method = RequestMethod.POST)
    @ResponseBody
    public String add(@ModelAttribute tac_job_boardVO vo, HttpSession session) {
        try {
            // 로그인 세션 확인
        	  MemberVO member = (MemberVO) session.getAttribute("member");
            if(member == null) {
                System.out.println("[DEBUG] 로그인 사용자 없음");
                return "로그인 필요";
            }

            // mem_code 세션에서 가져오기
            vo.setMem_code(member.getMemCode());

            // debug: 넘어온 값들 확인
            System.out.println("[DEBUG] board_type: " + vo.getBoard_type());
            System.out.println("[DEBUG] mem_code  : " + vo.getMem_code());
            System.out.println("[DEBUG] title     : " + vo.getTitle());
            System.out.println("[DEBUG] content   : " + vo.getContent());

            // DB에 저장
            boardService.writeBoard(vo);

            return "success";

        } catch(Exception e) {
            e.printStackTrace();
            return "실패: " + e.getMessage();
        }
    }

    // 글보기 (GET)
    @RequestMapping(value="/view.do", method = RequestMethod.GET)
    public ModelAndView view(@RequestParam("board_id") int board_id) {
        tac_job_boardVO board = boardService.viewBoard(board_id);
        ModelAndView mav = new ModelAndView("/tac_job/view");
        mav.addObject("board", board);
        return mav;
    }

    // 수정 폼 (GET)
    @RequestMapping(value="/edit.do", method = RequestMethod.GET)
    public ModelAndView editForm(@RequestParam("board_id") int board_id) {
        tac_job_boardVO board = boardService.viewBoard(board_id);
        ModelAndView mav = new ModelAndView("/tac_job/edit");
        mav.addObject("board", board);
        return mav;
    }

    // 수정 처리 (POST) — **이미지/파일/세션 자동 처리 없음**
    @RequestMapping(value="/edit.do", method = RequestMethod.POST)
    @ResponseBody
    public String edit(@ModelAttribute tac_job_boardVO board) {
        boardService.editBoard(board);
        return "success";
    }

    // 삭제 처리 (POST)
    @RequestMapping(value="/delete.do", method = RequestMethod.POST)
    @ResponseBody
    public String delete(@RequestParam("board_id") int board_id) {
        boardService.removeBoard(board_id);
        return "success";
    }

    // 추천 처리 (POST)
    @RequestMapping(value="/recommend.do", method = RequestMethod.POST)
    @ResponseBody
    public String recommend(@RequestParam("board_id") int board_id) {
        boardService.increaseRecommendCount(board_id);
        return "success";
    }
}