import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtMultimedia 5.15
import Arjun 1.0
import "test.js" as Global

//New VERSION STARTS HERE
ApplicationWindow {
    visible: true
    width: 708
    height: 785
    title: qsTr("Make some splashs!")
    id: root
    property var p: false
    property var thisTitle: "Make some splashs!"
    property var endingPage: " "
    Component.onCompleted: {
        console.log("Coins: "+Extra.numCoins)
        console.log(Extra.volume)
    }
    Component.onDestruction: {
        console.log("Coins: "+Extra.numCoins)
        console.log(Extra.volume)
        s_manager.writeSettings("volume0100", Extra.volume);
        s_manager.writeSettings("numCoins21", Extra.numCoins);
        s_manager.writeSettings("ballSource", Extra.ballSource);
    }
    SettingsManager{
        id: s_manager
    }

    onClosing: {
        if(endingPage==="qrc:/CompetitiveMode.qml"){
            stackView.push("qrc:/GameStore.qml");
            stackView.pop()
        }
        stackView.push("qrc:/CompetitiveMode.qml");
        stackView.pop()
    }
    //MISSIONS START HERE    ----------------------------------------------------1
    function checkIfCompleted(){
        for(let i =0; i < mMissionModel.count; i++){
            if(mMissionModel.get(i)){
                return true;
            }
        }
        return false;
    }

    Rectangle {
        visible:false
        z:17
        id: mainRect
        width: parent.width*2/3
        height: parent.width*4/5
        anchors.centerIn: parent
        Rectangle{
            anchors.top: parent.top
            id: header
            width: parent.width
            height: 60
            color: "#e6ae60"
            Text{
                anchors.fill: parent
                color: "#ffffff"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 28
                text: "Missions"
                font.family: "Complex"
            }
        }
        Rectangle{
            id: headerFade
            width: parent.width
            anchors.top:header.bottom
            height: 8
            color: "#c2910c"
        }
        Text{
            id: countdownText
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            anchors.top: headerFade.bottom
            text: "NEXT MISSIONS IN "+whatToPrint;
            font.family: "GENISO"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            color: "#595756"
            y: header.y+16
            font.pointSize: 12
        }
        ListModel{
            id: mMissionModel
            ListElement{
                name: ""
                description: "Splash 3 times in a row 99089 9898 89098 8808 9 89089 890"
                reward: 6;
                neededThings: 4
                currentThings: 2
            }
            ListElement{
                name: ""
                description: "Miss at the backboard twice"
                reward: 2;
                neededThings: 2
                currentThings: 0
            }
            ListElement{
                name: ""
                description: "Buy 3 different types of balls"
                reward: 8;
                neededThings: 3
                currentThings: 3
            }
            ListElement{
                name: ""
                description: "Get 3 coins in a match twice"
                reward: 3;
                neededThings: 1
                currentThings: 2
            }
        }
        Component{
            id: mMissionDelegate
            Rectangle{
                width: mainRect.width-25
                height: width*1/4+20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                Rectangle{
                    id: mainDelegateRect
                    width: parent.width
                    height: parent.height-12
                    anchors.verticalCenter: parent.verticalCenter
                    color: (currentThings===neededThings)?"#7ae868":"#e6ae60"
                    Column{
                        x:16
                        y:10
                        spacing: 20;
                        width: parent.width
                        Text{
                            id: theText
                            y:15
                            font.family: "Swis721 Cn BT"
                            font.bold: true
                            width: parent.width*2/3+15
                            wrapMode: Text.Wrap
                            font.pointSize: 12.5
                            color: "white"
                            text:description
                            //description text
                        }
                        Row{
                            spacing:2
                            //progress bar
                            ProgressBar {
                                id: thingsLeft
                                value: currentThings/neededThings
                                padding: 2
                                Text{
                                    z:3
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Swis721 Cn BT"
                                    font.bold: true
                                    font.pointSize: 14
                                    text:currentThings+"/"+neededThings
                                }
                                background: Rectangle {
                                    implicitWidth: theText.width
                                    implicitHeight: 32
                                    color: "#000000"
                                    radius: 2
                                }
                                contentItem: Item {
                                    implicitWidth: theText.width
                                    implicitHeight: 26
                                    Rectangle {
                                        width: thingsLeft.visualPosition * parent.width
                                        height: parent.height
                                        radius: 2
                                        color: "#06bf0c"
                                    }
                                }
                            }
                            //filler space
                            Rectangle{
                                width: 35
                                height: 2
                                color: "transparent"
                            }
                            //reward
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                color: "black"
                                font.family: "Swis721 Cn BT"
                                font.bold: true
                                font.pointSize: 18
                                text:reward
                            }
                            //coin pic
                            Image{
                                anchors.verticalCenter: parent.verticalCenter
                                width: 35
                                height: 35
                                source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
                            }
                        }
                    }
                }
            }
        }
        ListView{
            z:18
            anchors.top: countdownText.bottom
            width: parent.width
            height: parent.height-header.height-headerFade.height-countdownText.height-button.height-10
            x: 0;
            id: listOfMissions
            delegate: mMissionDelegate
            model: mMissionModel
        }
        Button{
            z: 19
            id: button
            anchors.top: listOfMissions.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: 60
            width: 140
            Rectangle{
                anchors.fill: parent
                color: "#40ad36"

            }
            Row{
                x:10
                anchors.verticalCenter: parent.verticalCenter
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                    font.family: "Swis721 Cn BT"
                    font.bold: true
                    font.pointSize: 18
                    text:"Get"
                }
                Rectangle{
                    width: 15
                    height: 2
                    color: "transparent"
                }

                //text
                Text{
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                    font.family: "Swis721 Cn BT"
                    font.bold: true
                    font.pointSize: 18
                    text:"5"
                }
                //coin pic
                Image{
                    anchors.verticalCenter: parent.verticalCenter
                    width: 35
                    height: 35
                    source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
                }
            }
        }
        Rectangle{
            width: button.width
            height: button.height
            y: button.y+5
            x: button.x-5
            color: "#188509"
        }
    }
    Rectangle{
        visible:false;
        z:16
        id: fadedRect
        x: mainRect.x-10
        y: mainRect.y+17
        width: mainRect.width
        height:mainRect.height
        color: "#c2910c"
    }
    //MISSIONS ENDS HERE  ------------------------------------------------------

    Dialog {
        onOpened: {
            Extra.isOpen = true;
        }
        onClosed: {
            Extra.isOpen = false;
        }
        id: aboutDialog
        modal: true
        focus: true
        x: (root.width - width) / 2
        y: root.height / 6
        width: Math.min(root.width, root.height) /4*3
        contentHeight: aboutColumn.height
        Flickable{
            contentHeight: aboutColumn.implicitHeight
            Column {
                id: aboutColumn
                spacing: 20
                anchors.fill: parent
                Label {
                    width: aboutDialog.availableWidth
                    text: "How to play"
                    wrapMode: Label.Wrap
                    font.pixelSize: 30
                    font.bold:true;
                    horizontalAlignment: "AlignHCenter"
                }
                Label {
                    width: aboutDialog.availableWidth
                    text: "A fun game related to sports and bouncing balls!"
                    wrapMode: Label.Wrap
                    font.pixelSize: 20
                }

                Label {
                    width: aboutDialog.availableWidth
                    text: "The objective of the game is to try to stop the slider as close to the "
                          + "middle as possible. The shot you shoot and the points earned are based on your accuracy. Three consecutive misses and your out! The difficulty progresses along with the levels. Get coins to by new balls in The Store and play around in the brand new customization mode"
                    wrapMode: Label.Wrap
                    font.pixelSize: 16
                    font.family: "Helventica"
                }
                Label {
                    width: aboutDialog.availableWidth
                    text: "Customization mode: Play around with a bouncing ball and customize it the way you would like!"
                    wrapMode: Label.Wrap
                    font.pixelSize: 16
                    font.family: "Helventica"
                }
            }
            ScrollBar.vertical: ScrollBar{}
        }


    }
    function help() {
        let url = "https://nba.com/"
        Qt.openUrlExternally(url)
    }
    Settings {
        id: settings
        property string style: "Default"
    }
    Dialog {
        onOpened: {
            Extra.isOpen = true;
        }
        onClosed: {
            Extra.isOpen = false;
        }

        id: settingsDialog
        x: Math.round((root.width - width) / 2)
        y: Math.round(root.height / 6)
        width: Math.round(Math.min(root.width, root.height) / 3 * 2)
        modal: true
        focus: true
        title: "Settings"

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            settings.style = styleBox.displayText
            settingsDialog.close()
        }
        onRejected: {
            styleBox.currentIndex = styleBox.styleIndex
            settingsDialog.close()
        }

        contentItem: ColumnLayout {
            id: settingsColumn
            spacing: 20
            RowLayout{
                spacing: 10

                Label{
                    text: "Volume"
                }
                Slider {
                    id: volumeSlider
                    from: 0
                    to: 1
                    onValueChanged: {
                        Extra.volume=volumeSlider.volume

                    }
                    value: QtMultimedia.convertVolume(Extra.volume,QtMultimedia.LinearVolumeScale,QtMultimedia.LogarithmicVolumeScale);
                    property real volume: QtMultimedia.convertVolume(volumeSlider.value,
                                                                     QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)
                }
            }
            RowLayout {
                spacing: 10

                Label {
                    text: "Style:"
                }

                ComboBox {
                    id: styleBox
                    property int styleIndex: -1
                    model: availableStyles
                    Component.onCompleted: {
                        styleIndex = find(settings.style, Qt.MatchFixedString)
                        if (styleIndex !== -1)
                            currentIndex = styleIndex
                    }
                    Layout.fillWidth: true
                }
            }

            Label {
                text: "Restart required"
                color: "#e41e29"
                opacity: styleBox.currentIndex !== styleBox.styleIndex ? 1.0 : 0.0
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: navigateBackAction.trigger()
    }

    Shortcut {
        sequence: StandardKey.HelpContents
        onActivated: help()
    }
    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenuAction.trigger()
    }

    Action {
        id: optionsMenuAction
        icon.name: "menu"
        icon.source: "file:///Users/arjun/Documents/CompetitiveBall/icons/splashs/menu.png"
        onTriggered: optionsMenu.open()
    }

    Action {
        id: navigateBackAction
        icon.name: stackView.depth > 1 ? "back" : ""
        icon.source: stackView.depth > 1? "file:///Users/arjun/Documents/CompetitiveBall/icons/splashs/back.png":""
        onTriggered: {
            if (stackView.depth > 1) {
                //Give them a reset warning
                if(root.width!=708){
                    root.width = 708;
                    root.height = 785;
                }

                if(endingPage==="qrc:/CompetitiveMode.qml")
                    warningDialog.open();
                else{
                    stackView.pop()
                    thisTitle = "Make some splashs!"
                }
            }
        }
    }
    Dialog {
        onOpened: {
            Extra.isOpen = true;
        }
        onClosed: {
            Extra.isOpen = false;
        }
        id: warningDialog
        x: Math.round((root.width - width) / 2)
        y: Math.round(root.height / 6)
        width: Math.round(Math.min(root.width, root.height) / 3 * 2)
        modal: true
        focus: true
        title: "Warning"

        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            stackView.pop()
            warningDialog.close()
            thisTitle = "Make some splashs!"
        }
        onRejected: {
            warningDialog.close()
        }

        contentItem: ColumnLayout {
            id: warningColumn
            spacing: 20

            RowLayout {
                spacing: 10

                Label {
                    text: "Are you sure you would like to leave? All progress in the current game will be lost"
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    wrapMode: Label.Wrap
                }
            }
        }
    }
    header: ToolBar {
        Material.foreground: "mintcream"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                visible: stackView.depth>1
                action: navigateBackAction
            }

            Label {
                id: titleLabel
                text: thisTitle.toString()
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                action: optionsMenuAction

                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    Action {
                        text: "Settings"
                        onTriggered: settingsDialog.open()
                    }
                    Action {
                        text: "Help"
                        onTriggered: help()
                    }
                    Action {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                }
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: Pane {
            id: pane
            Image{
                z:-1
                id: backgroundImage
                opacity: 0.4
                anchors.fill: parent
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/homeBackground.png"
            }
            Label {
                text: "Shoot some hoops!"
                font.family:"Impact"
                font.pointSize: 45
                width: 450
                wrapMode: Label.Wrap
                y:90
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Label.AlignHCenter
            }
            Rectangle{
                y: parent.width/2
                anchors.horizontalCenter: parent.horizontalCenter
                id: buttonToPlayGame
                width: 320
                height: 100
                border.color: "#7a0a00"
                border.width: 5
                color: "#f0ad30"
                Text{
                    text: "START"
                    font.family: "Tahoma"
                    font.bold: true
                    style: Text.Raised
                    font.pointSize: 31
                    anchors.centerIn: parent
                }
                radius: 50
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        stackView.push("qrc:/CompetitiveMode.qml");
                        endingPage="qrc:/CompetitiveMode.qml";
                        thisTitle="Game Mode"
                    }
                }
            }
            Column{
                y: 200
                x:20
                spacing: 50
                Rectangle{
                    color: "transparent"
                    width: 75
                    height: 75
                    radius: 50
                    border.width: 2
                    border.color: "black"
                    Image{
                        z:-1
                        anchors.centerIn: parent
                        width: 70
                        height: 70
                        source: "file:///Users/arjun/Documents/CompetitiveBall/images/shopIcon.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("qrc:/GameStore.qml");
                            endingPage="qrc:/GameStore.qml";
                            thisTitle="The Store"
                        }
                    }
                }
                Rectangle{
                    color: "transparent"
                    width: 75
                    height: 75
                    radius: 50
                    border.width: 2
                    border.color: "black"
                    Image{
                        z:-1
                        anchors.centerIn: parent
                        width: 70
                        height: 70
                        source: "file:///Users/arjun/Documents/CompetitiveBall/images/bouncingBallIcon.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("qrc:/CustomizationMode.qml");
                            endingPage="qrc:/CUstomizationMode.qml";
                            thisTitle="Customization Mode"
                            root.width = 1200
                            root.height= 580
                        }
                    }
                }
                Rectangle{
                    color: "transparent"
                    width: 75
                    height: 75
                    radius: 50
                    border.width: 2
                    border.color: "black"
                    Image{
                        x: 5
                        y:5
                        width: 20
                        height: 20
                        source: "file:///Users/arjun/Documents/CompetitiveBall/images/exclamationMark.png"
                        visible:(true)?(true):(false)    //change this to something else
                    }

                    Image{
                        z:-1
                        anchors.centerIn: parent
                        width: 70
                        height: 70
                        source: "file:///Users/arjun/Documents/CompetitiveBall/images/missionsIcon.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            mainRect.visible = true;
                            fadedRect.visible = true;
                        }
                    }
                }
            }
            Image {
                id: arrow
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/arrow1.png"
                width: 90
                height: 50
                rotation: 90
                y: 10;
                x: root.width-width+10
            }
        }
    }
    Item{
        id: clicker
        anchors.fill: parent
        focus: true
        Keys.onDigit5Pressed: {
            if(event.modifiers===Qt.ControlModifier){
                console.log("food")
                verification.visible=true;
            }
        }
    }
    TextField{
        z:5
        color: "white"
        id: verification
        placeholderText:"Enter the code"
        visible: false;
        width: 200
        height: 50
        onEditingFinished:{
            if(text==="4895"){
                Extra.numCoins+=4;
                text=""
            }
            visible = false;
            clicker.focus=true;
        }
    }
    Settings{
        category: "windows"
        property alias x: root.x
        property alias y: root.y
    }
}
