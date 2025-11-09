# 名侦探柯南案件手册

一个展示《名侦探柯南》案件信息的iOS应用，提供案件详情查看和音频播放功能。

## 功能特点

- 📱 精美的案件卡片式浏览界面
- 🔍 查看详细案件信息，包括标题、描述和相关图片
- 🎧 内置音频播放器，支持播放案件相关音频
- 📚 案件分类展示，方便查找
- 🎨 精美的UI设计，优化用户体验

## 技术栈

- 开发语言: Swift
- 最低支持版本: iOS 12.0+
- 主要框架:
  - UIKit: 构建用户界面
  - AVFoundation: 音频播放功能
  - SwiftyJSON: JSON数据处理
  - SnapKit: 自动布局

## 项目结构

```
conan/
├── AppDelegate.swift           # 应用委托
├── Component/                 # 自定义组件
│   ├── AudioPlayer/           # 音频播放器组件
│   │   ├── AudioPlayer.swift
│   │   └── AudioPlayerViewController.swift
│   ├── IncidentItem.swift     # 案件项视图
│   ├── TriangleView.swift     # 三角形视图组件
│   └── noticeCollectionReusableView.swift # 通知视图
├── Controller/
│   └── CaseCardViewController.swift # 案件卡片视图控制器
├── Model/
│   ├── CaseBook.swift         # 案件数据模型
│   ├── Incident.swift         # 案件详情模型
│   └── IncidentLoader.swift   # 案件数据加载
└── ViewController.swift       # 主视图控制器
```

## 安装说明

1. 确保已安装 Xcode 12.0 或更高版本
2. 克隆本仓库到本地
3. 打开 `conan.xcodeproj` 文件
4. 选择目标设备或模拟器
5. 点击运行按钮 (⌘ + R) 编译并运行应用

## 使用说明

1. 启动应用后，您将看到案件卡片列表
2. 左右滑动可浏览不同的案件卡片
3. 点击卡片可查看案件详情
4. 在详情页面，您可以：
   - 查看案件标题和描述
   - 浏览相关图片
   - 使用底部的音频播放器收听案件相关音频

## 贡献指南

欢迎提交 Issue 和 Pull Request。对于重大更改，请先开启 Issue 讨论您想要更改的内容。

## 致谢

- 感谢《名侦探柯南》创作团队
- 感谢所有贡献者和用户的支持
