// file: PauseActionReceiver.kt
package org.example.iccmw

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class PauseActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "PAUSE_ACTION") {
            // Perform your action here, like pausing playback
            Toast.makeText(context, "Playback paused", Toast.LENGTH_SHORT).show()
            // Optionally, you can communicate this back to Flutter if needed
        }
    }
}
