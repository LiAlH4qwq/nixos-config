# 柳絮

一个 NixOS 配置。

——「盼望着，盼望着，东风来了，春天的脚步近了。」

## 特性

- 模块化的、可开关的系统配置选项
- 支持不同设备不同用户、多个用户、每个用户独立的用户配置选项
- Impermanence（根目录为临时目录）
- 使用浅色主题保证外观一致性
- 安全启动支持（通过 [Lanzaboote](https://github.com/nix-community/lanzaboote)）
- 无 AI 参与编写，No Vibe coding

## 安装

还没写（）

## 注意

[flake.nix](./flake.nix) 中的 `nixosReleaseVersionWhenInstalled` 所含的版本号，

反映的是**系统安装时的版本号**，

非必要时，请**仅在**系统安装时，将其更改为**您所安装的版本号**，后续如无必要**请不要更改**。

## 协议

除非额外注明来源，配置文件均适用于 [MIT](./LICENSE) 协议。

若有额外注明来源，则以链接所指仓库的协议为准。