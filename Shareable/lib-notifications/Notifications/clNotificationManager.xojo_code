#tag Class
Class clNotificationManager
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Sub CancelSubscription(prmSubscriptionID as integer)
		  
		  var tempSub as clNotificationSubscription = nil
		  var tempSubIndex as integer = -1
		  var tempTopic as string
		  
		  for i as integer = 0 to self.Subscribers.LastIndex
		    
		    var s as clNotificationSubscription = self.Subscribers(i)
		    
		    if s.id = prmSubscriptionID then 
		      tempSub = s
		      tempSubIndex = i
		      exit 
		      
		    end if
		    
		  next
		  
		  if tempSub = nil then Return
		  
		  tempTopic = tempSub.Topic
		  
		  // Search in dictionary
		  if self.SubscribersByTopic.HasKey(tempTopic) then
		    var arr() as clNotificationSubscription = self.SubscribersByTopic.Value(tempTopic)
		    
		    var indexToDelete as integer = -1
		    
		    
		    for i as integer = 0 to arr.LastIndex
		      
		      var s as clNotificationSubscription = arr(i)
		      
		      if s.id = prmSubscriptionID then 
		        indexToDelete = i
		        exit 
		        
		      end if
		      
		    next
		    
		    if indexToDelete >-1 then
		      arr.RemoveAt(indexToDelete)
		      
		    end if
		    
		    if arr.count > 0 then
		      self.SubscribersByTopic.Value(tempTopic) = arr
		    else
		      self.SubscribersByTopic.Remove(tempTopic)
		      
		    end if
		    
		  end if
		  
		  // Remove from main list
		  
		  
		  if tempSubIndex > -1 then
		    self.Subscribers.RemoveAt(tempSubIndex)
		    
		  end if
		  
		  return
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  //
		  // Create a notification manager
		  //
		  // This is done by the shared method GetDefault() and a single notification manager should be enough
		  // Any call to PublishToDefault() and SubscribeToDefault() creates the default manager
		  //
		  // Configuration can be updated later
		  //
		  // The manager is created by idle. All published messages are stored in an inputQueue 'MessageToDispatch()'
		  // So the application can publish messages event before a single window / control / oject subscribes to anything 
		  // as long as the manager is idle.
		  //
		  // Once running, messages sent to unsuscried topics are discarded
		  //
		  
		  self.Configuration = new clNotificationConfiguration
		  
		  self.IsRunning = false
		  
		  self.processLoopTimer = new Timer
		  self.processLoopTimer.RunMode = timer.RunModes.Off
		  
		  self.processLoopTimer.AddActionNotificationReceiver(self)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DistributeMessages()
		  
		  if Subscribers.Count = 0 then return
		  
		  for each s as clNotificationSubscription in self.Subscribers
		    
		    if s.NbrMessagesInQueue > 0 then
		      select case  self.Configuration.DistributionStrategy 
		        
		      case  clNotificationConfiguration.DistributionOrder.CycleQueueFirst 
		        s.DistributeNext
		        
		      case clNotificationConfiguration.DistributionOrder.EmptyQueueFirst
		        s.DistributeAll
		        
		      end select
		      
		    end if
		    
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetDefault() As clNotificationManager
		  if DefaultNM  = nil then 
		    DefaultNM = new clNotificationManager
		    
		  end if
		  
		  return DefaultNM
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function internal_ProcessParameters(MessageText as string, paramarray MessageParameters as String) As string
		  
		  
		  var tmp_return As String = MessageText
		  
		  
		  For i As Integer = 0 To MessageParameters.Ubound
		    var formattedParam as string =  MessageParameters(i)
		    
		    tmp_return = tmp_return.Replace("%"+Str(i), formattedParam)
		    
		  Next
		  
		  Return tmp_return
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub internal_Publish(callerID as string, Topic as string, Message as string, Details as variant, SenderClientID as integer)
		  
		  self.TraceMessage("Publish " + callerID + " " + Topic + " " + Message)
		  
		  var msg as new clNotificationMessage(callerId, Topic, Message, Details, SenderClientID)
		  self.InputQueue.Add(msg)
		  
		  if self.IsRunning then
		    ProcessQueues
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListMySubscriptions(SubscriberClientID as integer) As string()
		  
		  var ret() as string
		  
		  for each s as clNotificationSubscription in self.Subscribers
		    if s.SubscriberClientID  = SubscriberClientID then
		      ret.add(s.Topic)
		      
		    end if
		    
		  next
		  
		  return ret
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListMySubscriptionsWithID(SubscriberClientID as integer) As pair()
		  
		  var ret() as pair
		  
		  for each s as clNotificationSubscription in self.Subscribers
		    if s.SubscriberClientID  = SubscriberClientID then
		      
		      ret.add(s.ID: s.Topic)
		      
		    end if
		    
		  next
		  
		  return ret
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ListSubscribedTopics() As string()
		  
		  var ret() as string
		  
		  if self.SubscribersByTopic = nil then return ret
		  
		  if self.SubscribersByTopic.KeyCount = 0 then return ret
		  
		  for each k as string in self.SubscribersByTopic.keys
		    ret.Add(k)
		    
		  next
		  
		  return ret
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrMessageOutputFor(prmTopic as string) As integer
		  var nbr as integer
		  
		  if self.SubscribersByTopic = nil then return -2
		  
		  if not self.SubscribersByTopic.HasKey(prmTopic) then return -1
		  
		  var arr() as clNotificationSubscription = self.SubscribersByTopic.Value(prmTopic)
		  
		  for each subs as clNotificationSubscription in arr
		    nbr = nbr + subs.NbrMessagesInQueue
		    
		  next
		  
		  Return nbr
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrMessagesInInputQueue() As integer
		  Return self.InputQueue.Count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrMessagesInTransit() As integer
		  //
		  // Total number of messages in the system
		  // This number may grow once messages from the input queue are sorted
		  //
		  var n as integer =  self.InputQueue.Count 
		  
		  for each s as clNotificationSubscription in self.Subscribers
		    n = n +  s.NbrMessagesInQueue
		    
		  next
		  
		  return n
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrSubscriptions() As integer
		  Return self.Subscribers.Count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrSubscriptionsFor(prmTopic as string) As integer
		  
		  if self.SubscribersByTopic = nil then return -2
		  
		  if not self.SubscribersByTopic.HasKey(prmTopic) then return -1
		  
		  var arr() as clNotificationSubscription = self.SubscribersByTopic.Value(prmTopic)
		  
		  Return arr.Count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Pause()
		  
		  self.TraceMessage("Pause")
		  
		  self.internal_Publish(cInternalSender, cReservedTopicSystem, "System paused", nil, -1)
		  
		  self.IsRunning = False
		  self.processLoopTimer.RunMode = timer.RunModes.Off
		  
		  // ProcessQueues
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PerformAction()
		  // Part of the actionNotificationReceiver interface.
		  
		  
		  ProcessQueues
		  
		  UpdateTimerStatus
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessQueues()
		  
		  
		  self.TraceMessage("ProcessQueues")
		  
		  if InputQueue.Count = 0 and Subscribers.Count = 0 then Return
		  
		  self.TraceMessage("Has pending message to sort")
		  
		  select case self.Configuration.ManagerStrategy
		    
		  case clNotificationConfiguration.HandlingStrategy.SortFirst
		    SortMessages
		    DistributeMessages
		    
		  case clNotificationConfiguration.HandlingStrategy.DistributeFirst
		    DistributeMessages
		    SortMessages
		    DistributeMessages
		    
		  case else
		    
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish(callerID as string, Topic as string, Message as string, SenderClientID as integer)
		  
		  if topic <> cReservedTopicSystem then
		    self.internal_Publish(callerID, Topic, Message, nil, SenderClientID)
		    
		    
		  end if
		   
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish(callerID as string, Topic as string, Message as string, Details as variant, SenderClientID as integer)
		  
		  if topic <> cReservedTopicSystem then
		    self.internal_Publish(callerID, Topic, Message, Details, SenderClientID)
		    
		    
		  end if
		   
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub PublishToDefault(callerID as string, Topic as string, Message as string, SenderClientID as integer)
		  clNotificationManager.GetDefault.Publish(callerID, Topic, Message, SenderClientID)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub PublishToDefault(callerID as string, Topic as string, Message as string, Details as variant, SenderClientID as integer)
		  clNotificationManager.GetDefault.Publish(callerID, Topic, Message, Details, SenderClientID)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub registerSubscription(NotificationTopic as string, subscription as clNotificationSubscription)
		  
		  var arr() as clNotificationSubscription
		  
		  if self.SubscribersByTopic = nil then self.SubscribersByTopic = new Dictionary
		  
		  if self.SubscribersByTopic.HasKey(NotificationTopic) then 
		    arr = self.SubscribersByTopic.Value(NotificationTopic)
		    
		  else
		    
		  end if
		  
		  arr.Add(subscription)
		  
		  self.SubscribersByTopic.Value(NotificationTopic) = arr
		  
		  Subscribers.Add(subscription)
		  
		  self.internal_Publish(cInternalSender, cReservedTopicSystem,  _
		  internal_ProcessParameters("Register client %0 for topic %1", subscription.SubscriberClientID.ToString,NotificationTopic) _
		  ,nil , -1)
		  
		  self.TraceMessage("Subscription wih id " + subscription.ID.ToString)
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Run()
		  
		  self.TraceMessage("Run")
		  
		  self.internal_Publish(cInternalSender, cReservedTopicSystem, "System running", nil, -1)
		  
		  self.IsRunning = true
		  
		  self.processLoopTimer.Period = self.Configuration.MessageSortingDelay
		  
		  self.processLoopTimer.RunMode = timer.RunModes.Multiple
		  
		  ProcessQueues
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Running() As Boolean
		  Return self.IsRunning
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SortMessages()
		  
		  self.TraceMessage("SortMessages")
		  
		  if self.SubscribersByTopic =nil then 
		    self.InputQueue.RemoveAll
		    Return
		    
		  end if
		  
		  if InputQueue.Count = 0 then return
		  
		  self.TraceMessage("SortMessages has messages to dispatch")
		  
		  for each m as clNotificationMessage in self.InputQueue
		    var t as string = m.Topic
		    
		    if self.SubscribersByTopic.HasKey(t) then
		      self.TraceMessage("Found subscribers for topic " +t)
		      
		      var arr() as clNotificationSubscription = self.SubscribersByTopic.Value(t)
		      
		      
		      if arr.Count = 1 then 
		        arr(0).AddMessage(m)
		        
		      else
		        
		        for each s as clNotificationSubscription in arr
		          s.AddMessage(m.Clone())
		          
		        next
		        
		      end if
		      
		      
		    else
		      self.TraceMessage("No subscribers for topic " +t)
		      
		    end if
		  next
		  
		  self.InputQueue.RemoveAll
		  
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start(DropPendingMessage as Boolean)
		  
		  self.TraceMessage("Start")
		  
		  if DropPendingMessage then
		    self.InputQueue.RemoveAll
		    
		  end if
		  
		  self.internal_Publish(cInternalSender, cReservedTopicSystem,  "System staring", nil, -1)
		  
		  self.Run
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Subscribe(NotificationTopic as string, Consumer as itfNotifiable, SubscriberClientID as integer) As integer
		  
		  self.TraceMessage("Subscribe to " + NotificationTopic)
		  
		  var subscription as new clNotificationSubscription(NotificationTopic, self.Configuration, Consumer, SubscriberClientID)
		  
		  self.registerSubscription(NotificationTopic, subscription)
		  
		  Return subscription.ID
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Subscribe(NotificationTopic as string, Consumer as itfNotifiableWithRawMessage, SubscriberClientID as integer) As integer
		  
		  self.TraceMessage("Subscribe to " + NotificationTopic)
		  
		  var subscription as new clNotificationSubscription(NotificationTopic, self.Configuration, Consumer, SubscriberClientID)
		  
		  self.registerSubscription(NotificationTopic, subscription)
		  
		  Return subscription.ID
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function SubscribeToDefault(NotificationTopic as string, Consumer as itfNotifiable, SubscriberClientID as integer) As integer
		  return clNotificationManager.GetDefault.Subscribe(NotificationTopic, Consumer, SubscriberClientID)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function SubscribeToDefault(NotificationTopic as string, Consumer as itfNotifiableWithRawMessage, SubscriberClientID as integer) As integer
		  return clNotificationManager.GetDefault.Subscribe(NotificationTopic, Consumer, SubscriberClientID)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TraceMessage(msg as String)
		  
		  if TraceAll then System.DebugLog(msg)
		  //"[" ++ "]"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateConfiguration(newConfiguration as clNotificationConfiguration)
		  
		  self.Configuration = newConfiguration
		  for each s as clNotificationSubscription in self.Subscribers
		    s.UpdateConfiguration(newConfiguration)
		    
		  next
		  
		  self.internal_Publish(cInternalSender, cReservedTopicSystem,  "Uupdate configuration", nil, -1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub UpdateTimerStatus()
		  
		  //
		  // Anything else left to process
		  // Otherwise, switch off the timer until next publish
		  //
		  
		  
		  if NbrMessagesInTransit = 0 then
		    self.processLoopTimer.RunMode = timer.RunModes.Off
		    
		  else
		    self.processLoopTimer.RunMode = timer.RunModes.Multiple
		    
		  end if
		  
		  return
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Configuration As clNotificationConfiguration
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared DefaultNM As clNotificationManager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private InputQueue() As clNotificationMessage
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private processLoopTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Subscribers() As clNotificationSubscription
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SubscribersByTopic As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared TraceAll As Boolean = True
	#tag EndProperty


	#tag Constant, Name = cInternalSender, Type = String, Dynamic = False, Default = \"Notification system", Scope = Private
	#tag EndConstant

	#tag Constant, Name = cReservedTopicSystem, Type = String, Dynamic = False, Default = \"$SYS", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
