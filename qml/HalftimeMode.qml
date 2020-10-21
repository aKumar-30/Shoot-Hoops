import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtMultimedia 5.9
import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs 1.2
//import otherArjun 1.0
Page {
    Rectangle{
        color:"black"
        x:-40
        y:0
        width:40
        height:parent.height
    }
    Rectangle{
        color:black
        x:40
        y:-40
        width:parent.height
        height:40
    }
    function onGoBackFromHalftime(points1){
        navigationStack.pop()
        Extra.points+=points1
        shouldBeginThirdLevel=true
    }
    visible: true
    y: navigationStack.navigationBar.height
    width: parent.width
    height: parent.height+y
    title:"Halftime!"
    id: root2
    property int timeRemaining: totalTimeTimer.interval/1000
    //    property alias ball: basketball
    property int numberOfClicks: 0;
    signal ballClicked;
    onBallClicked: {
        numberOfClicks++
    }

    Rectangle{
        id: levelRectangle
        anchors.centerIn: parent
        width: 1
        height: 1
        z:100;
        color: "#f7fafc"
        radius: 20;
        visible: false;
        Component.onCompleted: {
            levelRectangleAnimation.start()
        }
        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            id: levelRectangleText1
            text: "It's HALFTIME!"
            font.pointSize: 1;
            font.family: "Impact"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        Text{
            id: levelRectangleText
            text: "Click the ball to collect it and earn points - this adds on to your game score"
            font.pointSize: 14;
            font.family: "Century Gothic"
            wrapMode: Text.Wrap
            width: parent.width-30
            y: levelRectangleText1.y+levelRectangleText1.implicitHeight+30
            anchors.horizontalCenter: parent.horizontalCenter
            visible:false
        }
        Button{
            visible: false
            id: startGameButton
            text: "Start"
            font.pointSize: 14;
            width: parent.width-90
            height: 120
            y: levelRectangleText.y+levelRectangleText.implicitHeight+30
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                levelRectangle.visible=false;
                remainingTimeBox.visible=true
                ballTriggerTimer.start()
                totalTimeTimer.start()
            }
        }
        ParallelAnimation {
            id: levelRectangleAnimation
            onStarted: {
                levelRectangle.visible = true;
            }
            onStopped: {
                //Making bottom text appear
                levelRectangleText.visible=true
                startGameButton.visible=true;
            }
            NumberAnimation {
                target: levelRectangleText1
                property: "font.pointSize"
                duration: 800
                easing.type: Easing.Linear
                to:30
            }
            NumberAnimation {
                target: levelRectangle
                property: "width"
                duration: 800
                easing.type: Easing.Linear
                to: (root2.width*4/5)*7/10
            }
            NumberAnimation {
                target: levelRectangle
                property: "height"
                duration: 800
                easing.type: Easing.Linear
                to: root2.height*3/7
            }
        }
    }
    //for dynamic object creatin
    function createHalftimeBallObjects() {
        var component;
        var sprite;  //comes from qt doc and to lazy to change
        function finishCreation() {
            if (component.status === Component.Ready) {
                sprite = component.createObject(root2);
                if (sprite === null) {
                    // Error Handling
                    console.log("Error creating object");
                }
            } else if (component.status === Component.Error) {
                // Error Handling
                console.log("Error loading component:", component.errorString());
            }
        }
        component = Qt.createComponent("HalftimeBall.qml");
        if (component.status === Component.Ready)
            finishCreation();
        else
            component.statusChanged.connect(finishCreation);
    }
    Rectangle{
        visible: false
        id: remainingTimeBox
        anchors.centerIn: parent
        width:height
        height: remainingTimeBoxText.implicitHeight+30
        color: "black"
        z:200
        opacity: 0.4
        radius:20
        Text{
            id: remainingTimeBoxText
            x: parent.width/2-40
            anchors.centerIn: parent
            font.family: "GENISO"
            font.bold: true
            text: timeRemaining
            font.pointSize: 120
            color: "white"
        }
    }
    Rectangle{
        visible: false
        id: totalRewardsBox
        anchors.centerIn: parent
        width:remainingTimeBox.width
        height: remainingTimeBox.height
        color: "black"
        z:200
        opacity: 0.4
        radius:20
        Column{
            anchors.fill: parent
            anchors.centerIn: parent
            spacing: 25
            Text{
                anchors.horizontalCenter: parent.horizontalCenter
                text: value +" X " + " 15 = ";
                property int value: (totalRewardsBox.visible)?(numberOfClicks):(0)
                Behavior on value {
                    NumberAnimation { duration: 800; easing.type: Easing.InOutQuad }
                }
                id: totalRewardsBoxText
                font.family: "GENISO"
                font.bold: true
                font.pointSize: 40
                color: "white"
            }
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                Text{
                    property int value: (totalRewardsBox.visible)?(numberOfClicks*15):(0)
                    Behavior on value {
                        NumberAnimation { duration: 900; easing.type: Easing.InOutQuad }
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    text: value
                    font.family: "GENISO"
                    font.bold: true
                    font.pointSize: 55
                    color: "white"
                }
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    text: " extra points"
                    font.family: "GENISO"
                    font.pointSize: 15
                    color: "white"
                }
            }
        }
    }
    Timer{
        id: ballTriggerTimer
        interval: 500
        running: totalTimeTimer.running; repeat: true
        onTriggered:{
            let b =3;
            if(timeRemaining<15)
                b=4;
            if(timeRemaining<9)
                b=5
            if(timeRemaining<3)
                b=6
            for(let i =0; i < b; i++){
                createHalftimeBallObjects()
            }
        }
    }
    Timer{
        id: totalTimeTimer
        interval:  20000
    }

    PauseAnimation {
        id: endPauseAnim
        duration: 5000
        onStopped: {
            //do something
            onGoBackFromHalftime(numberOfClicks*15);
        }
    }
    PauseAnimation {
        id: endPauseAnim2
        duration: 2500
        onStopped:{
            remainingTimeBox.visible=false
            totalRewardsBox.visible=true
            endPauseAnim.start()
        }
    }
    Timer{
        id: countdownUpdateTimer
        interval: 1000
        running: totalTimeTimer.running; repeat: true
        onTriggered:{
            if(totalTimeTimer.running)
                timeRemaining--;
            if(timeRemaining===0){
                remainingTimeBoxText.text= "Time's Up"
                remainingTimeBox.height=remainingTimeBox.height;
                remainingTimeBoxText.font.pointSize=40
                endPauseAnim2.start()
            }
        }
    }
    //Sun
//    Rectangle{
//        z:8
//        visible: true
//        id: sun
//        radius: 80
//        x:-width/2+10
//        y:-height/2+10
//        width:130
//        height:130
//        color: "yellow"
//        Text{
//            id: onSunLevelText
//            font.pointSize: 10
//            text: "Count";
//            x: height*3/5+50
//            y: width*3/5+30
//            font.underline: true
//            color: "black"
//            font.family: "Blacklight"
//            wrapMode: Text.Wrap
//        }
//        Text{
//            id: onSunLevelText1
//            font.pointSize: 18
//            text: numberOfClicks;
//            anchors.top: onSunLevelText.bottom
//            color: "black"
//            font.family: "Athletic"
//            wrapMode: Text.Wrap
//            x: height*3/5+55
//        }
//    }
    //Sun
    Rectangle{
        visible: true
        id: sun
        radius: 80
        x:80
        y:50
        width:130
        height:130
        color: "yellow"
        z: 17
        Text{
            id: onSunLevelText
            font.pointSize: 14
            text: "Count";
            anchors.centerIn: parent
            color: "black"
            font.bold: true
            font.underline: true
            font.family: "Century Gothic"
            wrapMode: Text.Wrap
        }
        Text{
            id: onSunLevelText1
            font.pointSize: 15
            text: numberOfClicks;
            y: onSunLevelText.y+onSunLevelText.height+5
            color: "black"
            font.family: "Stencil"
            wrapMode: Text.Wrap
            anchors.horizontalCenter: onSunLevelText.horizontalCenter
        }
    }
    //Sky
    Rectangle {
        id: sky
        anchors.top: parent.top
        anchors.bottom: ground.top
        width: parent.width
        color:"blue"
        gradient: Gradient {
            GradientStop { id: skyStartGradient ;position: 0.0; color: "#0080FF" }
            GradientStop { id: skyEndGradient ;position: 1.0; color: "#66CCFF"}
        }
    }

    //Ground
    Rectangle{
        id: ground
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 300
        width: parent.width
        gradient: Gradient {
            GradientStop { id: groundStartGradient; position: 0.0; color: "#00FF00"}
            GradientStop {id: groundEndGradient; position: 1.0; color: "#00803F"}
        }
    }

}