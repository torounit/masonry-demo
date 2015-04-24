var _ = require('underscore');
var Packery = require('packery');

var gap = 1;

function getScrollPositionY() {
    return document.documentElement.scrollTop || document.body.scrollTop;
}

function getScreenHeight() {
    return document.documentElement.clientHeight;
}

function getContentHeight() {
    return document.body.clientHeight;
}

function isContentsOverScreen() {

    return ( getContentHeight() <= getScreenHeight() + getScrollPositionY() + gap );

};

function scrollToBottomEvent() {
    var scrollToBottomEvent = document.createEvent("UIEvent");
    scrollToBottomEvent.initEvent("scrollToBottom", true, true);

    return scrollToBottomEvent;
}



window.addEventListener('scroll', function(event) {
    if( isContentsOverScreen() ) {
        console.log(event);
        this.dispatchEvent( scrollToBottomEvent() );
    }
});


window.addEventListener('scrollToBottom', function(event) {
    console.log("bottom!");
});


// init
document.addEventListener('DOMContentLoaded', function(){

    var container = document.querySelector('.tiles');
    var page = 0;

    var pckry = new Packery( container, {
        "columnWidth": ".size",
        itemSelector: '.tile',
        "percentPosition": true
    });

    append();


    function createTiles() {

        var elements = _.map( _.range(4), function() {
            var rand = _.random(20);
            var sizer = "";
            if (rand < 1) {
                sizer = "tile_dobule-w tile_dobule-h";
            }
            else if (rand < 5) {
                sizer = "tile_dobule-w";
            }
            else if (rand < 8) {
                sizer = "tile_dobule-h";
            }

            var tile = document.createElement("div");
            tile.innerHTML = '<div class="tile__content"></div>';
            tile.setAttribute('class', 'tile ' + sizer);

            return tile;
        });

        return elements;
    }

    function append() {
        var tiles = createTiles();
        if(  !tiles || !tiles.length ) {
            return false;
        }

        page ++;
        var fragment = document.createDocumentFragment();
        _.each( tiles, function(tile) {
            fragment.appendChild(tile);
        });
        container.appendChild( fragment );
        pckry.appended( tiles );

        if( isContentsOverScreen() ) {
            append();
        }
    }


    document.querySelector('[data-tile-append]').addEventListener('click', function( event ){
        event.preventDefault();
    });

    document.querySelector('[data-tile-append]').addEventListener('click', _.throttle(append, 2000));
    window.addEventListener('scrollToBottom', _.throttle(append, 2000));

})

