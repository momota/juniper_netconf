## 機能

任意のテキストファイルから Juniper コマンドを読み込み、netconf でコマンドを実行する。
設定の commit 前後で Juniper ステータスを取得する。
(ステータスの差分チェックは、今のところ未実装)


## Usage

## Juniper機器への事前設定

Netconfでの設定変更を受け付けるため、以下の設定がJuniper機器側に必要となる。

```
set system services netconf ssh
```

### 事前設定

gemをインストールする。

```
$ gem install bundler
$ bundle install
```

`./node/HOSTNAME.yml` に設定変更対象の情報を記載する。

`./cfg/hoge.txt` に設定変更用のconfigファイルを置く。(set command)


### 実行

```
  $ ruby change_cfg.rb [設定変更対象ノードのホスト名] [設定変更用configのPATH]
```

- 第一引数
-- 設定変更対象ノードのホスト名。`./node/HOSTNAME.yml`のHOSTNAME部分を渡す
- 第二引数
-- 設定変更用の投入configのPATH



## ディレクトリ体系

```
./
├─cfg       ... Juniper 設定変更用のconfigなどを格納するディレクトリ。情報取得(show command)用はデフォルトshow_cmd.txt。
├─log       ... 実行ログ debug.log と エラーログ error.logを格納するディレクトリ。
├─node      ... 設定変更対象ノードへの接続情報ファイル(YAML)を格納するディレクトリ。
└─output    ... 設定変更前後の情報をファイル出力するディレクトリ
```


## 実行環境

以下の環境でテスト済み。

### Juniper EX switch

```
> show version
fpc0:
--------------------------------------------------------------------------
Hostname: TEST_HOSTNAME
Model: ex4550-32f
JUNOS Base OS boot [12.2R3.5]
JUNOS Base OS Software Suite [12.2R3.5]
JUNOS Kernel Software Suite [12.2R3.5]
JUNOS Crypto Software Suite [12.2R3.5]
JUNOS Online Documentation [12.2R3.5]
JUNOS Enterprise Software Suite [12.2R3.5]
JUNOS Packet Forwarding Engine Enterprise Software Suite [12.2R3.5]
JUNOS Routing Software Suite [12.2R3.5]
JUNOS Web Management [12.2R3.5]
JUNOS FIPS mode utilities [12.2R3.5]
```



### クライアント

```
$ cat /etc/os-release
NAME="Ubuntu"
VERSION="12.04.4 LTS, Precise Pangolin"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu precise (12.04.4 LTS)"
VERSION_ID="12.04"

$ ruby -v
ruby 1.9.2p320 (2012-04-20 revision 35421) [x86_64-linux]
```


### gem dependencies

```
DEPENDENCIES
  netconf (~> 0.3.1)
  sloe (~> 0.7.0)
```
