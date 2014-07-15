Scriptname EFFIdleMonitor extends Quest

EFFCore Property XFLMain Auto

int Property UpdateInterval auto
float Property SettleRadius auto

int __historySize = 8 ; remember to update the declarations if necessary
float[] __playerPosX
float[] __playerPosY
float[] __playerPosZ

Function OnInit()
	; history of player position over the last __historySize updates
	__playerPosX = new float[8]
	__playerPosY = new float[8]
	__playerPosZ = new float[8]

	; initialize the position histories with faraway junk datums
	;  so that we won't immediately assume the player is holding 
	;  still when the quest starts
	Actor _player = Game.GetPlayer()
	int count = 0
	while (count < __historySize)
		__playerPosX[count] = _player.X + 1000
		__playerPosY[count] = _player.Y + 1000
		__playerPosZ[count] = _player.Z + 1000
		count += 1
	endwhile

	RegisterForSingleUpdate(UpdateInterval)
EndFunction

bool Function IsRunning()
	return GetState() == "Idling" || GetState() == ""
EndFunction

Function StartIdle()
	If GetState() == "Stopped"
		GotoState("Idling")
		RegisterForSingleUpdate(UpdateInterval)
	Endif
EndFunction

Function StopIdle()
	GotoState("Stopped")
	XFLMain.XFL_AutoSandbox(false)
EndFunction

Auto State Idling
	Event OnUpdate()
		; cycle all positions down one notch in the history arrays
		int historyIndex = 0
		while (historyIndex < __historySize - 1)
			__playerPosX[historyIndex] = __playerPosX[historyIndex + 1]
			__playerPosY[historyIndex] = __playerPosY[historyIndex + 1]
			__playerPosZ[historyIndex] = __playerPosZ[historyIndex + 1]

			historyIndex += 1
		endwhile

		; set the most recent history as the current player position
		Actor _player = Game.GetPlayer()
		__playerPosX[__historySize - 1] = _player.X
		__playerPosY[__historySize - 1] = _player.Y
		__playerPosZ[__historySize - 1] = _player.Z

		If XFLMain.XFL_FollowerCountEx.GetValue() > 0
			; calculate distance between history start and present
			;    sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
			float xFactor = (__playerPosX[0] - _player.X)
			xFactor = xFactor * xFactor
			float yFactor = (__playerPosY[0] - _player.Y)
			yFactor = yFactor * yFactor
			float zFactor = (__playerPosZ[0] - _player.Z)
			zFactor = zFactor * zFactor

			float distance = Math.sqrt(xFactor + yFactor + zFactor)

			; if the player has moved less than the defined settle radius,
			;   set the flag that the sandbox package is looking for.
			if (distance > SettleRadius)
				XFLMain.XFL_AutoSandbox(false)
			else
				XFLMain.XFL_AutoSandbox(true)
			endif
		Endif

		; do it all again
		RegisterForSingleUpdate(UpdateInterval)
	EndEvent
EndState

State Stopped
	Event OnUpdate()
		; Do nothing in the stopped state
	EndEvent
EndState