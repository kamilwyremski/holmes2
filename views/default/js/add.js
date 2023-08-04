$(function(){

	CKEDITOR.replace("description",{height: "300px"});

	$("#preview_photos").sortable({
		containerSelector : "#preview_photos",
		itemSelector : ".img-thumbnail",
		handle: "img",
		placeholder	: "<div class='placeholder'></div>"
	});

	$("#form_add_classified").submit(function(){
		const $last = $("select[name=category_id]:enabled").last();
		if($last.val() == ""){
			$last.attr("disabled", true);
		}
	})

	$("#input_select_photo").change(function (){
		const $this = $(this);
		const number_photos = $this[0].files.length;
		let flag = true;
		let photo_count = $("#preview_photos .img-thumbnail").length;
		let progress_bar_value = 0;
		if(number_photos && (!photo_max || photo_max>photo_count)){
			$("#photos_progress").show();
			$("#preview_load").css("display", "inline-block");
			const $progress_bar = $("#photos_progress").find(".progress-bar");
			$("#photos_info").hide().html("");
			$("#box_add_classified input[type=submit]").prop("disabled", true);
			$.each($this[0].files, function(index, value){
				if(flag){
					const data_photo = new FormData();
					data_photo.append("action", "add_photo");
					data_photo.append("count_photo", photo_count);
					data_photo.append("file", $this[0].files[index]);
					$.ajax({
						url: "",
						type: "POST",
						data: data_photo,
						dataType :"json",
						contentType: false,
						cache: false,
						processData:false,
						success: function(data){
							if(data){
								if(data.status){
									$("#preview_photos").append('<div class="img-thumbnail"><img src="upload/photos/'+data['thumb']+'" alt="'+data['url']+'"><br><button class="btn btn-link remove_photo text-danger" title="'+data['remove_title']+'">'+data['Delete']+'</button><input type="hidden" name="photos[]" value="'+data['id']+'"></div>');
								}else{
									$("#photos_info").show().html(data.info);
								}
							}
							if(index === (number_photos-1)){
								$("#preview_load, #photos_progress").hide();
								$("#box_add_classified input[type=submit]").prop("disabled", false);
								$progress_bar.css("width", "0%").attr("aria-valuenow", "0").text("0%");
							}else{
								progress_bar_value += Math.round(100/number_photos);
								$progress_bar.css("width", progress_bar_value+"%").attr("aria-valuenow", progress_bar_value).text(progress_bar_value+"%");
							}
						},
						error: function () {
							$("#preview_load, #photos_progress").hide();
							$("#box_add_classified input[type=submit]").prop("disabled", false);
							flag = false;
							$progress_bar.css("width", "0%").attr("aria-valuenow", "0").text("0%");
						}
					});
				}
				photo_count++;
			});
		}else{
			$("#photos_info").show().html(lang["Photo limit exceeded"]);
		}
		$this.val("");
	})

	$("#button_get_coordinates").click(function(){
		const $form = $('#form_add_classified');
		let address = $form.find("input[name=address]").val();
		if($form.find("[name=state_id]").length && $form.find("[name=state_id]").val()!=""){
			address += " "+$form.find("[name=state_id] option:selected").text();
		}
		if($form.find("[name=state2_id]:enabled").length && $form.find("[name=state2_id]:enabled").val()!=""){
			address += " "+$form.find("[name=state2_id]:enabled option:selected").text();
		}
		if(address){
			$.ajax({
				url: "",
				type: "POST",
				data:{"action" : "get_coordinates","address" : address},
				dataType :"json",
				success: function(data) {
					if(data.lat && data.long){
						var latlng = new google.maps.LatLng(data.lat, data.long);
						google_maps_marker.setPosition(latlng);
						google_maps.setCenter(latlng);
						$form.find("input[name=address_lat]").val(data.lat);
						$form.find("input[name=address_long]").val(data.long);
					}
				}
			});
		}
		$(this).blur();
    return false;
  });
});

angular.module("addClassified", []).controller("addClassified", function($scope,$http,$q) {
	$scope.select_category_id = 0;
	$scope.list_categories = [];
	$scope.list_options = [];
	$scope.waiting_for_response = false;
	$scope.inputPrice = inputPrice;
	$scope.loadCategories = function(select_category_id=0,category_id=0,load_options=1){
		$scope.waiting_for_response = true;
		$scope.select_category_id = select_category_id;
		for(let i = 0; i < $scope.list_categories.length; i++) {
			if($scope.list_categories[i].category_id == select_category_id) {
				$scope.list_categories.splice((i+1), $scope.list_categories.length);break;
			}
		}
		$http.pendingRequests.forEach(function(request) {
			if(request.cancel){request.cancel.resolve();}
		});
		const cancel = $q.defer();
		const request = {
			method: "POST",
			url: location.href,
			data: $.param({"action":"get_categories_and_options", "category_id":category_id, "load_options":load_options}),
			headers: {"Content-Type": "application/x-www-form-urlencoded"},
			timeout: cancel.promise,
			cancel: cancel
		}
		$http(request).then(function(response) {
			if(!$.isEmptyObject(response.data.options)){
				$.each(response.data.options, function(index, value) {
					const id = value.id;
					if(list_options[id] != undefined){
						if(response.data.options[index].kind=="number"){
							response.data.options[index].value = parseInt(list_options[id][0]);
						}else if(response.data.options[index].kind=="checkbox"){
							response.data.options[index].value = list_options[id];
						}else{
							response.data.options[index].value = list_options[id][0];
						}
					}else if($scope.list_options[index] != undefined){
						response.data.options[index].value = $scope.list_options[id].value;
					}else{
						response.data.options[index].value = "";
					}
				});
				$scope.list_options = response.data.options;
			}else{
				$scope.list_options = [];
			}
			if(!$.isEmptyObject(response.data.categories) && (category_id>0 || $scope.list_categories.length==0)){
				selectCategory = "";
				if(list_categories.length){
					selectCategory = list_categories.shift();
				}
				required = (category_id) ? required_subcategory : required_category;
				$scope.list_categories.push({"category_id":category_id,"categories":response.data.categories,"selectCategory":selectCategory, "required":required});
				if(selectCategory){
					load_options = (list_categories.length) ? 0 : 1;
					$scope.loadCategories(category_id,selectCategory,load_options);
				}
			}
			$scope.waiting_for_response = false;
		});
  };
	load_options = (list_categories.length) ? 0 : 1;
	$scope.loadCategories(0,0,load_options);
});

$(document).on("click", ".remove_photo", function(){
	$(this).parents(".img-thumbnail").remove();
	$("#photos_info").html("");
	return false;
})
