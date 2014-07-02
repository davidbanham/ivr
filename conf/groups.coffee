module.exports =
  accounts:
    time: 'busHours'
    text: "Incoming call from Accounts queue."
    voicemail: "accounts@example.com"
    members: [
      'accountant@example.com'
    ]
  support:
    time: 'busHours'
    text: "Incoming call from Support queue."
    voicemail: "support@example.com"
    members: [
      'support1@example.com'
      'support2@example.com'
    ]
  sales:
    time: 'busHours'
    text: "Incoming call from Sales queue."
    voicemail: "salesvmail@example.com"
    members: [
      'salesman@example.com'
    ]
