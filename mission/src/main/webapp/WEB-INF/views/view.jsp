<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mission-view</title>
</head>
<body>
<header><h2>Grid그리드</h2></header>
<section style="border:2px solid black;">
	<div>
		<input type = "text" style="width:200px; height:35px; margin:10px 30px" id="id" name="id" placeholder="id">
		<input type = "text" style="width:200px; height:35px; margin:10px 60px" id="name" name="name" placeholder="name">
		<input type = "hidden" id="gender" name="gender">
		<input type = "radio" id="gender" name="gender" value="male"><label for="male">남</label>
		<input type = "radio" id="gender" name="gender" value="female"><label for="female">여</label>  
	</div>
	<div>
		<select id="country" style="width:210px; height:40px; margin:10px 30px;" onchange="categoryChange(this)" >
			<option>나라</option>
			<option value="대한민국">대한민국</option>
			<option value="미국">미국</option>
			<option value="일본">일본</option>
		</select>

		<select id="city" style="width:210px; height:40px; margin:10px 60px;"id="city">
			<option>도시</option>
		</select>
		
		<input style="width:210px; height:40px; margin:10px 30px;" type=date id=start>
		&nbsp;~&nbsp;
		<input style="width:210px; height:40px; margin:10px 30px;" type=date id=end>
	</div>
	
</section> 
<section style="border:2px solid black; height: 600px;">
	<div align="right" style="margin-right:100px; margin-top:20px; margin-bottom:20px;">
		<input type="button" id="select" name="select" value="조회">&nbsp;&nbsp;
		<input type="button" id="add" name="add" value="저장">&nbsp;&nbsp;
		<input type="button" id="download" name="download" value="엑셀다운" onclick='document.location="/excels?id="+$("#id").val()+"&name="+$("#name").val()+"&gender="+$("#gender:checked").val()+"&country="+$("#country").val()+"&city="+$("#city").val()+"&start="+$("#start").val()+"&end="+$("#end").val();'  >&nbsp;&nbsp;
		<!--값 2개 이상 보낼때에는 document.location="/경로?보낼변수명=" + 값 + "&보낼변수명2=" + 값 ..... ; -->
		<input type="button" id="resetbtn" name="resetbtn" value="삭제">  
	</div>
	<table align=center  id="table" style="border:2px solid black; width:900px; ">
		<colgroup>

			<col style="width:5%;" />

			<col style="width:15%;" />

			<col style="width:15%;" />
			
			<col style="width:15%;" />

			<col style="width:25%;" />

			<col style="width:25%;" />

		</colgroup>
		<thead>
			<tr>
				<th style='text-align:left'>선택</th>
				<th style='text-align:left'>아이디</th>
				<th style='text-align:left'>이름</th>
				<th style='text-align:left'>성별</th>
				<th style='text-align:left'>나라</th>
				<th style='text-align:left'>도시</th>
			</tr>
		</thead>
		<tbody id="list">
		</tbody>
	</table>
	
</section>
</body>
<script>
function categoryChange(e) {
	var good_a = ["서울", "인천", "부산", "광주"];
	var good_b = ["뉴욕", "LA", "캘리포니아", "맨해튼"];
	var good_c = ["도쿄", "오사카", "오키나와", "후쿠오카"];
	var target = document.getElementById("city");
	if(e.value == "대한민국") var d = good_a;
	else if(e.value == "미국") var d = good_b;
	else if(e.value == "일본") var d = good_c;
	target.options.length = 0;
	for (x in d) {
		var opt = document.createElement("option");
		opt.value = d[x];
		opt.innerHTML = d[x];
		target.appendChild(opt);
	}	
}
</script>
<script src='http://code.jquery.com/jquery-3.4.1.js'></script>
<script>
$(document)
.ready(function(){
	$.post('http://localhost:8083/loadlist',{},function(rcv){
		<!--아작스 호출 코드 => $.post( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
		<!--get방식 => $.get( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
			console.log(rcv);
			for(i=0; i<rcv.length; i++){
				let str="<tr><td><input type='checkbox' class='chkbox' name='check'></td><td>"+rcv[i]['id']+'</td><td>'+rcv[i]['name']+'</td><td>'+rcv[i]['gender']+'</td><td>'+rcv[i]['country']+'</td><td>'+rcv[i]['city']+'</td></tr>';
				$('#list').append(str);
			}
	},'json');
})
.on('click', '#add', function(){
	if($('input:checkbox[name="check"]').is(":checked") ==  false){ //insert
		//if 절에 input[name=check]:not(:checked)이거 들어가도 원래 됐었는데 이제 안됨 ㅠ
		//$('input:checkbox[name="check"]').is(":checked") ==  false
		$.post('http://localhost:8083/addlist',
				{id:$('#id').val(),name:$('#name').val(),gender:$('#gender:checked').val(), country:$('#country').val(), city:$('#city').val()},
					function(){
					//console.log('id: '+$('#id').val());
						getlist();
			},'text');
	}
	else{ //update
		$.post('http://localhost:8083/updatelist',
				{id:$('#id').val(),name:$('#name').val(),gender:$('#gender:checked').val(), country:$('#country').val(), city:$('#city').val()},
					function(){
						console.log('id: '+$('#id').val());
						getselectlist();
			},'text');
	}
})
.on('click', '#resetbtn', function(){
	//if($('#id').val()==''){
		//alert('삭제할 메뉴를 선택하십시오');
		//return false;
	//}
	//if(confirm('정말 삭제하시겠습니까?')==false) return false;
	if(!confirm('정말 삭제하시겠습니까?')) return false;
	
	var rowData = new Array();
	var tdArr = new Array();
	var checkbox = $("input[name=check]:checked");
	// 체크된 체크박스 값을 가져온다
	checkbox.each(function(i) {
		// checkbox.parent() : checkbox의 부모는 <td>이다.
		// checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
	var tr = checkbox.parent().parent().eq(i);
	var td = tr.children();
		
		// 체크된 row의 모든 값을 배열에 담는다.
	rowData.push(tr.text());
		
		// td.eq(0)은 체크박스 이므로  td.eq(1)의 값부터 가져온다.
	var id = td.eq(1).text();
		
		// 가져온 값을 배열에 담는다.
	tdArr.push(id);
		
	console.log("id : " + id);
	console.log("tdArr : " + tdArr);
	console.log("tdArr : " + tdArr.length);
	for(x in tdArr){
			$.post('http://localhost:8083/deletelist',{id:tdArr[x]},function(rcv){
				getselectlist();
			},'text');
		}
	})
	
})
.on('click','#select',function(){
	//if(!$("#id").val()==''){
		$('#list').empty();
		$.post('http://localhost:8083/selectlist',{id:$('#id').val(), name:$('#name').val(), gender:$('#gender:checked').val(), country:$('#country').val(), city:$('#city').val(), start:$('#start').val(), end:$('#end').val()},function(rcv){
			<!--아작스 호출 코드 => $.post( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
			<!--get방식 => $.get( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
				console.log(rcv);
				console.log($('#id').val());
				console.log($('#name').val());
				console.log($('#gender').val());
				console.log($('#country').val());
				console.log($('#city').val());
				console.log($('#start').val());
				console.log($('#end').val());
				for(i=0; i<rcv.length; i++){
					let str="<tr><td><input type='checkbox' class='chkbox' name='check'></td><td>"+rcv[i]['id']+'</td><td>'+rcv[i]['name']+'</td><td>'+rcv[i]['gender']+'</td><td>'+rcv[i]['country']+'</td><td>'+rcv[i]['city']+'</td></tr>';
					$('#list').append(str);
				}
		},'json');
	//}
	/* else{
		var rowData = new Array();
		var tdArr = new Array();
		var checkbox = $("input[name=check]:checked");
		
		// 체크된 체크박스 값을 가져온다
		checkbox.each(function(i) {
			// checkbox.parent() : checkbox의 부모는 <td>이다.
			// checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
		var tr = checkbox.parent().parent().eq(i);
		var td = tr.children();
			
			// 체크된 row의 모든 값을 배열에 담는다.
		rowData.push(tr.text());
			
			// td.eq(0)은 체크박스 이므로  td.eq(1)의 값부터 가져온다.
		var id = td.eq(1).text();
		var name = td.eq(2).text();
		var gender = td.eq(3).text();
		var country = td.eq(4).text();
		var city = td.eq(5).text();
			
			// 가져온 값을 배열에 담는다.
		tdArr.push(id);
		tdArr.push(name);
		tdArr.push(gender);
		tdArr.push(country);
		tdArr.push(city);
			
		console.log("id : " + id);
		console.log("name : " + name);
		console.log("gender : " + gender);
		console.log("country : " + country);
		console.log("city : " + city);
		
		//배열의 값을 하나씩 자리에 넣어준다.
		$('#id').val(tdArr[0]);
		$('#name').val(tdArr[1]);
		//gender의 value값 대로 체크표시가 되지 않음 ㅜㅜㅜㅜ
		$("input[name='gender'][value='tdArr[2]']").prop("checked", true);
		//$('#gender').val(tdArr[2]).prop('checked', true);
		$('#country').val(tdArr[3]);
		$('#country').val(tdArr[3]).each(function(i){
			var good_a = ["서울", "인천", "부산", "광주"];
			var good_b = ["뉴욕", "LA", "캘리포니아", "맨해튼"];
			var good_c = ["도쿄", "오사카", "오키나와", "후쿠오카"];
			var target = document.getElementById("city");
			if(i.value == "대한민국") var d = good_a;
			else if(i.value == "미국") var d = good_b;
			else if(i.value == "일본") var d = good_c;
			target.options.length = 0;
			
			for(x in d){
				if(d[x]==tdArr[4]){
					var tr = d[x];
					console.log("d[x] : "+d[x]);
					var opt = document.createElement("option");
					opt.value = d[tr];
					opt.innerHTML = d[tr];
					target.appendChild(opt);
				}
			}
			//ncaught TypeError: Cannot read properties of undefined (reading 'indexOf')왜날까..
			
	})
	
			
				
	})
		//나라는 데이터대로 표시가 되는데 도시는 안됨 ㅜㅜ
	$('#city').val(tdArr[4]);
	
	} */
	
})
function getlist(){
	$.post('http://localhost:8083/loadlist',{},function(rcv){
			$('#list').empty();
			for(i=0; i<rcv.length; i++){
				let str="<tr><td><input type='checkbox' class='chkbox' name='check'></td><td>"+rcv[i]['id']+'</td>'+'<td>'+rcv[i]['name']+'</td>'+'<td>'+rcv[i]['gender']+'</td>'+'<td>'+rcv[i]['country']+'</td>'+'<td>'+rcv[i]['city']+'</td></tr>';
				$('#list').append(str);
			}
			$('#id,#name,#start,#end,#city').val('');
			$('#country').val('나라');
			$("input:radio[name='gender']").prop('checked', false);
		},'json');
}
function getselectlist(){
	$('#list').empty();
	$.post('http://localhost:8083/selectlist',{id:$('#id').val(),name:$('#name').val(), gender:$('#gender:checked').val(), country:$('#country').val(), city:$('#city').val(), start:$('#start').val(), end:$('#end').val()},function(rcv){
		<!--아작스 호출 코드 => $.post( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
		<!--get방식 => $.get( url(RequestMapping, 서버에 보내는 입력, function(서버로부터 받은 출력), 'json or text or xml'(수신데이터포맷)    -->
			console.log(rcv);
			for(i=0; i<rcv.length; i++){
				let str="<tr><td><input type='checkbox' class='chkbox' name='check'></td><td>"+rcv[i]['id']+'</td><td>'+rcv[i]['name']+'</td><td>'+rcv[i]['gender']+'</td><td>'+rcv[i]['country']+'</td><td>'+rcv[i]['city']+'</td></tr>';
				$('#list').append(str);
			}
			/*  $('#id,#name,#start,#end,#city').val('');
			$('#country').val('나라');
			$("input:radio[name='gender']").prop('checked', false);*/
	},'json');
}
</script>

</html>