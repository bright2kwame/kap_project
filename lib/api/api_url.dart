class ApiUrl {
  //MARK: get the base url
  String getBaseUrl() {
    var baseTestUrl =
        "https://kapinitiative-test-api.herokuapp.com/api/v2.0/mobile/";
    var baseLiveUrl =
        "https://kapinitiative-test-api.herokuapp.com/api/v2.0/mobile/";
    const bool _kReleaseMode = bool.fromEnvironment("dart.vm.product");
    return _kReleaseMode ? baseTestUrl : baseLiveUrl;
  }

  //MARK: module category url
  String filterModuleCategory() {
    return getBaseUrl() + "modules/filter_categories/";
  }

  //MARK: filter modules
  String filterModules() {
    return getBaseUrl() + "modules/filter_modules/";
  }

  //MARK: complete sign up url
  String completeSignUp() {
    return getBaseUrl() + "users/social_media_login/";
  }

  //MARK: saving player id
  String playerId() {
    return getBaseUrl() + "users/save_player_id/";
  }

  //MARK: my profile url
  String myProfile() {
    return getBaseUrl() + "users/me/";
  }

  //MARK: all my modules
  String myModules() {
    return getBaseUrl() + "modules/filter_my_modules/";
  }

//MARK: my modules
  String moduleMySteps() {
    return getBaseUrl() + "modules/filter_my_sub_modules/";
  }

  //MARK: all module steps
  String moduleSteps() {
    return getBaseUrl() + "modules/filter_sub_modules/";
  }

  //MARK: check module status
  String checkModuleStatus() {
    return getBaseUrl() + "modules/check_module_enrolment/";
  }

  //MARK: subsribe to module
  String subscribeToModule() {
    return getBaseUrl() + "modules/start_module/";
  }

  //MARK: start sub module
  String startSubModule() {
    return getBaseUrl() + "modules/start_sub_module/";
  }

  //MARK: mark module as complete
  String markModuleAsComplete() {
    return getBaseUrl() + "modules/complete_sub_module/";
  }

  //MARK: submit answers
  String submitQuiz() {
    return getBaseUrl() + "modules/submit_quiz/";
  }

  //MARK: save notification token
  String saveToken() {
    return getBaseUrl() + "users/update_token/";
  }

  //MARK: leader board
  String leaderBoard() {
    return getBaseUrl() + "users/leader_board/";
  }

  //MARK: all my feeds
  String myFeed() {
    return getBaseUrl() + "feeds/filter_my_feeds/";
  }

  //MARK: update
  String updatePoint() {
    return getBaseUrl() + "users/update_point/";
  }

  //MARK: event check
  String eventCheckIn() {
    return getBaseUrl() + "events/check_in_at_event/";
  }

  //MARK: event checkins
  String myCheckIns() {
    return getBaseUrl() + "events/filter_my_event_checkins/";
  }

  //MARK: redeem points
  String redeemPoints() {
    return getBaseUrl() + "users/redeem_point/";
  }

  //MARK: main website
  String mainDomain() {
    return "https://www.afihc.org/";
  }

  //MARK: privacy site
  String privacyDomain() {
    return "https://www.afihc.org/";
  }

  //MARK: filter shops
  String filterShops() {
    return getBaseUrl() + "marketplace/filter_shops/";
  }

  //MARK: filter products
  String filterProducts() {
    return getBaseUrl() + "marketplace/filter_products/";
  }

  //MARK: make order
  String placeOrder() {
    return getBaseUrl() + "marketplace/place_order/";
  }

  //MARK: verify the payment otp
  String verifyPaymentNumberOrder() {
    return getBaseUrl() + "users/initiate_phone_number_verification/";
  }

  //MARK: fetch all messages
  String fetchMessages() {
    return getBaseUrl() + "users/fetch_messages/";
  }

  //MARK: login endpoint
  String login() {
    return getBaseUrl() + "users/login/";
  }

  //MARK: init password reset
  String initPasswordReset() {
    return getBaseUrl() + "users/forgot_password/";
  }

  //MARK: password reset
  String passwordReset() {
    return getBaseUrl() + "users/reset_password/";
  }

  //MARK: verify account
  String verifyAccount() {
    return getBaseUrl() + "users/verify_account/";
  }

  //MARK: send message
  String sendMessage() {
    return getBaseUrl() + "users/send_message/";
  }

  //MARK: get messages
  String messages() {
    return getBaseUrl() + "users/fetch_messages/";
  }
}
