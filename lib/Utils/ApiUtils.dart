class ApiUtils {

  static const String BASE = "https://apptocom.com/novelflex2/api/v1";
  static const String URL_REGISTER_READER_API = '$BASE/reader/register';
  static const String URL_REGISTER_WRITER_API = '$BASE/writer/register';
  static const String URL_LOGIN_USER_API = '$BASE/user/login';
  static const String CHECK_STATUS_API = '$BASE/user/check_user_status';
  static const String USER_SOCIAL_REGISTER = '$BASE/user/google/register';
  static const String USER_SOCIAL_LOGIN = '$BASE/user/googlelogin';
  static const String ALL_HOME_CATEGORIES_API = '$BASE/home/alldetails';
  // static const String ALL_HOME_CATEGORIES_API = '$BASE/home/category/books';
  static const String ALL_BOOKS_CATEGORIES_API = '$BASE/home/categoriesWiseBooksById';
  static const String SEARCH_CATEGORIES_API = '$BASE/categories/all';
  static const String SEARCH_AUTHOR_BY_CATEGORIES_ID_API = '$BASE/author/getByCategories';
  static const String GENERAL_CATEGORIES_NAME_API = '$BASE/categories/subcategory';
  static const String SEARCH_SUB_CATEGORIES_API = '$BASE/home/subcategory/books';
  static const String PROFILE_AUTHOR_API = '$BASE/author/profile';
  static const String EDIT_PROFILE_ = '$BASE/author/update/profile';
  static const String DELETE_ACCOUNT_PROFILE_API = '$BASE/author/delete/account';
  static const String BOOK_DETAIL_API = '$BASE/book/details';
  static const String LIKES_AND_DISLIKES_API = '$BASE/book/likesDislikes/add';
  static const String AUTHOR_PROFILE_VIEW = '$BASE/author/profile';
  static const String MAIN_CATEGORIES_DROPDOWN_API = '$BASE/categories/alls';
  static const String ADD_IMAGE_WITH_FILED_API = '$BASE/book/add';
  static const String PDF_UPLOAD_API = '$BASE/book/uploadFile';
  static const String DROPDOWN_SUB_CATEGORIES_API = '$BASE/categories/subcategories';
  static const String AUTHOR_BOOKS_DETAILS_API = '$BASE/author/bookLinkDetail';
  static const String SAVE_BOOK_API = '$BASE/book/saved';
  static const String READER_PROFILE_API = '$BASE/book/getReaderProfile';
  static const String CHECK_PROFILE_STATUS_API = '$BASE/home/checkUserType';
  static const String UPLOAD_BACKGROUND_IMAGE_API = '$BASE/author/backgroundImage';
  static const String SAVED_BOOKS_API = '$BASE/book/all-saved';
  static const String LIKES_BOOKS_API = '$BASE/book/all-liked';
  static const String UPLOAD_BOOKS_HISTORY = '$BASE/author/books/all';
  static const String EDIT_BOOKS_API = '$BASE/book/getBooksById';
  static const String UPLOAD_BOOK_IMAGE = '$BASE/book/update/book-Image';
  static const String UPDATE_FIELDS_BOOK_API = '$BASE/book/book-update';
  static const String DELETE_PDF_API = '$BASE/book/deleteChapter';
  static const String DELETE_BOOK_API = '$BASE/book/deleteBook';
  static const String STRIPE_PAYMENT_API = '$BASE/user/subscription/payment';
  static const String USER_SUBSCRIPTION_API = '$BASE/user/subscription';
  static const String FORGET_PASSWORD_API = '$BASE/user/reset_password';
  static const String UPDATE_PASSWORD_API = '$BASE/user/change_password';
  static const String USER_REFERRAL_API = '$BASE/user/subscription/referral';
  static const String USER_CHECK_SUBSCRIPTION_API = '$BASE/user/subscription/check';
  static const String ALL_CHAPTERS_API = '$BASE/book/chapters';
  static const String USER_PAYMENT_API = '$BASE/user/subscription/amount';
  static const String USER_PAYMENT_WITHDRAW_API = '$BASE/user/subscription/withdrawAmount';
  static const String USER_STATUS_API = '$BASE/user/follow/checkUserStatus';
  static const String FOLLOW_AND_UNFOLLOW_API = '$BASE/user/follow';
  static const String ALL_NOTIFICATIONS = '$BASE/notifications/all';
  static const String NOTIFICATIONS_COUNT = '$BASE/notifications/count';
  static const String SEEN_NOTIFICATIONS_COUNT = '$BASE/notifications/read?all';
  static const String SEARCH_AUTHORS = '$BASE/author/all';
  static const String ALL_RECENT_API = '$BASE/home/recently/book/all';
  static const String SLIDER_API = '$BASE/guest';
  // static const String SLIDER_API = '$BASE/home/slider';
  // static const String RECENT_API = '$BASE/home/recently/book';
  static const String RECENT_API = '$BASE/recentlyBook';
  static const String PROFILE_IMAGE_UPDATE_API = '$BASE/author/update/image';
  static const String MENU_PROFILE_API = '$BASE/tab/userProfile';
  static const String BOOK_VIEW_API = '$BASE/book/views/add';
  static const String GIFT_API = '$BASE/user/subscription/gifts';
  static const String GIFT_PAYMENT = '$BASE/user/subscription/userGiftAmount';
  static const String PAYMENT_APPLY_API = '$BASE/user/subscription/applyWithdrawAmount';
  static const String TOTAL_FOLLOWERS_API = '$BASE/user/follow/totalFollower';
  static const String TOTAL_GIFTS_API = '$BASE/user/follow/totalGifts';
  static const String SEE_ALL_REVIEWS_API = '$BASE/comments';
  static const String ADD_REVIEW_API = '$BASE/comment/store';
  static const String AGREEMENT_API = '$BASE/updata/status';
  static const String UPLOAD_AUDIO_API = '$BASE/book/uploadAudioFile';
  static const String UPLOAD_TEXT_BOOK = '$BASE/book/uploadTextFile';
  static const String GET_AUDIO_BOOK = '$BASE/book/audio';
  static const String GET_TEXT_BOOK = '$BASE/book/text';
  static const String UPDATE_AUDIO_BOOK = '$BASE/book/update/audio';
  static const String UPDATE_TEXT_BOOK = '$BASE/book/update/text';
  static const String GET_LINKS = '$BASE/social';
  static const String UPDATE_LINKS = '$BASE/updata/social';
  static const String ADD_PRIVATE_ADS_API = '$BASE/advertisment/add';






}