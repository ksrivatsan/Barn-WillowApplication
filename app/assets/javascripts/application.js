// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
function add_to_cart(element){
	type = element.getAttribute("data-type");
	color = element.getAttribute("data-color");

	result = localStorage.getItem(type + " "+ color);
	if(result)
		localStorage.setItem(type + " "+ color, Number(result)+1);
	else
		localStorage.setItem(type + " " + color, 1)
	console.log(localStorage)
	document.getElementsByClassName(color +"_" + type.split(" ").join("_"))[0].checked = true;
	document.getElementsByClassName(color +"_" + type.split(" ").join("_"))[0].selected = true;

}

function remove_from_cart(element){
	type = element.getAttribute("data-type");
	color = element.getAttribute("data-color");

	result = localStorage.getItem(type + " "+ color);
	if(result < 2)
		localStorage.removeItem(type + " " + color)
	else
		localStorage.setItem(type + " "+ color, Number(result)-1);
	console.log(localStorage)
	document.getElementsByClassName(color +"_" + type.split(" ").join("_"))[0].checked = false;
	document.getElementsByClassName(color +"_" + type.split(" ").join("_"))[0].selected = false;
}

function hide_add_button(element){
	element.style = "display:none";
	color = element.getAttribute("data-color");
	type = element.getAttribute("data-type");
	to_be_hidden = "REMOVE_"+color+"_"+type.split(" ").join("_");
	el = document.getElementById(to_be_hidden);
	el.style = "display:visible";
}

function hide_remove_button(element){
	element.style = "display:none;";
	color = element.getAttribute("data-color");
	type = element.getAttribute("data-type");
	to_be_hidden = "ADD_"+color+"_"+type.split(" ").join("_");
	el = document.getElementById(to_be_hidden);
	el.style = "display:visible;background-color:#7FFFD4";
}

function change_image(element, event){
	new_image = element.src;
	type = element.getAttribute("data-type").split(" ").join("_");
	color = element.getAttribute("data-color");
	el = document.getElementsByClassName(type+"_"+color);
	el[0].src = new_image;
	event.preventDefault();

}

// function checkout(e){
// 	cart_is_empty(e);
// }

function checkout(e){
	var checkboxes = document.querySelectorAll('input[type="checkbox"]');
	var checkedOne = Array.prototype.slice.call(checkboxes).some(x => x.checked);
	console.log(checkedOne);
	if (checkedOne == false){
		alert("Please add something to the cart");
		e.preventDefault();
	} else {
		document.forms["checkout_form"].submit();
	}
}

$(document).ready(function () {
	
});