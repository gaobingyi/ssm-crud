package com.gby.ssm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gby.ssm.bean.Department;
import com.gby.ssm.bean.Message;
import com.gby.ssm.service.DepartmentService;

@Controller
public class DepartmentController {
	
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("/depts")
	@ResponseBody
	public Message getDepts() {
		List<Department> depts = departmentService.getDepts();
		return Message.success().add("depts", depts);
	}
	
}
