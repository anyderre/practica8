app.controller("encuestaTableController", function ($http, $scope) {
    $scope.encuestas = [];
    $scope.pageno = 1;
    $scope.total_count = 0;
    $scope.itemsPerPage= 10;

    $scope.isTrue = function (val){
        return val===true
    }

    $scope.isNull = function (val){
        return val===null
    };
    $scope.getData = function (pageno) {
        $scope.encuestas=[];

        $http.get("/api/encuesta/buscar/size").then(function (response) {
            $scope.total_count=response.data
            console.log($scope.total_count)
        });

        $http.get("/api/encuesta/buscar/"+(pageno-1)+"/"+$scope.itemsPerPage).then(
            function (response) {
                $scope.encuestas = response.data;
                console.log($scope.encuestas)
            }, function (response) {
                $scope.encuestas=response.data
            })
    };

});