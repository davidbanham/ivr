id = '' or process.env.PLIVO_ID
token = '' or process.env.PLIVO_TOKEN
module.exports =
  email:
    user: '' or process.env.EMAIL_USER
    pass: '' or process.env.EMAIL_PASS
    domain: '' or process.env.EMAIL_DOMAIN
    from: '' or process.env.EMAIL_FROM
  plivo:
    id: id
    token: token
    app_name: '' or process.env.PLIVO_APP_NAME
    apiURL: "https://#{id}:#{token}@api.plivo.com/v1/Account/#{id}"
    endpoints: [
      ''
    ]
  url: '' or process.env.APP_URL
