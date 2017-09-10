<#include "header.ftl">
<#include "nav.ftl">

<div class="container" id="paste-bin">
    <div class="panel panel-primary" style="width: 300px">
        <div class="panel-heading" style="background-color: #802022">
            <a href="/paste/show/list">
                <h4 class="public" style="text-decoration: none; color: white;">Public</h4>
            </a>
        </div>
        <div class="panel-body">
            <ul class="list-group">
            <#if publicPaste??>
                <#list publicPaste as p>
                    <li class="list-group-item"><a href="/paste/show/${p.getId()}">${p.getTitulo()}</a><span class="pull-right">${p.getSintaxis()}</span></li>
                </#list>
            </#if>
            </ul>
        </div>
    </div>
    <div class="panel panel-primary" style="width:800px; margin-left: 30px">
        <div class="panel-heading">Copy and Paste</div>
        <div class="panel-body">

            <form action="/paste/" method="post" name="myForm" onsubmit="return(validate());" >
                <div class="row">
                    <div class=" col-md-7">
                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" class="form-control" name="title" id="title"
                                   placeholder="Enter the Paste title here">
                        </div>
                        <div class="form-group">
                            <label for="bloqueDeTexto">New Paste</label>
                            <textarea class="form-control" name="bloqueDeTexto" id="bloqueDeTexto" cols="50"
                                      rows="20"></textarea>
                            <p id="demo"></p>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="form-group" style="margin-top:77px">
                            <label for="syntax">Syntax</label>
                            <select class="form-control" name="syntax" id="syntax">
                                <option selected disabled>Select One</option>
                                <option>apache</option>
                                <option>bash</option>
                                <option>c#</option>
                                <option>c++</option>
                                <option>css</option>
                                <option>coffeeScript</option>
                                <option>diff</option>
                                <option>html</option>
                                <option>xml</option>
                                <option>http</option>
                                <option>ini</option>
                                <option>json</option>
                                <option>java</option>
                                <option>javascript</option>
                                <option>lisp</option>
                                <option>makefile</option>
                                <option>markdown</option>
                                <option>ngnix</option>
                                <option>objective-C</option>
                                <option>php</option>
                                <option>perl</option>
                                <option>python</option>
                                <option>ruby</option>
                                <option>sql</option>
                                <option>shell</option>
                                <option>session</option>
                                <option>arduino</option>
                                <option>arm assembler</option>
                                <option>clojure</option>
                                <option>django</option>
                                <option>excel</option>
                                <option>f#</option>
                                <option>go</option>
                                <option>haskell</option>
                                <option>groovy</option>
                                <option>r</option>
                                <option>sml</option>
                                <option>swift</option>
                                <option>vb.net</option>
                                <option>yaml</option>

                            </select>
                        </div>
                        <div class="form-group">
                            <label for="expirationDate">Expiration Date</label>
                            <select class="form-control" name="expirationDate" id="expirationDate" >
                                <option selected disabled>Select One</option>
                                <option>never</option>
                                <option>10 minutes</option>
                                <option>15 minutes</option>
                                <option>30 minutes</option>
                                <option>1 hour</option>
                                <option>1 day</option>
                                <option>1 week</option>
                            </select>
                        </div>
                            <div class="form-group">
                                <label for="expositionType">Exposition Type</label>
                                <select class="form-control" name="expositionType" id="expositionType" >
                                    <option selected disabled>Select One</option>
                                    <option>public</option>
                                    <option>private</option>
                                    <option>unlisted</option>
                                </select>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group" style="margin-top:190px">
                                        <button class="btn btn-primary form-control" id="guardarCambios" type="submit">Create New Paste
                                        </button>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>
                <input type="hidden" name = "Latitude" id="Latitude">
                <input type="hidden" name = "Longitude" id="Longitude">
            </form>
            <div class="col-md-6">
                    <button class="btn btn-primary" id="guardar">Save Paste Offline
                    </button>
            </div>

        </div>
    </div>

</div>

<script type="text/javascript">
    $(document).ready(function(){
        var opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
        }
        //Obteniendo la referencia directa.
        navigator.geolocation.getCurrentPosition(function(geodata){

            var coordenadas = geodata.coords;

            $("#Latitude").value=coordenadas.latitude
            $("#Longitude").value=coordenadas.longitude

            $("#posicionGps").text("Latitud: "+coordenadas.latitude+", Longitud: "+coordenadas.longitude+", Precisión: "+coordenadas.accuracy+" metros");
        }, function(){
            $("#posicionGps").text("No permite el acceso del API GEO");
        }, opcionesGPS);

        //Obteniendo el cambio de referencia.
        id = navigator.geolocation.watchPosition(function(geodata){
            var coordenadas = geodata.coords;
            $("#posicionGps2").text("Latitud: "+coordenadas.latitude+", Longitud: "+coordenadas.longitude+", Precisión: "+coordenadas.accuracy+" metros, cantidad: "+cantidad);
            cantidad++;
            if(cantidad>=5){
                navigator.geolocation.clearWatch(id);
                console.log("Finalizando la trama")
            }
        },function(error){
            //recibe un objeto con dos propiedades: code y message.
            $("#posicionGps2").text("No permite el acceso del API GEO. Codigo: "+error.code+", mensaje: "+error.message);
        });
    });

    function validate() {

        if (document.myForm.title.value === "") {
            alert("Please provide the title of the form");
            document.myForm.title.focus();
            return false;
        }

        if (document.myForm.bloqueDeTexto.value == "") {
            alert("Please provide the text block of the form");
            document.myForm.bloqueDeTexto.focus();
            return false;
        }

        if (document.myForm.syntax.value === "Select One")
        {
            alert('Please enter Syntax name');
            document.getElementById('syntax').style.borderColor = "red";
            return false;
        }

        if (document.myForm.expirationDate.value === "Select One")
        {
            alert('Please enter expiration date');
            document.getElementById('expirationDate').style.borderColor = "red";
            return false;
        }

        if (document.myForm.expositionType.value === "Select One")
        {
            alert('Please enter expiration date');
            document.getElementById('expositionType').style.borderColor = "red";
            return false;
        }

    }
    $(document).ready(function () {
        setInterval(function(){
            if(!navigator.onLine){
                $("#guardarCambios").hide();
                $("#guardar").show()
            }else {
                $("#guardarCambios").show();
                $("#guardar").hide();
            }
        }, 1000)
    })
    $(document).ready(function () {
$("#guardar").click(function () {
    if(navigator.onLine){
        alert("browser is online");
    }else {
        alert("browser is offline");
        //dependiendo el navegador busco la referencia del objeto.
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

        //indicamos el nombre y la versión
        var dataBase = indexedDB.open("prueba_db", 1);

        //se ejecuta la primera vez que se crea la estructura
        //o se cambia la versión de la base de datos.
        dataBase.onupgradeneeded = function (e) {
            console.log("Creando la estructura de la tabla");

            //obteniendo la conexión activa
            active = dataBase.result;

            //creando la colección:
            //En este caso, la colección, tendrá un ID autogenerado.
            var pastes = active.createObjectStore("pastes", {keyPath: 'titulo', autoIncrement: true});

            //creando los indices. (Dado por el nombre, campo y opciones)
            pastes.createIndex('por_sintaxis', 'sintaxis', {unique: true});

        };

        //El evento que se dispara una vez, lo
        dataBase.onsuccess = function (e) {
            console.log('Proceso ejecutado de forma correctamente');
        };

        dataBase.onerror = function (e) {
            console.error('Error en el proceso: ' + e.target.errorCode);
        };

        //var r = indexedDB.open("prueba_db", 1);
        dataBase.onsuccess = function(event) {
            var db = event.target.result;
            // Es necesario abrir una transacción e indicar un modo: readonly, readwrite y versionchange
            var transaccion = db.transaction(["pastes"], "readwrite");

            //Manejando los errores.
            transaccion.onerror = function (e) {
                alert(request.error.name + '\n\n' + request.error.message);
            };

            transaccion.oncomplete = function (e) {
                document.querySelector("#title").value = '';
                alert('Objeto agregado correctamente');
            };

            //abriendo la colección de datos que estaremos usando.
            var pastes = transaccion.objectStore("pastes");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            alert(document.querySelector("#title").value)
            alert( document.querySelector("#bloqueDeTexto").value)
            alert(document.querySelector("#syntax").value)

            alert(document.querySelector("#expositionType").value)
            alert(document.querySelector("#expirationDate").value)

            var request = pastes.put({
                titulo: document.querySelector("#title").value,
                bloqueDeCodigo: document.querySelector("#bloqueDeTexto").value,
                sintaxis: document.querySelector("#syntax").value,
                tipoExposicion: document.querySelector("#expositionType").value,
                fechaExpiracion: getDate(document.querySelector("#expirationDate").value),
                cantidadVista: 0,
                fechaPublicacion: new Date().toString()
            });

            request.onerror = function (e) {
                var mensaje = "Error: " + e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };

            request.onsuccess = function (e) {

                console.log("Datos Procesado con exito");
                document.querySelector("#title").value = "";
                document.querySelector("#bloqueDeTexto").value = "";
                $("#syntax").prop("selectedIndex", 0);
                $("#expositionType").prop("selectedIndex", 0);
                $("#expirationDate").prop("selectedIndex", 0);

            };

        };

          }

    });
});


    function getDate(fecha) {
        var fechaDeHoy = new Date().getTime() / 1000;
        switch (fecha) {
            case "10 minutes":
                return (10 * 60) + fechaDeHoy;
            case "15 minutes":
                return (15 * 60) + fechaDeHoy;
            case "20 minutes":
                return (20 * 60) + fechaDeHoy;
            case "30 minutes":
                return (30 * 60) + fechaDeHoy;
            case "1 hour":
                return (60 * 60) + fechaDeHoy;
            case "1 day":
                return (24 * 60 * 60) + fechaDeHoy;
            case "1 week":
                return 7 * 24 * 60 * 60 + fechaDeHoy;
            case "never":
                var sDate1 = "31/12/9999";
                var date = []
                date = sDate1.split("/");
                var newDate = new Date(date[2], date[0] - 1, date[1]).getTime()
                return newDate;
            default:
                return 0;
        }

    }
//    /**
//     * Permite listar todos los datos digitados.
//     */
//    function listarDatos() {
//
//        //por defecto si no lo indico el tipo de transacción será readonly
//        var data = dataBase.result.transaction(["pastes"]);
//        var pastes = data.objectStore("pastes");
//        var contador = 0;
//        var pastes_recuperados=[];
//
//        //abriendo el cursor.
//        pastes.openCursor().onsuccess=function(e) {
//            //recuperando la posicion del cursor
//            var cursor = e.target.result;
//            if(cursor){
//                contador++;
//                //recuperando el objeto.
//                pastes_recuperados.push(cursor.value);
//
//                //Función que permite seguir recorriendo el cursor.
//                cursor.continue();
//
//            }else {
//                console.log("La cantidad de registros recuperados es: "+contador);
//            }
//        };
//
//        //Una vez que se realiza la operación llamo la impresión.
//        data.oncomplete = function () {
//            imprimirTabla(pastes_recuperados);
//        }
//
//    }
//
//    /**
//     *
//     * @param lista_pastes
//     */
//    function imprimirTabla(lista_pastes) {
//        //creando la tabla...
//        var tabla = document.createElement("table");
//        var filaTabla = tabla.insertRow();
//        filaTabla.insertCell().textContent = "Titulo";
//        filaTabla.insertCell().textContent = "Bloque de codigo";
//        filaTabla.insertCell().textContent = "Sintaxis";
//        filaTabla.insertCell().textContent = "Tipo Exposicion";
//        filaTabla.insertCell().textContent = "Fecha Expiracion";
//        filaTabla.insertCell().textContent = "Fecha Publicacion";
//        filaTabla.insertCell().textContent = "Cantidad Vista";
//
//        for (var key in lista_pastes) {
//            //
//            filaTabla = tabla.insertRow();
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].titulo;
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].bloqueDeCodigo;
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].sintaxis;
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].tipoExposicion;
//            filaTabla.insertCell().textContent = ""+new Date(lista_pastes[key].fechaExpiracion*1000).toString();
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].fechaPublicacion;
//            filaTabla.insertCell().textContent = ""+lista_pastes[key].cantidadVista;
//        }
//
//        document.getElementById("listaPaste").innerHTML="";
//        document.getElementById("listaPaste").appendChild(tabla);
//    }
//
//
//    /**
//     *
//     */
//    function buscarPaste() {
//
//        //recuperando el id.
//        var titulo = prompt("Indique el titulo del paste");
//        console.log("titulo digitado: "+ titulo);
//
//        //abriendo la transacción en modo readonly.
//        var data = dataBase.result.transaction(["pastes"]);
//        var pastes = data.objectStore("pastes");
//
//        //buscando paste por la referencia al key.
//        pastes.get(titulo).onsuccess = function(e) {
//
//            var resultado = e.target.result;
//            console.log("los datos: "+resultado);
//
//            if(resultado !== undefined){
//
//                var p = document.createElement("p");
//                p.appendChild(document.createTextNode(""+JSON.stringify(resultado)));
//                console.log(JSON.stringify(resultado));
//                document.getElementById("listaPaste").innerHTML="";
//                document.getElementById("listaPaste").appendChild(p);
//            }else{
//                console.log("Paste no encontrado...");
//            }
//        };
//
//    }
//
//    function buscarPasteSintaxis() {
//
//        var consultaSintaxis = prompt("Indique la sintaxis");
//        console.log("El sintaxis consultado: " +consultaSintaxis);
//        if(consultaSintaxis === undefined){
//            return;
//        }
//
//        //por defecto si no lo indico el tipo de transacción será readonly
//        var data = dataBase.result.transaction(["pastes"]);
//        var pastes = data.objectStore("pastes");
//        var contador = 0;
//        var pastes_recuperados=[];
//
//        //buscando la referencia por el indice.
//        var indice = pastes.index("por_sintaxis");
//
//        //determinando la forma de la consulta
//        var singleKeyRange = IDBKeyRange.only(consultaSintaxis);
//
//        //abriendo el cursor.
//        indice.openCursor(singleKeyRange).onsuccess=function(e) {
//            //recuperando la posicion del cursor
//            var cursor = e.target.result;
//            if(cursor){
//                contador++;
//                //recuperando el objeto.
//                pastes_recuperados.push(cursor.value);
//
//                //Función que permite seguir recorriendo el cursor.
//                cursor.continue();
//
//            }else {
//                console.log("La cantidad de registros recuperados es: "+contador);
//            }
//        };
//
//        //Una vez que se realiza la operación llamo la impresión.
//        data.oncomplete = function () {
//            imprimirTabla(pastes_recuperados);
//        }
//
//    }
//
//    function borrarPaste() {
//
//        var titulo = prompt("Indique el sintaxis");
//        console.log("sintaxis digitada: "+titulo);
//
//        var data = dataBase.result.transaction(["pastes"], "readwrite");
//        var pastes = data.objectStore("pastes");
//
//        pastes.delete(titulo).onsuccess = function (e) {
//            console.log("Paste eliminado...");
//        };
//    }
//
//    function cambiarPaste() {
//
//        //recuperando el titulo.
//        var titulo = prompt("Indique el titulo");
//        console.log("titulo digitada: "+titulo);
//
//
//        //abriendo la transacción en modo escritura.
//        var data = dataBase.result.transaction(["pastes"],"readwrite");
//        var pastes = data.objectStore("pastes");
//
//        //buscando paste por la referencia al key.
//        pastes.get(titulo).onsuccess = function(e) {
//
//            var resultado = e.target.result;
//            console.log("los datos: "+JSON.stringify(resultado));
//
//            if(resultado !== undefined){
//                document.querySelector("#titulo").value = resultado.titulo;
//                document.querySelector("#bloqueDeCodigo").value = resultado.bloqueDeCodigo;
//                document.querySelector("#sintaxis").value = resultado.sintaxis;
//                document.querySelector("#tipoExposicion").value = resultado.tipoExposicion;
//                document.querySelector("#fechaExpiracion").value = new Date(resultado.fechaExpiracion*1000);
//            }else{
//                console.log("Pastes no encontrado...");
//            }
//        };
//
//    }
//
//    function guardarCambios(){
//        //abriendo la transacción en modo escritura.
//        var data = dataBase.result.transaction(["pastes"],"readwrite");
//        var pastes = data.objectStore("pastes");
//
//        //buscando paste por la referencia al key.
//        pastes.get(document.querySelector("#titulo").value).onsuccess = function(e) {
//
//            var resultado = e.target.result;
//            console.log("los datos: "+JSON.stringify(resultado));
//
//            if(resultado !== undefined){
//                resultado.titulo= document.querySelector("#titulo").value;
//                resultado.bloqueDeCodigo= document.querySelector("#bloqueDeCodigo").value ;
//                resultado.sintaxis = document.querySelector("#sintaxis").value ;
//                resultado.tipoExposicion = document.querySelector("#tipoExposicion").value ;
//                resultado.fechaExpiracion = getDate(document.querySelector("#fechaExpiracion").value) ;
//                resultado.cantidadVista = 0;
//
//                var solicitudUpdate = pastes.put(resultado);
//
//                //eventos.
//                solicitudUpdate.onsuccess = function (e) {
//                    console.log("Datos Actualizados....");
//                }
//
//                solicitudUpdate.onerror = function (e) {
//                    console.error("Error Datos Actualizados....");
//                }
//
//            }else{
//                console.log("Pastes no encontrado...");
//            }
//        };
//    }
//
//
//}

</script>
<#include "footer.ftl">

