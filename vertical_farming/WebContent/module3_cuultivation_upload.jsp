<!DOCTYPE html>
<html>
<head>
<title>File Upload Widget</title>
<link href="adminuploadencripted/css/bootstrap.css" rel='stylesheet'
	type='text/css' />
<link href="adminuploadencripted/css/style.css" rel="stylesheet"
	type="text/css" media="all" />
<script src="adminuploadencripted/js/jquery.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords"
	content="File Upload Widget Responsive web template, Bootstrap Web Templates" />
<script type="application/x-javascript"> 
        addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false); 
        function hideURLbar(){ window.scrollTo(0,1); } 
    </script>
<style>
body {
	background-image: url('veg.jpg');
	background-size: cover;
	background-position: center;
}
</style>
</head>
<body>

	<h1 style="color: white;">FILE UPLOAD</h1>

	<div class="upload">
		<h3>Select File</h3>
		<div class="login-form">
			<form>
				<div>
					<span>Title</span> <input type="text" class="title"
						value="Eg: Beach Fun" onfocus="this.value = '';"
						onblur="if (this.value == '') {this.value = 'Eg: Beach Fun';}" />
				</div>
				<div>
					<span>Description</span> <input type="text" class="describe"
						value="Eg: The one in the Bahamas" onfocus="this.value = '';"
						onblur="if (this.value == '') {this.value = 'Eg: The one in the Bahamas';}" />
				</div>
			</form>

			<form action="cultivationupload" method="post" enctype="multipart/form-data">
				<input type="file" name="file" /> <input type="submit"
					value="Upload" />
			</form>

			<ul>
				<!-- The file uploads will be shown here -->
			</ul>

			<!-- Cancel Button -->
			<button type="button" onclick="cancelUpload()">Cancel</button>
		</div>

		<!-- JavaScript Includes -->
		<script src="adminuploadencripted/js/jquery.knob.js"></script>
		<script src="adminuploadencripted/js/jquery.ui.widget.js"></script>
		<script src="adminuploadencripted/js/jquery.iframe-transport.js"></script>
		<script src="adminuploadencripted/js/jquery.fileupload.js"></script>
		<script src="adminuploadencripted/js/script.js"></script>

		<!-- Cancel Button Script -->
		<script>
        function cancelUpload() {
            window.location.href = 'module3_cultivation_homepage.html';
        }
    </script>

	</div>

	<div class="footer">
		<br>
	</div>

</body>
</html>
