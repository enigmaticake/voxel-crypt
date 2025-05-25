function arr_find_index(arr, value) {
	for (var i = 0; i < array_length(arr); ++i) {
		if (arr[i] == value) return i;
	}
	return -1;
}

function arr_find(arr, name) {
	for (var i = 0; i < array_length(arr); ++i) {
		if (arr[i] == name) {
			return arr[i];
		}
	}
	return -1;
}

function arr_get(arr, value, _default = undefined) {
	var index = arr_find_index(arr, value);
	return (index != -1) ? arr[index] : _default;
}

function arr_string(arr) {
	var str = "";
	
	for (var i = 0; i < array_length(arr); ++i) {
		str += string(arr[i]);
	}
	
	return str;
}


/**
 * Function Description
 * @param {struct} struct
 * @param {string} name
 * @param {any} value
 */
function ref_get(struct, name, value) {
    return struct_get(struct, name) ?? value;
}