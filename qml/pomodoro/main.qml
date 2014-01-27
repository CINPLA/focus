import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: pomodoroRoot

    property real timeLeft: 0

    width: 1280
    height: 720

    state: "break"

    function pad(num, size) {
        var s = num+"";
        while (s.length < size) s = "0" + s;
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
                text: "Don't disturb for"
            }
            PropertyChanges {
                target: footerText
                text: "more minutes"
            }
        },
        State {
            name: "pause"
            PropertyChanges {
                target: pomodoroRoot
                color: "#CDCD12"
            }
            PropertyChanges {
                target: headerText
                text: "Currently disturbed with"
            }
            PropertyChanges {
                target: footerText
                text: "minutes left"
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
                text: "minutes"
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
        text: Math.floor(timeLeft / 60) + ":" + pad(Math.floor(timeLeft % 60), 2)
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
        text: "more minutes"
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
                    console.log(soundNumber)
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
    }

    SoundEffect {
        id: dontWorrySound
        loops: 1
        source: "dontworry.wav"
    }

    SoundEffect {
        id: allYouGotSound
        loops: 1
        source: "allyougot.wav"
    }

    SoundEffect {
        id: shotKillSound
        loops: 1
        source: "shotkill.wav"
    }
}
