/*
	AutoHotKey Windows key reassigner for nwjs

	This script will run along with the node webkit app as a child process.
	It will reassign the "Ctrl+Alt+Shift" key combo in the NW app to the Winkey.
	The script accepts a single command line parameter, which will be the hotkey combined with the Winkey in the NW app.

	Notes: 
		- Script must be compiled to accept parameters. Use AHK2Exe.

	NWJS example usage:

		winKeyAHK(['a', 'b', 'c']); // AHK command line parameters: http://www.autohotkey.com/docs/Scripts.htm#cmd
		initHotkey('Ctrl+Alt+Shift+a');
		initHotkey('Ctrl+Alt+Shift+b');
		initHotkey('Ctrl+Alt+Shift+c');

		function winKeyAHK(keys) {
			var spawn = require('child_process').spawn,
				child = spawn('<path to nwjs_winkey.exe>', keys);
		}

		function initHotkey(hotkey) {
			var option = {
			  key : hotkey,
			  active : function() {
			   	// do stuff
			  },
			  failed : function(msg) {
			    console.log(msg);
			  }
			};

			shortcut = new gui.Shortcut(option);
			gui.App.unregisterGlobalHotKey(shortcut); // Reset the shortcut on app reload.
			gui.App.registerGlobalHotKey(shortcut);
		}

	(steelskysoftware@gmail.com, 2015)
*/

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance, Force
#ErrorStdOut
#NoTrayIcon
#Persistent

Loop, %0% ; dynamic variable 0 contains the number of parameters
{
	param := %A_Index% ; A_Index is the current loop iteration
	Hotkey, #%param%, runWinKeyCombo ; "#" is either windows key.
}
return

; we'll use Control+Shift+Alt for every hotkey combo since this combo is rarely used, and currently (0.11.6) nwjs's Shortcut API only supports these three modifiers for Windows.
runWinKeyCombo:
{
	currentHotkey = %A_ThisHotkey% ; if Win+A is pressed this will contain "#a".
	StringReplace, currentHotkey, currentHotkey, #, , All ; remove the "#" so we can just send "a".
	send {Control Down}{Shift Down}{Alt Down}
	send %currentHotkey%
	send {Control Up}{Shift Up}{Alt Up}
}
return
