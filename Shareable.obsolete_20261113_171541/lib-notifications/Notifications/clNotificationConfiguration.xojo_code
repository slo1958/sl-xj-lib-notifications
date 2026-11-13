#tag Class
Protected Class clNotificationConfiguration
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		  //
		  // All message queues are handling via timer actions
		  //
		  
		  // This is the processing of the input queue, sorting by topic and forwarding to subscription queues
		  self.MessageSortingDelay = 50
		  
		  // This is the processing of the distribution queue
		  self.MessageDistributionDelay = 3
		  
		  // This is in which order the input and output are processed
		  self.ManagerStrategy = HandlingStrategy.DistributeFirst
		  
		  // This is how multiple subscription are handled
		  self.DistributionStrategy = DistributionOrder.CycleQueueFirst
		  
		  // This is to support MQTT style structured topics, where a sunscriber to aaa/* get all messages with topics aaa/bbb, aaa/ccc, ..
		  // (not implemented) 
		  self.HandleStructuredTopicSubscription = false
		  
		  // Present notification explosion when a notification handler forward the notification
		  self.ApplyFilterOnClientID = True
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ApplyFilterOnClientID As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		DistributionStrategy As DistributionOrder
	#tag EndProperty

	#tag Property, Flags = &h0
		HandleStructuredTopicSubscription As boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		ManagerStrategy As HandlingStrategy
	#tag EndProperty

	#tag Property, Flags = &h0
		MessageDistributionDelay As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		MessageSortingDelay As Integer
	#tag EndProperty


	#tag Enum, Name = DistributionOrder, Type = Integer, Flags = &h0
		EmptyQueueFirst
		CycleQueueFirst
	#tag EndEnum

	#tag Enum, Name = HandlingStrategy, Type = Integer, Flags = &h0
		SortFirst
		DistributeFirst
	#tag EndEnum


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
			Name="MessageSortingDelay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DistributionStrategy"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="DistributionOrder"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HandleStructuredTopicSubscription"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ManagerStrategy"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="HandlingStrategy"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MessageDistributionDelay"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
