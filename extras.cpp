#include "extras.h"

Extras::Extras(QObject *parent) : QObject(parent), m_volume(0.0), m_isOpen(false), m_numCoins(64), m_ballSource("file:///Users/arjun/Documents/All_Qt_Projects/Qt Quick/Qt Fundamentals Udemy Course/10-6AnimationDemo/images/basket_ball.png")
{

}

double Extras::volume() const
{
    return m_volume;
}

void Extras::setVolume(double volume)
{
    if (m_volume == volume)
        return;

    m_volume = volume;

    emit volumeChanged(m_volume);
}

bool Extras::isOpen() const
{
    return m_isOpen;
}

void Extras::setIsOpen(bool isOpen)
{
    if (m_isOpen == isOpen)
        return;

    m_isOpen = isOpen;
    emit isOpenChanged(m_isOpen);
}

int Extras::numCoins() const
{
    return m_numCoins;
}

void Extras::setNumCoins(int numCoins)
{
    if (m_numCoins == numCoins)
        return;

    m_numCoins = numCoins;
    emit numCoinsChanged(m_numCoins);
}

QString Extras::ballSource() const
{
    return m_ballSource;
}

void Extras::setBallSource(QString ballSource)
{
    if (m_ballSource == ballSource)
        return;

    m_ballSource = ballSource;
    emit ballSourceChanged(m_ballSource);
}
