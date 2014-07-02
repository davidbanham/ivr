IVR
===

This is an IVR framework. It's been used in production for years, but is just now being open sourced.

In the process of being open-sourced, parts have been rewritten to be more generic. For this reason, there may be some bugs that have crept in.

There are no tests for this project, I'm afraid. It was hacked together years ago and none have been added since.

This is designed to work with the Plivo platform. There are currently no plans to port it to any other provider, but if someone feels like doing it I wouldn't be opposed.

## Concepts

### People

People that use your system are defined in people.coffee. They are identified via email address. They have metadata associated like extensions and timezones. They can have multiple numbers, which are routes they can be reached by when the IVR needs to call them.

### Conference rooms

You can define as many conference rooms as you like in conferenceRooms.coffee. These have a user PIN and an admin PIN.

### Groups

You can group people into logical units in groups.coffee. These have an associated time, during which it is considered okay to call their members. This timezone is evaluated relative to the timezone that person is actually in.

They also have a text field associated. This is the text that is read out to People when they recieve a call routed to that Group.

The voicemail paramater is where message recordings will be sent if no member of the group was available to take the call.

### Ivr

The actual IVR menu is declared in ivr.coffee. The script that people hear when they first call your number is in default.

### Times

These are times that you can use in Groups. You can call them whatever you want, and they have a start hour and an end hour, also days on which they are in operation.
