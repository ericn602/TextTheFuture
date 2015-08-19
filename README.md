# TextTheFuture
TextTheFuture is an iOS app that allows its users to schedule a message to be automatically sent out to somebody else.

Technologies Used:<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Node.js (Backend) <br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Agenda-Module (Scheduling)<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MongoDB (Database)<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Twilio (SMS service provider)<br>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;iOS (Client-Side Interface)<br>
  
# How to Install
After you clone the files to your desktop, make sure you have Node.JS and MongoDB installed. Step up a Twilio account if you haven't already.

  1. Open up TextTheFuture/TextTheFutureBackend/routes/index.js
  2. Make the following changes the index.js
    - line 3, input your Twilio SID and Auth Token inside the parameters designated
    - line 11, input your Twilio phone number (as a string).
  3. Open up your Terminal and run MongoDB
    - run mongod --dbpath "PATH TO /TextTheFuture/TextTheFutureBackend/data"
    - open up another terminal and type in "mongo" to connect to your mongodb database
    - type in "use TextTheFuture"
    - NOTE: We are assumming that mongo is running at localhost:27017
  4. Start up your backend with "npm start" on another terminal
  5. Open up the client in xCode
    - in ViewController.m, line 61, change "YourPhoneNumber" to whatever phone number you want the receiver to see
    - do the same in TableViewController.m, line 19
  6. Run the iOS code in xCode (try building on the iPhone 5, so the layout isn't messed up)
  7. Test to see if everything worked

#Contact
If you have trouble installing or have any questions. Feel free to send me an email at eric.duy@gmail.com

#License
Copyright 2015 Eric Nguyen. All rights reserved. Licensed under [GNU General Public License](http://www.gnu.org/licenses/gpl-3.0.en.html)

