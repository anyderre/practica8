<#include "header.ftl">
<#include "nav.ftl">



<div class="container" xmlns="http://www.w3.org/1999/html">
    <div class="row">
        <div class="col-md-offset-1 col-md-9">
            <h1 class="headline">Presentando el Highlight</h1>
            <div class="code_box">
                <div class="row">
                    <div class="col-md-12">
                        <form action="">
                            <div class="form-group">
                                <label for="raw">${titulo}</label>
                                <div class="raw-hjs">
                                        <pre >
                                            <code class="${paste.getSintaxis()}">${paste.getBloqueDeCodigo()}</code>
                                        </pre>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>


<#include "footer.ftl">