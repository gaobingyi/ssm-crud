package com.gby.ssm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gby.ssm.bean.Employee;
import com.gby.ssm.bean.Message;
import com.gby.ssm.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService employeeService;
	
	// @RequestMapping("/emps")
	public String getEmployees(@RequestParam(value="pn", defaultValue="1") Integer pn, Model model) {
		PageHelper.startPage(pn, 5);
		List<Employee> emps = employeeService.getAll();
		PageInfo<Employee> pageInfo = new PageInfo<>(emps);
		model.addAttribute("pageInfo", pageInfo);
		return "list2";
	}
	
	@RequestMapping("/emps")
	@ResponseBody
	public Message getEmpsWithJson(
			@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		PageHelper.startPage(pn, 8);
		List<Employee>	 emps = employeeService.getAll();
		PageInfo<Employee> pageInfo = new PageInfo<>(emps);
		return Message.success().add("pageInfo", pageInfo);
	}
	
	@RequestMapping(value="/emp", method=RequestMethod.POST)
	@ResponseBody
	public Message saveEmp(Employee employee) {
		employeeService.saveEmp(employee);
		return Message.success();
	}
	
	@RequestMapping(value="/checkuser", method=RequestMethod.POST)
	@ResponseBody
	public Message checkUser(@RequestParam("name") String name) {
		System.out.println("hello");
		if (employeeService.checkUser(name)) {
			return Message.success();
		} else {
			return Message.fail();
		}
	}
	
	
}
