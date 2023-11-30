
var openedUIType, selectedCategory, selectedStoreTransactionType, selectedItem, selectedItemCost, selectedItemCurrencyType  = null;

var selectedItemId = 0;

var pressedToBuyCooldown = false;

function closeNUI() {

	$("#categories").html('');
	$("#types").html('');
	$("#products").html('');
	$("#objects").html('');

	openedUIType = null;
	selectedCategory = null;
	selectedStoreTransactionType = null;

	selectedItemId = 0;

	selectedItem = null;
	selectedItemCost = null;
	selectedItemCurrencyType = null;

	pressedToBuyCooldown = false;

	displayPage("categories_menu", "visible");
	displayPage("buttons", "hidden");
	displayPage("type_categories_menu", "hidden");
	displayPage("category_products", "hidden");
	displayPage("object_dialog", "hidden");

	document.getElementById("products_item_amount_input").value = 1;

	document.getElementById("object_dialog_model_title").innerHTML = "";
	document.getElementById("products_selected_item_display").style.color = "rgba(255, 0, 0, 0.7)";
	document.getElementById("products_selected_item_display").innerHTML = Locales.NotSelected;

	document.getElementById("enable_shop").style.display="none";

    $.post("http://tpz_stores/closeNUI", JSON.stringify({}));
}

function playAudio(sound) {
	var audio = new Audio('./audio/' + sound);
	audio.volume = Config.DefaultClickSoundVolume;
	audio.play();
}

const loadScript = (FILE_URL, async = true, type = "text/javascript") => {
	return new Promise((resolve, reject) => {
		try {
			const scriptEle = document.createElement("script");
			scriptEle.type = type;
			scriptEle.async = async;
			scriptEle.src =FILE_URL;
  
			scriptEle.addEventListener("load", (ev) => {
				resolve({ status: true });
			});
  
			scriptEle.addEventListener("error", (ev) => {
				reject({
					status: false,
					message: `Failed to load the script ${FILE_URL}`
				});
			});
  
			document.body.appendChild(scriptEle);
		} catch (error) {
			reject(error);
		}
	});
  };
  
  loadScript("js/locales/locales-" + Config.Locale + ".js").then( data  => { 

	displayPage("categories_menu", "visible");
	displayPage("buttons", "hidden");
	displayPage("type_categories_menu", "hidden");
	displayPage("object_dialog", "hidden");
	displayPage("category_products", "hidden");

	
	document.getElementById("products_selected_item_display").style.color = "rgba(255, 0, 0, 0.7)";
	document.getElementById("products_selected_item_display").innerHTML = Locales.NotSelected;
	document.getElementById("object_dialog_display_button").innerHTML = Locales.Display;
	document.getElementById("shop_back_button").innerHTML = Locales.Back;
	
  }) .catch( err => { console.error(err); });

$(function() {
	window.addEventListener('message', function(event) {
		var item = event.data;

		if (item.type == "enable_shop") {
			document.body.style.display = item.enable ? "block" : "none";

			document.getElementById("enable_shop").style.display="block";
		}

		else if (item.action == 'updateStoreHeaderTitle'){

			document.getElementById("shop_opened_title_display").innerHTML = event.data.header;
			document.getElementById("shop_opened_title_footer").innerHTML = event.data.footer;
		}

		else if (item.action == 'updatePlayerAccountInformation'){
			var prod_account = event.data.accounts;

			document.getElementById("player_account_information_text").innerHTML = Locales.YouHave + "$" + prod_account.dollars + " " + Locales.Dollars + ", ¢" + prod_account.cents + " " + Locales.Cents + " & " + prod_account.gold + " " + Locales.Gold + ".";
		}

		else if (item.action == 'addStoreCategories'){

			$("#categories").append(
				`<div id="categories_category_name" category = "` + event.data.label + `">` + event.data.label + `</div>` +
				`<div> &nbsp; </div>`
			);

			openedUIType = "store_categories";
		}

		else if (item.action == 'addStoreCategoryTypes'){
			
			$("#types").append(
				`<div id="type_categories_category_name" category = "` + event.data.label + `">` + event.data.label + `</div>` +
				`<div> &nbsp; </div>`
			);

			displayPage("type_categories_menu", "visible");

			openedUIType = "store_type_categories";
		}

		else if (item.action == 'clearStoreCategoryProducts'){
			$("#products").html('');
		}
		else if (item.action == 'addStoreSelectedCategoryProducts'){
			var prod_item = event.data.item_data;

			openedUIType = "store_products";

			displayPage("category_products", "visible");

			var currencySymbol = "$";
			var currencyName   = Locales.Dollars;

			if (prod_item.currency == "cents") {
				currencySymbol = "¢";
				currencyName   = Locales.Cents;

			} else if (prod_item.currency == "gold") {
				currencySymbol = "";
				currencyName   = Locales.Gold;
			}

			var itemId = prod_item.id;

			if (itemId == null) {
				itemId = 0;
			}
			
			if (prod_item.hasRequiredLevel) {

				$("#products").append(
					`<div id="products_background_image"></div>` +
					`<img id="products_item_image_display" src = "` + getItemIMG(prod_item.item) + `"></img>` + 
					`<div id="products_item_label">` + prod_item.label + `</div>` +
					`<div id="products_item_cost" style = "color: rgba(60,179,113, 0.747)"; >X1 ` + currencySymbol + prod_item.price + " " + currencyName + `</div>` +
					`<div id="products_select_button" label = "` + prod_item.label + `" currency = "` + prod_item.currency  + `" cost = "` + prod_item.price + `" itemid = "` + itemId + `" item = "` + prod_item.item + `">` + Locales.Select + `</div>` +
					`<div> &nbsp; </div>` +
					`<div> &nbsp; </div>`
				);
			}else{

				$("#products").append(
					`<div id="products_background_image"></div>` +
					`<img id="products_item_image_display" src = "` + getItemIMG(prod_item.item) + `"></img>` +
					`<div id="products_item_label" style = "color: rgba(255, 0, 0, 0.7)"; >` + prod_item.label + `</div>` +
					`<div id="products_item_cost" style = "color: rgba(255, 0, 0, 0.5)"; >` + prod_item.requiredLevel + " Knowledge Level Is Required." + `</div>` +
					`<div> &nbsp; </div>` +
					`<div> &nbsp; </div>`
				);
			}

		}

		else if (item.action == 'closeUI'){
			closeNUI();
		}
		

	});

	$("body").on("keyup", function (key) {
		if (key.which == 27){

			document.getElementById("products_selected_item_display").style.color = "rgba(255, 0, 0, 0.7)";
			document.getElementById("products_selected_item_display").innerHTML = Locales.NotSelected;
			
			if (openedUIType == "store_products") {
				playAudio("button_click.wav");

				displayPage("category_products", "hidden");
				$("#products").html('');
				$("#types").html('');
	
				$.post('http://tpz_stores/loadStoreTypeCategories', JSON.stringify({
					category : selectedCategory, 
				}));
	
			}else if (openedUIType == "store_type_categories") {
				playAudio("button_click.wav");

				displayPage("buttons", "hidden");
				displayPage("type_categories_menu", "hidden");
				displayPage("categories_menu", "visible");
				
				$("#categories").html('');
				$("#types").html('');
	
				$.post('http://tpz_stores/loadCategories', JSON.stringify({
					category : selectedCategory, 
				}));
	
				// open store categories (not store types)
			}else if (openedUIType == "store_categories") {
				closeNUI();
			}
		}
	});

	// Back Button
	$("#objects_shop").on("click", "#shop_back_button", function() {
		playAudio("button_click.wav");

		document.getElementById("products_selected_item_display").style.color = "rgba(255, 0, 0, 0.7)";
		document.getElementById("products_selected_item_display").innerHTML = Locales.NotSelected;

		if (openedUIType == "store_products") {
			
			displayPage("category_products", "hidden");
			$("#products").html('');
			$("#types").html('');

			$.post('http://tpz_stores/loadStoreTypeCategories', JSON.stringify({
				category : selectedCategory, 
			}));

			document.getElementById("products_item_amount_input").value = 1;

		}else if (openedUIType == "store_type_categories") {
			displayPage("buttons", "hidden");
			displayPage("type_categories_menu", "hidden");
			displayPage("categories_menu", "visible");
			
			$("#categories").html('');
			$("#types").html('');

			$.post('http://tpz_stores/loadCategories', JSON.stringify({
				category : selectedCategory, 
			}));

		}
	});

	// Categories Selection
	$("#objects_shop").on("click", "#categories_category_name", function() {
		playAudio("button_click.wav");

		var $button = $(this);
		var $Category = $button.attr('category');

		selectedCategory = $Category;

		displayPage("categories_menu", "hidden");

		$.post('http://tpz_stores/loadStoreTypeCategories', JSON.stringify({
			category : $Category, 
		}));

		displayPage("buttons", "visible");
	});

	$("#objects_shop").on("click", "#type_categories_category_name", function() {
		playAudio("button_click.wav");

		var $button = $(this);
		var $Category = $button.attr('category');

		displayPage("type_categories_menu", "hidden");

		if ($Category == "buy") {
			document.getElementById("products_action_button").innerHTML = Locales.Buy;
			selectedStoreTransactionType = "buy";

		}else if ($Category == "sell"){
			document.getElementById("products_action_button").innerHTML = Locales.Sell;
			selectedStoreTransactionType = "sell";
		}

		$.post('http://tpz_stores/loadStoreTypeCategoryProducts', JSON.stringify({
			category : $Category, 
		}));

		displayPage("buttons", "visible");
	});

	
	// Selecting & Purchasing Objects
	$("#objects_shop").on("click", "#products_select_button", function() {
		playAudio("button_click.wav");

		var $button = $(this);
		var $Label = $button.attr('label');

		var $ItemId = $button.attr('itemid');
		var $Item = $button.attr('item');
		var $Cost = $button.attr('cost');
		var $CurrencyType = $button.attr('currency');

		selectedItemId = $ItemId;
		selectedItem = $Item;
		selectedItemCost = $Cost;
		selectedItemCurrencyType = $CurrencyType;

		document.getElementById("products_selected_item_display").style.color = "rgba(203, 216, 117, 0.719)";
		document.getElementById("products_selected_item_display").innerHTML = $Label;
	});


	$("#objects_shop").on("click", "#products_action_button", function() {
		playAudio("button_click.wav");

		var label  = document.getElementById("products_selected_item_display").innerHTML;
		var amount = document.getElementById("products_item_amount_input").value;

		if (label != Locales.NotSelected) {
			$.post('http://tpz_stores/performActionOnSelectedProduct', JSON.stringify({
				itemid : selectedItemId,
				item : selectedItem, 
				label : label,
				quantity : amount,
				cost : selectedItemCost,
				currency : selectedItemCurrencyType,
				category : selectedStoreTransactionType,
			}));
		}

	});


	document.getElementById('products_item_amount_input').onkeypress = function(e){
		if (!e) e = window.event;
		var keyCode = e.code || e.key;

		if (keyCode == "Enter" || keyCode == "NumpadEnter"){

			if (!pressedToBuyCooldown) {
				pressedToBuyCooldown = true;

				playAudio("button_click.wav");
			
				var label  = document.getElementById("products_selected_item_display").innerHTML;
				var amount = document.getElementById("products_item_amount_input").value;
	
				if (label != Locales.NotSelected) {
	
					$.post('http://tpz_stores/performActionOnSelectedProduct', JSON.stringify({
						item : selectedItem, 
						label : label,
						quantity : amount,
						cost : selectedItemCost,
						currency : selectedItemCurrencyType,
						category : selectedStoreTransactionType,
					}));
				}

				setTimeout(function() { pressedToBuyCooldown = false; }, 2000);
			}

		  return false;
		}
	}


});

function displayPage(page, cb){
	document.getElementsByClassName(page)[0].style.visibility = cb;
  
	[].forEach.call(document.querySelectorAll('.' + page), function (el) {
	  el.style.visibility = cb;
	});
  }

function onNumbers(evt){
	// Only ASCII character in that range allowed
	var ASCIICode = (evt.which) ? evt.which : evt.keyCode;
	
	if (ASCIICode > 31 && (ASCIICode < 48 || ASCIICode > 57))
		return false;
	return true;
  }
  
function getItemIMG(item){
	return 'nui://tpz_inventory/html/img/items/' + item + '.png';
}