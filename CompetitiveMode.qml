import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.1
import QtMultimedia 5.15
import "test.js" as Global
Page {
    visible: true
    width: 708
    height: 785
    title:"Competitive Mode"
    property int duration: 1000
    id: root
    property bool isNewColor: false
    property var gradientGround1: "#00FF00"
    property var gradientGround2: "#00803F"
    property bool whatToDoWhenClicked: false
    property int counter1 : 0;
    property var mDuration: 1500
    property int points: 0;
    property int personalBest: 0;
    property var manyMisses : 0;
    property var manyMakes: 0;
    property var extraPoints: 0;
    property int level: 1;
    property int levelIndicator: 1
    property var sliderEasingType: Easing.Linear
    property var firstTime: true;
    property var levelIndicatorDown: (level!==3)?(22-levelIndicator):(50-levelIndicator)
    property var animationWhichIsRunning:1
    property var makingStreakColor: "red"
    property var colors: ["#cf3732","#db8d44","#e3d430","#29c910", "#e3d430", "#db8d44", "#cf3732"]
    property bool haveRandomlyChoosenIfCoinAppears: false;
    property int coinProb: 0;
    property int counter2: 0;
    property bool firstTime2: true
    property bool firstTime3: true
    property bool newRun: false;
    property var currentRandomOrder5: []
    property var currentIndexForRandom: 0;
    property var mIsOpen: Extra.isOpen

    onMIsOpenChanged:{
        if(Extra.isOpen===false)
            stateRectId.state= "notPaused"
        else
            stateRectId.state = "paused"
    }

    function newRandomColors3(){
        for(var i =0; i< 5; i++){
            let mArray = ["#cf3732","#cf3732","#db8d44","#db8d44","#e3d430","#e3d430","#29c910"]
            for(let i = mArray.length - 1; i > 0; i--){
                const j = Math.floor(Math.random() * i)
                const temp = mArray[i]
                mArray[i] = mArray[j]
                mArray[j] = temp
            }
            currentRandomOrder5.push(mArray);
        }
    }
    function figureOutShotWithColor(value)
    {
        if(level!==3){
            return "null";
        }
        //red
        if(figureOutColor(value)==="#cf3732"){
            console.log("I went to red")
            let random = Math.random()*3;
            if(random<=1)
                return "airball"
            else
                return "backboardMiss"
        }
        //orange
        else if(figureOutColor(value)==="#db8d44"){
            let random = Math.random()*7;
            if(random<=2)
                return "backboardMiss"
            else if(random<=6)
                return "rimMiss"
        }
        //yellow
        else if(figureOutColor(value)==="#e3d430"){
            let random = Math.random()*10;
            if(random<=5)
                return "backboardMake"
            else if(random<=9)
                return "rimMake"
        }
        //green
        else if(figureOutColor(value)==="#29c910"){
            console.log("I went to green")
            let random = Math.random()*10;
            if(random<=1)
            {
                return "rimMake"
            }
            else if(random<=6)
            {
                return "splash"
            }
            else if(random<=9)
            {
                return "extraSplash"
            }
        }
    }
    function figureOutColor(value)
    {
        if(value<142.9){
            return colors[0];
        }
        else if(value<285.8){
            return colors[1];
        }
        else if(value<428.7){
            return colors[2];
        }
        else if(value<571.5){
            return colors[3];
        }
        else if(value<714.4){
            return colors[4];
        }
        else if(value<857.2){
            return colors[5]
        }
        else{
            return colors[6]
        }
    }
    Audio{
        id: mMusic1
        source:"file:///Users/arjun/Documents/CompetitiveBall/images/mMusic1.wav"
        loops:Audio.Infinite
        volume: Extra.volume
    }
    Component.onCompleted: {
        mMusic1.play()

    }
    Component.onDestruction: {
        mMusic1.stop()

    }
    //Pause button
    MouseArea{
        anchors.fill: parent
        onClicked: {
            if(levelRectangleAnimationPause.running)
            {
                levelRectangleAnimationPause.complete()
            }
            else if(levelRectangleAnimation.running){
                levelRectangleAnimation.complete()
                levelRectangleAnimationPause.complete()
            }
        }

        onDoubleClicked:{
            function pauseAllAnim()
            {
                if(levelRectangleAnimation.running){
                    levelRectangleAnimation.pause();
                    animationWhichIsRunning=levelRectangleAnimation
                }
                else if(airBallAnimation.running){
                    airBallAnimation.pause()
                    animationWhichIsRunning=airBallAnimation
                }
                else if(splashAnimation.running){
                    splashAnimation.pause()
                    animationWhichIsRunning=splashAnimation
                }
                else if(rimMakeAnimation.running){
                    rimMakeAnimation.pause()
                    animationWhichIsRunning=rimMakeAnimation
                }
                else if(backboardMissAnimation.running){
                    backboardMissAnimation.pause();
                    animationWhichIsRunning=backboardMissAnimation
                }
                else if(backboardAnimation.running){
                    backboardAnimation.pause()
                    animationWhichIsRunning=backboardAnimation
                }
                else if(seqAnimationId.running){
                    seqAnimationId.pause()
                    animationWhichIsRunning=seqAnimationId
                }

            }
            function resumeAllAnim()
            {
                if(animationWhichIsRunning!=1)
                {
                    animationWhichIsRunning.resume()

                }
            }
            if(stateRectId.state==="notPaused")
            {
                stateRectId.state="paused"
                mMusic1.play()
                pauseAllAnim();
            }
            else
            {
                if(!levelRectangleAnimationPause.runnning){
                    stateRectId.state="notPaused"
                    mMusic1.play()
                    resumeAllAnim();
                }
            }
        }
    }

    //Pause state rectangle
    Rectangle{
        anchors.fill: parent
        id: pauseRectangle
        z: 100
        visible: true
        color: "#000000"
        opacity: 0.81
        anchors.centerIn: parent
        Image{
            width: 552*4/5
            height: 452*4/5
            anchors.centerIn: parent
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/pauseButton.png"
        }
    }
    function whatToDoWhenAnimFinished()
    {
        //variable declaration
        haveRandomlyChoosenIfCoinAppears = false;
        //this is the random prob for the coin
        //function for what to do when going to next level
        function whatToDoForNextLevel()
        {
            level++;
            levelIndicator=1;
            tally1.visible =false; tally2.visible =false; tally3.visible =false;
            tally4.visible =false; tally5.visible =false; tally6.visible =false;
            tally7.visible =false; tally3.visible =false; tally8.visible =false;
            tally9.visible =false; tally10.visible =false; plus11.visible=false;
            x1.visible=false;
            x2.visible=false;
            x3.visible=false;
            feedbackLabel.text=""
            flashingScoreText.color = "black"
            insideRectangleMouseArea.enabled = true
            manyMakes=0;
            manyMisses=0;
            levelRectangleAnimation.start();
        }
        //fix ball
        basketBall.width=115
        basketBall.height=115
        basketBall.y = root.height-basketBall.height-50;
        basketBall.x=33;
        basketBall.rotation = 0

        //general check
        flashingScoreText.opacity=0;
        //Check if three misses- if game is over
        //If you lose it all...
        if(manyMisses==3)
        {
            giantX.visible= true;
            //Just resetting somethings
            flashingScoreText.color="black"
            insideRectangleMouseArea.enabled = true
            if(points>personalBest)
            {
                personalBest=points;
            }
            points = 0;
            level= 1;
            levelIndicator=0;
            extraPoints=0;
            manyMisses=0;
            manyMakes = 0;
            mDuration=1300
            sliderEasingType = Easing.Linear
            mMusic1.stop()
            tryAgainDialog.open()
        }
        //General thing to do if MAKE for AFTER THE ANIMATION IS FINISHED
        if(manyMakes>0){
            if(flipable.visible){
                haveRandomlyChoosenIfCoinAppears=true;
                coinAnim.start()
            }
        }

        //Level one stuff
        if(level===1)
        {
            coinProb = 6;
            sliderId.value=100;
            mDuration-=42
            insideRectangleMouseArea.enabled = true
            if(levelIndicator > 21)
            {
                whatToDoForNextLevel()
                mDuration=1400
            }
            else{
                //have to have on all three, only restart thing if not going to next level
                seqAnimationId.restart();
            }
        }
        //Level two stuff
        else if(level===2)
        {
            coinProb = 4;
            var options = [Easing.Linear, Easing.InQuad, Easing.OutQuad, Easing.InOutCubic, Easing.OutCubic, Easing.InQuart, Easing.OutQuart, Easing.OutQuint, Easing.InOutQuint, Easing.InSine, Easing.OutSine, Easing.InExpo, Easing.OutInExpo, Easing.OutCirc, Easing.OutInCirc, Easing.InOutElastic, Easing.OutElastic, Easing.OutBack, Easing.OutInBack, Easing.InBack, Easing.InBounce, Easing.OutBounce, Easing.InOutBounce, Easing.OutInBounce, Easing.BezierCurve]
            sliderEasingType=options[Math.floor((Math.random() * 26))];
            sliderId.value=200;
            mDuration-=35;
            insideRectangleMouseArea.enabled = true;
            if(levelIndicator >21)
            {
                handleId.visible=false;
                sliderId.enabled=false;
                whatToDoForNextLevel()

            }
            else{
                //have to have on all three, only restart thing if not going to next level
                seqAnimationId.restart();
            }
        }
        //Level three stuff
        else if(level===3)
        {
            coinProb = 3;
            mPauseAnim.duration-=20;
            handleId.visible=false;
            sliderId.enabled=true;
            //clearling the last times random order
            currentRandomOrder5=[];
            //making sure it starts at the first index (index 0);
            currentIndexForRandom = 0;
            newRandomColors3();
            mPauseAnim.restart();

        }

        //other variables stuff for everything
        //So basically we needed this to only happen AFTER the animation appears, so  if the animation doesnt appear this runs but if it does then it will run at the end of it
        if(!haveRandomlyChoosenIfCoinAppears){
            if (Math.floor((Math.random()*coinProb))==0){
                flipable.visible=true;
                flipable.flipped = !flipable.flipped;
            }
            else
                flipable.visible=false;
        }
    }
    //Images start here
    //Sky
    Rectangle {
        Component.onCompleted: {
            //Used to show level one message
            levelRectangleAnimation.start()
        }
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
    Image{
        visible: false;
        z:5
        id: pointingFinger
        width: 414*1/6;
        height: 600*1/6;
        x: insideContainerId.x+insideContainerId.width/2-width/2
        y: insideContainerId.y-height;
        source: "file:///Users/arjun/Documents/CompetitiveBall/images/pointingPicture.png"
        onVisibleChanged: {
            //start the animation once it is visible
            pointingFingerAnim.start()
        }
        onYChanged: {
            if(y===(insideContainerId.y-height-2)||y===(insideContainerId.y-height+32))
                pointingFingerAnim.restart()
        }

        SequentialAnimation{
            id: pointingFingerAnim
            NumberAnimation {
                id: pointingFingerAnimFront
                target: pointingFinger
                property: "y"
                to:insideContainerId.y-pointingFinger.height+20;
                duration: 300
                easing.type: Easing.Linear
            }
            NumberAnimation {
                id: pointingFingerAnimBack
                target: pointingFinger
                property: "y"
                to:(insideContainerId.y-pointingFinger.height-2)
                duration: 300
                easing.type: Easing.Linear
            }
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
    //Hoop
    Rectangle{
        z:4
        y:200
        id: backboard;
        height: 160;
        width:12
        color: "darkgray"
        border.width: 1
        border.color: "black"
        anchors.right: parent.right
    }

    Image{
        z:4
        id: rim
        source: "file:///Users/arjun/Documents/CompetitiveBall/images/basketballHoop2.png"
        anchors.right: backboard.left
        y: backboard.y+(backboard.height*2/3)
        width: 150
        height: 110
    }
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
        Text{
            id: onSunLevelText
            font.pointSize: 12
            text: "Level: " + level;
            anchors.centerIn: parent
            font.underline: true
            color: "black"
            font.family: "Blacklight"
            wrapMode: Text.Wrap
        }
        Text{
            id: onSunLevelText1
            font.pointSize: 12
            text: levelIndicatorDown;
            anchors.top: onSunLevelText.bottom
            color: "black"
            font.family: "Athletic"
            wrapMode: Text.Wrap
            x: parent.width/2-10
        }
    }
    //Coin counter thingy
    Rectangle{
        Row{
            spacing: 20;
            x: 10
            y:10
            Image{
                width: 25
                height: 25
                source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
            }
            Text{
                property int theText: Extra.numCoins
                text: theText
                font.family: "Stencil"
                horizontalAlignment: Text.AlignHCenter
                font.pointSize:15
            }
        }
    }

    //the coin with anim

    Flipable {
        visible: false
        x: rim.x+65
        y:rim.y+17
        id: flipable
        property bool flipped: false
        front: Image { //--> collapse
            width: 50
            height: 50
            anchors.centerIn: parent
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinFront.png"
        }
        back: Image { //--> collapse
            width: 50
            height: 50
            anchors.centerIn: parent
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/coinBack.png"
        } //<-- collapse

        transform: Rotation {
            axis.x: 0; axis.y: 1; axis.z: 0
            angle: flipable.flipped ? 180 : 0
            onAngleChanged: {
                if(angle === 180 || angle ===0){
                    if(flipable.visible)
                        flipable.flipped = !flipable.flipped
                }
            }

            Behavior on angle {
                NumberAnimation {
                    duration: 500

                }
            }
        }

        ParallelAnimation{
            id: coinAnim
            onFinished:{
                flipable.visible = false;
                flipable.x= rim.x+65
                flipable.y = rim.y+17
                flipable.back.height = 50;
                flipable.back.width = 50;
                flipable.front.width = 50;
                flipable.front.height = 50;
                Extra.numCoins++;

                //So basically we needed this to only happen AFTER the animation appears, so  if the animation doesnt appear this runs but if it does then it will run at the end of it
                if (Math.floor((Math.random()*coinProb))==0){
                    flipable.visible=true;
                    flipable.flipped = !flipable.flipped;
                }
                else
                    flipable.visible=false;
            }

            NumberAnimation {
                target: flipable.back
                property: "width"
                duration: 500
                to:30
            }
            NumberAnimation {
                target: flipable.back
                property: "height"
                duration: 500
                to:30
            }
            NumberAnimation {
                target: flipable.front
                property: "width"
                duration: 500
                to:30
            }
            NumberAnimation {
                target: flipable.front
                property: "height"
                duration: 500
                to:30
            }
            PathAnimation {
                id: pathAnim
                duration: 1000
                target: flipable
                orientation: PathAnimation.TopFirst
                anchorPoint: Qt.point(flipable.width/2,
                                      flipable.height/2)
                path: Path {
                    startX:rim.x+65 ; startY: rim.y+17
                    PathCurve {
                        x: 22
                        y: 22
                    }
                }
            }
        }

    }

    //basketball
    Image{
        z:3
        id: basketBall
        y:root.height-basketBall.height-50;
        x:33;
        width: 115
        height: 115
        source: Extra.ballSource
    }
    //feedback label
    Label{
        id: feedbackLabel
        font.family: "Century Gothic"
        text: "dda"
        z: 2
        width: 250
        wrapMode: Label.Wrap
        x: parent.width - width-20
        y: 20
        font.pointSize: 15
        visible: false
    }
    //level animation/rectangle
    Rectangle{
        id: levelRectangle
        anchors.centerIn: parent
        width: 1
        height: 1
        z:100;
        color: "#f7fafc"
        radius: 20;
        visible: false;

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            id: levelRectangleText1
            text: "Level " + level
            font.pointSize: 1;
            font.family: "Impact"
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }
        Text{
            function levelTextFunc(level)
            {
                if(level===1){
                    levelRectangleText.text = "     Hint: The slider moves faster as you go along. Survive for 21 rounds to advance, 3 missed in a row and you're out"
                }
                else if(level===2){
                    levelRectangleText.text = "     Hint: The slider has different patterns of motion. Survive for 21 shots to advance, 3 missed in a row and you're are out"
                }
                else if(level===3){
                    levelRectangleText.text = "     Hint: The colors are switching! Try to catch the green one? (not as easy ias it looks)!  Survive for 21 shots to advance, 3 missed in a row and you're are out"
                }
            }
            id: levelRectangleText
            text: levelTextFunc(level)
            font.pointSize: 14;
            font.family: "Courier New"
            wrapMode: Text.Wrap
            width: parent.width-30
            y: levelRectangleText1.y+levelRectangleText1.implicitHeight+30
            anchors.horizontalCenter: parent.horizontalCenter
            visible:false
        }

        ParallelAnimation {
            id: levelRectangleAnimation
            onStarted: {
                levelRectangle.visible = true;
            }
            onFinished: {
                //Making bottom text appear
                levelRectangleText.visible=true
                levelRectangleAnimationPause.start()

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
                to: (root.width*4/5)*7/10
            }
            NumberAnimation {
                target: levelRectangle
                property: "height"
                duration: 800
                easing.type: Easing.Linear
                to: root.height*3/7
            }
        }
        PauseAnimation {
            id: levelRectangleAnimationPause
            onStarted: {
                stateRectId.state = "paused"
            }
            onFinished: {
                //resetting everything to defaults
                stateRectId.state = "notPaused";
                levelRectangle.visible = false;
                levelRectangle.width=1;
                levelRectangle.height = 1;
                levelRectangleText1.font.pointSize=1
                levelRectangleText.visible=false
                if (level===3){
                    sliderId.enabled=true;
                    newRandomColors3();
                    mPauseAnim.start();
                }
                else{
                    insideRectangleMouseArea.enabled = true;
                    seqAnimationId.start()
                }
            }
            duration: 8000
        }
    }
    //Giant x
    Image{
        id: giantX;
        visible: false;
        anchors.centerIn: parent
        source: "file:///Users/arjun/Documents/CompetitiveBall/images/xSymbol.png"
        height: 600
        width: 515
    }

    //All three of the x's
    Row{
        id: threeMissesX
        anchors.bottom: scoreId.top
        x: scoreId.x +35
        Image{
            visible: false;
            id: x1
            height: 45;
            width: 30;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/xSymbol.png"
        }
        Image{
            visible: false
            id: x2
            height: 45;
            width: 30;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/xSymbol.png"
        }
        Image{
            visible: false
            id: x3
            height: 45;
            width: 30;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/xSymbol.png"
        }
    }
    //All ten of the lines
    Row{
        id: allMakeTallies11
        anchors.bottom: scoreId.top
        x: scoreId.x +35
        Image{
            visible: false;
            id: tally1
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally2
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally3
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false;
            id: tally4
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally5
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
            transform: Rotation{
                id: rotateImagePhoto
                angle: 315
                origin.x: tally5.width/2
                origin.y: tally5.height
            }
        }
        Image{
            visible: false
            id: tally6
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false;
            id: tally7
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally8
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally9
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
        }
        Image{
            visible: false
            id: tally10
            height: 50;
            width: 10;
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/oneLine1.png"
            transform: Rotation{
                id: rotateImagePhoto2
                angle: 315
                origin.x: tally10.width/2
                origin.y: tally10.height
            }
        }
        Image{
            visible: false
            id: plus11
            height: 30
            width: 30
            source: "file:///Users/arjun/Documents/CompetitiveBall/images/plusSign.png"
        }
    }

    //Score and PB rectangle
    Rectangle{
        id: flashingScore
        width: scoreId.width*1/2
        height: scoreId.height*3/2
        z:2
        color: "transparent"
        //border.color: "black" //no need for border
        x: scoreId.x-scoreId.width/2
        anchors.verticalCenter: scoreId.verticalCenter
        Text{
            id: flashingScoreText
            opacity: 0;
            color: "black"
            x: 1
            y: 1
            text:"apples are cool"
            rotation: 0
            font.family: "Snap ITC"
            font.pointSize: 14
        }

        NumberAnimation {
            id: flashingScoreAnim
            target: flashingScoreText
            property: "opacity"
            duration: 300
            easing.type: Easing.Linear
            to: 1;
        }
    }
    //Box in the corner with score and PB
    Rectangle{
        z:2
        id: scoreId
        width: 150
        height: 90
        radius: 23
        border.color: "#134f13"
        border.width: 3
        x: rim.x-30
        y: ground.y + 24

        Text{
            property int value: points

            id: pointText
            text: value
            Behavior on value {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
            font.pointSize: 22
            y: 10
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "impact"
        }

        Text{
            text: "PB: " + personalBest;
            font.pointSize: 12
            font.bold: true
            font.family: "Helventica"
            anchors.top: pointText.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }

        gradient: Gradient{
            GradientStop{position: 0 ;color: "#faf5f5"}
            GradientStop{position: 1/7 ;color: "#bfe6b1"}
            GradientStop{position: 2/7 ;color: "#faf5f5"}
            GradientStop{position: 3/7 ;color: "#bfe6b1"}
            GradientStop{position: 4/7 ;color: "#faf5f5"}
            GradientStop{position: 5/7 ;color: "#bfe6b1"}
            GradientStop{position: 6/7 ;color: "#faf5f5"}
            GradientStop{position: 1 ;color: "#bfe6b1"}
        }
    }

    Rectangle{
        id: insideContainerId
        color: "#dfedf2"
        opacity: 0.95
        width: 500
        height: 75
        x: parent.width/2-width/2+60
        y: parent.height-ground.height/2-height/2+40
        signal sliderStopped(double value);
        onSliderStopped: {

            //normal setting upp stuff
            basketBall.width=115
            basketBall.height=115
            basketBall.y = root.height-basketBall.height-50;
            basketBall.x=33;
            basketBall.rotation = 0
            feedbackLabel.visible= false;
            feedbackLabel.font.italic=false
            feedbackLabel.font.bold = false
            //Variable declarations
            var feedback = [];
            var random_number=0;
            let level3ShotAccuracy = figureOutShotWithColor(value);
            let pointsThisRound = 0;

            if(level3ShotAccuracy==="airball"|| level3ShotAccuracy==="null"&&(value <110  || value >890)){
                console.log("Shooting an airball")
                manyMisses++;
                manyMakes=0;
                points -= 120;
                pointsThisRound -= 120;
                airBallAnimation.start();
                feedback = ["Seriously, you can do MUCH better", "An airball?", "You are supposed to shoot at the hoop, you know?", "My dog can shoot better than that", "A complete failure...", "Why do you even play this sport?"]
                random_number = Math.floor((Math.random() * 6));
                feedbackLabel.font.italic = true;
            }
            else if(level3ShotAccuracy==="backboardMiss"|| level3ShotAccuracy==="null"&&(value <190 || value >820)){
                manyMisses++;
                manyMakes=0;
                points -= 50;
                pointsThisRound -= 50;
                backboardMissAnimation.start()
                feedback = ["Well, better than an airball", "Atleast you hit the backboard", "Your NBA hopes are dwindling", "Next time, try to hit the rim", "Might want to start taking some basketball lessons", "Not your worst..."]
                random_number = Math.floor((Math.random() * 6));
            }
            else if(level3ShotAccuracy==="rimMiss"|| level3ShotAccuracy==="null"&&(value <290 || value >720)){
                manyMisses++;
                manyMakes=0;
                points -= 20;
                pointsThisRound -= 20;
                rimMissAnimation.start()
                feedback = ["Brick", "Close but not yet there", "Hit the net next time, not the rim", "Closer than ever", "You'll do it next time"]
                random_number = Math.floor((Math.random() * 5));
            }
            else if(level3ShotAccuracy==="backboardMake"|| level3ShotAccuracy==="null"&&(value < 330 || value >680)){
                manyMakes++;
                manyMisses=0
                points +=30;
                pointsThisRound += 30;
                backboardAnimation.start()
                feedback = ["Good shot","A make is a make", "A bucket is a bucket", "Lucky shot??", "Banks don't count...try again", "According to Satvik: Banks don't count...try again", "You can do even better"]
                random_number = Math.floor((Math.random() * 7));
            }
            else if(level3ShotAccuracy==="rimMake"|| level3ShotAccuracy==="null"&&(value <420 || value > 570)){
                manyMakes++;
                manyMisses=0

                points+=50
                pointsThisRound += 50;
                rimMakeAnimation.start()
                feedback = ["I thought that was going to miss", "The rim was on your side", "Looks like you are on a set path to the NBA", "Amazing shot!", "Pretty nice!"]
                random_number = Math.floor((Math.random() * 5));
            }
            else if(level3ShotAccuracy==="splash"|| level3ShotAccuracy==="null"&&(value <480|| value>510)){
                console.log("Shooting an splash")
                manyMakes++;
                manyMisses=0

                points+= 110
                pointsThisRound += 110;
                splashAnimation.start()
                feedback = ["The next Steph Curry?", "Splashing it like Klay Thompson?", "What an amazing shot?", "Making some splashes", "All the way from deep?", "Swish!", "Like a true nba player"]
                random_number = Math.floor((Math.random() * 7));
            }
            else{
                //need these stuffy here for if statement to check for make the work
                console.log("Shooting an splash")
                manyMakes++;
                manyMisses=0

                points+= 150
                pointsThisRound +=150;
                splashAnimation.start()
                feedback = ["The GOAT??", "May be the greatest shot ever", "Game winner!", "Buzzer beater", "MVP"]
                random_number = Math.floor((Math.random() * 5));
                feedbackLabel.font.bold = true;
                splashAnimation.start()
            }
            //Do every time either way
            feedbackLabel.visible = true;
            feedbackLabel.text = feedback[random_number];
            levelIndicator++;
            (level===3)?(sliderId.enabled=true):(sliderId.enabled=false);
            //If make- in general
            if(manyMakes>0)
            {
                x1.visible=false;
                x2.visible=false;
                x3.visible=false;
                //Brighten the color of the score box text on the bottom left
                switch(manyMakes){
                case 1: tally1.visible =true;
                    flashingScoreText.color = "black"
                    break;
                case 2: tally1.visible =true; tally2.visible =true;
                    flashingScoreText.color = "#302525"
                    break;
                case 3:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    flashingScoreText.color = "#422e2e"
                    extraPoints=70;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 4:tally1.visible =true; tally2.visible =true;
                    tally3.visible =true; tally4.visible =true;
                    flashingScoreText.color = "#523333"
                    extraPoints=100;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 5:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    flashingScoreText.color = "#633434"
                    extraPoints=120;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 6:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    flashingScoreText.color = "#803434"
                    extraPoints=140;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 7:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    tally6.visible =true; tally7.visible =true;
                    flashingScoreText.color = "#a34141"
                    extraPoints=170;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 8:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true;
                    tally6.visible =true; tally7.visible =true; tally8.visible =true;
                    flashingScoreText.color = "#d44242"
                    extraPoints=180;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 9:tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    tally7.visible =true; tally8.visible =true; tally9.visible =true;
                    flashingScoreText.color = "#ed4747"
                    extraPoints=190;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                case 10: tally1.visible =true; tally2.visible =true; tally3.visible =true;
                    tally4.visible =true; tally5.visible =true; tally6.visible =true;
                    tally7.visible =true; tally8.visible =true;
                    tally9.visible =true; tally10.visible =true;
                    flashingScoreText.color = "#ff0000"
                    extraPoints=200;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                default: tally1.visible =true; tally2.visible =true; tally3.visible =true; tally4.visible =true;
                    tally5.visible =true; tally6.visible =true; tally7.visible =true; tally8.visible =true; tally9.visible =true;
                    tally10.visible =true; plus11.visible = true;
                    flashingScoreText.color = "#2b59ff"
                    extraPoints+=15;
                    points += extraPoints;
                    pointsThisRound +=extraPoints;
                    break;
                }
            }
            //If miss - in general
            else{
                tally1.visible =false; tally2.visible =false; tally3.visible =false;
                tally4.visible =false; tally5.visible =false; tally6.visible =false;
                tally7.visible =false; tally3.visible =false; tally8.visible =false;
                tally9.visible =false; tally10.visible =false; plus11.visible=false;
                extraPoints=70;
                flashingScoreText.color = "black"
                switch(manyMisses)
                {
                case 1: x1.visible=true; break;
                case 2: x1.visible=true; x2.visible = true; break;
                case 3: x1.visible=true; x2.visible = true; x3.visible = true; break;
                }
            }

            //Flashing plus or minus scoreId
            flashingScoreText.text= (manyMakes>0)?("+"+pointsThisRound):(pointsThisRound)
            flashingScoreText.x= Math.random()*(flashingScore.width-flashingScoreText.implicitWidth)+1;
            flashingScoreText.y= Math.random()*(flashingScore.height-flashingScoreText.implicitHeight)+1;
            flashingScoreText.rotation= (Math.random()*100)-50;
            sliderId.enabled=false
            flashingScoreAnim.start();

            insideRectangleMouseArea.enabled = false;
        }
        MouseArea{
            id: insideRectangleMouseArea
            enabled: false;
            anchors.fill: parent
            propagateComposedEvents: true
            onClicked: {
                if(stateRectId.state=="notPaused" && level!==3){
                    if(!seqAnimationId.running&&!pointingFinger.visible){
                        seqAnimationId.start();
                        whatToDoWhenClicked=true
                    }
                    else{
                        seqAnimationId.stop();
                        insideContainerId.sliderStopped(sliderId.value);
                    }
                }
                pointingFinger.visible=false;
                firstTime2=false;
            }
            onDoubleClicked:{
                mouse.accepted=false;
            }
        }
        Slider{
            onValueChanged: {
                console.log(value);
                if(firstTime2){
                    if(value===1){
                        counter2=1;
                    }
                    if(counter2 ==1 && value===500.5){
                        seqAnimationId.stop();
                        pointingFinger.visible=true;
                    }
                }
                if(level===3)
                {
                    mPauseAnim.stop();
                    pointingFinger.visible=false;
                    insideContainerId.sliderStopped(sliderId.value);
                    handleId.visible=true;
                    sliderId.enabled=false;
                    firstTime3=false;
                }
                else{
                    if(value===1)
                    {
                        seqAnimationId.restart()
                    }
                }
            }

            anchors.centerIn: parent
            id: sliderId
            from: 1;
            to: 1000;
            value: 20;
            width: 440;
            height: 20;
            enabled:false;
            background: Rectangle{
                implicitHeight: 4
                height: implicitHeight
                radius: 6
                gradient: Gradient{
                    orientation: Gradient.Horizontal
                    GradientStop{position: 0.0; color: (level===3)?colors[0]:"#cf3732"}
                    GradientStop{position: (level===3)?0.1428:0.2; color:(level===3)?colors[0]:"#db8d44"}
                    GradientStop{position: (level===3)?0.1429:0.35; color:(level===3)?colors[1]:"#e3d430"}
                    GradientStop{position: (level===3)?0.2857:0.5; color:(level===3)?colors[1]:"#29c910"}
                    GradientStop{position: (level===3)?0.2858:0.65; color:(level===3)?colors[2]:"#e3d430"}
                    GradientStop{position: (level===3)?0.4286:0.8; color:(level===3)?colors[2]:"#db8d44"}
                    GradientStop{position: (level===3)?0.4287:1.0; color:(level===3)?colors[3]:"#cf3732"}
                    //below ones not used until level 3
                    GradientStop{position: (level===3)?0.5714:1.1; color:(level===3)?colors[3]:"#000000"}
                    GradientStop{position: (level===3)?0.5715:1.1; color:(level===3)?colors[4]:"#000000"}
                    GradientStop{position: (level===3)?0.7143:1.1; color:(level===3)?colors[4]:"#000000"}
                    GradientStop{position: (level===3)?0.7144:1.1; color:(level===3)?colors[5]:"#000000"}
                    GradientStop{position: (level===3)?0.8571:1.1; color:(level===3)?colors[5]:"#000000"}
                    GradientStop{position: (level===3)?0.8572:1.1; color:(level===3)?colors[6]:"#000000"}
                    GradientStop{position: (level===3)?1:1.1; color:(level===3)?colors[6]:"#000000"}
                }
                Rectangle {
                    height: parent.height
                    color: "#21be2b"
                    radius: 2
                }
            }
            handle: Rectangle {
                id: handleId
                x: sliderId.leftPadding + sliderId.visualPosition * (sliderId.availableWidth - width)
                y: sliderId.topPadding + sliderId.availableHeight / 2 - height / 2
                implicitWidth: 12
                implicitHeight: 31
                radius: 4
                color: sliderId.pressed ? "#f0f0f0" : "#ededed"
                border.color: "#9e9e9e"
            }
            SequentialAnimation{
                id: seqAnimationId
                NumberAnimation {
                    target: sliderId
                    property: "value"
                    to:1000
                    duration: mDuration
                    easing.type: sliderEasingType
                }
                NumberAnimation {
                    target: sliderId
                    property: "value"
                    to:0
                    duration: mDuration
                    easing.type: sliderEasingType

                }
            }
            PauseAnimation {
                onFinished: {
                    if(currentIndexForRandom===5)
                        currentIndexForRandom=0;
                    colors= currentRandomOrder5[currentIndexForRandom];
                    currentIndexForRandom+=1;

                    if(firstTime3===true&&currentIndexForRandom===4){
                        console.log(colors)
                        for(let i =0; i< colors.length; i++){
                            if(colors[i]==="#29c910"){
                                pointingFinger.x=sliderId.x-(pointingFinger.width/2)+(i/7*sliderId.width)+(1/14*sliderId.width)+165;
                                pointingFinger.y+= 34
                                pointingFingerAnimFront.to+=34
                                pointingFingerAnimBack.to+=34
                                firstTime3=false;
                                pointingFinger.visible=true;
                                break;
                            }
                        }
                    }
                    else
                        mPauseAnim.restart();
                }

                id: mPauseAnim
                duration: 1000
            }
        }
    }
    //splash animation
    MyAnimation{
        id: splashAnimation
        toX: rim.x+26;
        downEasingType: Easing.InQuad;
        toY: 50;
        animationDuration: 1600
        rotationNumber: 800
        onStopped:{
            whatToDoWhenAnimFinished()
        }

    }
    //air ball animation
    MyAnimation{
        id: airBallAnimation
        toX: rim.x-75;
        downEasingType: Easing.InQuad;
        toY: 250;
        animationDuration: 1600
        rotationNumber: 800
        otherToY: rim.y + 200
        percentageSmall: 0.4
        percentageLarge: 0.6
        shrink: false
        onStopped: {
            whatToDoWhenAnimFinished()
        }

    }

    //Backboard make
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        id: backboardAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 90
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 90
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: backboard.y-20
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: backboard.x-basketBall.width+20
                        duration: 1600*0.8
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: basketBall
                        property: "y"
                        to: rim.y-15
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        duration: 1600*0.2
                        to: rim.x+26
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "width"
                        to: 65
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "height"
                        to: 65
                        duration: 1600*0.2
                        easing.type: Easing.Linear
                    }
                    SequentialAnimation{
                        id: rimRockId
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counter1<2){
                                rimRockId.start();
                                counter1++;
                            }
                            else
                            {
                                rimRockId.rotation = 0;
                            }
                        }
                    }
                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //Backboard miss
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        id: backboardMissAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600*(0.8+0.65)
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 90
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 90
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: backboard.y-20
                                duration: 1600*0.3
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: backboard.x-basketBall.width+20
                        duration: 1600*0.8
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: basketBall
                        property: "y"
                        to: rim.y+200
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        duration: 1600*0.65
                        to: rim.x-300
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "width"
                        to: 110
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "height"
                        to: 110
                        duration: 1600*0.65
                        easing.type: Easing.InCubic
                    }
                    SequentialAnimation{
                        id: rimRockId1
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counter1<2){
                                rimRockId1.start();
                                counter1++;
                            }
                            else
                            {
                                rimRockId1.rotation = 0;
                            }
                        }
                    }
                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //Rim make
    SequentialAnimation{
        onStopped :{
            whatToDoWhenAnimFinished()
        }
        id: rimMakeAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 90
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 90
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y-basketBall.height+25
                                duration: 1600*0.25
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x-basketBall.width/2+25
                        duration: 1600*0.75
                    }
                }
                ParallelAnimation{
                    SequentialAnimation{
                        id: rimRockId2
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05
                        }
                        onFinished: {
                            if(counter1<2){
                                rimRockId2.start();
                                counter1++;
                            }
                            else
                            {
                                rimRockId2.rotation = 0;
                            }
                        }
                    }
                    SequentialAnimation{
                        NumberAnimation {
                            target: basketBall
                            property: "y"
                            to: 150
                            duration: (1600*0.25)*0.65
                            easing.type: Easing.OutQuad
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 70
                                duration: 1600*0.25*0.75
                                easing.type: Easing.Linear
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 70
                                duration: 1600*0.25*0.75
                                easing.type: Easing.Linear
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "y"
                                to: rim.y-20
                                duration: (1600*0.25)*0.55
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        property: "x"
                        to: rim.x+26
                        duration: 1600*0.25
                        easing.type: Easing.Linear
                    }
                }
                PauseAnimation {
                    duration: 400
                }
            }
        }
    }
    //Rim miss
    SequentialAnimation{
        onStopped:{
            whatToDoWhenAnimFinished()
        }
        id: rimMissAnimation
        ParallelAnimation{
            RotationAnimation{
                target: basketBall
                properties: "rotation"
                direction: RotationAnimation.Clockwise
                to: 800
                duration: 1600*1.7
            }
            SequentialAnimation{
                ParallelAnimation {
                    SequentialAnimation {
                        NumberAnimation {
                            target: basketBall
                            properties: "y"
                            to: 50
                            duration: 1600 * 0.5
                            easing.type: Easing.OutCirc
                        }
                        ParallelAnimation{
                            NumberAnimation {
                                target: basketBall
                                property: "width"
                                to: 75
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }
                            NumberAnimation {
                                target: basketBall
                                property: "height"
                                to: 75
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }

                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y-60
                                duration: 1600*0.35
                                easing.type: Easing.InQuad
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x+50
                        duration: 1600*0.85
                    }
                }

                ParallelAnimation {
                    SequentialAnimation{
                        id: rimRockId3
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 3
                            duration: 1600*0.05
                        }
                        RotationAnimation{
                            target: rim
                            property: "rotation"
                            to: 0
                            duration: 1600*0.05

                            onFinished: {
                                if(counter1<2){
                                    rimRockId2.start();
                                    counter1++;
                                }
                                else
                                {
                                    rimRockId2.rotation = 0;
                                }
                            }
                        }
                        SequentialAnimation {
                            ParallelAnimation{
                                NumberAnimation {
                                    target: basketBall
                                    property: "width"
                                    to: 115
                                    duration: 1600*0.4
                                    easing.type: Easing.Linear
                                }
                                NumberAnimation {
                                    target: basketBall
                                    property: "height"
                                    to: 115
                                    duration: 1600*0.4
                                    easing.type: Easing.Linear
                                }

                                NumberAnimation {
                                    target: basketBall
                                    properties: "y"
                                    to: 140
                                    duration: 1600*0.4
                                    easing.type: Easing.OutQuad
                                }
                            }
                            NumberAnimation {
                                target: basketBall
                                properties: "y"
                                to: rim.y+150
                                duration: 1600 * 0.45
                                easing.type: Easing.InCubic
                            }
                        }
                    }
                    NumberAnimation {
                        target: basketBall
                        properties: "x"
                        to: rim.x-350
                        duration: 1600*0.85
                    }

                }
            }
        }
        PauseAnimation {
            duration: 400
        }
    }
    //Try again dialog
    MessageDialog{
        id: tryAgainDialog
        title: "You lost!"
        standardButtons: MessageDialog.Retry
        informativeText: "Try Again!"
        detailedText: "If you miss 3 in a row, you are out. Try to beat your personal best score!"
        //Removing giant x added before the dialog was opened
        onAccepted: {
            giantX.visible = false;
            seqAnimationId.stop()
            levelRectangleAnimation.start()
            mMusic1.stop()
            x1.visible=false; x2.visible = false; x3.visible = false;
        }
        onVisibilityChanged: {
            if(!this.visible){
                giantX.visible = false;
                seqAnimationId.stop()
                levelRectangleAnimation.start()
                mMusic1.stop()
                x1.visible=false; x2.visible = false; x3.visible = false;
            }
        }
    }

    Rectangle{
        id: stateRectId
        state: "notPaused"
        states: [
            State {
                name: "paused"
                PropertyChanges {
                    target: pauseRectangle
                    visible: true
                }
            },
            State {
                name: "notPaused"
                PropertyChanges {
                    target: pauseRectangle
                    visible: false
                }
            }
        ]
        transitions: [
            Transition {
                from: "*"
                to: "*"
                ColorAnimation {
                    duration: 500
                }
                NumberAnimation{
                    property: opacity
                    duration: 500
                }
            }
        ]
    }



    Settings{
        category: "allOtherStuff1"
        id: mSettings
        property alias personalBest: root.personalBest
    }
}




