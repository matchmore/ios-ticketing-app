# Step-by-Step Guide to the `AlpsSDK` and the Ticketing App

This guide is an overview to have the first glimpse into our `AlpsSDK`. See how it works through a demo app that we've built using our technology.

## Prerequisities

We assume that you already have knowledge about the **Advanced Location Publish/Subscribe** `ALPS` model.
If not, please have a look at our portal [matchmore.io/](https://matchmore.io/).

Alps iOS SDK uses Apple Push Notification Service (APNS) to deliver notifications to your iOS users.

If you already know how to enable APNS, don't forget to upload the certificate in our portal.

Else, you can find help on [how to setup APNS](https://github.com/matchmore/alps-ios-sdk/blob/master/ApnsSetup.md).

## What will be covered
* Register in our portal
* Create an application in our cloud
* Get Ticketing App and launch it
* Ticketing App review
* Do you have iBeacons?

## Get started

### Register in our portal

*Did you have a look at the live demo ? Ticketing App is mirroring this demo.*

* Click on Sign In.
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

**Note :** `API_KEY` is needed to build an application using `AlpsSDK`.

### Get Ticketing App and launch it

Our github : [https://github.com/matchmore/alps-ios-TicketingApp](https://github.com/matchmore/alps-ios-TicketingApp)

Go in your terminal and git clone the project. The command you can enter in your terminal :

    git clone https://github.com/matchmore/alps-ios-TicketingApp.git

Then, enter in the folder with your terminal, you can use this command :

    cd alps-ios-TicketingApp

To start using this project you need to install the `AlpsSDK`, which comes in the form of a CocoaPod.
We have already set it up in this project, but remember to add these lines to your own podfile for the next project, in order to use our Alps SDK.

    pod 'AlpsSDK'

Then save the file, and go to your terminal (which is inside of Ticketing App folder) and enter the command :

    pod install

In case of any problems with CocoaPods try:

    pod repo update

* Open the Workspace of Ticketing App’s project.
* Open the file AppDelegate.swift and assign api-key and to `MatchMore` static class, as illustrated hereafter.

```swift
// Basic setup
let config = MatchMoreConfig(apiKey: "YOUR_API_KEY")
MatchMore.configure(config)
```

* Run the project on your simulator or on your apple Iphone.

**Careful!** Before using the application, make sure to set location on your simulator, as shown below. For this, when your simulator is launched, go in Debug/Location and set a custom location or just use Apple location. Make sure that is not set on “None”. See image below.

![find Debug Location in simulator](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/debugLocation.png "find debug Location")

###  Ticketing App Review

**Reminder :** Please have a look at our portal [http://matchmore.io/](http://matchmore.io/) to see the `Live Demo`. We will cover this demo with a real app which is the `Ticketing App`.

1. Attach a publication to device 1
2. Attach a subscription to device 2
3. Simulate a movement for device 2
4. Receive a match or not

#### Attach a publication to Device 1

We want to attach a publication to Device 1.
* Select tab bar `Sell` at the bottom right.
* Click on `Sell a ticket` at the top-right.
This will switch you to another view where you can publish. Notice that we will publish only on our iPhone emulator during this demo.
* Click on Mobile Button, you can now publish a publication on Device 1 by clicking on “Publish” button. Don't forget to set information. We recommend the following :
Concert : Montreux Jazz
Price : 100
Range : 1000
Duration : 1000
* Press “Publish”.

**Note :** Most important is that topic is the same for both publisher and subscriber and properties should equal selector ( Here Concert = “Montreux Jazz” is our property and selector )

![Publish on Device 1](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/attachPub.png "Attach a publication on Device 1")

#### Register a second device, Device 2

**IMPORTANT :** You need a physical iPhone to run a second simulator.

* Build and run the project by selecting your physical iPhone as the simulator

#### Attach a subscription to Device 2

* Go to tab "Find"  and click on the + at the top-right of the screen.
You can now add informations for the subscription on Device 2.
We recommend the next information for your subscription :
Concert : Montreux Jazz
Max Price : 3000
Range (m) : 1000
Duration (s) : 1000
* Accept the subscription by clicking on `Start Getting Matches!`
* Simulate a movement for Device 2 to enter Device 1's publication range.

![Attach on Device 2](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/attachSub.png "Attach a subscription on Device 2")

**Note :** You need to know where Device 1 location is set on the Xcode Simulator.

To set Device 1 location :
* Go in simulator, Debug/Location/CustomLocation
* use `Custom Location` and set it to a location and move near to it with Device 2 to get the Match

#### Receive a match or not

   You will get a notification every time you get a match !

![get the match](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/match.png "match")

**NOTE :** You can actually test the whole app without creating two devices. For the purpose to mirror the live demo on our portal, we made the choice to show describe this tutorial with two devices.

### You have iBeacons

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

* Approach the beacons to trigger matches.
![select iBeacon](https://github.com/matchmore/alps-ios-TicketingApp/blob/master/media/selectIBeacon.png "add Beacon step final")


## License

`Alps iOS Ticketing App` is available under the MIT license. See the LICENSE file for more info.
