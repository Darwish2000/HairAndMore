/// Defines all api paths available.
///
/// https://cgfyraknvt.eu08.qoddiapp.com/customers/registration
class ApiPaths {
  static const base = "cgfyraknvt.eu08.qoddiapp.com";
  // static const base = "localhost:3000";
  static const _customers = '/customers';
  static const _customerDetailsbyUID = '/customerDetailsbyUID';
  static const _registration = '/registration';
  static const _updateCustomerInfo = '/updateCustomerInfo';
  static const _addCustomerInfo = '/addCustomerInfo';
  static const _categories = '/categories';
  static const _updateCustomerFCM = '/updateCustomerFCM';
  static const _availableDays = '/availableDays';
  static const _workingdays = '/workingdays';
  static const _members_benefits = '/members_benefits';
  static const _courts = '/courts';
  static const _products = '/products';
  static const _booking = '/booking';
  static const _orders = '/orders';
  static const _rewards = '/rewards';
  static const _customer_type = '/customer_type';
  static const _become_amember = '/become_amember';
  static const _courtsdays = '/courtsdays';
  static const _courts_by_workingdays = '/findForMobile';
  static const _findCustomerByUID = '/findCustomerByUID';
  static const _createBooking = '/createBooking';

  static const _storeDiscountCoupons = '/store_discount_coupons';

  static const _points_transactions = '/points_transactions';
  static const _sub_points = '/sub_points';


  static const getCustomerUID = "$_customers$_findCustomerByUID";
  static const getRegistration = "$_customers$_registration";
  static const getUpdateCustomerInfo = "$_customers$_updateCustomerInfo";
  static const getAddCustomerInfo = "$_customers$_addCustomerInfo";
  static const getCategories = "$_categories";
  static const getUpdateCustomerFCM = "$_customers$_updateCustomerFCM";
  static const getAvailableDays = "$_workingdays$_availableDays";
  static const getMembers_benefits = "$_members_benefits";
  static const getCourts = "$_courts";
  static const getWorkingdays = "$_workingdays$_booking";
  static const getProducts = "$_products";
  static const getBookingCustomer = "$_booking";
  static const getOrdersCustomer = _orders;
  static const getRewardsCustomerType = '$_rewards$_customer_type';
  static const becomeAMember = '$_customers$_become_amember';
  static const getCourtsdaysByWorkingDayId = '$_courtsdays$_courts_by_workingdays';
  static const createBooking = '$_booking$_createBooking';
  static const redeemPoints = '$_points_transactions$_sub_points';
  //----------------------
  static const createOrder = "$_orders/createOrder";
  static const checkCoupon = "$_storeDiscountCoupons/checkCoupon";

/*  static clearDriver(String orderId) => "$_clearDriver/$orderId";
  static getProductReviews(String productId) => "$_reviewsBase/item/$productId";
  static updateProduct(String productId) => "$_updateProduct/$productId";
  static removeProduct(String productId) => "$_ItemsBase/$productId";
  static updateCategory(String catId) => "$_categoriesBase/$catId";
  static removeCategory(String catId) => "$_categoriesBase/$catId";
  static updateBrand(String id) => "$_brandBase/$id";
  static removeBrand(String id) => "$_brandBase/$id";
  static updateSubcategory(String id) => "$_subcategoriesBase/$id";
  static removeSubcategory(String id) => "$_subcategoriesBase/$id";
  static removeReview(String id) => "$_reviewsBase/$id";
  static updateOffer(String id) => "$_offerBase/$id";
  static activateOffer(String id) => "$_offerBase/activate/$id";
  static deactivateOffer(String id) => "$_offerBase/deactivate/$id";
  static removeOffer(String id) => "$_offerBase/$id";*/
}
