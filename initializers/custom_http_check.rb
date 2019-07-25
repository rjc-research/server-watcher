# FOR POTATO SERVICE
POTATO_CUSTOM_HTTP_CHECK = lambda {
  |response|
  # check status code
  status_code = response.status.to_s
  if not status_code =~ /^(2|3)[0][0-1]$/
    return "Invalid status_code: #{status_code}"
  end

  # check URL
  url = "#{response.host}:#{response.port}#{response.path}"
  if not (
    url =~ /^live.wealth-park.com:443\/?$/ or
    url =~ /^[a-z0-9\-]+\.wealth-park\.com:443\/login\/?$/
  )
    return "Invalid URL: #{url}"
  end
  
  # scan for specific texts
  body = response.body.force_encoding('UTF-8')
  if not (
    body.scan(/(サインイン|Sign In|登錄)/).count > 0 and
    body.scan(/(メールアドレス|Email|電郵地址)/).count > 0 and
    body.scan(/(パスワード|Password|密碼)/).count > 0
  )
    return "Can't detect all mandatory texts of login page"
  end

  # everything was ok
  nil
}

# FOR API SERVICE
API_CUSTOM_HTTP_CHECK = lambda {
  |response|
  # check status code
  status_code = response.status.to_s
  if not status_code =~ /^(2|3)[0][0-1]$/
    return "Invalid status_code: #{status_code}"
  end
  
  # check body
  if not response.body == 'OK'
    return "Invalid body: #{response.body}"
  end

  # everything was ok
  nil
}

# FOR CHAT SERVICE
CHAT_CUSTOM_HTTP_CHECK = lambda {
  |response|
  # check status code
  status_code = response.status.to_s
  if not status_code =~ /^(2|3)[0][0-1]$/
    return "Invalid status_code: #{status_code}"
  end
  
  # check body
  if not response.body == 'OK'
    return "Invalid body: #{response.body}"
  end

  # everything was ok
  nil
}

# FOR CHAT ADMIN SERVICE
CHAT_ADMIN_CUSTOM_HTTP_CHECK = lambda {
  |response|
  # check status code
  status_code = response.status.to_s
  if not status_code =~ /^(2|3)[0][0-1]$/
    return "Invalid status_code: #{status_code}"
  end
  
  # check body
  if not response.body.force_encoding('UTF-8').scan('<script src="./app.min.js"></script>').count > 0
    return "Body doesn't contain 'app.min.js'"
  end

  # everything was ok
  nil
}

# FOR STORAGE SERVICE
STORAGE_CUSTOM_HTTP_CHECK = lambda {
  |response|
  # check status code
  status_code = response.status.to_s
  if not status_code =~ /^(2|3)[0][0-1]$/
    return "Invalid status_code: #{status_code}"
  end
  
  # check body
  json = JSON.parse(response.body)
  if not json['err'] == 0
    return "Invalid error code: #{json['err']}"
  end

  # everything was ok
  nil
}
