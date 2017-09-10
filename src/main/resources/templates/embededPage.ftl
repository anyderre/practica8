<#include "header.ftl">
<#include "nav.ftl">



<div class="container" xmlns="http://www.w3.org/1999/html">
    <div class="row">
        <div class="col-md-offset-1 col-md-9">
            <h1 class="headline">Embed Codes For Paste</h1>
            <div class="code_box">
                <h3 class="embedP">${"Embed Codes For Paste ID: "+ "${paste.getId()}"}</h3>
                <h5>In order to embed this content into your website or blog, simply copy and paste the code provided below.</h5>
                   <p class="embed">iframe src="${""+"${paste.getUrl()}"}" style=border:none;width:100%</p>
                 </div>
        </div>
</div>

    <script>
        $(document).ready(function() {
            $(".embed").append("/>");
            $(".embed").prepend("<")
        });
    </script>

<#include "footer.ftl">