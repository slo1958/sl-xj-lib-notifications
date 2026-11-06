#tag Class
Class clNotificationManager
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  self.IsRunning = false
		  self.DispatchingDelay = 100
		  
		  self.processLoopTimer = new Timer
		  self.processLoopTimer.RunMode = timer.RunModes.Off
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DistributeMessages()
		  
		  if Subscribers.Count = 0 then return
		  
		  for each s as clNotificationSubscription in self.Subscribers
		    s.DistributeNext
		    
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

	#tag Method, Flags = &h0
		Sub Pause()
		  
		  self.TraceMessage("Pause")
		  
		  self.IsRunning = False
		  self.processLoopTimer.RunMode = timer.RunModes.Off
		  
		  ProcessQueues
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessQueues()
		  
		  
		  self.TraceMessage("ProcessQueues")
		  
		  if MessagesToDispatch.Count = 0 and Subscribers.Count = 0 then Return
		  
		  const StrategySortFirst as integer = 1
		  const StrategyDispatchFirst as integer = 2
		  
		  var tempStrategy as integer = StrategyDispatchFirst
		  
		  self.TraceMessage("Has pending message to sort")
		  
		  select case tempStrategy
		    
		  case StrategySortFirst
		    SortMessages
		    DistributeMessages
		    
		  case StrategyDispatchFirst
		    DistributeMessages
		    SortMessages
		    DistributeMessages
		    
		  case else
		    
		  end select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Publish(callerID as string, Topic as string, Message as string)
		  
		  self.TraceMessage("Publish " + callerID + " " + Topic + " " + Message)
		  
		  var msg as new clNotificationMessage(callerId, Topic, Message)
		  self.MessagesToDispatch.Add(msg)
		  
		  if self.IsRunning then
		    ProcessQueues
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub PublishToDefault(callerID as string, Topic as string, Message as string)
		  clNotificationManager.GetDefault.Publish(callerID, Topic, Message)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Run()
		  
		  self.TraceMessage("Run")
		  
		  self.IsRunning = true
		  self.processLoopTimer.Period = 10
		  
		  self.processLoopTimer.RunMode = timer.RunModes.Multiple
		  
		  ProcessQueues
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SortMessages()
		  
		  self.TraceMessage("SortMessages")
		  
		  if self.SubscribersByTopic =nil then 
		    self.MessagesToDispatch.RemoveAll
		    Return
		    
		  end if
		  
		  if MessagesToDispatch.Count = 0 then return
		  
		  self.TraceMessage("SortMessages has messages to dispatch")
		  
		  for each m as clNotificationMessage in self.MessagesToDispatch
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
		  
		  self.MessagesToDispatch.RemoveAll
		  
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start(DropPendingMessage as Boolean)
		  
		  self.TraceMessage("Start")
		  
		  if DropPendingMessage then
		    self.MessagesToDispatch.RemoveAll
		    
		  end if
		  
		  self.Run
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Subscribe(NotificationTopic as string, Consumer as itfNotificationCallback) As integer
		  
		  self.TraceMessage("Subscribe to " + NotificationTopic)
		  
		  var arr() as clNotificationSubscription
		  
		  if self.SubscribersByTopic = nil then self.SubscribersByTopic = new Dictionary
		  
		  if self.SubscribersByTopic.HasKey(NotificationTopic) then 
		    arr = self.SubscribersByTopic.Value(NotificationTopic)
		    
		  else
		    
		  end if
		  
		  var subscription as new clNotificationSubscription(NotificationTopic, Consumer)
		  
		  arr.Add(subscription)
		  
		   self.SubscribersByTopic.Value(NotificationTopic) = arr
		  
		  Subscribers.Add(subscription)
		  
		  self.TraceMessage("Subscription wih id " + subscription.ID.ToString)
		  
		  Return subscription.ID
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TraceMessage(msg as String)
		  
		  if TraceAll then System.DebugLog(msg)
		  //"[" ++ "]"
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Shared DefaultNM As clNotificationManager
	#tag EndProperty

	#tag Property, Flags = &h21
		Private DispatchingDelay As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private IsRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MessagesToDispatch() As clNotificationMessage
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
