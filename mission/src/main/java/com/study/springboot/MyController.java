package com.study.springboot;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.spring.Mdao;
import com.study.springboot.spring.Mdto;

@Controller
public class MyController {
	@Autowired
	private Mdao mdao;
	
	@RequestMapping("/")
	public String view(Model model) {
		
		return "view";
	}
	@RequestMapping("/addlist")
	@ResponseBody
	public String addList(HttpServletRequest req) {
		String id = req.getParameter("id");
		String name = req.getParameter("name");
		String gender = req.getParameter("gender");
		String country = req.getParameter("country");
		String city = req.getParameter("city");
		System.out.println(id+name+gender+country+city);
		
		mdao.addlist(id, name, gender, country, city);
		return "ok";
		
	}
	@RequestMapping("/updatelist")
	@ResponseBody
	public String updateList(HttpServletRequest req) {
		String id = req.getParameter("id");
		String name = req.getParameter("name");
		String gender = req.getParameter("gender");
		String country = req.getParameter("country");
		String city = req.getParameter("city");
		System.out.println(id+name+gender+country+city);
		
		mdao.updatelist(id, name, gender, country, city);
		return "ok";
		
	}
	@RequestMapping("/deletelist")
	@ResponseBody
	public String doDeletelist(HttpServletRequest req) {
		String id = req.getParameter("id");
		mdao.deletelist(id);
		return "ok";
	}
	@RequestMapping("/getlist")
	@ResponseBody 
	public String getlist() {
		ArrayList<Mdto> mdto = mdao.getList();
		JSONArray ja = new JSONArray();
		for(int i=0; i<mdto.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id",mdto.get(i).getId());
			jo.put("name",mdto.get(i).getName());
			jo.put("gender",mdto.get(i).getGender());
			jo.put("country",mdto.get(i).getCountry());
			jo.put("city",mdto.get(i).getCity());
			ja.add(jo);
		}
		
		return ja.toJSONString();
	}
	
	
	@RequestMapping("/loadlist")
	@ResponseBody 
	public String loadlist() {
		ArrayList<Mdto> mdto = mdao.getList();
		JSONArray ja = new JSONArray();
		for(int i=0; i<mdto.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id",mdto.get(i).getId());
			jo.put("name",mdto.get(i).getName());
			jo.put("gender",mdto.get(i).getGender());
			jo.put("country",mdto.get(i).getCountry());
			jo.put("city",mdto.get(i).getCity());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	@RequestMapping("/selectlist")
	@ResponseBody 
	public String selectlist(HttpServletRequest req) {
		ArrayList<Mdto> mdto = mdao.selectlist(req.getParameter("id"), req.getParameter("name"), req.getParameter("gender"), req.getParameter("country"), req.getParameter("city"), req.getParameter("start"), req.getParameter("end"));
		JSONArray ja = new JSONArray();
		for(int i=0; i<mdto.size(); i++) {
			JSONObject jo = new JSONObject();
			jo.put("id",mdto.get(i).getId());
			jo.put("name",mdto.get(i).getName());
			jo.put("gender",mdto.get(i).getGender());
			jo.put("country",mdto.get(i).getCountry());
			jo.put("city",mdto.get(i).getCity());
			ja.add(jo);
		}
		return ja.toJSONString();
	}
	
	
	@RequestMapping("/excels")
	public void download(HttpServletRequest req, HttpServletResponse response) throws IOException {
		    	
				Workbook wb = new XSSFWorkbook();
		        Sheet sheet = wb.createSheet("게시판 정보");
		        int rowNum = 0;
		        
		        Row headerRow = sheet.createRow(rowNum++);
		        headerRow.createCell(0).setCellValue("아이디");
		        headerRow.createCell(1).setCellValue("이름");
		        headerRow.createCell(2).setCellValue("성별");
		        headerRow.createCell(3).setCellValue("나라");
		        headerRow.createCell(4).setCellValue("도시");
		 
		        ArrayList<Mdto> mdto = mdao.selectlist(req.getParameter("id"), req.getParameter("name"), req.getParameter("gender"), req.getParameter("country"), req.getParameter("city"), req.getParameter("start"), req.getParameter("end")); 
		        //500에러가 왜 나는것일까유,,? mdao.getList();는 에러 안나고 잘 됨 ㅠ
		        for (Mdto board : mdto) {
		            Row bodyrow = sheet.createRow(rowNum++);
		            bodyrow.createCell(0).setCellValue(board.getId());
		            bodyrow.createCell(1).setCellValue(board.getName());
		            bodyrow.createCell(2).setCellValue(board.getGender());
		            bodyrow.createCell(3).setCellValue(board.getCountry());
		            bodyrow.createCell(4).setCellValue(board.getCity());
		            System.out.println(board.getId());
		        }
		        
		        // Download
		        response.setContentType("ms-vnd/excel");
		        response.setHeader("Content-Disposition", "attachment;filename=information.xlsx");
		        try {
		            wb.write(response.getOutputStream());
		        } finally {
		            wb.close();
		        }
		    }
}
