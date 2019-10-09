// const serviceBaseUrl = 'http://192.168.1.127:8086';
const serviceBaseUrl = 'http://192.168.1.109:8086';
// const serviceBaseUrl = 'http://192.168.1.107:8086';
const servicePath = {
  'login': serviceBaseUrl + '/account/login',                                                         // 登录
  'getSmsCode': serviceBaseUrl + '/account/getSmsCode',                                               // 获取验证码
  'register': serviceBaseUrl + '/account/register',                                                   // 注册/重置密码
  'exitLogin': serviceBaseUrl + '/account/exitLogin',                                                 // 退出登录
  'getHomePage': serviceBaseUrl + '/home/getHomePage',                                                // 获取首页数据
  'getStoreIndustryList': serviceBaseUrl + '/store/getStoreIndustryList',                             // 获取门店类型
  'getPageStore': serviceBaseUrl + '/store/getPageStore',                                             // 获取门店列表
  'getPageSearchStore': serviceBaseUrl + '/store/getPageSearchStore',                                 // 搜索门店列表
  'getShopTypeAndEssentialMessage': serviceBaseUrl + '/store/getShopTypeAndEssentialMessage',         // 门店分类，详情，是否关注
  'followAndCleanFollow': serviceBaseUrl + '/store/followAndCleanFollow',                             // 关注与取消关注
  'getCommodityPageByCommodityTypeId': serviceBaseUrl + '/store/getCommodityPageByCommodityTypeId',   // 获取门店商品列表
  'getCommodityNewestPrice': serviceBaseUrl + '/store/getCommodityNewestPrice',                       // 获取商品最新价格
  'addStoreForUnlicensed': serviceBaseUrl + '/store/addStoreForUnlicensed',                           // 添加无证共享店
  'addStore': serviceBaseUrl + '/store/addStore',                                                     // 添加有证共享店
  'authenticationStore': serviceBaseUrl + '/store/authenticationStore',                               // 认证共享店
  'addCommodityType': serviceBaseUrl + '/store/addCommodityType',                                     // 添加商品类型
  'editCommodityType': serviceBaseUrl + '/store/editCommodityType',                                   // 修改商品类型
  'deleteCommodityType': serviceBaseUrl + '/store/deleteCommodityType',                               // 删除商品类型
  'addCommodity': serviceBaseUrl + '/store/addCommodity',                                             // 添加商品
  'editCommodity': serviceBaseUrl + '/store/editCommodity',                                           // 修改商品
  'deleteCommodity': serviceBaseUrl + '/store/deleteCommodity',                                       // 删除商品
  'upperShelfAndLowerShelf': serviceBaseUrl + '/store/upperShelfAndLowerShelf',                       // 上架或下架：0下架，1 上架
  'getQiNiuToken': serviceBaseUrl + '/store/getQiNiuToken',                                           // 获取七牛云上传文件Token
  'getMyStorePage': serviceBaseUrl + '/store/getMyStorePage',                                         // 获取我的共享店
  'getStoreById': serviceBaseUrl + '/store/getStoreById',                                             // 获取门店
  'editCommodityDetail': serviceBaseUrl + '/store/editCommodityDetail',                               // 编辑商品详情
  'editStoreDescription': serviceBaseUrl + '/store/editStoreDescription',                             // 编辑门店详情
  'getMyFollowPage': serviceBaseUrl + '/store/getMyFollowPage',                                       // 获取我的关注门店列表
  'getPersonAndAdList': serviceBaseUrl + '/person/getPersonAndAdList',                                // 获取基本信息与广告
  'upDateAvatar': serviceBaseUrl + '/person/upDateAvatar',                                            // 修改头像
  'getPersonInfo': serviceBaseUrl + '/person/getPersonInfo',                                          // 获取用户基本信息
  'upDateNikeName': serviceBaseUrl + '/person/upDateNikeName',                                        // 修改昵称
  'upDateMailbox': serviceBaseUrl + '/person/upDateMailbox',                                          // 修改邮箱
  'upDatePassword': serviceBaseUrl + '/person/upDatePassword',                                        // 修改密码
  'authentication': serviceBaseUrl + '/person/authentication',                                        // 实名认证
  'getAuthenticationInfo': serviceBaseUrl + '/person/getAuthenticationInfo',                          // 获取实名信息
  'getMyAssets': serviceBaseUrl + '/person/getMyAssets',                                              // 获取我的资产
  'complaints': serviceBaseUrl + '/person/complaints',                                                // 意见投诉
  'getMessage': serviceBaseUrl + '/person/getMessage',                                                // 获取个人消息，通告消息
  'getMyTeamAchievement': serviceBaseUrl + '/person/getMyTeamAchievement',                            // 获取我的团队总业绩
  'getMyTeam': serviceBaseUrl + '/person/getMyTeam',                                                  // 获取我的团队
  'saveReceivingAddress': serviceBaseUrl + '/person/saveReceivingAddress',                            // 添加收货地址
  'getReceivingAddressListByUId': serviceBaseUrl + '/person/getReceivingAddressListByUId',            // 获取收货地址
  'deleteReceivingAddressById': serviceBaseUrl + '/person/deleteReceivingAddressById',                // 删除收货地址
  'updateReceivingAddress': serviceBaseUrl + '/person/updateReceivingAddress',                        // 修改收货地址
  'authenticationPhone': serviceBaseUrl + '/person/authenticationPhone',                              // 认证手机号
  'getOrderPage': serviceBaseUrl + '/order/getOrderPage',                                             // 获取订单列表
  'getOrderDetailById': serviceBaseUrl + '/order/getOrderDetailById',                                 // 获取订单详情
  'applogin': serviceBaseUrl + '/mp/applogin',                                                        // 微信登录
  'wxPay': serviceBaseUrl + '/wxApi/wxPay',                                                           // 微信统一下单
};