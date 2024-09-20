# radiko-backup

## Installation
```bash
#For Ubuntu 24.04 LTS
sudo apt install curl
sudo apt install libxml2-utils
sudo apt install jq
sudo apt install ffmpeg
sudo apt install eyed3
sudo apt install nodejs
sudo apt install npm

git clone --recursive https://github.com/ebidragon/radiko-backup.git

cd radiko-backup/box-upload
npm install
```

## Configuration
### [box-upload](https://github.com/ebidragon/box-upload/blob/main/README.md#Configuration)
1. [.env](https://github.com/ebidragon/box-upload/blob/main/README.md#env)
2. [token](https://github.com/ebidragon/box-upload/blob/main/README.md#token-user_idjson)

### .env
- [user_id](https://developer.box.com/platform/appendix/locating-values/#user-ids)
- [folder_id](https://developer.box.com/platform/appendix/locating-values/#content-ids)
- [api_key](https://sendgrid.kke.co.jp/docs/User_Manual_JP/Settings/api_keys.html)
```bash
cd ht
cp .env.example .env
```
1. Copy `user_id` to [.env](ht/.env) `USER_ID`
2. Copy `folder_id` to [.env](ht/.env) `FOLDER_ID`
3. Copy `api_key` to [.env](ht/.env) `MAIL_API_KEY`
4. Copy `to email address` to [.env](ht/.env) `MAIL_TO`
5. Copy `from email address` to [.env](ht/.env) `MAIL_FROM`
### cron
```
0 0 * * 5 /home/username/radiko-backup/ht/rec.sh
```