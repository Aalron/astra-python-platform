SET NAMES utf8mb4;

DROP TABLE IF EXISTS `t_user`;
CREATE TABLE if not exists `t_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `user_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'user name',
  `pass_word` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'password',
  `email` varchar(50) comment '邮箱',
  `role` varchar(10) comment 'admin;user',
  `token` varchar(500) comment 'token',
  `login_status` boolean comment '登录的状态',
  `login_ip` varchar(20) comment '登陆地ip地址',
  `label` varchar(100) comment '用户标签',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE KEY `un_username` (`user_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

drop table if exists t_mirror_sources;

CREATE TABLE if not exists `t_mirror_sources` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `enabled` tinyint(1) DEFAULT '1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  UNIQUE KEY `uk_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

drop table if exists t_projects;

CREATE TABLE if not exists `t_projects` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL comment '项目名称',
  `description` text COLLATE utf8mb4_unicode_ci comment '项目描述',
  `git_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL comment '项目git的url',
  `git_username` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment '项目git的用户名',
  `git_password` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment '项目git的密码',
  `local_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL comment '项目存储在本地的路径',
  `branch` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'main' comment '项目拉取的分支名',
  `auto_pull` tinyint(1) DEFAULT '0' comment '是否自动拉取',
  `pull_schedule` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment '自动更新拉取的crontab频率',
  `last_pull_time` datetime DEFAULT NULL comment '上一次项目代码更新的日期',
  `clone_true` tinyint(1) DEFAULT '0' comment '是否克隆成功过',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_project_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


drop table if exists t_python_versions;

CREATE TABLE if not exists `t_python_versions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `version` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL comment 'python版本号',
  `source_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment '安装的地址来源',
  `install_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment '安装的地址',
  `is_default` tinyint(1) DEFAULT '0',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

drop table if exists t_scheduled_tasks;

CREATE TABLE if not exists `t_scheduled_tasks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL comment '调度任务的名称',
  `description` text COLLATE utf8mb4_unicode_ci comment '调度任务的描述',
  `project_id` bigint NOT NULL comment '调度任务归属的项目的id',
  `exec_commands` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL comment '该调度任务的执行命令',
  `task_type` tinyint COLLATE utf8mb4_unicode_ci comment '1 - 一次性;2 - 周期调度',
  `schedule_expression` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL comment 'cron 表达式的值',
  `next_execution_time` datetime DEFAULT NULL comment '下一次执行时间',
  `last_execution_time` datetime DEFAULT NULL comment '上一次执行时间',
  `last_execution_result` text COLLATE utf8mb4_unicode_ci comment '上一次执行的结果',
  `enabled` boolean default false comment '任务是否启用',
  `virtual_environment_name` varchar(100) NOT NULL COMMENT '虚拟环境名称',
  `label_id` bigint comment '标签id',
  `alarm_type` varchar(20) comment '告警类型 DingTalk/FeiShu/WeChat',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_project_id` (`project_id`),
  KEY `idx_enabled` (`enabled`),
  KEY `idx_next_execution_time` (`next_execution_time`),
  KEY `idx_task_create_time` (`create_time`),
  KEY `idx_task_type` (`task_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

drop table if exists t_label_info;

CREATE TABLE if not exists `t_label_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL comment '标签名称',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


drop table if exists t_system_config;

CREATE TABLE if not exists `t_system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `config_value` text COLLATE utf8mb4_unicode_ci,
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

drop table if exists t_task_execution_history;

CREATE TABLE if not exists `t_task_execution_history` (
  `id` bigint NOT NULL,
  `task_id` bigint NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime DEFAULT NULL,
  `status` enum('RUNNING','SUCCESS','FAILED','CANCELLED','WAITING') COLLATE utf8mb4_unicode_ci NOT NULL,
  `output` longtext COLLATE utf8mb4_unicode_ci,
  `error_message` text COLLATE utf8mb4_unicode_ci,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_history_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

drop table if exists t_virtual_environments;

CREATE TABLE if not exists `t_virtual_environments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL comment '虚拟环境名',
  `path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL comment '虚拟环境的路径',
  `python_version_id` bigint NOT NULL comment '虚拟环境对应的python版本的数据id',
  `mirror_source` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT 'https://mirrors.aliyun.com/pypi/simple/',
  `install_requirement_status` enum('RUNNING','SUCCESS','FAILED','CANCELLED') COLLATE utf8mb4_unicode_ci,
  `requirement_txt` longtext comment '安装的python依赖包',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_python_version_id` (`python_version_id`),
  KEY `idx_ve_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 任务日志表
DROP TABLE IF EXISTS t_task_logs;

CREATE TABLE IF NOT EXISTS `t_task_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_id` bigint DEFAULT NULL COMMENT '任务ID',
  `execution_id` bigint DEFAULT NULL COMMENT '执行历史ID',
  `log_level` enum('INFO','WARN','ERROR','DEBUG') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INFO' COMMENT '日志级别',
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '日志内容',
  `log_time` datetime NOT NULL COMMENT '日志产生时间',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_task_id` (`task_id`),
  KEY `idx_execution_id` (`execution_id`),
  KEY `idx_log_time` (`log_time`),
  KEY `idx_log_level` (`log_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务执行日志表';

INSERT INTO `t_python_versions` (`version`, `source_url`, `install_path`, `is_default`) VALUES
('3.13.5', 'https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tar.xz', '/usr/local/bin/python3.13', 1);

-- 预置镜像源
INSERT INTO `t_mirror_sources` (`name`, `url`, `description`, `is_default`, `enabled`) VALUES
('官方源', 'https://pypi.org/simple/', 'Python官方PyPI源', 1, 1),
('清华源', 'https://pypi.tuna.tsinghua.edu.cn/simple/', '清华大学镜像源', 0, 1),
('阿里源', 'https://mirrors.aliyun.com/pypi/simple/', '阿里云镜像源', 0, 1),
('腾讯源', 'https://mirrors.cloud.tencent.com/pypi/simple/', '腾讯云镜像源', 0, 1),
('华为源', 'https://repo.huaweicloud.com/repository/pypi/simple/', '华为云镜像源', 0, 1),
('豆瓣源', 'https://pypi.douban.com/simple/', '豆瓣镜像源', 0, 1),
('中科大源', 'https://pypi.mirrors.ustc.edu.cn/simple/', '中国科学技术大学镜像源', 0, 1);

-- 系统配置
INSERT INTO `t_system_config` (`config_key`, `config_value`, `description`) VALUES
('retention_days', '30', '执行历史保留天数'),
('save_record_for_every_task','5','每个任务保留最大的历史执行记录数');

INSERT INTO `t_user` ( user_id, user_name, pass_word, role )
VALUES(10001, 'admin', '$2a$10$qdgA7U0Qaq2nPRowelbR4OVPQfha6Ws.1S.YIHJbYm.hpWOnJ/Zdy', 'admin');

DROP TABLE IF EXISTS t_monitor_config;

CREATE TABLE IF NOT EXISTS `t_monitor_config` (
  `id` BIGINT AUTO_increment PRIMARY KEY COMMENT '主键ID',
  `platform_type` VARCHAR(20) NOT NULL COMMENT '平台类型：DingTalk/ WeChat/ FeiShu',
  `webhook_url` VARCHAR(512) NOT NULL COMMENT '回调地址',
  `secret` VARCHAR(255) DEFAULT NULL COMMENT '密钥（部分平台需要）',
  `token` VARCHAR(255) DEFAULT NULL COMMENT 'token（部分平台需要）',
  `enabled` TINYINT NOT NULL DEFAULT 1 COMMENT '是否启用：1-启用，0-禁用',
  `timeout_seconds` INT NOT NULL DEFAULT 10 COMMENT '超时时间（秒）',
  `retry_times` INT NOT NULL DEFAULT 3 COMMENT '重试次数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uk_platform (platform_type) COMMENT '保证每个平台配置唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '监控配置表';
