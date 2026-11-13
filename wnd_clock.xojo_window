#tag DesktopWindow
Begin DesktopWindow wnd_clock Implements Notifications.itfNotifiable
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   366
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "One notification every 10 seconds"
   Type            =   0
   Visible         =   True
   Width           =   578
   Begin DesktopListBox ListBox1
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   1
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   244
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   47
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   538
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopButton btn_start
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Start timer"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   28
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   303
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   157
   End
   Begin DesktopButton btn_stop
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Stop timer"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   436
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   303
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   122
   End
   Begin DesktopLabel Label1
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Don't forget to start the notification system in the control panel window."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   15
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   531
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  
		  clNotificationManager.GetDefault.CancelSubscriptions(Subscriptions)
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  //
		  // Put all subscriptions in an array, so we can esaily unsubscribe when the window is closing
		  //
		  
		  self.Subscriptions.Add(clNotificationManager.SubscribeToDefault(cClockTopic, self, -1))
		  
		  // Register a timer 
		  TimeriD = clNotificationManager.GetDefault.RegisterTimer(cClockTopic,"hello",10000)
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub NotificationReceived(Sender as string, Topic as String, Message as String, SenderClientID as int64)
		  // Part of the Notifications.itfNotifiable interface.
		  
		  var t as string = DateTime.Now.SQLDateTime
		  Listbox1.AddRowAt(0, t + ". " + Message)
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Subscriptions() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private TimeriD As Integer
	#tag EndProperty


	#tag Constant, Name = cClockMessage, Type = String, Dynamic = False, Default = \"Hello", Scope = Public
	#tag EndConstant

	#tag Constant, Name = cClockTopic, Type = String, Dynamic = False, Default = \"clk", Scope = Public
	#tag EndConstant


#tag EndWindowCode

#tag Events btn_start
	#tag Event
		Sub Pressed()
		  
		  clNotificationManager.GetDefault.TimerStart(self.TimeriD)
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btn_stop
	#tag Event
		Sub Pressed()
		  clNotificationManager.GetDefault.TimerStop(self.TimeriD)
		  
		End Sub
	#tag EndEvent
#tag EndEvents
