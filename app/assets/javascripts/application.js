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

function remove_from_cart_on_checkout(element){
	type = element.getAttribute("data-type");
	color = element.getAttribute("data-color");
	document.getElementsByClassName("remove_div_for_"+color +"_" + type.split(" ").join("_"))[0].style = "display:none;";
	remove_from_order_details = document.getElementsByClassName("remove_div_for_"+color +"_" + type.split(" ").join("_"))[0].getAttribute("data-id");
	el = document.getElementsByClassName("order_details")[0];
	array = JSON.parse(el.value);
	array.remove(parseInt(remove_from_order_details));
	el = document.getElementsByClassName("order_details")[0].setAttribute("value", "[" + array.toString() + "]");
	if(array.length < 1){
		alert("Cart is empty. Please add something to the cart!");
		document.getElementById("continue_shopping").style = "display:visible;background-color:aqua;";
		document.getElementById("order_info").style="display:none";
	}
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

if (!Array.prototype.remove) {
  Array.prototype.remove = function(vals, all) {
    var i, removedItems = [];
    if (!Array.isArray(vals)) vals = [vals];
    for (var j=0;j<vals.length; j++) {
      if (all) {
        for(i = this.length; i--;){
          if (this[i] === vals[j]) removedItems.push(this.splice(i, 1));
        }
      }
      else {
        i = this.indexOf(vals[j]);
        if(i>-1) removedItems.push(this.splice(i, 1));
      }
    }
    return removedItems;
  };
}

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

function check_if_cart_is_empty(e){
	el = document.getElementsByClassName("order_details")[0];
	if(JSON.parse(el.value).length < 1){
		alert("Cart can't be empty!");
		e.preventDefault();
	}
}

$(document).ready(function () {
	
});