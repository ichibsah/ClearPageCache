<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="expires" content="-1" />
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="copyright" content="2013, Web Site Management" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" >
	<title>Assign It</title>
	<link rel="stylesheet" href="css/bootstrap.min.css" />
	<style type="text/css">
		body
		{
			padding: 10px;
		}
	</style>
	<script type="text/javascript" src="js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="rqlconnector/Rqlconnector.js"></script>
	<script type="text/javascript">
		var _PageGuid = '<%= session("pageguid") %>';
		var ProjectGuid = '<%= session("projectguid") %>';
		var CurrentUserGuid = '<%= session("userguid") %>';
		var LoginGuid = '<%= session("loginguid") %>';
		var SessionKey = '<%= session("sessionkey") %>';
		var RqlConnectorObj = new RqlConnector(LoginGuid, SessionKey);
	
		$(document).ready(function() {
			InitPageGuid();
			
			LoadSimplePageInfo(_PageGuid);
		});
		
		function InitPageGuid()
		{
			var objClipBoard = window.opener.document;
			var SmartEditURL;
			if($(objClipBoard).find('iframe[name=Preview]').length > 0)
			{
				SmartEditURL = $(objClipBoard).find('iframe[name=Preview]').contents().get(0).location;
			}
			
			var EditPageGuid = GetUrlVars(SmartEditURL)['EditPageGUID'];
			var ParamPageGuid = GetUrlVars()['pageguid'];
			
			if(EditPageGuid != null)
			{
				_PageGuid = EditPageGuid;
			}
			else if (ParamPageGuid != null)
			{
				_PageGuid = ParamPageGuid;
			}
		}
		
		function GetUrlVars(SourceUrl)
		{
			if(SourceUrl == undefined)
			{
				SourceUrl = window.location.href;
			}
			SourceUrl = new String(SourceUrl);
			var vars = [], hash;
			var hashes = SourceUrl.slice(SourceUrl.indexOf('?') + 1).split('&');
			for(var i = 0; i < hashes.length; i++)
			{
				hash = hashes[i].split('=');
				vars.push(hash[0]);
				vars[hash[0]] = hash[1];
			}
	
			return vars;
		}

		function LoadSimplePageInfo(PageGuid)
		{
			var strRQLXML = '<PAGE action="load" guid="' + PageGuid + '"/>';
			RqlConnectorObj.SendRql(strRQLXML, false, function(data){
				$('#page-headline').val($(data).find('PAGE').attr('headline'));
				
				$('#page-id').val($(data).find('PAGE').attr('id'));
				
				$('#page-guid').val($(data).find('PAGE').attr('guid'));
				
				ClearPageCache(PageGuid);
			});
		}
		
		function ClearPageCache(PageGuid)
		{
			var strRQLXML = '<PAGEBUILDER><PAGES action="pagevaluesetdirty"><PAGE guid="' + PageGuid + '"/></PAGES></PAGEBUILDER>';
			RqlConnectorObj.SendRql(strRQLXML, false, function(data){
				window.opener = '';
				self.close();
			});
		}
	</script>
</head>
<body>
	<div class="alert alert-warning">
		<h4>Clearing Page Cache</h4>
	</div>
	<div class="form-horizontal well">
		<div class="control-group">
			<label class="control-label" for="from-email">Page Headline:</label>
			<div class="controls">
				<input type="text" id="page-headline" readonly="readonly"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="to-email">Page Id:</label>
			<div class="controls">
				<input type="text" id="page-id" readonly="readonly"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label" for="subject-email">Page Guid:</label>
			<div class="controls">
				<input type="text" id="page-guid" readonly="readonly"/>
			</div>
		</div>
	</div>
</body>
</html>