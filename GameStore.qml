import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.1
import "test.js" as Global
Page {
    visible: true
    width: 708
    height: 785
    title:"Competitive Mode"
    property int duration: 1000
    id: root
    property var found: true;
    property var bought: ["Normal Ball", "Blue", "Green"]
    property int count: 0;
    property var mName: "";
    property var mSource: "";
    property var mIndex: -1;
    property bool firstTime: true;
    property bool firstTime1: true;
    property var givenName: "";
    Component.onCompleted: {
        bigPicText.text =givenName;

    }

    function findCurrentIndex()
    {
        console.log(bought)
        let thing;
        for(let i =0; i < contactModel.count;i++){
            if(contactModel.get(i).picSource=== Extra.ballSource)
                thing = i
        }
        for(let k =0; k <bought.length; k++){
            for(let j = 0; j < contactModel.count; j++){
                if(bought[k]===contactModel.get(j).name){
                    contactModel.get(j).isBought=true
                    break;
                }
            }
        }
        return thing;
    }
    function checkIfFound()
    {
        found = false;
        for(let i =0; i < bought.length; i++){
            if(bought[i]===mName){
                found = true;
                return true;
            }
        }
        return false;
    }
    function someOfTheStuffToDoWhenClicked()
    {
        firstTime=false;
        if(!found){
            //not bought yet
            purchaseButton.visible=true;
            buttonFadeRect.visible=true;
            lockSign.visible = true;

            purchaseButtonText.text = count;

            if(Extra.numCoins>=count){
                purchaseButton.enabled=true;
                colorRect.color= "#bdbd22"
            }
            else{
                purchaseButton.enabled = false;
                colorRect.color= "#69685a"
            }
        }
        else{
            //bought before
            Extra.ballSource=mSource;
            purchaseButton.visible=false;
            buttonFadeRect.visible=false;
            lockSign.visible = false;
            givenName=mName;
        }
        bigPicImage.source= mSource;
        bigPicText.text =mName;
    }
    Image{
        x:0.1
        anchors.fill: parent
        opacity: 0.2
        source: "file:///Users/arjun/Documents/CompetitiveBall/images/gameStoreBackground.jpg"
    }
    //Number of coins thingy
    Rectangle{
        Component.onCompleted: {
            bigPicAnim.start()
        }

        Row{
            spacing: 20;
            x: 10
            y:10
            Image{
                anchors.verticalCenter: parent.verticalCenter
                width: 25
                height: 25
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
            }
            Text{
                anchors.verticalCenter: parent.verticalCenter
                property int value: Extra.numCoins
                text: value
                font.family: "Stencil"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize:15
                Behavior on value {
                    NumberAnimation { duration: (firstTime)?1:1000; easing.type: Easing.InOutQuad}
                }
            }

        }
    }
    //Big Pic
    Rectangle{
        id: bigPic
        y:lockSign.y+lockSign.height/3-height+8
        anchors.horizontalCenter: parent.horizontalCenter
        width: purchaseButton.width*2.5
        height: purchaseButton.width*1.5
        border.color: "darkgray"
        border.width: 3
        radius: 4
        color: "transparent"
        Text{
            text: "Normal Ball"
            id: bigPicText
            font.family: "Tw Cen MT Condensed Extra Bold"
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 25
            anchors.horizontalCenter: parent.horizontalCenter
            y:2
            color: "black"
        }
        Image{
            id: bigPicImage
            source: Extra.ballSource
            width: 165;
            height: 165;
            anchors.horizontalCenter: parent.horizontalCenter
            y:bigPicText.y+bigPicText.height+2
        }

        RotationAnimation{
            id: bigPicAnim
            target: bigPicImage
            property: "rotation"
            easing.type: Easing.Linear
            to: 360*5;
            duration: 10020
            onStopped: {
                bigPicImage.rotation =0;
                bigPicAnim.start()
            }
        }
    }

    //lockSign sign
    Image{
        visible: false
        id: lockSign
        width: purchaseButton.width/2
        height: width
        anchors.bottom: buttonFadeRect.top
        anchors.horizontalCenter: parent.horizontalCenter
        source: "file:///Users/arjun/Documents/CompetitiveBall/images/lockSign.png"
    }

    //Purchase Button
    Button{
        MessageDialog{
            id: confirmMessage
            title: "Confirmation"
            standardButtons: MessageDialog.Yes |MessageDialog.Cancel
            text: "Are you sure you want to purchase this?"
            onYes:{
                Extra.numCoins-=count
                contactModel.get(mIndex).isBought=true
                bought.push(mName);
                boughtChanged();
                checkIfFound()
                someOfTheStuffToDoWhenClicked();
            }

        }
        onClicked: {
            confirmMessage.open()
        }
        visible:false;
        z:2
        x: buttonFadeRect.x+4
        y:buttonFadeRect.y-3
        id: purchaseButton
        height: 70;
        width:150;
        Rectangle{
            id: colorRect
            anchors.fill:parent
            color:"yellow"
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                Text{
                    id: purchaseButtonText
                    //cost
                    text: "25"
                    font.pointSize: 18
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Goudy Stout"
                }
                Image{
                    //coin pic
                    width:30
                    height:30;
                    source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

    }
    Rectangle{
        visible: false;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: grid.top
        id: buttonFadeRect
        height: 70;
        width:150;
        color: "#93a8c4"
    }
    //List model for all the different things
    ListModel{
        id: contactModel
        ListElement{
            index:0
            isBought: false
            type: "regularBall";
            name: "Normal Ball"
            picSource: "file:///Users/arjun/Documents/All_Qt_Projects/Qt Quick/Qt Fundamentals Udemy Course/10-6AnimationDemo/images/basket_ball.png"
            price: 0;
        } ListElement{
            index:1
            isBought: false
            type: "blueBall";
            name: "Blue"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/blueBall.png"
            price: 10
        } ListElement{
            index:2
            isBought: false
            type: "greenBall";
            name: "Green"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/greenBall.png";
            price: 10
        } ListElement{
            index:3
            isBought: false
            type: "redBall";
            name: "Red"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/redBall.png"
            price: 15
        }ListElement{
            index:4
            isBought: false
            type: "tennisBall";
            name: "Tennis Ball"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/tennis_ball.png"
            price: 15
        }ListElement{
            index:5
            isBought: false
            type: "soccerBall";
            name: "Soccer Ball"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/soccer_ball.png"
            price: 20
        }ListElement{
            index:6
            isBought: false
            type: "bowlingBall";
            name: "Bowling Ball"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/bowling_ball.png"
            price: 30

        }ListElement{
            index:7
            isBought: false
            type: "volleyBall";
            name: "Volley Ball"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/volley_ball.png"
            price: 35
        }
        ListElement{
            index:8
            isBought: false
            type: "Tire";
            name: "The Tire"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/tire_ball.png"
            price: 39
        }
        ListElement{
            index:9
            isBought: false
            type: "Donut";
            name: "The Donut"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/donut_ball.png"
            price: 45
        }
        ListElement{
            index:10
            isBought: false
            type: "Coin";
            name: "The Coin"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/coin.png"
            price: 60
        }
        ListElement{
            index:11
            isBought: false
            type: "Earth";
            name: "The Earth"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/earth.png"
            price: 80
        }
        ListElement{
            index:12
            isBought: false
            type: "moon";
            name: "The Moon"
            picSource: "file:///Users/arjun/Documents/CompetitiveBall/images/moon.png"
            price: 80
        }
    }

    GridView {
        clip: true
        ScrollBar.vertical: ScrollBar{}
        //        boundsBehavior: Flickable.OvershootBounds
        populate: Transition {
            NumberAnimation { properties: "x,y"; duration: 400 }
        }
        width: cellWidth*4; height: cellHeight*3
        cellWidth: 115; cellHeight: 115
        id:grid
        anchors.horizontalCenter: parent.horizontalCenter
        y:root.height-height-40
        currentIndex: findCurrentIndex()
        model: contactModel
        Component{
            id: foundDel
            Rectangle{
                width: grid.cellWidth
                height: grid.cellHeight
                color: "transparent"
                Rectangle {
                    width: grid.cellWidth-20
                    height: grid.cellHeight-20
                    id: wrapper
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    border.width: 3
                    border.color: "black"
                    radius: 5;
                    color: (isBought)?"white":"#a1a1a1"
                    Image{
                        id: mImage
                        x:parent.x
                        y:6
                        width: 65
                        height:65;
                        source: picSource

                    }
                    Text{
                        width: grid.cellWidth-15
                        y: mImage.y+mImage.height+4
                        anchors.horizontalCenter: parent.horizontalCenter
                        id: nameText
                        text: name
                        font.family: "Palatino Linotype"
                        font.bold:  (grid.isCurrentItem===true)?"true":"false"
                        horizontalAlignment: Text.AlignHCenter
                        font.pointSize: 8
                        color:"#050027"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked:{
                            mIndex=index
                            count = price;
                            mName = name;
                            mSource = picSource;
                            //what happens when u click
                            grid.currentIndex=index;
                            checkIfFound()
                            someOfTheStuffToDoWhenClicked()
                        }
                    }
                }
            }
        }
        delegate: foundDel
        highlight:
            Rectangle {
            z:8
            color: "steelblue";
            radius: 5;
            opacity: 0.6
            Image{
                id: checkMark
                visible: found;
                anchors.centerIn: parent
                width: 100;
                height: 100;
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/checkMark.png"
            }
            Image{
                id: theXofDoom
                visible: !found;
                anchors.centerIn: parent
                width: 100;
                height: 100;
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/theXOfDoomAndHorror.png"
            }
        }
        focus: true
    }

    Settings{
        category: "mySettingsThing5"
        property alias mBought1: root.bought
        property alias mMName: root.givenName
    }
}

