# Voyce

<b> 1. What functionality/code has been added? </b>

<ol type="a">
  <li>Switched database functionality from old database to new database. This includes updates to the GoogleService-Info.plist and Info.plist files.</li>
  <li>Changed the functionality where a user clicks on a like, the number of vibes keeps on incrementing. It used to be when a user clicked on a like the number of vibes would decrement or reset to 1. The main code change is in the switchButton() function in the PostTableViewCell.swift file.</li>
  <li>Commented the UnacknowledgePost function out so that users will be able to acknowledge the post as many times as they want. This includes updates to the UserManager.swift file.</li>
  <li> Added a function called randomEmoji() that returns random iPhone emojis (for now). This allows the feed to show random emojis when a user clicks on the like button next to a post. This includes updates to the PostTableViewCell.swift file.</li>
</ol>


<b> 2. How to compile? </b>

To compile the program, you should first download Xcode 11. Once you have successfully installed the IDE, you need to install CocoaPods. This process can be very tricky. The easiest way to compile the program, and make it run is to install the Cocoapods using the "Sudo-less installation" directions. 

These directions can found at: https://guides.cocoapods.org/using/getting-started.html.<br />
After Cocoapods is installed, your program should be able to compile.

<b> 3. How to deploy? </b>

Once CocoaPods is installed successfully, go to your terminal and execute: <pre><code>open Voyce.xcworkspace</code></pre>
After Xcode opens, click on the 'play' or 'build and then run on current scheme' button at the top left corner of the interface to deploy the program

<b> 4. How to run the program? </b>

Open the Voyce app on the iPhone simulator and navigate through the user interface!
