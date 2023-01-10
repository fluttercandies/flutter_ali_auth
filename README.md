# flutter_ali_auth

Language: 中文

基于阿里云一键登录的 **Flutter集成的SDK插件**

阿里云一键登录安卓接入文档: [Android_V2.12-1.9](https://help.aliyun.com/document_detail/144231.html)

阿里云一键登录IOS接入文档: [iOS_V2.12.9](https://help.aliyun.com/document_detail/144186.html)

## 目录
* [效果图](#效果图-)
    * [IOS](#IOS)
    * [Android](#Android)
* [准备工作](#准备工作-)
* [原生SDK代码调用顺序](##先了解原生sdk代码调用顺序-)
* [插件使用](#插件使用-%EF%B8%8F)
    * [添加监听](#1-添加监听)
    * [初始化SDK配置密钥与UI](#2初始化sdk-initsdk)
    * [检查环境](#3一键登录获取token-login)
    * [预取号](#4检查认证环境-checkverifyenable)
    * [调起授权页面，获取Token](#5一键登录预取号-accelerateloginpage)
* [注意事项](#注意事项-%EF%B8%8F)


## 效果图 📷

### IOS

| 全屏 | 底部弹窗 | 中间弹窗 |
| --- | --- | --- |
| ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/full_screen_with_custom_view_ios.PNG "full_screen_image_ios") | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/bottomsheet_ios.PNG) | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/alert_ios.PNG) |

### Android

| 全屏 | 底部弹窗 | 中间弹窗 |
| --- | --- | --- |
| ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/full_screen_with_custom_view_android.jpg "full_screen_image_android") | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/bottomsheet_android.jpg) | ![](https://github.com/ManInTheWind/assets_repository/blob/main/images/project/alert_android.jpg) |

## 准备工作 🔧

请登录阿里云控制台[号码认证服务](https://dypns.console.aliyun.com/?spm=5176.13329450.favorite.ddypns.2fdd4df5w4jELK#/overview)
分别添IOS和Android的认证方案，从而获取到SDK的秘钥。
注意：Ios只需要输入绑定`Bundle name`即可，Android则需要包名和和签名。[如何获取App的签名](https://help.aliyun.com/document_detail/87870.html)

## 先了解原生SDK代码调用顺序 🔗
```java
/*
* 1.初始化获取Token实例
*/
TokenResultListener mTokenListener = new TokenResultListener();

/*
* 2.初始化SDK实例
*/
mAlicomAuthHelper = PhoneNumberAuthHelper.getInstance(context, mTokenListener);

/*
* 3.设置SDK密钥
*/
mAlicomAuthHelper.setAuthSDKInfo();

/*
* 4.检测终端⽹络环境是否⽀持⼀键登录或者号码认证，根据回调结果确定是否可以使⽤⼀键登录功能
*/
mAlicomAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper#SERVICE_TYPE_LOGIN);

/*
* 5.若步骤4返回true，则根据业务情况，调⽤预取号或者⼀键登录接⼝
*   详⻅Demo接⼊⼯程
*/
mAlicomAuthHelper.getLoginToken(context, 5000);
```

## 插件使用 ☄️


### 1. 添加监听
```dart
/// 传入回调函数 onEvent,onError(可选),onDone(可选)
AliAuthClient.onListen(_onEvent, onError: _onError);
```
在`onEvent`中监听回调并且自行进行判断
```dart
void _onEvent(dynamic event) async {
    final responseModel = AuthResponseModel.fromJson(Map.from(event));
    if (responseModel.resultCode == PNSCodeSuccess &&
        responseModel.token != null) {
      setState(() {
        _token = responseModel.token;
      });
    } else if (responseModel.resultCode == PNSCodeDecodeAppInfoFailed) {
      print(responseModel.msg)
    } else {
      print(responseModel.msg)
      print('code:${responseModel.resultCode}');
    }
}

``` 
回调实例`AuthResponseModel`
在原生中已经对事件响应码进行了包装，消息成员如下

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| resultCode | String | SDK返回码，600000表示操作成功（初始化/检查环境/预取号/登录成功）,详情参考官网的[SDK返回码](https://help.aliyun.com/document_detail/144186.html#section-24w-vwk-205) |
| requestId | String | SDK请求ID，如出现无法解决问题时候可以根据Id创建工单咨询|
| msg | String | SDK返回码描述，详情参考官网的[SDK返回码](https://help.aliyun.com/document_detail/144186.html#section-24w-vwk-205) |
| token | String | 在 **授权页面点击登录按钮成功** 认证后resultCode为60000时，会返回认证的Token,此时SDK提供的服务到此结束，可以拿Token到服务端进行自行判断登录认证|
| innerCode | String | 如果初始化认证SDK出现问题，回调信息一般会携带运行商的错误代码和错误信息，详情参考[运营商SDK错误码](https://help.aliyun.com/document_detail/85351.htm?spm=a2c4g.11186623.0.0.ab636cf0vQSEZO#topic2087)|
| innerMsg | String | 运行商认证时候出现的错误信息|


### 2.初始化SDK **(initSdk)**

```dart
/// 初始化前需要须对插件进行监听
await AliAuthClient.initSdk(
authConfig: const AuthConfig(),
);
```
需要通过 `AuthConfig` 来配置安卓和IOS端的秘钥，以及UI的配置 `AuthUIConfig`,成员如下

| 参数名 | 类型           | 描述                                                                                                                                      |
| --- |--------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| iosSdk | String       | IOS秘钥                                                                                                                                   |
| androidSdk | String       | Android秘钥                                                                                                                               |
| enableLog | bool         | 是否打印日志                                                                                                                                  |
| authUIStyle | Enum         | fullScreen(全屏) bottomSheet(底部弹窗) alert(中间弹窗) 目前暂时配置了三种常用竖屏的形式,更多形式参考[官方文档](https://help.aliyun.com/document_detail/144232.html) 后续将陆续支持 |
| authUIConfig | AuthUIConfig | UI配置类                                                                                                                                   |

`AuthUIConfig`为UI的配置类型,分为全屏UI配置 `FullScreenUIConfig` 和弹窗UI配置 `AlertUIConfig`

`FullScreenUIConfig` 成员如下

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| navConfig | NavConfig | 导航栏UI配置 |
| backgroundColor | String | 十六进制背景颜色,eg: "#ffffff" |
| backgroundImage | String | 本地的背景图片,eg: "/assets/image/background.png" |
| prefersStatusBarHidden | Boolean | 状态栏是否隐藏，默认显示 |
| logoConfig | LogoConfig | LogoUI配置类 |
| sloganConfig | SloganConfig | SloganConfig配置类 |
| phoneNumberConfig | PhoneNumberConfig | PhoneNumberConfig配置类 |
| loginButtonConfig | LoginButtonConfig | LoginButtonConfig配置类 |
| changeButtonConfig | ChangeButtonConfig | ChangeButtonConfig配置类 |
| checkBoxConfig | CheckBoxConfig | CheckBoxConfig配置类 |
| privacyConfig | PrivacyConfig | PrivacyConfig配置，自定义协议（目前只支持三个） |

`AlertUIConfig` 成员如下

| 参数名 | 类型 | 描述 |
| --- | --- | --- |
| alertTitleBarConfig | AlertTitleBarConfig | 弹窗ActionBar的UI配置 |
| alertContentViewColor | String | 十六进制背景颜色,eg: "#ffffff" |
| alertBlurViewColor | String | 弹窗蒙层的颜色,安卓暂时不支持 |
| alertBlurViewAlpha | double | 弹窗蒙层的透明度,安卓暂时不支持 |
| alertBorderRadius | double | 弹窗圆角，安卓暂时不支持 |
| alertWindowWidth | double | 弹窗宽度 |
| alertWindowHeight | double | 弹窗高度 |
| logoConfig | LogoConfig | LogoUI配置类 |
| sloganConfig | SloganConfig | SloganConfig配置类 |
| phoneNumberConfig | PhoneNumberConfig | PhoneNumberConfig配置类 |
| loginButtonConfig | LoginButtonConfig | LoginButtonConfig配置类 |
| changeButtonConfig | ChangeButtonConfig | ChangeButtonConfig配置类 |
| checkBoxConfig | CheckBoxConfig | CheckBoxConfig配置类，弹窗默认隐藏checkbox |
| privacyConfig | PrivacyConfig | PrivacyConfig配置，自定义协议（目前只支持三个） |


### 3.一键登录获取Token **(login)**

调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token,可选参数为Timeout,默认5s

调用此接口后会通过之前注册的监听中回调信息
```dart
await AliAuthClient.login();
```


### 4.检查认证环境 **(checkVerifyEnable)**

一般不需要主动调用检查，因为插件本身在初始化成功后马上进行**检查环境（checkVerifyEnable）**和**加速一键登录授权页弹起（accelerateLoginPage**），防止等待弹起授权页时间过长，这个逻辑与原生SDK一样，建议此方法在debug或者自行判断使用

调用此接口后会通过之前注册的监听中回调信息

```dart
await AliAuthClient.checkVerifyEnable();
```


### 5.一键登录预取号 **(accelerateLoginPage)**

一般不需要主动调用检查，因为插件本身在初始化成功后马上进行检查环境（checkVerifyEnable）和加速一键登录授权页弹起（accelerateLoginPage），防止等待弹起授权页时间过长，这个逻辑与原生SDK一样，建议此方法在debug或者自行判断使用

- 在不是一进app就需要登录的场景 建议调用此接口 加速拉起一键登录页面
- 等到用户点击登录的时候 授权页可以秒拉
- 预取号的成功与否不影响一键登录功能，所以不需要等待预取号的返回。

```dart
await AliAuthClient.accelerateLoginPage();
```

### 6.移除登录事件 **(removeListener)**

移除授权页的事件监听

```dart
await AliAuthClient.removeListener();
```

### 7.其他方法

下面的方法与官网接入文档一致，可以根据个人开发情况进行使用

```dart
/// 关闭授权页loading
await AliAuthClient.hideLoginLoading();

/// 退出授权认证页
await AliAuthClient.quitLoginPage();
```

## 插件须知 ⚠️
### 关于权限
1. 安卓权限，本插件已经添加必要的权限支持：
```xml
<uses-permission android:name="android.permission.INTERNET" /> <!-- 网络访问 -->
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> <!-- 检查wifi网络状态 -->
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> <!-- 检查网络状态 -->
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" /> <!-- 切换网络通道 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/> <!-- 本地信息缓存 -->
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> <!-- 开关Wi-Fi状态，解决中国内地机型移动网络权限问题需要 -->
```
  已经添加增加usesCleartextTraffic配置
```xml
 <application
        android:name=".DemoApplication"
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/AppTheme"
        android:usesCleartextTraffic="true">
```
>目前中国移动提供的个别接口为HTTP请求，对于全局禁用HTTP的项目，需要设置HTTP白名单。以下为运营商HTTP接口域名：onekey.cmpassport.com，enrichgw.10010.com，
详情可参见[官方文档](https://help.aliyun.com/document_detail/144231.html#section-no4-043-b31)

2.苹果开发

- 插件已经集成主库`ATAuthSDK.framework`，不需要添加`-ObjC`。

- 开发工具建议使用Xcode 11及以上。

- 支持iOS 10及以上系统。

## 最后，有用请🌟~




