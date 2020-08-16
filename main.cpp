#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>
#include <QQmlContext>
#include <QDebug>
#include "extras.h"
#include <QQuickView>
#include "settingsmanager.h"
#include <QTime>
#include <QDateTime>

#include "flashingtimer.h"
FlashingTimer allTheTimeStuff();

int main(int argc, char *argv[])
{
    //Prob only need this or...
    QGuiApplication::setApplicationName("Make some Splashs!");
    QGuiApplication::setOrganizationName("someOrganization");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //App information
    app.setOrganizationName("someOrganization");
    app.setOrganizationDomain("someOrganization.com");
    app.setApplicationName("Make some splashs!");

    //All the timer things

    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty()){
        settings.setValue("style", style);
    }
    else{
        QQuickStyle::setStyle(settings.value("style").toString());
    }

    FlashingTimer joe = allTheTimeStuff();
    Extras extra;
    QQmlApplicationEngine engine;
    SettingsManager dude;
    qmlRegisterType<SettingsManager>("Arjun", 1, 0, "SettingsManager");
    //one thing to note is that is you want to change something in c++ (say with a timer) and want to automatically have it update in QML use setContextObject with the object instead of setObjectProperty
     engine.rootContext()->setContextObject(&joe);
     engine.rootContext()->setContextProperty("FlashingTimer",&joe);
    engine.rootContext()->setContextProperty("Extra", &extra);
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());

    //save volume
    double volume1 = extra.volume();
    if(!settings.contains("volume0100"))
        dude.writeSettings("volume0100", volume1);
    else
        extra.setVolume(SettingsManager::loadSettings("volume0100").toDouble());

    //save coins
    double numCoins1 = extra.numCoins();
    if(!settings.contains("numCoins21"))
        dude.writeSettings("numCoins21", numCoins1);
    else
        extra.setNumCoins(SettingsManager::loadSettings("numCoins21").toInt());

    //save ball source
    QString ballSource1 = extra.ballSource();
    if(!settings.contains("ballSource"))
        dude.writeSettings("ballSource", ballSource1);
    else
        extra.setBallSource(SettingsManager::loadSettings("ballSource").toString());

    //save personal best
    int personalBest1 = extra.personalBest();
    if(!settings.contains("personalBest55")){
        dude.writeSettings("personalBest55",personalBest1);
    }
    else
        extra.setPersonalBest(SettingsManager::loadSettings("personalBest55").toInt());


    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}


FlashingTimer allTheTimeStuff(){
  QDateTime now= QDateTime::currentDateTime();
  //Make and save tomorrow
  QSettings settings;
  SettingsManager dude;
  QDateTime tomorrow=now.addSecs(86399);
  if(!settings.contains("whatIsTomorrow?"))
      dude.writeSettings("whatIsTomorrow?", tomorrow);
  else{
      tomorrow = SettingsManager::loadSettings("whatIsTomorrow?").toDateTime();
  }
  if(tomorrow<now){
      tomorrow=tomorrow.addSecs(86399);
  }
  FlashingTimer joe(tomorrow);
  emit joe.callUpdateMissions();

  return joe;
}

// Default message handler to be called to bypass all other warnings.
static const QtMessageHandler QT_DEFAULT_MESSAGE_HANDLER = qInstallMessageHandler(0);
// a custom message handler to intercept warnings
void customMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString & msg)
{
    switch (type) {
    case QtWarningMsg: {
        if (!msg.contains("TypeError: Cannot read property 'horizontalCenter' of null")){ // suppress this warning
            (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg); // bypass and display all other warnings
        }
    }
    break;
    default:    // Call the default handler.
        (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg);
        break;
    }
}
