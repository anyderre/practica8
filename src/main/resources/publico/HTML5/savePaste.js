alert("hey")

$(document).ready(function () {

    var dataBase = indexedDB.open("prueba_db", 1);
    var data = dataBase.result.transaction(["pastes"]);
    var pastes = data.objectStore("pastes");
    var contador = 0;
    var pastes_recuperados = [];

    //abriendo el cursor.
    pastes.openCursor().onsuccess = function (e) {
        //recuperando la posicion del cursor
        var cursor = e.target.result;
        if (cursor) {
            contador++;
            //recuperando el objeto.
            pastes_recuperados.push(cursor.value);

            //Función que permite seguir recorriendo el cursor.
            cursor.continue();

        } else {
            console.log("La cantidad de registros recuperados es: " + contador);
        }
    };

    //Una vez que se realiza la operación llamo la impresión.
    data.oncomplete = function () {
        pastes_recuperados.forEach(function (paste) {
            jsondata = {
                "bloqueDeCodigo": paste.bloqueDeCodigo,
                "sintaxis": paste.sintaxis,
                "fechaExpiracion": parseInt(paste.fechaExpiracion, 10),
                "tipoExposicion": paste.tipoExposicion,
                "fechaPublicacion": new Date(paste.fechaPublicacion).getTime() / 1000,
                "titulo": paste.titulo,
                "url": "",
                "cantidadVista": 0
            }

        $.ajax({
            url: "/paste/guardar",
            method: "POST",
            data: {json: jsondata},
            contentType: "application/json",
            success: function (data) {
                alert(JSON.stringify(data));
            },
            error: function (errMsg) {
                alert(JSON.stringify(errMsg));
            }

        })
    })
}
});