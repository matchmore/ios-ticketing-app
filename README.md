# Step-by-Step Guide to the ALPS SDK and the Ticketing App

This guide is an overview to have the first glimpse into our Alps SDK. See how it works through a demo app that we specially built with our technology.

## Prerequisities

We assume that you already have knowledge about the **Advanced Location Publish/Subscribe** `ALPS` model. If not, please have a look at our portal [http://dev.matchmore.com/](http://dev.matchmore.com/).

## What will be covered
* Register in our portal
* Create an application in our cloud
* Get Ticketing App and launch it
* Ticketing App review
* You have iBeacons?

## Get started

### Register in our portal

*Did you have a look at the live demo ? Ticketing App is mirroring this demo.*

* Click on sign in.
* Register an account, then connect yourself and and we will get started with the portal.

![Sign in and register an account](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/dashboard.png "signIn")

### Create an application in our cloud
* This is your dashboard in the `Matchmore` portal.
* To `create your first app` click on the button on the left.

![Create your first app](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/firstApp.png "firstApp")

* Fill the asked information and then click on create.

I have filled with name :

      test

and description :

      This is a test application

Your first application is now registered !

![your first app api-key](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/apikey.png "apikeyFirstApp")

**Note :** the api-key is needed to build an application using our Alps SDK.

### Get Ticketing App and launch it

Our github : [https://github.com/matchmore/alps-ios-TicketingApp](https://github.com/matchmore/alps-ios-TicketingApp)

Go in your terminal and git clone the project. The command you can enter in your terminal :

      git clone https://github.com/matchmore/alps-ios-TicketingApp.git

Then, enter in the folder with your terminal, you can use this command :

      cd alps-ios-TicketingApp

To start using this project you need to install the ALPS SDK, which comes in the form of a CocoaPods.
We have already set a pod file in this project but remember to add these lines to your own podfile for the next project, in order to use our Alps SDK.

      pod 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git', :tag => '0.4.0'
      pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git', :tag => ‘0.4.2’

Then save the file, and go to your terminal (which is inside of Ticketing App folder) and enter the command :

      pod install

* Open the Workspace of Ticketing App’s project.
* Open the file AppDelegate.swift and paste the api-key from the portal (this api-key is the one created with your first app), as illustrated hereafter.
* The constant “APIKEY” should be equal to the **UUID** of your api-key.
![put your api-key in appDelegate](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/appApikey.png "put your api-key in appDelegate")
* Run the project on your simulator or on your apple Iphone.

**Careful!** Before using the application, make sure to set location on your simulator, as shown below. For this, when your simulator is launched, go in Debug/Location and set a custom location or just use Apple location. Make sure that is not set on “None”. See image below.

![find Debug Location in simulator](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/debugLocation.png "find debug Location")

###  Ticketing App Review

**Reminder :** Please have a look at our portal [http://dev.matchmore.com/](http://dev.matchmore.com/) to see the `Live Demo`. We will cover this demo with a real app which is the `Ticketing App`.

1. Register two users with one device each
2. Attach a publication to device 1
3. Attach a subscription to device 2
4. Simulate a movement for device 2
5. Receive a match or not

#### Register a first user with a device ( The publisher / Alice )

* Use the simulator in Xcode, select an iPhone 7 or iPhone 7 plus, and run the project.
* Enter “Alice” in the username textfield and press login.
* Selecting “No, thank you” will not create a subscription for Alice’s device.

![Register Alice](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/1.png "1.")

#### Attach a publication to Alice’s device ( Device 1 in Live demo )

We want to attach a publication to Alice’s device.
* Select tab bar `Sell` at the bottom right.
* Click on `Sell a ticket` at the top-right.
This will switch you to another view where you can publish. Notice that we will publish only on our iPhone emulator during this demo.
* Click on Mobile Button, you can now publish a publication on Alice’s device by clicking on “Publish” button. You can change informations but we already settled all the information you need, you can leave it like that.
* Press “Publish”.

**Note :** Most important is that topic is the same for both publisher and subscriber and properties should equal selector ( Here Concert = “Montreux Jazz” is our property and selector )

![Publish on Alice's device](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/2..png "2.")

#### Register a second user with a device ( The subscriber / Bob )

**IMPORTANT :** You need a physical iPhone to run a second simulator.

* Build and run the project by selecting your physical iPhone as the simulator
* Register a second user with a device ( The subscriber / Bob )
* Repeat step 1, but this time with “Bob” as a username.
* Press login.

#### Attach a subscription to Bob’s device ( Device 2 in Live demo )

* Accept the subscription by clicking on `Yes, please subscribe to this topic`
* Simulate a movement for Bob’s device

**Note :** You need to know where Alice’s device location is set on the Xcode Simulator.

To set Alice's device location :
* Go in simulator, Debug/Location/CustomLocation
* use `Custom Location` and set it to a location and move near to it with Bob’s device to get the Match

#### Receive a match or not

   You will get a notification every time you get a match !!

![get the match](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/match.png "match")


### You have iBeacons ?

Our technology integrate iBeacon, if you have iBeacons you can attach publication/subscription on it and our cloud service will deliver the match with soon to come pusher endpoints such as Apple Pusher Notifications.

* First, you need to register the beacons on our portal. On your dashboard, click on `Beacons`.
![add Beacon step 1](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon1.png "add Beacon step 1")
* Start, to register your beacons for future use in your application.
![add Beacon step 2](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon2.png "add Beacon step 2")

In order to register your beacon(s), you need to **provide their current UUID, Major and Minor**. The name of the beacon could be his color or his form, something that helps you to recognize this beacon.

When you are done your beacons dashboard should show informations about your registered beacons.
![add Beacon step 3](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon3.png "add Beacon step 3")

Now assign your beacons in each application(s) you want to make use of them.
* Go to “Applications” in your dashboard.
![add Beacon step 4](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon4.png "add Beacon step 4")
* Click on the `+ beacon` icon, under the application in which you want to assign beacon(s).
![add Beacon step 5](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon5.png "add Beacon step 5")

Choose the beacons and click on assign. See image below for an example of what you should have.
![add Beacon step 6](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/addBeacon6.png "add Beacon step 6")

**NOTE :** The userId of the owner of the beacons in this app is equal to the api- key.

* Run Ticketing App, and go to `sell tab`
* click on `Sell a ticket`.

Look at `iBeacon`, you should be able to choose between the beacons you assigned to your application.

When, re-run the Ticketing-App on your physical iPhone (Bob´s device / the subscriber).
* Approach the beacons in which you published to trigger matches.
![select iBeacon](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/selectIBeacon.png "add Beacon step final")
