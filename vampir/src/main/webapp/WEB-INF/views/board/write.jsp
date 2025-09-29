<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" /> 
<%
  request.setCharacterEncoding("UTF-8");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>

<!-- TinyMCE -->
<script src="https://cdn.tiny.cloud/1/r2t7fl9os6sksmww8gr8qwlu772dk2b368fb3ohilgu8y0vt/tinymce/7/tinymce.min.js" referrerpolicy="origin"></script>

<script>
$(document).ready(function() {
    // ✅ 에디터 초기화: textarea[name=content]만 에디터로 변환
    tinymce.init({
        selector: 'textarea[name=content]',
        height: 400,
        menubar: false,
        plugins: 'image link lists code',
        toolbar: 'undo redo | styles | bold italic underline forecolor | alignleft aligncenter alignright | bullist numlist | link image | code',
        content_style: `
            body {
                background-color:#1c1c1c; 
                color:#f5f5f5; 
                font-family: Arial, sans-serif; 
                padding: 10px; 
                line-height:1.6;
            }
            img { max-width: 100%; border-radius: 8px; }
        `,
        images_upload_url: '${contextPath}/board/imageUpload.do',
        automatic_uploads: true,
        file_picker_types: 'image',
        images_upload_handler: function(blobInfo, success, failure) {
            var xhr = new XMLHttpRequest();
            xhr.open('POST', '${contextPath}/board/imageUpload.do');
            xhr.onload = function() {
                if(xhr.status !== 200){ failure('HTTP Error: '+xhr.status); return; }
                var json = JSON.parse(xhr.responseText);
                if(!json || typeof json.location !== 'string'){ failure('Invalid JSON: '+xhr.responseText); return; }
                success(json.location);
            };
            var formData = new FormData();
            formData.append('file', blobInfo.blob(), blobInfo.filename());
            xhr.send(formData);
        },
        setup: function(editor){
            editor.on('NodeChange', function(e){
                if(e && e.element && e.element.nodeName === 'IMG'){
                    e.element.style.maxWidth = '600px';
                    e.element.style.height = 'auto';
                }
            });
        }
    });
});

// ✅ 추가 파일 업로드 함수
var cnt = 1;
function fn_addFile(){
    $("#d_file").append(
        "<input type='file' name='file"+cnt+"' style='margin-top:8px; display:block;'/>"
    );
    cnt++;
}

// ✅ 목록으로 돌아가기
function backToList(form){
    form.action="${contextPath}/board/list.do";
    form.submit();
}
</script>

<style>
body {
    background-color: #1c1c1c;
    color: #f5f5f5;
    font-family: Arial, sans-serif;
    margin: 0;
    padding: 0;
}
h1 {
    text-align: center;
    color: #e03b3b;
    margin: 30px 0;
}
form {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
    background-color: #222;
    border-radius: 8px;
    box-shadow: 0 0 10px #000;
}
.form-group {
    margin-bottom: 20px;
}
.form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: bold;
    color: #e03b3b;
}
.form-input {
    width: 100%;
    padding: 8px;
    border-radius: 4px;
    border: 1px solid #444;
    background-color: #333;
    color: #f5f5f5;
}
.btn {
    padding: 10px 20px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    margin-right: 10px;
}
.btn-submit {
    background-color: #bb2222;
    color: #f5f5f5;
}
.btn-cancel {
    background-color: #555;
    color: #f5f5f5;
}
</style>
</head>
<body>
<h1>글쓰기</h1>

<form name="articleForm" method="post" action="${contextPath}/board/addNewArticle.do" enctype="multipart/form-data">
    <!-- 작성자 -->
    <div class="form-group">
        <label class="form-label" for="author">작성자</label>
        <input type="text" id="author" class="form-input" value="${member.name}" readonly />
    </div>

    <!-- 제목 -->
    <div class="form-group">
        <label class="form-label" for="title">글제목</label>
        <input type="text" id="title" name="title" class="form-input" maxlength="500" />
    </div>

    <!-- 본문 (TinyMCE) -->
    <div class="form-group">
        <label class="form-label" for="content">글내용</label>
        <textarea id="content" name="content" maxlength="4000"></textarea>
    </div>

    <!-- 추가 파일 업로드 -->
    <div class="form-group">
        <label class="form-label">추가 파일</label>
        <input type="button" class="btn btn-cancel" value="파일 추가" onClick="fn_addFile()" />
        <div id="d_file"></div>
    </div>

    <!-- 버튼 영역 -->
    <div style="text-align:center;">
        <input type="submit" class="btn btn-submit" value="글쓰기" />
        <input type="button" class="btn btn-cancel" value="목록보기" onClick="backToList(this.form)" />
    </div>
</form>
</body>
</html>
