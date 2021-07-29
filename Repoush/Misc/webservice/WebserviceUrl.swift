//
//  WebserviceUrl.swift
//  ShibariStudy
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

// Client Base Url


//var BASE_URL = "http://pris24.com/pris24_app_ios/service/"

//var Privacy_BASE_URL = "http://pris24.com/pris24_app_ios/home/"


var BASE_URL = "http://pris24.com/pris24_app/service/"
var Privacy_BASE_URL = "http://pris24.com/pris24_app/home/"



let productDetail = BASE_URL + "get_product_detail"
let ProductBidDetail = BASE_URL + "get_productBidDetails"
let placeBid = BASE_URL + "place_bid"
let getAllUserProduct = BASE_URL + "getAllUserProducts"
let getAllUserHistoryProduct = BASE_URL + "getUserHistoryProducts"
let NotificationStatusAPI =  BASE_URL + "account_status/"
let getAllProductAPI = BASE_URL + "getAllProducts"
let getAllBidAPI = BASE_URL + "get_AllBid"
let getUpDateStatusAPI = BASE_URL + "update_status"
let getCheckOutAPI = BASE_URL + "checkout"
let getMakeOrderCompltedAPI = BASE_URL + "make_order_completed"
let getFeedbackAPI = BASE_URL + "feedback_seller"
let getOtherUserDetailAPI = BASE_URL + "getOtherUserDetail"
let deleteProductAPI = BASE_URL + "deleteProduct"
let getCategoryAPI = BASE_URL + "getCategory"
let getSubCategory = BASE_URL + "getSubCategory"
let getPropertyAPI = BASE_URL + "property_details"
let getEditProductAPI = BASE_URL + "editProduct"
let getDeleteProductAPI = BASE_URL + "deleteProductImage"
let getPosProductAPI = BASE_URL + "postProduct"
let getProductCommentListAPI = BASE_URL + "product_comment_list"
let getProductCommnetAPI = BASE_URL + "product_comment"
let getSellerHistoryRepostAPI = BASE_URL + "repost_product"
let getUserProfileAPI = BASE_URL + "get_userDetail"
let getSendOTPAPI = BASE_URL + "send_otp"
let getChangeEmailAPI = BASE_URL + "user_change_email"
let getResendAPI = BASE_URL + "resendOtp"
let getUserChangeEmailVeryfyOtpAPI = BASE_URL + "user_change_email_verify_otp"
let getUpdateUserProfileAPI = BASE_URL + "update_userProfile"
let getDeleteCommentAPI = BASE_URL + "delete_product_reply_comment"
let getAllBuyerAPI = BASE_URL + "get_AllBidBuyer"
let getBidCancelAPI = BASE_URL + "bid_cancel"
let getVerifiOtpAPI = BASE_URL + "verify_forgot_otp"
let shareAuction =  Privacy_BASE_URL + "share_auction/"
let SetNewPasswordPassword =  BASE_URL + "setNewpassword"

let userNotificationStatusAPI =  BASE_URL + "user_notification_status"


let getOfferList =  BASE_URL  + "offer_list"
let getOfferListDetail =  BASE_URL  + "offer_list_user"
let getsentNotificationAllUser =  BASE_URL  + "notification_template?"
let AskQuedtionCommnetUpdate =  BASE_URL  + "product_comment_update?"
let forgotPasswordAPI =  BASE_URL  + "forgotPassword?"
let checkPromocodeAPI =  BASE_URL  + "check_promo?"
let personalUserNotificationListAPI =  BASE_URL  + "get_notification_list?"

let getPrivacyEnglishAPI = Privacy_BASE_URL + "privacy_policy_en"
let getPrivacyDanishAPI = Privacy_BASE_URL + "privacy_policy_da"
let getPrivacyProfessionalEnglishAPI = Privacy_BASE_URL + "privacy_policy_en"
let getProfessionalDanishAPI = Privacy_BASE_URL + "privacy_policy_da"

let getTermsConditionsEnglishAPI = Privacy_BASE_URL + "terms_conditions_en"
let getTermsConditionsDanishAPI = Privacy_BASE_URL + "terms_conditions_da"
let getTermsConditionsProfessionalEnglishAPI = Privacy_BASE_URL + "professional_terms_conditions_en"
let getTermsConditionsProfessionalDanishAPI = Privacy_BASE_URL + "professional_terms_conditions_da"

let getReceivedNotificationTemplate =  Privacy_BASE_URL  + "get_notification_template_new?"
let getsentTNotificationTemplate =  Privacy_BASE_URL  + "get_notification_template?"

