#tag Class
Protected Class clNotificationSubscription
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Sub AddMessage(msg as clNotificationMessage)
		  
		  self.TraceMessage("Add message")
		  
		  self.MessageQueue.Add(msg)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor(prmTopic as string)
		  self.SubscriptionID = NextID
		  self.SubscribedTopic = prmTopic
		  
		  self.CallSeq = new timer
		  
		  self.CallSeq.RunMode = timer.RunModes.Off
		  self.CallSeq.AddActionNotificationReceiver(self)
		  
		  self.ExtendedCallback = nil
		  self.StandardCallback = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(prmTopic as string, prmCallback as itfExtendedNotificationCallback)
		  
		  self.Constructor(prmTopic)
		  
		  self.ExtendedCallback = prmCallback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(prmTopic as string, prmCallback as itfNotificationCallback)
		  
		  self.Constructor(prmTopic)
		  
		  self.StandardCallback = prmCallback
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DistributeAll()
		  
		  self.TraceMessage("DistributeAll")
		  
		  if MessageQueue.Count = 0 then return
		  
		  self.TraceMessage("DistributeAll has message to distribute")
		  
		  self.CallSeq.Period = 1
		  self.CallSeq.RunMode = timer.RunModes.Multiple
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DistributeNext()
		  self.TraceMessage("DistributeNext")
		  
		  if MessageQueue.Count = 0 then return
		  
		  self.CallSeq.Period = 3
		  self.CallSeq.RunMode = timer.RunModes.Single
		  
		  return
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ID() As integer
		  Return SubscriptionID
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
		  
		  if self.StandardCallback <> nil then self.StandardCallback.SignalReceived(msg.Sender, msg.Topic, msg.Message)
		  if self.ExtendedCallback <> nil then self.ExtendedCallback.MessageReceived(msg)
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TraceMessage(msg as String)
		  
		  clNotificationManager.TraceMessage(msg)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CallSeq As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		ExtendedCallback As itfExtendedNotificationCallback
	#tag EndProperty

	#tag Property, Flags = &h0
		MessageQueue() As clNotificationMessage
	#tag EndProperty

	#tag Property, Flags = &h0
		StandardCallback As itfNotificationCallback
	#tag EndProperty

	#tag Property, Flags = &h0
		StartedOn As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SubscribedTopic As string
	#tag EndProperty

	#tag Property, Flags = &h0
		SubscriptionID As Integer
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
			Name="MessageQueue()"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
