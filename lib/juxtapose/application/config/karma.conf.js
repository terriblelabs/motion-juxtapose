module.exports = function(config){
    config.set({
    basePath : '../',

    files : [
      'js/angular.min.js',
      'js/underscore-min.js',
      'js/app.js',
      'spec/javascript/lib/angular/angular-mocks.js',
      'spec/javascript/unit/**/*.js'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['Chrome'],

    plugins : [
            'karma-junit-reporter',
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-jasmine'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

})}
