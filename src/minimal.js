'use strict';

// Creating promise to import dependency highlight.js scripts for One Light
const importHighlightJS = new Promise((resolve, reject) => {
    const script = document.createElement('script');
    document.head.appendChild(script);
    script.onload = resolve;
    script.onerror = reject;
    script.async = true;
    script.src = 'https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@9.15.8/build/highlight.min.js';
});

// Run the promise, then initialize the script on finish
importHighlightJS.then(() => {
    // Catch all the <code> elements, and consider them as code to be highlighted
    var code = document.querySelectorAll('code');
    // Highlight each of them
    Array.prototype.forEach.call(code, hljs.highlightBlock);
    // Make the ones not nested in a <pre> element inline
    code.forEach(function(item) {
        if (item.parentElement.nodeName != 'PRE') {
            item.setAttribute('style', item.getAttribute('style') + '; display: inline');
        }
    });
},
() => {
    console.log("Error: Can't retrieve highlight.js, or can't initialize it.");
});
