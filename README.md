# yingdan_ios

##五天影记重构的任务列表, 完全不用担心完不成, 呵呵

###以下的内容, 大部分的核心代码都有, 你都不用重新写, 模型也有
- 第一天 搭框架, 使用友盟调用登录接口									已完成 2015-03-01
	+ 搭框架是指做出登录页面的UI, 以及主页的UI, 分四个页面
	+ 登录功能, 调用sso登录, 获取信息, 然后请求api, 登录成功则保存信息
- 第二天 电影列表页面, 通知页面 搜索电影								2015-03-01
	+ 两个页面的展示, 以及一个搜索功能
- 第三天 首页最新展示													2015-03-02
	+ 适配还没做
- 第四天 点赞功能 友盟分享图片功能 添加弹幕功能						2015-03-03
	+ 点赞功能已实现功能, UI还没同步
	+ 分享图片这一块, 功能基本实现, 等待需求最终确定
	+ 添加弹幕功能只需要一个页面, 输入内容, 可以移动位置, 即可发布
- 第五天 将第三天第四天没完成的完成一下就行							2015-03-04



###以后会学到的东西
* 省流量, 提升用户的体验
* git的使用, github的使用
* 本地缓存解决方案 http://realm.io
* 代码规范
* 注释编写, 生成文档
* 单元测试的书写
* xcode的xvim插件的使用
* 加密传输
* token获取api数据
* UITableView的优化, 图片加载缩略图
* 了解又拍云提供的图片缩略图
* 了解友盟的登录与分享功能
* 注重程序的效率, 代码的整洁

* 图片资源
* icon
* tabbar icon
* 登录的两个按钮, 4张图片, 正常的和高亮时候的

1. 开始搭框架, 一个主的navigation, 登录页作为根页面, 登录成功之后跳转到tabbarviewcontroller(首页), 首页包括四个navigationcontroller
2. 框架搭好了之后做登录页面, 用自动布局, 适配 
3. 登录页面好了之后使用友盟的sso
4. 友盟登录了之后使用afnetworking请求api, 进行跳转


