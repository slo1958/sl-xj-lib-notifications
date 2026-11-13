#tag Module
Protected Module Notifications
	#tag Method, Flags = &h0
		Sub NotificationSimulator(notifs() as pair, delay as integer, EndTopic as string, endMessage as string)
		  var c as new clNotificationSimulator(Notifs)
		  
		  c.NotifySimulationDone(EndTopic, endMessage)
		  
		  c.Start(delay)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Signal(callerID as string, Topic as string, Message as string, ClientID as integer)
		  clNotificationManager.PublishToDefault(callerID, Topic, Message, ClientID)
		  
		  
		End Sub
	#tag EndMethod


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
End Module
#tag EndModule
