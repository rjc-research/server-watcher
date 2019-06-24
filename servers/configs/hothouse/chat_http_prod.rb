{
  active: true,
  name: 'hothouse/chat/prod/http',
  #url: 'https://hothouse.wealth-park.com/chat/api/check_alive',
  url: 'https://hothouse-chat.wealth-park.com/api/check_alive',
  interval: INTERVAL,
  alert: ALERT_EMAIL_ADDRESSES,
  custom_http_check: CHAT_CUSTOM_HTTP_CHECK,
}