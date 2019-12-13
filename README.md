# react-native-face-aliverify
    基于阿里金融级实人认证sdk封装分享
# 小序
    最初玩RN还是在2017 那时RN版本还在0.4x.x 时间过得确实有点快 最近接了一个RN的项目 不得不再来调研一下RN 好家伙现在已经0.61.5 我这个项目
    大体会用到四个核心模块 1.活体认证 2.支付 3.定位 4.升级服务 好久没玩 宝刀已老 对接活体认证 一个坑 坑我N天 所以记录一下 分享到github
# 关于RN版本选择
    RN 0.60 是一个里程碑 性能 底层库都有所优化 综合考虑 我选择 0.57.7
    小提示：RN versions (0.57, 0.58 (<0.58.4), …) with Xcode 10.3 可能会run-ios的时候提示找不到模拟器
[点击查看 解决方案](https://www.bram.us/2019/09/04/react-native-could-not-find-iphone-x-simulator/)
# 步入正题
.
├── App.js
├── README.md
├── android
├── app.json
├── index.js
├── ios
├── modules
├── node_modules
├── package.json
└── yarn.lock
## android 
新建modules文件夹 里面放的就是集成活体认证的代码
aliface 一个Android的静态库
注意：build.gradle
1. minSdkVersion 18 最小支持为18
2. dependencies 依赖依然使用support不使用androidx

如果拷贝代码 在加载类库后请检查aliface 类库build.gradle是否发生变化

### 加载aliface类库
在android - setting.gradle 添加如下代码 相当于link

include ':aliface'
project(':aliface').projectDir = new File(rootProject.projectDir, '../modules/aliface')

### 主项目添加aliface依赖
在主项目build.gradle下添加
implementation project(":aliface")

### MainApplication.java 注册package
主项目mainapplication.java 的getPackages添加

,new FacePackage()

### 亲测截图
![11576124551_.pic](./assets/11576124551_.pic.jpg)

![21576124552_.pic](./assets/21576124552_.pic.jpg)

![41576124553_.pic](./assets/41576124553_.pic.jpg)

![31576124553_.pic](./assets/31576124553_.pic.jpg)

![61576124555_.pic](./assets/61576124555_.pic.jpg)

![71576124556_.pic](./assets/71576124556_.pic.jpg)

## IOS

ios比较繁琐一些 不过还好 一步一步来 搞定它

### 添加相机使用权限

Privacy - Camera Usage Description

![1](/assets/1.png)

### 在 Xcode 的编译设置中关闭 Bitcode 选项。

![2](/assets/2.jpg)

### 在 Xcode 编译设置的 Linking > Other Linker Flags 中，添加设置 -ObjC -framework "BioAuthAPI" -lxml2

![3](/assets/3.png)

### 添加 framework 文件和 bundle 文件

1. 引入 SDK 中 frameworks 文件夹下所有的 framework 到工程之中。
2. 





