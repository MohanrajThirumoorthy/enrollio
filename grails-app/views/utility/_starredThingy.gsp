<!-- you should wrap this template in a <span></span> class with
starId="someId" and class="star" (See studentQuickView template) } -->
<img src="${resource(dir:'images/icons', file:thingy.starred ? 'star_gold.png' : 'star_grey.png')}"
    starred="${thingy.starred ? 'true' : 'false'}" />
