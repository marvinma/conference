<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	response.setDateHeader("Expires", 0);
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<jsp:include page="../../../../include/sys-common.jsp" />
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    <script type="text/javascript">
	
		$(document).ready(function(){  
			loadGrid();  
    	});  
    	
		function loadGrid()  {
			$('#dg').datagrid({
				nowrap:false,
				loadMsg:'加载中，请稍候...',
				fitColumns:true,
				pagination : true,//页码
				pageNumber : 1,//初始页码
				pageSize : 15,
				pageList : [15,30,45,60],
				detailFormatter:function(index,row){
					return '<div style="padding:5px"><table id="ddv-' + index + '"></table></div>';
				},
				pagination:true,
			});
		}

	</script>
  </head>
  
  <body>
  	
	<table id="dg" title="一级菜单分类" style="width:100%;height:100%"
		data-options="striped:true,rownumbers:true,singleSelect:false,url:'essay_type/r',method:'get', 
      				 multiSort:true,fit:true,nowrap:false,toolbar:'#toolbar',pagination:'true'">
		<thead>
			<tr id="tr">
				<th data-options="field:'ck',checkbox:true"></th>
				<th data-options="field:'id',width:$(this).width() * 0,nowrap:'false',align:'left',hidden:'true'">分类Id</th>
				<th data-options="field:'meetingId',width:$(this).width() * 0,nowrap:'false',align:'left',hidden:'true'">会议编号</th>
				<th data-options="field:'typeName',width:$(this).width() * 0.4,nowrap:'false',align:'left'">一级菜单分类名称</th>
				<th data-options="field:'typeNameEn',width:$(this).width() * 0.4,nowrap:'false',align:'left'">一级菜单分类英文名称</th>
				<th data-options="field:'showOrder',width:$(this).width() * 0.1,nowrap:'false',align:'left'">显示顺序</th>
			</tr>
		</thead>
	</table>
	
	<div id="toolbar">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-add" plain="true" onclick="addEssayTypeInfo()">添加</a>
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-edit" plain="true" onclick="editEssayTypeInfo()">修改</a> 
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-remove" plain="true" onclick="delEssayTypeInfo()">删除</a>
	</div>
	
	<div id="dlg" class="easyui-dialog"
		style="width:400px;height:300px;padding:20px 30px" closed="true"
		maximizable="true" resizable="true"
		left="150" top="0"
		buttons="#dlg-buttons">
			<form id="ff" method="post">
				<table cellpadding="5">
					<tr>
						<td></td>
						<td>
							<input type="hidden" name="id" />
							<input type="hidden" name="meetingId" />
							<input type="hidden" name="parentMenu" />
						</td>
					</tr>
					<tr>
						<td>文章类型名称:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="typeName"
							data-options="required:true,missingMessage:'一级分类名称不能为空！'"></input>
						</td>
					</tr>
					<tr>
						<td>英文文章类型名称:</td>
						<td>
							<input class="easyui-validatebox" type="text" name="typeNameEn"
							data-options="required:true,missingMessage:'英文一级分类名称不能为空！'"/>
						</td>
					</tr>
					<tr>
						<td>显示顺序:</td>
						<td>
							<input class="easyui-numberbox" type="text" name="showOrder"
							data-options="required:true,missingMessage:'显示顺序不能为空！'"/>
						</td>
					</tr>
				</table>
			</form>
		
		    <div id="dlg-buttons">
					<a href="javascript:void(0)" id="add" class="easyui-linkbutton" onclick="add()" style="padding:5px;" iconCls="icon-ok">保存</a>
					<a href="javascript:void(0)" id="edit" class="easyui-linkbutton" iconCls="icon-ok" 
						onclick="edit()" style="padding:5px;">修改</a>
					<a id="closehref" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel"  onclick="javascript:$('#dlg').dialog('close')">取消</a>
			</div>
 	</div>
	<script type="text/javascript">
		function addEssayTypeInfo() {
			$('#ff').form('reset');
			$('#typeName').val('');
			$('#dlg').dialog('open').dialog('setTitle', '添加文章分类');
		    $('#add').css('display','inline');
		    $('#edit').css('display','none');
		}
		
		function add() {
			$('#ff').form('submit', {
				url:'<%=basePath%>essay_type/c',
				method:'POST',
				success:function(data){
						$.messager.alert('提示',data);
						$('#dlg').dialog('close');
						loadGrid();
					}
				});
		}
		
		function delEssayTypeInfo(){
			var ids = "";
			var rows = $('#dg').datagrid('getSelections');
			var num=rows.length;//获取要删除信息的个数
			if(num > 0){
				for(var i=0; i<rows.length; i++){//组成一个字符串，ID主键之间用逗号隔开
					if(i!=rows.length-1){
						ids=ids+rows[i].id+",";
				     }else{
				    	 ids=ids+rows[i].id;
				     } 
					} 
					$.messager.confirm("提示", "是否删除选中的"+num+"条数据?", function (r) {
					if(r){
						 $.ajax({  
					          type:"GET",  
					          url:'<%=basePath%>essay_type/d',  
					          data: {id:ids},  
					          success:function(msg){
					          	 $.messager.alert("提示",msg);  
					             loadGrid();
					          }  
					       });
					}
					});
			}else{
				$.messager.alert('错误','请选中要删除的信息分类！');
			}
			
		}
		
		function editEssayTypeInfo(){
			$('#add').css('display','none');
			$('#edit').css('display','inline');
			var row = $('#dg').datagrid('getSelections');
			var num  = row.length;
			if(num > 1 || num == 0){
				$.messager.alert('提示',"请选中一条记录进行修改");
				return;
			}
			
			$('#dlg').dialog('open').dialog('setTitle', '修改');
			$('#ff').form('load', row[0]);
		}
		
		function edit() {
			$('#ff').form('submit', {
				url:'<%=basePath%>essay_type/u',
				method:'POST',
				success:function(data){
						$.messager.alert('提示',data);
						$('#dlg').dialog('close');
						loadGrid();
					}
				});
		}
		
	</script>
  </body>
</html>
