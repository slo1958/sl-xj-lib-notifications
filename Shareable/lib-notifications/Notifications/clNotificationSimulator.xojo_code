#tag Class
Protected Class clNotificationSimulator
Implements Notifications.itfNotifiable
	#tag Method, Flags = &h0
		Sub Constructor(notifications() as pair)
		  
		  self.mNotificationsToSend = notifications
		  
		  WeStartedManager = false
		  
		  return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  
		  if timerid >= 0 then 
		    clNotificationManager.GetDefault.TimerCancel(TimerID)
		    timerid = -1
		    
		  end if
		  
		  if SubscriptionID >= 0 Then
		    clNotificationManager.GetDefault.CancelSubscription(SubscriptionID)
		    SubscriptionID = -1
		    
		  end if
		  
		  if WeStartedManager then
		    clNotificationManager.GetDefault.Pause()
		    
		    WeStartedManager = false 
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NotificationReceived(Sender as string, Topic as String, Message as String, SenderClientID as int64)
		  // Part of the Notifications.itfNotifiable interface.
		  
		  if self.mNotificationsToSend.Count = 0 then
		    clNotificationManager.GetDefault.TimerStop(self.TimerID)
		    
		    if timerid >= 0 then 
		      clNotificationManager.GetDefault.TimerCancel(TimerID)
		      timerid = -1
		      
		    end if
		    
		    if SubscriptionID >= 0 Then
		      clNotificationManager.GetDefault.CancelSubscription(SubscriptionID)
		      SubscriptionID = -1
		      
		    end if
		    
		    if self.mEndTopic.Length > 0 then clNotificationManager.PublishToDefault(cCaller, self.mEndTopic, self.mEndMessage, -1)
		    
		    Return
		    
		  end if
		  
		  var p as pair = self.mNotificationsToSend(0)
		  self.mNotificationsToSend.RemoveAt(0)
		  
		  
		  var msgTopic as string = p.Left
		  var msgMessage as string = p.Right
		  
		  clNotificationManager.PublishToDefault(cCaller, msgTopic, msgMessage, -1)
		  
		  Return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NotifySimulationDone(EndTopic as string, endMessage as string)
		  
		  self.mEndTopic = EndTopic
		  self.mEndMessage = endMessage
		  
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start(delay as integer)
		  
		  self.SubscriptionID = clNotificationManager.SubscribeToDefault(cNotifs, self, -1)
		  
		  self.TimerID = clNotificationManager.RegisterTimerInDefault(cNotifs, "X", delay)
		  
		  
		  if not clNotificationManager.GetDefault.Running then
		    WeStartedManager = true
		    clNotificationManager.GetDefault.Start(true)
		    
		  else
		    WeStartedManager = false
		    
		  end if
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mEndMessage As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEndTopic As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mNotificationsToSend() As pair
	#tag EndProperty

	#tag Property, Flags = &h21
		Private SubscriptionID As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TimerID As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private WeStartedManager As Boolean
	#tag EndProperty


	#tag Constant, Name = cCaller, Type = String, Dynamic = False, Default = \"SIMULATOR", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cNotifs, Type = String, Dynamic = False, Default = \"NOTSIM", Scope = Public
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
		#tag ViewProperty
			Name="mNotificationsToSend()"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
