angular.module('juxtapose', [
               'juxtapose.controllers',
               'juxtapose.services'
])
angular.module('juxtapose.controllers', [])
angular.module('juxtapose.services', [])

angular.module('juxtapose.services').factory('Project', [
  function(){
    return {
      query: function(){
        return Juxtapose.project;
      }
    }
  }
])

angular.module('juxtapose.controllers').controller('ProjectsCtrl', ['$scope', '$http', 'Project',
   function($scope, $http, Project){
     $scope.project = Project.query()

     $scope.accept = function(spec){
       $http({
         url: "/accept",
         method: "POST",
         data: {"filename": spec.current.img}
       }).success(function(response){
         response.image.path += "?refresh=true"
         spec.accepted = response.image
         spec.current = null
         spec.diff = null
       })
     }
   }
])
