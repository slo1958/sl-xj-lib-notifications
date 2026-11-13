#tag Class
Protected Class clNotificationTimeTriggered
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Sub Constructor(Topic as string, Message as String, Periodicity as integer)
		  
		  //
		  // placeholders : 
		  //  %0  datetime at time of publish as SqlDateTime
		  //  %1  mesage sequence number
		  // 
		  
		  self.mTopic = Topic
		  
		  self.UpdateMessage(Message)
		  
		  self.init_internal(Periodicity)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub init_internal(Periodicity as integer)
		  
		  self.mCreatedAt = System.MicroSeconds
		  self.mTimerID = NextID
		  
		  self.mPeriodicity = Periodicity
		  
		  self.CallSeq = new timer
		  
		  self.CallSeq.RunMode = timer.RunModes.Off
		  
		  self.CallSeq.AddActionNotificationReceiver(self)
		  
		  if mPeriodicity > 0 then
		    self.CallSeq.Period = mPeriodicity
		    
		    self.CallSeq.RunMode = timer.RunModes.Off
		    
		  end if
		  
		  self.mcallCount = 0
		  
		  return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Message() As string
		  return self.mMessage
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function NextID() As integer
		  UniqueTimerID = UniqueTimerID + 1
		  return UniqueTimerID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PerformAction()
		  // Part of the actionNotificationReceiver interface.
		  
		  var temp as string
		  
		  if self.mMessageHasPlaceHolders  then
		    var p1 as string = DateTime.Now.SQLDateTime
		    var p2 as string = self.mcallCount.ToString
		    
		    temp = clNotificationManager.ProcessParameters(Message, "[" + p1 + "]", "[" + p2 + "]")
		    
		  else
		    temp = Message
		    
		  end if
		  clNotificationManager.GetDefault.Publish(cClockCallerID, Topic, temp, -1)
		  
		  self.mcallCount = self.mcallCount + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function RunMode() As Timer.RunModes
		  if self.CallSeq = nil then
		    return timer.RunModes.Off
		    
		  else
		    return self.CallSeq.RunMode
		    
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  
		  if self.CallSeq = nil then Return
		  
		  self.CallSeq.RunMode = timer.RunModes.Multiple
		  
		  self.mLastStart = System.MicroSeconds
		  
		  return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  
		  if self.CallSeq = nil then Return
		  
		  self.CallSeq.RunMode = timer.RunModes.Off
		  
		  self.mLastStop = System.MicroSeconds
		  
		  return
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TimerID() As integer
		  Return self.mTimerID
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Topic() As string
		  return self.mTopic
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateMessage(newMessage as string)
		  self.mMessage = Message
		  
		  self.mMessageHasPlaceHolders =  Message.IndexOf("%") > 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdatePeriodicity(NewPeriodicity as integer)
		  
		  self.mPeriodicity = NewPeriodicity
		  
		  if self.CallSeq <> nil then
		    self.CallSeq.Period = NewPeriodicity
		    
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private CallSeq As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultMsg As string
	#tag EndProperty

	#tag Property, Flags = &h0
		DefaultTopic As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mcallCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCreatedAt As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastStart As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastStop As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessage As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mMessageHasPlaceHolders As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPeriodicity As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSenderClientID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTimerID As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTopic As string
	#tag EndProperty

	#tag Property, Flags = &h0
		Periodicity As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Shared UniqueTimerID As Integer
	#tag EndProperty


	#tag Constant, Name = cClockCallerID, Type = String, Dynamic = False, Default = \"CLOCK", Scope = Private
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
			Name="Periodicity"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultTopic"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DefaultMsg"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
