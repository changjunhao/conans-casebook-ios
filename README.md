# 柯南事件簿

一款精美的《名侦探柯南》剧场版案件信息展示 iOS 应用。以卡片滑动浏览的方式呈现每一部剧场版的详细信息，支持案件详情查看与音频播放。

## 功能特性

- **卡片式案件浏览** — 基于 `UIPageViewController` 的左右滑动卡片交互，每部剧场版一张卡片
- **案件详情页** — 展示剧场版标题、描述、插图，内置音频播放器
- **静候上线机制** — 尚未上线的剧场版以灰度卡片展示，点击弹出"静候上线"提示
- **导航协调器** — 使用 Coordinator 模式统一管理页面跳转与模态弹出
- **多语言支持** — 通过 String Catalog (`Localizable.xcstrings`) 实现本地化
- **暗色模式适配** — 全面支持 Light / Dark 外观

## 技术栈

| 类别 | 技术 |
|------|------|
| 语言 | Swift |
| 最低版本 | iOS 13.0+（UIScene 生命周期） |
| UI 框架 | UIKit |
| 音频 | AVFoundation |
| 图片加载 | Kingfisher 8.x |
| 自动布局 | SnapKit 6.x |
| 架构模式 | Coordinator + Service 分层 |
| 生命周期 | UIScene（SceneDelegate） |
| 本地化 | String Catalog (`.xcstrings`) |
| 依赖管理 | Swift Package Manager |

## 项目结构

```
conan/
├── AppDelegate.swift              # 应用入口
├── SceneDelegate.swift            # UIScene 生命周期管理
├── Coordinator/
│   └── AppCoordinator.swift       # 导航协调器
├── Controller/
│   ├── CaseBookListViewController.swift  # 案件卡片列表（主页）
│   ├── CaseCardViewController.swift      # 单张案件卡片
│   └── IncidentViewController.swift      # 案件详情页
├── Model/
│   ├── CaseBook.swift             # 剧场版数据模型
│   ├── Incident.swift             # 案件详情模型
│   └── IncidentLoader.swift       # 案件数据加载器
├── Service/
│   ├── APIConfiguration.swift     # API 地址与资源路径配置
│   ├── CaseBookService.swift      # 剧场版数据服务
│   └── IncidentService.swift      # 案件详情数据服务
├── Component/
│   ├── AudioPlayer/               # 音频播放器组件
│   │   ├── AudioPlayer.swift
│   │   └── AudioPlayerViewController.swift
│   ├── CardLayout.swift           # 卡片布局计算
│   ├── IncidentItem.swift         # 案件列表项视图
│   ├── NoticeCollectionReusableView.swift
│   ├── ReuseIdentifier.swift      # 复用标识符
│   └── TriangleView.swift         # 三角形装饰视图
├── Resources/
│   └── Localizable.xcstrings      # 多语言字符串目录
└── Assets.xcassets/               # 图片资源
```

## 架构设计

项目采用 **Coordinator + Service** 分层架构：

```
SceneDelegate
    └── AppCoordinator          ← 统一导航管理
        ├── CaseBookService     ← 剧场版数据提供
        └── IncidentService     ← 案件详情数据提供
```

- **AppCoordinator** 负责所有页面跳转逻辑，包括详情页弹出与"静候上线"提示
- **Service 层** 通过协议（`CaseBookProviding`、`IncidentProviding`）解耦，便于测试与替换
- **数据模型** 均为不可变值类型（`struct` + `let`），保证数据安全

## 快速开始

### 环境要求

- Xcode 15.0+
- iOS 13.0+
- Swift 5.9+

### 运行步骤

1. 克隆仓库
   ```bash
   git clone https://github.com/your-username/conans-casebook-ios.git
   ```
2. 打开项目
   ```bash
   open conan.xcodeproj
   ```
3. 等待 Swift Package Manager 自动解析依赖（Kingfisher、SnapKit）
4. 选择模拟器或真机，按 `⌘ + R` 运行

## 使用说明

1. 启动应用后进入卡片列表主页
2. **左右滑动**浏览不同剧场版卡片
3. 点击底部按钮或卡片：
   - 已上线的剧场版 → 进入案件详情页，可查看标题、描述、插图并播放音频
   - 未上线的剧场版 → 弹出"静候上线"提示
4. 在详情页可使用底部音频播放器收听案件相关音频

## 测试

项目包含完善的单元测试，覆盖模型、服务层、组件和协调器等核心模块：

```bash
xcodebuild test -project conan.xcodeproj -scheme conan -destination 'platform=iOS Simulator,name=iPhone 16'
```

## 许可

### 源代码许可

本项目源代码采用 [PolyForm Noncommercial License 1.0.0](LICENSE) 许可，禁止一切商业使用。允许非商业性的复制、修改与分发（学习、研究、个人项目等）。详见项目根目录 `LICENSE` 文件。

### 知识产权声明

《名侦探柯南》（名探偵コナン）相关版权、商标及其他知识产权归原著作权方所有，包括但不限于：

- 青山刚昌（原作者）
- 小学馆（出版方）
- 读卖电视台 / TMS Entertainment（动画制作方）

本项目中使用的《名侦探柯南》相关名称、图片、音频等素材均属于上述权利方的财产，仅供本应用在授权范围内使用。

### 免责声明

本项目为个人学习与技术研究作品，与原著作权方无任何关联，不构成官方授权、背书或认可。
