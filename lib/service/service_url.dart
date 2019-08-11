// const serviceBaseUrl = 'http://192.168.1.127:8086';
const serviceBaseUrl = 'http://192.168.1.104:8086';
const servicePath = {
  'login': serviceBaseUrl + '/account/login',                                 // 登录
  'getSmsCode': serviceBaseUrl + '/account/getSmsCode',                       // 获取验证码
  'register': serviceBaseUrl + '/account/register',                           // 注册/重置密码
  'exitLogin': serviceBaseUrl + '/account/exitLogin',                         // 退出登录
  'getHomePage': serviceBaseUrl + '/home/getHomePage',                        // 获取首页数据
  'getStoreIndustryList': serviceBaseUrl + '/store/getStoreIndustryList',     // 获取门店类型
  'getPageStore': serviceBaseUrl + '/store/getPageStore',                     // 获取门店列表
  'getPageSearchStore': serviceBaseUrl + '/store/getPageSearchStore',         // 搜索门店列表
  'getPersonAndAdList': serviceBaseUrl + '/person/getPersonAndAdList',        // 获取基本信息与广告
  'upDateAvatar': serviceBaseUrl + '/person/upDateAvatar',                    // 修改头像
  'getPersonInfo': serviceBaseUrl + '/person/getPersonInfo',                  // 获取用户基本信息
  'upDateNikeName': serviceBaseUrl + '/person/upDateNikeName',                // 修改昵称
  'upDateMailbox': serviceBaseUrl + '/person/upDateMailbox',                  // 修改邮箱
  'upDatePassword': serviceBaseUrl + '/person/upDatePassword',                // 修改密码
  'authentication': serviceBaseUrl + '/person/authentication',                // 实名认证
  'getAuthenticationInfo': serviceBaseUrl + '/person/getAuthenticationInfo',  // 获取实名信息
  'getMyAssets': serviceBaseUrl + '/person/getMyAssets',                      // 获取我的资产
  'complaints': serviceBaseUrl + '/person/complaints',                        // 意见投诉
  'getMessage': serviceBaseUrl + '/person/getMessage',                        // 获取个人消息，通告消息
  'getMyTeamAchievement': serviceBaseUrl + '/person/getMyTeamAchievement',    // 获取我的团队总业绩
  'getMyTeam': serviceBaseUrl + '/person/getMyTeam',                          // 获取我的团队
  'getOrderPage': serviceBaseUrl + '/order/getOrderPage',                     // 获取订单列表
  'getOrderDetailById': serviceBaseUrl + '/order/getOrderDetailById',         // 获取订单详情
};