# terraform_GKE

terraformでGKEを立ち上げてみる。

## 立ち上げ概要

terraformでGKE(GCP上のK8S)を立ち上げるものになります。

必要なソースは以下にまとめてあります。

https://github.com/naritomo08/terraform_GKE_public

## 前提

以下のページなどを参考に、terraform稼働環境を作成し、GCPでの適当なリソースが作成できる状態にあること。

とくにgcp.jsonファイルを作成できていること。

[Terraformをdocker環境で立ち上げてみる。](https://qiita.com/naritomo08/items/7e5a9d1b7eaf18dc0060)

Dockerを使用しない場合、以下のコマンドを利用できている状態になっていること。
```bash
aws

brew
*Terraform導入時に必要

tfenv
*terraform稼働コンテナを利用しない場合は必要
```

k8s関連コマンド(kubectl)を使用できていること。

以下のページを参考に手動コマンドでのGKE構築できていること。

[なるべくCLIでGKEクラスタを作成してみる](https://qiita.com/ttr_tkmkb/items/26328fbbf5f17b920046)

*macの場合、brewでできると思われます。

### (コンテナ利用しない場合)指定バージョン(1.５.7)のterraformを導入する。

```bash
tfenv install
```

## terraformソースファイル入手

terraformを動かすフォルダ内にて、以下コマンドを稼働する。

```bash
git clone https://github.com/naritomo08/terraform_GKE_public.git
cd terraform_GKE
```

後にファイル編集などをして、git通知が煩わしいときは
作成したフォルダで以下のコマンドを入れる。

```bash
 rm -rf .git
```

gcp.jsonファイルを本フォルダに持ってくる。

## 作成（基本ネットワーク、GKE作成）

tfstateフォルダに行き、tfstate用バケットを作成する。

作成する際、”main.tf”内の<バケット名>部分を適当な名前に変更すること。

同じく、”provider.tf”内の<プリジェクト名>部分を使用しているプロジェクト名にする。

defaultフォルダ内へ順番入り、リソース作成を実施する。

作成する際、”backend.tf”内の<バケット名>部分を前の手順で指定した名前に変更すること。

provider.tf,varidate.tf内の<プロジェクト名>をgcpで使用するプロジェクト名にする。

### 作成コマンド

以下のコマンドで作成可能

一度作成できれば最後のコマンドのみでよい。
```bash
terraform init
terraform plan
terraform apply
→　yesを入力する。
```

*いくつかエラーでてくる際は落ち着いてエラーを訳して対応すること。大体API立ち上げかAMI権限追加になります。

## GKE利用方法

gcloud container clusters get-credentials cluster --region asia-northeast1

kubectl config get-contexts 

kubectl get nodes
→3台のノードがでてくること。

## サンプルデプロイ実施。

manifestフォルダに移動。

kubectl apply -f deploy.yml

kubectl apply -f svc-lb.yml

kubectl get svc
→External-IPの値を確認する。(数分待つ。)

以下のサイトへアクセスしてnginx画面が出てくること。

```bash
http://<External-IP>
```

## サンプルデプロイ削除

```bash
kubectl delete -f .
```

## 削除方法

以下のコマンドで削除可能

```bash
ｃcd ../default
terraform destroy
cd ../tfstate
terraform destroy
kubectl config current-context
→はじめに出てくるnameのものを控える。
kubectl config delete-context <コンテキスト名>
```
