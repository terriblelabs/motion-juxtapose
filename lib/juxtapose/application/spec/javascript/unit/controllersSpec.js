(function() {
  'use strict'

  describe('ProjectsCtrl', function() {
    var test = {};

    beforeEach(module('juxtapose.controllers'))
    beforeEach(inject(function($rootScope, $controller, $httpBackend){
      var projectMock = { query: function(){ return {}} }

      test.scope = $rootScope.$new()
      test.controller = $controller('ProjectsCtrl', {
        $scope: test.scope, Project: projectMock, $http: $httpBackend
      })
    }))

    it('should extract the iOS version', function() {
      var spec = { directory: "/Code/screenshotter-test/spec/screens/iphone/ios_7.0.3/home-controller-has-a-single-button/home_screen" }
      expect(test.scope.deviceName(spec)).toEqual("iphone")
    })

    it('should extract the iOS version', function() {
      var spec = { directory: "/Code/screenshotter-test/spec/screens/iphone/ios_7.0.3/home-controller-has-a-single-button/home_screen" }
      expect(test.scope.iOSVersion(spec)).toEqual("7.0.3")

      spec = { directory: "/Code/screenshotter-test/spec/screens/iphone/7.0/home-controller-has-a-single-button/home_screen" }
      expect(test.scope.iOSVersion(spec)).toEqual("7.0")
    })

    return it('should extract the spec name', function() {
      var spec = { directory: "/Code/screenshotter-test/spec/screens/iphone/ios_7.0.3/home-controller-has-a-single-button/home_screen" }
      expect(test.scope.specName(spec)).toEqual("Home controller has a single button | home_screen")
    })
  })

}).call(this)
