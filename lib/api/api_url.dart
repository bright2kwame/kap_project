class ApiUrl {
  //MARK: get the base url
  String getBaseUrl() {
    var baseTestUrl = "https://somtinsomtin-api.herokuapp.com/api/v1.0/";
    var baseLiveUrl = "https://somtinsomtin-api.herokuapp.com/api/v1.0/";
    const bool _kReleaseMode = const bool.fromEnvironment("dart.vm.product");
    return _kReleaseMode ? baseTestUrl : baseLiveUrl;
  }

  //MARK: check number url
  String checkPhone() {
    return getBaseUrl() + "users/check_phone_number/";
  }

  //MARK: verify number url
  String verifyPhoneumber() {
    return getBaseUrl() + "users/verify_phone_number/";
  }

  //MARK: verify number url
  String resendVerificationCode() {
    return getBaseUrl() + "users/resend_signup_verification/";
  }

  //MARK: complete sign up url
  String completeSignUp() {
    return getBaseUrl() + "mobile/users/register_or_login/";
  }

  //MARK: saving player id
  String playerId() {
    return getBaseUrl() + "users/save_player_id/";
  }

  //MARK: my profile url
  String myProfile() {
    return getBaseUrl() + "mobile/users/me/";
  }

  //MARK: change password
  String changePassword() {
    return getBaseUrl() + "users/change_password/";
  }

  //MARK: init password reset
  String initPasswordReset() {
    return getBaseUrl() + "users/forgot_password/";
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
