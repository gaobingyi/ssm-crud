package com.gby.ssm.test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.gby.ssm.bean.Employee;
import com.gby.ssm.bean.EmployeeExample;
import com.gby.ssm.dao.DepartmentMapper;
import com.gby.ssm.dao.EmployeeMapper;

@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Test
	public void test() {
		/*departmentMapper.insertSelective(new Department(null, "������"));
		departmentMapper.insertSelective(new Department(null, "���Բ�"));*/
		
		/*employeeMapper.insertSelective(new Employee(null, "�߱���", "M", "gaobingyi@qq.com", 3));
		employeeMapper.insertSelective(new Employee(null, "�����", "F", "gaoyijuan@qq.com", 4));*/
		
		/*Employee emp = employeeMapper.selectByPrimaryKeyWithDept(3);
		System.out.println(emp);*/
		
		EmployeeExample example = new EmployeeExample();
		example.createCriteria().andNameLike("��%");
		List<Employee> emps = employeeMapper.selectByExampleWithDept(example);
		for (Employee employee : emps) {
			System.out.println(employee);
		}
	}
}
