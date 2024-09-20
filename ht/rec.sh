#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
RADISH_PATH="`dirname ${SCRIPT_DIR}`/radish/radi.sh"
TYPE='radiko'
STATION='TBS'
DURATION=60
AIR_DATE=`date '+%Y年%m月%d日' --date '1 day ago'`

TAG_ARTIST='ハライチ'
TAG_ALBUM='ハライチのターン！'
TAG_TITLE="${TAG_ALBUM} ${AIR_DATE}"
TAG_YEAR=${AIR_DATE:0:4}
TAG_GENRE='Radio'

COVER_PATH="${SCRIPT_DIR}/front_cover.png"
M4A_PATH="${SCRIPT_DIR}/${TAG_TITLE}.m4a"
MP3_PATH="${SCRIPT_DIR}/${TAG_TITLE}.mp3"

START=`date '+%s'`
"${RADISH_PATH}" -t ${TYPE} -s ${STATION} -d ${DURATION} -o "${M4A_PATH}"
END=`date '+%s'`
EXEC_TIME=$((END-START))
if [ ${EXEC_TIME} -gt 60 ]; then
  CONTENT="RECORDING: $((EXEC_TIME/60))min"
else
  CONTENT="RECORDING: ${EXEC_TIME}sec"
fi
CONTENT="${CONTENT} (`date -d "@${START}" '+%Y-%m-%dT%H:%M:%S%:z'`/`date -d "@${END}" '+%Y-%m-%dT%H:%M:%S%:z'`)"

START=`date '+%s'`
ffmpeg -i "${M4A_PATH}" -ar 44100 -ab 64k "${MP3_PATH}"
eyeD3 -a "${TAG_ARTIST}" -A "${TAG_ALBUM}" -t "${TAG_TITLE}" --recording-date "${TAG_YEAR}" -G "Radio" --add-image "${COVER_PATH}:FRONT_COVER" --to-v2.3 "${MP3_PATH}"
END=`date '+%s'`
EXEC_TIME=$((END-START))
if [ ${EXEC_TIME} -gt 60 ]; then
  CONTENT="${CONTENT}\nENCODING: $((EXEC_TIME/60))min"
else
  CONTENT="${CONTENT}\nENCODING: ${EXEC_TIME}sec"
fi
CONTENT="${CONTENT} (`date -d "@${START}" '+%Y-%m-%dT%H:%M:%S%:z'`/`date -d "@${END}" '+%Y-%m-%dT%H:%M:%S%:z'`)"

set -a; source "${SCRIPT_DIR}/.env"; set +a
BOXAPP_PATH="`dirname ${SCRIPT_DIR}`/box-upload/index.js"

START=`date '+%s'`
UPLOAD_EXEC=`node "${BOXAPP_PATH}" 'upload' "${USER_ID}" "${FOLDER_ID}" "${MP3_PATH}" 2> ${SCRIPT_DIR}/error.log`
if [ $? -ne 0 ]; then
  SUBJECT="[error]${TAG_ALBUM}"
  CONTENT="${CONTENT}\nFILE: エラー (${TAG_TITLE})"
else
  SUBJECT="[success]${TAG_ALBUM}"
  CONTENT="${CONTENT}\nFILE: ${UPLOAD_EXEC}"
fi
END=`date '+%s'`
EXEC_TIME=$((END-START))
if [ ${EXEC_TIME} -gt 60 ]; then
  CONTENT="${CONTENT}\nUPLOAD: $((EXEC_TIME/60))min"
else
  CONTENT="${CONTENT}\nUPLOAD: ${EXEC_TIME}sec"
fi
CONTENT="${CONTENT} (`date -d "@${START}" '+%Y-%m-%dT%H:%M:%S%:z'`/`date -d "@${END}" '+%Y-%m-%dT%H:%M:%S%:z'`)"

curl --request POST \
  --url 'https://api.sendgrid.com/v3/mail/send' \
  --header 'Authorization: Bearer '"${MAIL_API_KEY}" \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [{"to": [{"email": "'"${MAIL_TO}"'"}]}],"from": {"email": "'"${MAIL_FROM}"'"},"subject": "'"${SUBJECT}"'","content": [{"type": "text/plain","value": "'"${CONTENT}"'"}]}'
