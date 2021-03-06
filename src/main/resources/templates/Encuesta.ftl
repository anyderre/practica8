<!DOCTYPE html >
<html lang="en" ng-app="encuesta">
<#include "header.ftl">
<#--<#include "nav.ftl">-->
<body>
<div class="container wrapper">
            <div class="panel panel-primary">
                <div class="panel-heading">Encuestas</div>
                <div class="panel-body">

                        <div class="row">
                            <div class="col-sm-12">
                            <hr>
                            <div class="table-responsive" ng-controller="encuestaTableController"
                                 ng-init="getData(pageno)">
                                <table class="table table-bordered table-hover table-striped">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Nombre</th>
                                        <th>Sector</th>
                                        <th>Nivel Escolar</th>
                                        <th>&nbsp</th>
                                        <th>&nbsp</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr ng-show="encuestas.length <=0">
                                        <td colspan="6" style="text-align:center;">Leyendo Nuevos Datos!!</td>
                                    </tr>
                                    <tr dir-paginate="encuesta in encuestas|itemsPerPage:itemsPerPage"
                                        total-items="total_count">
                                        <td>{{$index+1}}</td>
                                        <td>{{encuesta.nombre}}</td>
                                        <td>{{encuesta.sector}}</td>
                                        <td>{{encuesta.nivelEscolar}}</td>
                                        <td>
                                            <a href="/encuesta/editar/{{encuesta.id}}">
                                                <p data-placement="top" data-toggle="tooltip" title="Editar">
                                                    <button class="btn btn-primary btn-xs" data-title="Editar"
                                                            data-toggle="modal" data-target="#edit"><span
                                                            class="glyphicon glyphicon-pencil"></span></button>
                                                </p>
                                            </a>
                                        </td>
                                        <td>
                                            <a href="/encuesta/eliminar/{{encuesta.id}}">
                                                <p data-placement="top" data-toggle="tooltip" title="Eliminar">
                                                    <button class="btn btn-danger btn-xs" data-title="Eliminar"
                                                            data-toggle="modal" data-target="#delete"><span
                                                            class="glyphicon glyphicon-trash"></span></button>
                                                </p>
                                            </a>
                                        </td>

                                    </tr>

                                    </tbody>
                                </table>
                                <div style="display: inline-block;  text-align: center">
                                    <dir-pagination-controls
                                            max-size="10"
                                            direction-links="true"
                                            boundary-links="true"
                                            on-page-change="getData(newPageNumber)">
                                    </dir-pagination-controls>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-offset-10 col-sm-2">
                                <button type="button" class="btn btn-primary btn-xs">Ver encuestas</button>
                            </div>
                        </div>
                        <!-- /.row -->

                        <div class="row">
                            <div class="col-sm-12">
                                <div id="map" style="width: 100%; height: 400px; padding-left: 15px; padding-right: 15px"></div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>


</div>
<script src="/js/dirPagination.js"></script>
<script src="/js/app.js"></script>
<script src="/js/Controller/encuestaController.js">
</script>

<script type="text/javascript">
    $(document).ready(function () {
        $("#map").hide();
    });

    function initMap() {
        var myLatLng = {lat: 19.45000, lng: -70.70000};

        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 12,
            center: myLatLng,
            mapTypeid: 'terrain'
        });
        $(".btn-xs").click(function () {
            $("#map").show();
            setEncuestas(map);
        });

        function setEncuestas(map) {
            var image = {
                url: '/images/pol.png',
                // This marker is 20 pixels wide by 32 pixels high.
                size: new google.maps.Size(20, 20),
                // The origin for this image is (0, 0).
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(0, 20)
            };
            var shape = {
                coords: [1, 1, 1, 20, 18, 20, 18, 1],
                type: 'poly'
            };
            $.getJSON("/api/encuestas/buscar", function (data) {
                $.each(data, function (key, encuesta) {
                    var marker = new google.maps.Marker({
                        position: {
                            lat: encuesta.latitude,
                            lng: encuesta.longitude
                        },
                        map: map,
                        icon: image,
                        shape: shape,
                        title: encuesta["nombre"],
                        zIndex: 1
                    });
                });
            });
        }
    }
</script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyABtO1OiHaJnWDo29kaUUOm06HBU6GjAUA&callback=initMap">
</script>
</body>
</html>

