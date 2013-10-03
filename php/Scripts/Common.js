$(document).ready(function () {
    var url = 'https://itunes.apple.com/us/app/way-way-discover-places-everybody/id694189318?mt=8';
    $('.lnkAppStore').attr('href', url);
});

var modal = (function () {
    var 
				method = {},
				$overlay,
				$modal,
				$content,
				$close;

    // Center the modal in the viewport
    method.center = function () {
        var top, left;

        top = Math.max($(window).height() - $modal.outerHeight(), 0) / 2;
        left = Math.max($(window).width() - $modal.outerWidth(), 0) / 2;

        $modal.css({
            top: top + $(window).scrollTop(),
            left: left + $(window).scrollLeft()
        });
    };

    // Open the modal
    method.open = function (settings) {
        $content.empty().append(settings.content);

        $modal.css({
            width: settings.width || 'auto',
            height: settings.height || 'auto'
        });

        method.center();
        $(window).bind('resize.modal', method.center);
        $modal.show();
        $overlay.show();
    };

    // Close the modal
    method.close = function () {
        $modal.hide();
        $overlay.hide();
        $content.empty();
        $(window).unbind('resize.modal');
    };

    // Generate the HTML and add it to the document
    $overlay = $('<div id="overlay"></div>');
    $modal = $('<div id="modal"></div>');
    $content = $('<div id="content"></div>');
    $close = $('<a id="close" href="#">close</a>');

    $modal.hide();
    $overlay.hide();
    $modal.append($content, $close);

    $(document).ready(function () {
        $('body').append($overlay, $modal);
    });

    $close.click(function (e) {
        e.preventDefault();
        method.close();
    });

    return method;
} ());

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

/********************************************
var result = $.string.Format("Hello, {0}.", "world");
//result -> "Hello, world."
*********************************************/
$.string = {
    Format: function (text) {
        //check if there are two arguments in the arguments list
        if (arguments.length <= 1) {
            //if there are not 2 or more arguments there's nothing to replace
            //just return the text
            return text;
        }
        //decrement to move to the second argument in the array
        var tokenCount = arguments.length - 2;
        for (var token = 0; token <= tokenCount; ++token) {
            //iterate through the tokens and replace their placeholders from the text in order
            var reg = new RegExp("\\{" + token + "\\}", "gi");
            var value = arguments[token + 1];
            text = text.replace(reg, value);

        }
        return text;
    },
    IsNullOrEmpty: function (text) {
        if (typeof text == "undefined")
            return true;
        var value = $.trim(text);
        if (value.length == 0)
            return true;
        return false;
    },
    Compare: function (strA, strB, ignoreCase) {
        if (typeof ignoreCase == "undefined")
            ignoreCase = false;
        if (typeof strA != "undefined" && typeof strB != "undefined" && typeof strA == "string" && typeof strB == "string") {
            if (ignoreCase) {
                strA = strA.toLowerCase();
                strB = strB.toLowerCase();
            }
            return strA === strB;
        }
        return false;
    }
};