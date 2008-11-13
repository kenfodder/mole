
function gel(element_id) {
    return document.getElementById(element_id);
}
function show(element_id) {
    gel(element_id).style.display = '';
}
function hide(element_id) {
    gel(element_id).style.display = 'none';
}
