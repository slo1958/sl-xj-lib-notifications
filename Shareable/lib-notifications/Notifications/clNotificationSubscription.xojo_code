#tag Class
Protected Class clNotificationSubscription
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Sub AddMessage(msg as clNotificationMessage)
		  
		  self.TraceMessage("Add message")
		  
		  if msg.SenderClientID >= 0 and msg.SenderClientID = self.SubscriberClientID and self.Configuration.ApplyFilterOnClientID then
		    // ignore message
		    
		  else
		    self.MessageQueue.Add(msg)
		    
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(prmTopic as string, config as clNotificationConfiguration, SubscriberClientID as integer)
		  self.mSubscriptionID = NextID
		  self.mSubscribedTopic = prmTopic
		  self.Configuration = config
		  self.mSubscriberClientID = SubscriberClientID
		  
		  self.CallSeq = new timer
		  
		  self.CallSeq.RunMode = timer.RunModes.Off
		  self.CallSeq.AddActionNotificationReceiver(self)
		  
		  self.ExtendedCallback = nil
		  self.StandardCallback = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(prmTopic as string, config as clNotificationConfiguration, prmCallback as itfNotifiable, SubscriberClientID as integer)
		  
		  self.Constructor(prmTopic, config, SubscriberClientID)
		  
		  self.StandardCallback = prmCallback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(prmTopic as string, config as clNotificationConfiguration, prmCallback as itfNotifiableWithRawMessage, SubscriberClientID as integer)
		  
		  self.Constructor(prmTopic, config, SubscriberClientID)
		  
		  self.ExtendedCallback = prmCallback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DistributeAll()
		  
		  self.TraceMessage("DistributeAll")
		  
		  if MessageQueue.Count = 0 then return
		  
		  self.TraceMessage("DistributeAll has message to distribute")
		  
		  self.CallSeq.Period = self.Configuration.MessageDistributionDelay
		  
		  self.CallSeq.RunMode = timer.RunModes.Multiple
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DistributeNext()
		  self.TraceMessage("DistributeNext")
		  
		  if MessageQueue.Count = 0 then return
		  
		  self.CallSeq.Period = self.Configuration.MessageDistributionDelay
		  
		  self.CallSeq.RunMode = timer.RunModes.Single
		  
		  return
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ID() As integer
		  Return mSubscriptionID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NbrMessagesInQueue() As integer
		  Return self.MessageQueue.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function NextID() As integer
		  UniqueSubscriptionID = UniqueSubscriptionID + 1
		  return UniqueSubscriptionID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PerformAction()
		  
		  self.TraceMessage("PerformAction")
		  
		  if MessageQueue.Count = 0 then 
		    if self.CallSeq.RunMode = timer.RunModes.Multiple then self.CallSeq.RunMode = timer.RunModes.Off
		    return
		    
		  end if
		  
		  self.TraceMessage("PerformAction has messages")
		  
		  var msg as clNotificationMessage = self.MessageQueue(0)
		  self.MessageQueue.RemoveAt(0)
		  
		  msg.MarkDistrbuted()
		  
		  if self.StandardCallback <> nil then self.StandardCallback.SignalReceived( _
		  msg.Sender _
		  , msg.Topic _
		  , msg.Message _
		  , msg.SenderClientID)
		  
		  if self.ExtendedCallback <> nil then self.ExtendedCallback.MessageReceived(msg)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SubscriberClientID() As integer
		  Return mSubscriberClientID
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Topic() As string
		  Return self.mSubscribedTopic
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TraceMessage(msg as String)
		  
		  clNotificationManager.TraceMessage(msg)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateConfiguration(newConfiguration as clNotificationConfiguration)
		  
		  self.Configuration = newConfiguration
		  
		  self.CallSeq.Period = self.Configuration.MessageDistributionDelay
		  
		  Return
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CallSeq As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Configuration As clNotificationConfiguration
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ExtendedCallback As itfNotifiableWithRawMessage
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MessageQueue() As clNotificationMessage
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubscribedTopic As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubscriberClientID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSubscriptionID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StandardCallback As itfNotifiable
	#tag EndProperty

	#tag Property, Flags = &h21
		Private StartedOn As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared UniqueSubscriptionID As Integer
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
		#tag ViewProperty
			Name="StartedOn"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mSubscriptionID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
