import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
  id: input

  implicitWidth: 240
  font.pointSize: 12

  property var notHoveredColor: Qt.darker("#212834", 2)
  property var hoveredColor: Qt.darker("#212834", 1.5)

  background: Rectangle {
    color: input.notHoveredColor
    radius: 4

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.IBeamCursor
      hoverEnabled: true
      onEntered: parent.color = input.hoveredColor
      onExited: parent.color = input.notHoveredColor
    }
  }
}