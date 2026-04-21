# 暖暖瓜心 (Jinlian Reminder)

一款基于 Flutter 的用药提醒应用，用于管理药物、服药提醒和复诊记录。

## 项目概述

- **用途**: 药物管理和服药提醒
- **命名**: 取自名著"大朗，该吃药了"
- **平台**: Android / iOS
- **语言**: Dart (Flutter)
- **SDK**: Flutter ^3.11.5

## 核心功能

1. **药物管理**: 添加、编辑、删除药物信息
2. **服药提醒**: 支持多种提醒频率（每日、每周、每月、按天间隔、按小时间隔）
3. **复诊提醒**: 药物复诊日期追踪和提前提醒
4. **服药记录**: 记录服药状态（已服用、已跳过、遗漏）

## 架构结构

```
lib/
├── main.dart                 # 应用入口和主界面
├── models/                   # 数据模型 (Isar collections)
│   ├── medication.dart       # 药物模型
│   ├── reminder.dart         # 提醒模型
│   ├── follow_up_alert.dart  # 复诊提醒模型
│   ├── medication_log.dart   # 服药记录模型
│   └── *.g.dart              # Isar 生成文件
├── services/                 # 业务服务层
│   ├── database_service.dart # Isar 数据库操作
│   ├── notification_service.dart # 本地通知管理
│   ├── reminder_scheduler.dart   # 提醒调度计算
│   └── follow_up_reminder_service.dart # 复诊提醒服务
└── screens/                  # UI 页面
    ├── home_screen.dart      # 今日概览主页
    ├── medication_list_screen.dart # 药物列表
    ├── medication_form_screen.dart # 药物表单
    ├── reminder_list_screen.dart   # 提醒列表
    ├── reminder_form_screen.dart   # 提醒表单
    ├── log_screen.dart       # 服药记录历史
    └── follow_up_screen.dart # 复诊管理
```

## 数据模型

### Medication (药物)
- `name`: 药物名称
- `dosage`: 剂量
- `instructions`: 用药说明
- `hasFollowUpDate`: 是否有复诊日期
- `followUpDate`: 复诊日期
- `endDate`: 用药截止日期
- `isActive`: 是否活跃

### Reminder (提醒)
- `medicationId`: 关联药物 ID
- `time`: 提醒时间 (HH:mm 格式)
- `frequency`: 频率类型 (daily/weekly/monthly/interval/intervalHours)
- `frequencyDetails`: 频率详情（周几/日期/间隔天数/间隔小时数）
- `nextTriggerTime`: 下次触发时间
- `isActive`: 是否活跃

### MedicationLog (服药记录)
- `medicationId`: 药物 ID
- `reminderId`: 提醒 ID
- `scheduledTime`: 计划时间
- `actualTime`: 实际服药时间
- `status`: 状态 (taken/skipped/missed)

### FollowUpAlert (复诊提醒)
- `medicationId`: 药物 ID
- `followUpDate`: 复诊日期
- `alertDate`: 提醒日期（提前7天）
- `hasAlerted`: 是否已提醒
- `isConfirmed`: 是否已确认

## 关键依赖

| 依赖 | 用途 |
|------|------|
| `isar` + `isar_flutter_libs` | 本地数据库 |
| `flutter_local_notifications` | 本地通知 |
| `timezone` | 时区支持 |
| `intl` | 日期格式化 |
| `path_provider` | 文件路径 |

## 常用命令

```bash
# 运行应用
flutter run

# 生成 Isar 模型代码
flutter pub run build_runner build

# 清理并重新生成
flutter pub run build_runner build --delete-conflicting-outputs

# 分析代码
flutter analyze

# 构建 APK
flutter build apk
```

## 服务层说明

### DatabaseService
- 单例模式，管理 Isar 数据库连接
- 提供 CRUD 操作：药物、提醒、复诊提醒、服药记录
- 支持按日期、状态过滤查询

### NotificationService
- 初始化本地通知渠道
- 支持即时通知和定时通知
- 处理 Android 电池优化权限
- 精确闹钟权限请求

### ReminderScheduler
- 计算下次触发时间（支持多种频率）
- 调度/取消通知
- 处理提醒触发后的记录创建

### FollowUpReminderService
- 复诊日期追踪
- 提前 7 天提醒
- 自动检查非复诊药物的截止日期

## 提醒频率类型

| 类型 | 说明 | frequencyDetails |
|------|------|------------------|
| `daily` | 每日 | 无 |
| `weekly` | 每周特定日 | 周几列表 (1-7, 逗号分隔) |
| `monthly` | 每月特定日 | 日期列表 (1-31, 逗号分隔) |
| `interval` | 按天间隔 | 间隔天数 |
| `intervalHours` | 小时间隔 | 间隔小时数 |

## Android 权限要求

- 通知权限
- 精确闹钟权限 (Android 12+)
- 电池优化忽略（避免系统延迟通知）

## 注意事项

1. Isar 模型修改后需运行 `build_runner` 重新生成
2. Android 通知需要高优先级和全屏意图以确保准时触发
3. 电池优化权限通过原生 MethodChannel 处理