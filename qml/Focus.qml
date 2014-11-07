import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: pomodoroRoot

    property real timeLeft: 0
    property int hoursLeft: Math.floor(timeLeft / 60 / 60)
    property int minutesLeft: Math.floor((timeLeft % 3600) / 60)
    property int secondsLeft: Math.floor((timeLeft % 60))

    width: 1280
    height: 720

    state: "break"

    function pad(num, size) {
        var s = Math.floor(num)+"";
        while (s.length < size) {
            s = "0" + s;
        }
        return s;
    }

    states: [
        State {
            name: "pomodoro"
            PropertyChanges {
                target: pomodoroRoot
                color: "#AB2231"
            }
            PropertyChanges {
                target: headerText
                text: "Focusing for"
            }
            PropertyChanges {
                target: footerText
                text: (hoursLeft > 0) ? "more hours" : ((minutesLeft > 0) ? "more minutes" : "more seconds")
            }
        },
        State {
            name: "pause"
            PropertyChanges {
                target: pomodoroRoot
                color: "#ff7f00"
            }
            PropertyChanges {
                target: headerText
                text: "Pausing with"
            }
            PropertyChanges {
                target: footerText
                text: (hoursLeft > 0) ? "hours left" : ((minutesLeft > 0) ? "minutes left" : "seconds left")
            }
            PropertyChanges {
                target: timer
                running: false
            }
        },
        State {
            name: "break"
            PropertyChanges {
                target: pomodoroRoot
                color: "#22AB31"
            }
            PropertyChanges {
                target: headerText
                text: "Been chilling for"
            }
            PropertyChanges {
                target: footerText
                text: (hoursLeft > 0) ? "hours" : ((minutesLeft > 0) ? "minutes" : "seconds")
            }
        }
    ]

    transitions: [
        Transition {
            ColorAnimation {
                target: pomodoroRoot
                duration: 200
            }
        }
    ]

    Text {
        id: headerText
        color: "white"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: parent.width * 0.05
        }
        height: parent.height / 5
        font.pixelSize: height
        horizontalAlignment: Text.AlignHCenter
        scale: paintedWidth > width ? (width / paintedWidth) : 1
        smooth: true
        renderType: Text.NativeRendering
    }

    Text {
        id: timerText
        color: "white"
        anchors {
            top: headerText.bottom
            bottom: footerText.top
            left: parent.left
            right: parent.right
        }
        font.pixelSize: height
        horizontalAlignment: Text.AlignHCenter
        scale: paintedWidth > width ? (width / paintedWidth) : 1
        text: ((hoursLeft > 0) ? pad(hoursLeft,1) + ":" : "")
              + ((hoursLeft > 0 || minutesLeft > 0) ? pad(minutesLeft, (hoursLeft > 0) ? 2 : 1) + ":" : "")
              + pad(secondsLeft, (minutesLeft > 0) ? 2 : 1)
        smooth: true
        renderType: Text.NativeRendering
    }
    Text {
        id: footerText
        color: "white"
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: parent.width * 0.05
        }
        height: parent.height / 5
        font.pixelSize: height
        horizontalAlignment: Text.AlignHCenter
        scale: paintedWidth > width ? (width / paintedWidth) : 1
        text: hoursLeft > 0 ? "more hours" : "more minutes"
        smooth: true
        renderType: Text.NativeRendering
    }

    Timer {
        id: timer
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            if(pomodoroRoot.state === "pomodoro") {
                timeLeft -= interval / 1000
                if(timeLeft < 0) {
                    pomodoroRoot.state = "break"
                    var soundNumber = Math.floor((Math.random()*3))
                    switch(soundNumber) {
                    case 0:
                        dontWorrySound.play()
                        break
                    case 1:
                        allYouGotSound.play()
                        break
                    case 2:
                        shotKillSound.play()
                        break
                    }
                }
            } else if(pomodoroRoot.state === "break"){
                timeLeft += interval / 1000
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if(mouse.button === Qt.RightButton) {
                if(pomodoroRoot.state === "break") {
                    pomodoroRoot.state = "pomodoro"
                    timeLeft = 25 * 60
                } else {
                    pomodoroRoot.state = "break"
                    timeLeft = 0
                }
            } else if(mouse.button === Qt.LeftButton) {
                if(pomodoroRoot.state === "pomodoro") {
                    pomodoroRoot.state = "pause"
                } else if(pomodoroRoot.state === "pause") {
                    pomodoroRoot.state = "pomodoro"
                }
            }
        }

        onWheel: {
            if(pomodoroRoot.state === "pomodoro") {
                timeLeft += wheel.angleDelta.y / 120. * 60.
                if(timeLeft < 0) {
                    timeLeft = 0
                }
            }
        }
    }

    SoundEffect {
        id: dontWorrySound
        loops: 1
        source: "../sounds/dontworry.wav"
    }

    SoundEffect {
        id: allYouGotSound
        loops: 1
        source: "../sounds/allyougot.wav"
    }

    SoundEffect {
        id: shotKillSound
        loops: 1
        source: "../sounds/shotkill.wav"
    }
}
