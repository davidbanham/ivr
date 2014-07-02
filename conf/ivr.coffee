module.exports =
  routes:
    sales:
      template: 'redirect'
      params:
        path: '/groups/sales'
    support:
      template: 'redirect'
      params:
        path: '/groups/support'
    accounts:
      template: 'redirect'
      params:
        path: '/groups/accounts'
    conferenceRooms:
      template: 'digits'
      params:
        path: '/conferenceRooms'
        script: "Please enter your conference room number."
        numDigits: 1
    extension:
      template: 'digits'
      params:
        path: '/dialExt'
        numDigits: 4
        script: "Please enter the extension you wish to reach now."
    default:
      template: 'digits'
      params:
        path: '/ivr'
        script: "Hi, thanks for calling us. For sales, press 1. For media enquiries, press 2. For support, press 3. For accounts, press 4. If you would like to dial an extension, press 7. For conference calls, press 9."
