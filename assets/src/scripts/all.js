
var $ = require('jquery');
var Masonry = require('masonry-layout');

var container = document.querySelector('.tiles');
// init

var iso = new Masonry( container, {
    "columnWidth": ".size",
    itemSelector: '.tile',
    "percentPosition": true
});