#tag Class
Protected Class clNotificationMessage
	#tag Method, Flags = &h0
		Function Clone() As clNotificationMessage
		  
		  var temp as new clNotificationMessage(self.mSender, self.mTopic, self.mMessage)
		  
		  temp.mOriginalCreatedAt = self.mCreatedAt
		  temp.mOriginalMessageID = self.mMessageId
		  
		  return temp
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(prmCallerID as string, prmTopic as string, prmMessage as string)
		  self.mCreatedAt = System.MicroSeconds
		  self.mMessageID = NextID
		  
		  self.mOriginalCreatedAt = self.mCreatedAt
		  self.mOriginalMessageID = self.mMessageID
		  
		  self.mSender = prmCallerID
		  self.mTopic = prmTopic
		  self.mMessage = prmMessage
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreatedAt() As double
		  return self.mCreatedAt
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MarkDistrbuted()
		  self.DistrbutedOn = system.Microseconds
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Message() As string
		  return self.mMessage
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MessageId() As integer
		  Return self.mMessageID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function NextID() As integer
		  UniqueMessageID = UniqueMessageID + 1
		  return UniqueMessageID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalCreatedAt() As double
		  return self.mOriginalCreatedAt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OriginalMessageId() As integer
		  Return self.mOriginalMessageID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Sender() As string
		  return self.mSender
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Topic() As string
		  return self.mTopic
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private DistrbutedOn As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCreatedAt As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessage As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessageID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalCreatedAt As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOriginalMessageID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSender As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTopic As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared UniqueMessageID As Integer
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
			Name="mSender"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mTopic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="mMessage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
