<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Index</title>
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<script type="text/javascript" src="static/js/jquery-1.12.4.min.js"></script>
<link href="static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 添加员工模态框 -->
	<div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
			
				<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				<h4 class="modal-title" id="myModalLabel">添加员工</h4>
				</div>
				
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">姓名</label>
							<div class="col-sm-6">
								<input type="text" name="name" class="form-control" id="empName_add_input" placeholder="empName">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-6">
								<input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">性别</label>
							<div class="col-sm-10">
								<label class="radio-inline">
									<input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
								</label>
								<label class="radio-inline">
									<input type="radio" name="gender" id="gender2_add_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">部门</label>
							<div class="col-sm-4">
								<!-- 部门提交部门id即可 -->
								<select id="dept_add_select" class="form-control" name="dId"></select>
							</div>
						</div>
					</form>
				</div>
				
				<div class="modal-footer">
				  <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				  <button type="button" id="emp_save_btn" class="btn btn-primary">保存</button>
				</div>
				
			</div>
		</div>
	</div>
	<!-- 添加员工模态框结束 -->

	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-3 col-md-offset-9">
				<button class="btn btn-primary" id="emp_add_btn">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
		</div>
		<!-- 分页 -->
		<div class="row">
			<!--分页文字信息  -->
			<div class="col-md-6" id="page_info_area">
				
			</div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area">
				
			</div>
		</div>
		<!-- 分页结束 -->
	</div>
	<script type="text/javascript">
	
		var totalRecord;
	
		$(function() {
			to_page(1);
		});
		
		function to_page(pn) {
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"GET",
				success:function(result){
					// 1.解析并显示员工信息
					build_emps_table(result);
					// 2.解析并显示分页信息
					build_page_info(result);
					build_page_nav(result)
				}
			});
		}	
		
		function build_emps_table(result) {
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item){
				var idTd = $("<td></td>").append(item.id);
				var nameTd = $("<td></td>").append(item.name);
				var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
				var emailTd = $("<td></td>").append(item.email);
				var deptTd = $("<td></td>").append(item.department.name);
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
					.append("编辑");
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
					.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
					.append("删除");
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				$("<tr></tr>")
					.append(idTd)
					.append(nameTd)
					.append(genderTd)
					.append(emailTd)
					.append(deptTd)
					.append(btnTd)
					.appendTo("#emps_table tbody");
			});
		}
		
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"+
					result.extend.pageInfo.pages+"页，总"+
					result.extend.pageInfo.total+"条记录");
			totalRecord = result.extend.pageInfo.total;
		}
		
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				//为元素添加点击翻页的事件
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum-1);
				});
			}
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			if(result.extend.pageInfo.hasNextPage == false){
				nextPageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			} else {
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum+1);
				});
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
			}
			ul.append(firstPageLi).append(prePageLi);
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if(result.extend.pageInfo.pageNum == item){
					numLi.addClass("active");
				}
				numLi.click(function(){
					to_page(item);
				});
				ul.append(numLi);
			});
			ul.append(nextPageLi).append(lastPageLi);
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		
		$("#emp_add_btn").click(function(){
			// 清除表单数据
			$("#emp_add_modal form")[0].reset();
			getDepts();
			$("#emp_add_modal").modal({
				backdrop:"static"
			});
		});
		
		function getDepts() {
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result) {
					$.each(result.extend.depts, function(){
						var optionEle = $("<option></option>")
							.append(this.name).attr("value", this.id);
						optionEle.appendTo("#dept_add_select");
					});
				}
			});
		}
		
		//显示校验结果的提示信息
		function show_validate_msg(ele,status,msg){
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			if("success"==status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error" == status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		// 校验表单数据
		function validate_add_form() {
			// 校验员工姓名
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input", "success", "");
			};
			// 校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				return false;
			}else{
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}
		
		// 为添加员工模态框中的保存按钮注册点击事件
		$("#emp_save_btn").click(function() { 
			if(!validate_add_form()) {
				return false;
			}
			
			if ($(this).attr("ajax-va" == "error")) {
				return false;
			}
			
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#emp_add_modal form").serialize(),
				success:function(result) {
					// alert(result.message);
					// 1.关闭模态框
					$("#emp_add_modal").modal("hide");
					// 2.自动跳转到最后一页
					to_page(totalRecord);
				}
			});
		});
		
		// 校验用户名是否可用
		$("#empName_add_input").change(function() {
			var name = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"name="+name,
				type:"POST",
				success:function(result) {
					if (result.code == 100) {
						show_validate_msg("#empName_add_input", "success", "用户名可用");
						$("#emp_save_btn").attr("ajax-va", "success");
					} else {
						show_validate_msg("#empName_add_input", "error", "用户名不可用");
						$("#emp_save_btn").attr("ajax-va", "error");
					}
				}
			});
		});
		
		
	</script>
</body>
</html>