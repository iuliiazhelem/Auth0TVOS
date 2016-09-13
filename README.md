# Auth0TVOS

This sample exposes how to integrate Auth0 database authentication into your tvOS application.

You can implement Auth0  authentication with [Auth0.swift Toolkit for Auth0 API](https://github.com/auth0/Auth0.swift).

For this you need to add the following to your `Podfile`:
```
pod 'Auth0', '~> 1.0.0-beta.7'
```

### Important Snippets
### Step 1: Login to Auth0.
```Swift
  Auth0
  .authentication()
  .login(
      usernameOrEmail: emailTextField.text!,
      password: passwordTextField.text!,
      connection: "Username-Password-Authentication"
  )
  .start { result in
    switch result {
      case .Success(let credentials):
          print("access_token: \(credentials.accessToken)")
      case .Failure(let error):
          print(error)
      }
  }
```

### Step 2: Fetch the user info.
```Swift
  Auth0
  .authentication()
  .tokenInfo(token: <tokenId>)
  .start { result in
    switch result {
      case .Success(let profile):
        //Show data
      case .Failure(let error):
        //Show error
      }
  }
```

Before using the example please make sure that you change keys in the `Auth0.plist` file with your data:

##### Auth0 data from [Auth0 Dashboard](https://manage.auth0.com/#/applications):
- ClientId (your Auth0ClientId)
- Domain (your Auth0Domain)
