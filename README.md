# sl-xj-lib-notifications
Xojo 2026.2.1

# Simple notification system
 
## Introduction

The library provides a basic notification system for Xojo applications. 

Published messages are stored in an input queue. The notification manager will periodically process the input queue and sort the messages based on subscription to a topic. The manager will then distribute the sorted message to the subscribers. The sorting process and the distribution process are activated by timers, so the publisher and the receiver are disconnect processes. 

A class, a window, ... can receive notifications by implementing the itfNotifiable interface and subscribing to one or more topics.

The itfNotifiable interface expects one method:

```Xojo
Sub NotificationReceived(Sender as string, Topic as String, Message as String, SenderClientID as int64)
```

### Information related to a notification
 
If a message should be sent to more than one subscriber, it is cloned, each subscriber receiving a distinct object.


A default manager is allocated and paused.

| Parameter         | Type   | Description    |
|----------------|----------|-------------------------------------------------------------------------|
| Sender         | String   | A string identifying the sender, carried but not used by the library    |
| Topic          | String   | The topic of the notification                                           |
| Message        | String   | The body of the message                                                 |
| SenderClientID | interger | A unique number identifying the sender. Used by the library (see below) |

### About Sender and SenderClientID
The Sender is a string identifying the sender. Its values are based on conventions used by the sender (publisher) and receiver (subscriber) The library transfer the value by does not use it.

The SenderClientID is an integer. By default, if the senderCientID and the subscriberClientID are identical, the message is not forwarded to the subscriber.

The main purpose of the SenderClientID is to prevent the explosion of notifications. A basic example, you have two or more windows where something needs to be kept in synch and that something can be updated by the user in any window. 

Each window subscribes to the same topic and uses its handle as SubcriberClientID. Assuming the window implements one of the itfNotifiablexxx interface:

```Xojo
call clNotificationManager.SubscribeToDefault("SelectionUpdate", self, WindowHandleAsInteger)
```
equivalent to 

```Xojo
call clNotificationManager.GetDefault.Subscribe("SelectionUpdate", self, WindowHandleAsInteger)
```


When something is updated by the user, the window where the change occurs publishes a notification: the Sender is what has changed, the message is the new value and the SenderClientID is the handle of the window. 


```Xojo
call clNotificationManager.PublishToDefault("PopupCountry", "SelectionUpdate", selectedCountry, WindowHandleAsInteger)

```

Which is equivalent to:

```Xojo

clNotificationManager.GetDefault.Publish("PopupCountry", "SelectionUpdate", selectedCountry, WindowHandleAsInteger)

```
All subscribing windows will receive the notification related to the topic "SelectionUpdate", excepted the sender. 

When the application starts and restores saved settings a similar call will be forwarded to all windows.

Note that this behaviour can be disabled globally in the configuration parameters or for a single instance by setting the ClientID to -1.

### More information about a message
 
The message object used by the library contains more information. If the application needs access to those information, it can implement the interface itfNotifiableWithRawMessage instead of the itfNotifiable interface.

```Xojo
sub MessageReceived(msg as clNotificationMessage)

```

A given object should not implement the two interfaces.

## Questions ?
### Can we disable the filter on ClientID ?
Yes, either in the configuration parameters or for a given message or subscription by setting the ClientID to -1

### The '$SYS' topic

The Notification manager sends notifications to the '$SYS' topic and other objects are not allowed to publish notifications with that topic. Anyone can subscribe to the topic.

If there are no subscriptions to that topic, the messages are discarded.

### Can we have more than one Notification manager ?
Yes. There are no connections between the managers. This means that any message published using one manager are not seen by the other manager. The only solution would be to implement an object subscribing to the first manager and publishing on the second manager.

### Do we have structured topics, like subscribing to 'aaa/*'
Not yet :)

### What is the point of not starting the notification system when allocated?
When the manager is running, messages sent to topics without subscriptions are discared. If the App.Open or any configuration method sends notification during the startup process, all of them will be ignored. By letting other objects subscribe to relevant topics before starting the manager, we ensure that subscribers will receive the relevant notification generated during startup.