package com.myspring.vampir.serverboard.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class ServerBoardController {

    // (선택) 월드 코드 → 표시명 매핑 (뷰에서 월드 한글명을 보여주고 싶을 때 사용)
    private static final Map<String, String> WORLD_LABELS = new LinkedHashMap<String, String>();
    static {
        WORLD_LABELS.put("kapf", "카프");
        WORLD_LABELS.put("olga", "올가");
        WORLD_LABELS.put("shima", "쉬마");
        WORLD_LABELS.put("oscar", "오스카");
        WORLD_LABELS.put("damir", "다미르");
        WORLD_LABELS.put("moarte", "모아르테");
        WORLD_LABELS.put("razvi", "라즈비");
        WORLD_LABELS.put("foam", "포아메");
        WORLD_LABELS.put("dorlingen", "돌링엔");
        WORLD_LABELS.put("kizaiya", "키자이아");
        WORLD_LABELS.put("nel", "넬");
        WORLD_LABELS.put("mila", "밀라");
        WORLD_LABELS.put("lilith", "릴리스");
        WORLD_LABELS.put("kain", "카인");
        WORLD_LABELS.put("ridel", "리델");
    }

    /** 선택 화면: /vampir/serverboard.do */
    @RequestMapping(value = "/serverboard.do", method = RequestMethod.GET)
    public ModelAndView select() {
        ModelAndView mav = new ModelAndView("/serverboardSelect"); // Tiles 정의명
        // (선택) 월드 리스트를 뷰에 넘기고 싶다면 주석을 해제하세요.
        // mav.addObject("worldLabels", WORLD_LABELS);
        return mav;
    }

    /** 목록 화면: /vampir/serverboard/{world}/{server}  (예: /serverboard/kapf/1) */
    @RequestMapping(value = { "/serverboard/{world}/{server}", "/serverboard/{world}/{server}.do" },
                    method = RequestMethod.GET)
    public ModelAndView list(@PathVariable("world") String world,
                             @PathVariable("server") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/list"); // Tiles 정의명
        mav.addObject("world", world);
        mav.addObject("server", server);
        // (선택) 표시용 한글명
        mav.addObject("worldLabel", WORLD_LABELS.get(world));
        mav.addObject("serverLabel", server + " 서버");
        return mav;
    }

    /** (옵션) 쿼리스트링 버전: /serverboard/list.do?world=kapf&server=1 */
    @RequestMapping(value = "/serverboard/list.do", method = RequestMethod.GET)
    public ModelAndView listWithParams(@RequestParam("world") String world,
                                       @RequestParam("server") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/list"); // Tiles 정의명
        mav.addObject("world", world);
        mav.addObject("server", server);
        // (선택) 표시용 한글명
        mav.addObject("worldLabel", WORLD_LABELS.get(world));
        mav.addObject("serverLabel", server + " 서버");
        return mav;
    }
    
 // 글쓰기 폼 (월드/서버 파라미터로 미리 선택)
    @RequestMapping(value = {"/serverboard/write", "/serverboard/write.do"}, method = RequestMethod.GET)
    public ModelAndView writeForm(
            @RequestParam(value="world", required=false, defaultValue="ALL") String world,
            @RequestParam(value="server", required=false, defaultValue="ALL") String server) {
        ModelAndView mav = new ModelAndView("/serverboard/write"); // tiles 정의명
        mav.addObject("world", world);
        mav.addObject("server", server);
        return mav;
    }

    // 글 등록 처리 (저장 로직은 서비스에 맞게 구현)
    @RequestMapping(value = {"/serverboard/add", "/serverboard/add.do"}, method = RequestMethod.POST)
    public ModelAndView add(
            @RequestParam("world")  String world,
            @RequestParam("server") String server,
            @RequestParam("title")  String title,
            @RequestParam("content") String content) {

        // TODO: 저장 로직 (DB insert) — 서비스 호출
        // serverBoardService.save(world, server, title, content, writer ...);

        // 등록 후 목록으로
        ModelAndView mav = new ModelAndView("redirect:/serverboard/" + world + "/" + server);
        return mav;
    }
}
