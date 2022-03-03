function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'admoons@mail.com'
    config.userPassword = 'admin123'
  } else if (env == 'e2e') {
    // customize
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  // note: klo comment dibuka nanti token yg diambil jadi 1 username aja buka 3 3nya yg didefine

  return config;
}