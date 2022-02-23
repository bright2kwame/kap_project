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

  //MARK: password reset
  String resetPassword() {
    return getBaseUrl() + "users/reset_password/";
  }

  //MARK: login
  String login() {
    return getBaseUrl() + "users/login/";
  }

  //MARK: update avatar
  String updateAvatar() {
    return getBaseUrl() + "users/update_profile_picture/";
  }

  //MARK: purchased vouchers
  String purchasedVouchers() {
    return getBaseUrl() + "vouchers/purchased_vouchers/";
  }

  //MARK: vouchers
  String vouchers() {
    return getBaseUrl() + "vouchers/available_vouchers/";
  }

  //MARK: merchants
  String merchants() {
    return getBaseUrl() + "merchants/approved_merchants/";
  }

  //MARK: voucher history
  String voucherHistories() {
    return getBaseUrl() + "vouchers/purchase_history/";
  }

  //MARK: wallets
  String wallets() {
    return getBaseUrl() + "wallets/";
  }

  //MARK: verified wallets
  String verifiedWallets() {
    return getBaseUrl() + "wallets/verified_wallets/";
  }

//MARK: verify wallet
  String verifyWallet(String id) {
    return getBaseUrl() + "wallets/$id/confirm_wallet_number/";
  }

  //MARK: verify wallet
  String deleteWallet(String id) {
    return getBaseUrl() + "wallets/$id/";
  }

  //MARK: edit wallet
  String editWallet(String id) {
    return getBaseUrl() + "wallets/$id/";
  }

  //MARK: resend wallet
  String resendWalletOtp(String id) {
    return getBaseUrl() + "wallets/$id/resend_wallet_otp/";
  }

  //MARK: verify recipient
  String verifyRecipient() {
    return getBaseUrl() + "users/verify_voucher_recipient/";
  }

  //MARK: buy voucher
  String buyVoucher() {
    return getBaseUrl() + "vouchers/purchase_voucher/";
  }

  //MARK: trasfer voucher
  String transferVoucher() {
    return getBaseUrl() + "vouchers/transfer_voucher/";
  }

  //MARK: redeem voucher
  String redeemVoucher() {
    return getBaseUrl() + "vouchers/redeem_voucher/";
  }

  //MARK: merchants vouchers
  String merchantVouchers(String id) {
    return getBaseUrl() + "merchants/$id/merchant_vouchers/";
  }

  //MARK: merchants search
  String merchantSearch() {
    return getBaseUrl() + "merchants/search_merchants/";
  }

  //MARK: voucher search
  String voucherSearch() {
    return getBaseUrl() + "vouchers/search_available_vouchers/";
  }

  //MARK: user notification
  String notification() {
    return getBaseUrl() + "users/notifications/";
  }

  //MARK: save notification token
  String saveToken() {
    return getBaseUrl() + "users/save_notification_token/";
  }

  //MARK: number of  unread
  String numberOfUnread() {
    return getBaseUrl() + "users/notifications/num_of_unread/";
  }

  //MARK: mark notification as read
  String markAsRead(String id) {
    return getBaseUrl() + "users/notifications/$id/mark_as_read/";
  }

  //MARK: voucher activities
  String voucherActivities() {
    return getBaseUrl() + "vouchers/filter_voucher_history/";
  }

  //MARK: main website
  String mainDomain() {
    return "https://www.afihc.org/";
  }

  //MARK: privacy site
  String privacyDomain() {
    return "https://www.afihc.org/";
  }
}
