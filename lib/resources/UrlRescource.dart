class UrlRescource{
  //company  ip address
  static String BASE_URL = "http://192.168.1.8/brighttails/api/";
  static String BASE_IMG_URL = "http://192.168.1.8/brighttails/admin/uploads/";
  // home ip address
  // static String BASE_URL = "http://192.168.1.8/brighttails/api/";
  // static String BASE_IMG_URL = "http://192.168.1.8/brighttails/admin/uploads/";
  // phone ip address
  // static String BASE_URL = "http://192.168.205.112/brighttails/api/";
  // static String BASE_IMG_URL = "http://192.168.205.112/brighttails/admin/uploads/";

  //images folders
  static String HOSPITALIMG = BASE_IMG_URL + "hospital/";
  static String PRODUCTIMG = BASE_IMG_URL + "products/";
  static String DOCTORIMG = BASE_IMG_URL + "doctor/";
  static String PETIMG = BASE_IMG_URL + "pet/";
  static String ARTICLEIMG = BASE_IMG_URL + "article/";
  static String ANIMALIMG = BASE_IMG_URL + "animal/";
  static String USERIMG = BASE_IMG_URL + "user/";
  static String CATEGORYIMG = BASE_IMG_URL + "category/";
  static String BRANDIMG = BASE_IMG_URL + "brand/";

  //login and register side
  static String LOGIN = BASE_URL + "login.php";
  static String REGISTER = BASE_URL + "register.php";

  //forgot password
  static String FORGOTPASSWORD = BASE_URL + "forgotpassword.php";

  //change password
  static String CHANGEPASSWORD = BASE_URL + "changepassword.php";

  //hospital module
  static String ALLHOSPITAL = BASE_URL + "allhospital.php";
  static String ADDAPPOINTMENT = BASE_URL + "appointmentform.php";
  static String ALLHOSPITALTIMING = BASE_URL + "allhospitaltiming.php";

  //product module
  static String ALLCATEGORY = BASE_URL + "allcategory.php";
  static String ALLSUBCATEGORY = BASE_URL + "allsubcategory.php";
  static String ALLPRODUCT = BASE_URL + "allproducts.php";
  static String ADDTOCART = BASE_URL + "addtocart.php";

  //product wishlist
  static String ALLWISHLIST = BASE_URL + "allwishlist.php";
  static String INSERTWISHLIST = BASE_URL + "insertwishlist.php";
  static String DELETEWISHLIST = BASE_URL + "deletewishlist.php";
  static String DELEWISHLIST = BASE_URL + "delwishlist.php";

  //doctor module
  static String ALLDOCTOR = BASE_URL + "alldoctor.php";

  //cart and check out module
  static String ALLCART = BASE_URL + "allcart.php";
  static String DELETECART = BASE_URL + "deletecart.php";
  static String ADDCHECKOUT = BASE_URL + "addcheckout.php";
  static String ALLCHECKOUT = BASE_URL + "allcheckout.php";

  //coupon module
  static String ALLCOUPON = BASE_URL + "allcoupon.php";
  static String ALLCOUPONDATA = BASE_URL + "allcoupondata.php";

  //pets module
  static String ALLANIMAL = BASE_URL + "allanimaldata.php";
  static String ALLBREED = BASE_URL + "allbreed.php";
  static String ALLPET = BASE_URL + "allpet.php";
  static String ALLPETDATA = BASE_URL + "allpetdata.php";
  static String ADDINQUIRY = BASE_URL + "inquiryform.php";
  static String ADDANIMALPRODUCT = BASE_URL + "animalproduct.php";

  //article module
  static String ALLARTICLE = BASE_URL + "allarticle.php";

  //faq module
  static String ALLFAQ = BASE_URL + "allfaq.php";

  //city module
  static String ALLCITYDATA = BASE_URL + "allcitydata.php";

 //my profile module
  static String ALLMYPROFILEVIEW = BASE_URL + "allmyprofileview.php";

  //brand and product for brand module
  static String ALLBRAND = BASE_URL + "allbrand.php";
  static String ALLBRANDPRODUCT = BASE_URL + "allbrandproduct.php";

  //my order module
  static String ALLMYORDER = BASE_URL + "allmyorder.php";
  static String ALLITEM = BASE_URL + "allitem.php";
  static String ALLTRACK = BASE_URL + "alltrack.php";

}
